%% Task 6 - All about tumor segmentation

% Step 1 plots a histogram of pixel intensities of slice 15 of the de-rotated 3D reconstructed volume from task 5;
% Applies thresholding to create a binary mask for the tumour and overlays it on top of the original slice using a different colour

% In Step 2(part 1), the same process is repeated but for 3D(histogram + thresholding for binary mask + overlaying)
% In Step 2(part 2) the script compares the 3D tumour mask with the ground-truth mask via the Dice coefficient
% In Step 2(part 3) the script renders the tumour as a 3D volume, using a combination of isosurface and patch 

% NOTE: For the first part, I used the code from task 5 to derotate the 3D reconstructed volume 
% Another way this would work is to run task 5 from this script using the run function
% However, the coursework did not mention if this is allowed (if each file is supposed to be run independently)
% Hence why I put the task 5 code in the first 5 sections 

%% Task 5 Derotation code 

%% Loading the 3D kspace data

vol_data = load('kspace3D_tumour.mat'); % loading data 
vol_kspace_data = vol_data.kspace_3D ; % extracting the kspace_single_slice variable

%% Converting the kspace Data from k-space to spatial via ND Inverse Fourier Transform

vol_spatial_image = ifftn(single(vol_kspace_data));% inverse fourier transform for 3D data

%% Shifting and scaling/normalising the image 

vol_abs_image = abs(vol_spatial_image); % absolute value of the image
vol_scaled_image = vol_abs_image /max(vol_abs_image(:)); % normalising by dividing by the absolute max

%% Fixing the orientation of the image using imrotate 

% creating an empty matrix of zeroes, the same size as the original image
rotated_image = zeros(size(vol_scaled_image), 'like', vol_scaled_image); % matrix padded with zeros
rotation_angle = -15; % undoing the 15-degree rotation by -15

% Looping through all slices in the axial orientation to correct the offset

for k = 1:size(vol_scaled_image, 3) % k = slices in the axial orientation, the upper limit is the size of the image

    % The rotated image indexed at the axial orientation 
    % Then the loop 'imrotate's each slice by the rotation angle of -15 degrees
    % Then applies nearest neighbor interpolation and resizing the image via cropping
    % Without cropping there is a dimension mismatch of 512*512 in the left hand side and  628-by-628 on the left

    rotated_image(:,:,k) = imrotate(vol_scaled_image(:,:,k), rotation_angle, 'nearest', 'crop'); % correcting the rotation for the 32 slices in the axial plane
   
end

%% Task 6 Code

%% Step 1 Part 1:representative slice 15 from the de-rotated 3D reconstructed volume from task 5

axial_slice_15 = rotated_image(:,:,15); % axial slice 15 (xy plane 2D image)

%% Step 1 Part 2: Plotting a histogram of the intensities

figure; % creating a figure object
imhist(axial_slice_15); % image = axial slice number 15, number of bins = 256(default)

xlabel('Normalised pixel intensities');% x-label
ylabel('Frequency of pixel intensity');% y-label
title('Histogram of Pixel Intensity Values For Axial Slice 15 MRI Scan') % Title for the histogram intensity values image

% Tumors have high frequencies due to their high water content, as they contribute more to the MRI than healthy brain tissue
% The histogram shows a small peak at the high frequency range, starting at around 0.97 (since the frequencies are normalised) 
% I also noted that this particular peak at high frequencies is absent in the task 2 MRI image without a tumor embedded

% Setting the lower and upper limits

upper_limit = 1; % the highest pixel value is 1 because the data is normalised
lower_limit = 0.97; % approximate lower limit of tumor frequencies 

% Displaying the Lower and Upper limits as red,dashed, centered, and left-aligned lines 

lower_limit_line = xline(lower_limit,'-','Lower Limit', 'Color','r','LabelHorizontalAlignment','left',...
    'LabelVerticalAlignment','middle','LineStyle','--', 'FontSize',12); % lower limit line
upper_limit_line = xline(upper_limit,'-','Upper Limit', 'Color','r','LabelHorizontalAlignment','left', ...
    'LabelVerticalAlignment','middle', 'LineStyle','--', 'FontSize',12); % upper limit line

%% Step 1 Part 3:  Thresholding to generate a binary mask for the tumour in this slice

% I'm applying the lower limit only, as the upper limit is 1(maximum possible frequency)

mask = axial_slice_15; % creating a copy of the rotated image axial slice 15, same size as well 
mask(mask >= lower_limit) = 1; % setting all values greater than the lower limit as 1 (foreground)
mask(mask < lower_limit) = 0; % setting all values less than the lower limit as 0 (background)

%% Step 1 Part 4: Creating an image overlayed with the mask 

overlayed = imoverlay(axial_slice_15, mask, "magenta"); % overlaying the mask over the image, using overlay function

%% Step 1 Part 5: Displaying the histogram, tumour binary mask, and overlayed image

% Setting the dimensions and axis before displaying, same as Task 4


image_size = size(rotated_image); % size of the image : [xyz]
voxel_sizes = [0.43 0.43 5]; % in mm 0.43 for x, y and 5 for z axis

% Computing actual spatial coordinates of the voxels:
% Again just multiplying the image dimensions and the voxel sizes(same as the pixel distances in task 3) 

x_axis = (0:image_size(1)-1) * voxel_sizes(1); % x axis in mm
y_axis = (0:image_size(2)-1) * voxel_sizes(2); % y axis in mm
z_axis = (0:image_size(3)-1) * voxel_sizes(3); % z axis in mm

% Subplots 

figure; % creating figure object
sgtitle('Histogram, Tumor Mask and Overlayed Image Subplots') % main title

% Displaying the overlayed image 

subplot(2,2,1);%  subplot for the overlayed image
imagesc(y_axis,x_axis,overlayed) % displaying the overlayed image via imagesc using adjusted axes
colormap gray; axis image % gray colormap, keeping the image axis square
xlabel('Spatial co-ordinate [mm]');% x-label
ylabel('Spatial co-ordinate [mm]');% y-label
title ('Overlayed Image for Axial (XY Plane) Slice 15 ') % Title of the overlayed image

% Displaying the tumour binary mask 

subplot(2,2,2);%  subplot for the tumour binary mask 
imagesc(y_axis,x_axis,mask);  % mask display
colormap gray; axis image % gray colormap is suitable for visualisation
xlabel('Spatial co-ordinate [mm]');% x-label
ylabel('Spatial co-ordinate [mm]');% y-label
title ('Binary Mask for Axial (XY Plane) Slice 15 MRI Brain Scan') % Title for the binary mask image

% Displaying the histogram 

subplot(2,2,3);  % subplot for the histogram of pixel values
imhist(axial_slice_15); % image = axial slice number 15
xlabel('Normalised pixel intensities');% x-label
ylabel('Frequency of pixel intensity');% y-label
title('Histogram of Pixel Intensity Values For Axial Slice 15 MRI Scan'); % Histogram of Pixel intensities title 

lower_limit_line_2 = xline(lower_limit,'-','Lower Limit', 'Color','r','LabelHorizontalAlignment','left',...
    'LabelVerticalAlignment','middle','LineStyle','--', 'FontSize',12); % lower limit line
upper_limit_line_2 = xline(upper_limit,'-','Upper Limit', 'Color','r','LabelHorizontalAlignment','left', ...
    'LabelVerticalAlignment','middle', 'LineStyle','--', 'FontSize',12); % upper limit line

%% STEP 2 Part 1: 3D volume segmentation 

% Same process as in Step 1, but in 3D
% The same logic for the 2D tumor mask applies (tumor corresponds to the high frequency peak)

% Plotting the histogram

figure;  % creating figure object
imhist(rotated_image) % histogram of pixel values for the whole 3D image
xlabel('Normalised pixel intensities');% x-label
ylabel('Frequency of pixel intensity');% y-label
title('Histogram of Pixel Intensity Values 3D')  % Title of the histogram for the 3D image

% Setting the lower and upper limits for visualisation

lower_limit_line_3D = xline(lower_limit,'-','Lower Limit', 'Color','r','LabelHorizontalAlignment','left', ...
    'LabelVerticalAlignment','middle', 'LineStyle','--' );% lower limit line
upper_limit_line_3D = xline(upper_limit,'-','Upper Limit', 'Color','r','LabelHorizontalAlignment','left', ...
    'LabelVerticalAlignment','middle', 'LineStyle','--');% upper limit line

% Thresholding to generate a binary mask for the tumour in 3D

mask_3D = rotated_image; % creating a copy of the rotated image axial slice, same size as well 
mask_3D(mask_3D >= lower_limit) = 1; % setting all values greater than the lower limit as 1 (foreground)
mask_3D(mask_3D < lower_limit) = 0; % setting all values less than the lower limit as 0 (background)

%% STEP 2 Part 2: Loading ground truth for comparison

ground_truth = load('ground_truth.mat'); % ground truth data for 3D tumour mask
ground_truth_data = ground_truth.ground_truth ; % extracting the ground truth variable 

% The dice function displays/returns the dice coefficient, a measure of how similar images are
% This function is found in the dice_function file

dice_coefficient = dice_function(ground_truth_data, mask_3D); % inputs are the ground truth mask and the custom mask

disp(['The dice coefficient is :' string(dice_coefficient)]) % displaying the dice coefficient
%% STEP 2 Part 3:  Rendering the tumour as a 3D volume 

% Justification of isosurface + patch approach
% Here, I used isorsurface + patch to render the tumour as a 3D volume
% It does display the spatial extent of the tumour within the brain, and also highlights its shape and location.
% I adjusted the transparency for the brain surface to be more transparent than the tumor, with different colors(red and gray) for easier identification 
% Other approaches, such as volume viewer worked well, but I'm unsure if they meet the question requirements

figure;  % creating figure object
hold on % hold + patch + set then repeat for brain data

% Rendering the tumor 

tumor_intensity = 0.9; % high intensity reflecting high pixel intensity of the tumor 
tumor_render = patch(isosurface(mask_3D, tumor_intensity)); 
set(tumor_render,'facecolor','red' ... % red color for easy identification
    ,'edgecolor','none', ...
    'facealpha', 0.7); % facealpha = opacity: It should be less transparent than the whole brain volume for easier analysis

% Rendering the MRI Brain Volume as a whole

brain_intensity = 0.4; % less intense than tumor
brain_volume = patch(isosurface(rotated_image, brain_intensity)); % patch the isosurface of the brain volume 
brain_color = [0.7 0.7 0.7]; % gray color 
set(brain_volume,'facecolor',brain_color, ...% setting the parameters of the facecolor, edge color, and facealpa (opacity)
    'edgecolor','none', 'facealpha', 0.3); % more transparent than the tumor 

view(3); axis tight; grid on; % view in 3D; axis limits to equal the data range
camlight; lighting gouraud; % creates a light to the right; gouraud for better lighting on surfaces
title('3D Volume Rendering of Tumor') % Title for 3D Volume Rendering of Tumor image

hold off % putting everything on the same axis 
