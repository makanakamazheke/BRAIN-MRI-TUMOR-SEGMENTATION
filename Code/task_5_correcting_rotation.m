%% Task 5

% This script corrects the 15˚ offset in the axial plane of the reconstructed brain volume from Task 4 via imrotate
% And displays it similarly to task 4 

%% Loading the 3D k-space data

vol_data = load('kspace3D_tumour.mat'); % loading k-space data 
vol_kspace_data = vol_data.kspace_3D ; % extracting the kspace_single_slice variable

%% Converting the kspace data to spatial via ND Inverse Fourier Transform

vol_spatial_image = ifftn(single(vol_kspace_data));% inverse fourier transform for ND data

%% Shifting and scaling/normalising the image 

vol_abs_image = abs(vol_spatial_image); % absolute value of the image
vol_scaled_image = vol_abs_image /max(vol_abs_image(:)); % normalising by dividing by the absolute max

%% Fixing the orientation of the image using imrotate 

% creating an empty matrix of zeroes, the same size as the original image
rotated_image = zeros(size(vol_scaled_image), 'like', vol_scaled_image); % matrix padded with zeros
rotation_angle = -15; % undoing the 15-degree rotation by -15

% Looping through all slices in the axial orientation to correct the offset

for k = 1:size(vol_scaled_image, 3) % k = slices in the axial orientation, upper limit is the size of the image
    
    % The rotated image indexed at the axial orientation 
    % Then the loop 'imrotate's each slice by the rotation angle of -15 degrees
    % Then applies nearest neighbor interpolation and resizing the image via cropping
    % Without cropping there is a dimension mismatch error of 512*512 in the left hand side and 628-by-628 on the left

    rotated_image(:,:,k) = imrotate(vol_scaled_image(:,:,k), rotation_angle, 'nearest', 'crop'); % correcting the rotation for the 32 slices in the axial plane
   
end


%% Setting the dimensions and axis 

image_size = size(rotated_image);  % size of the image : [xyz]
voxel_sizes = [0.43 0.43 5]; % in mm 0.43 for x, y and 5 for z axis

% Computing the actual spatial coordinates of the voxels, same as Task 4
% Again, just multiplying the image dimensions and the voxel sizes(same as the pixel distances in task 1-3) 

x_axis = (0:image_size(1)-1) * voxel_sizes(1); % x axis in mm
y_axis = (0:image_size(2)-1) * voxel_sizes(2); % y axis in mm
z_axis = (0:image_size(3)-1) * voxel_sizes(3); % z axis in mm

%% Centering indices first, by halving each slice

xslice = round(image_size(1) / 2); % length of x-dimension divided by 2 to give the centered xslice
yslice = round(image_size(2) / 2); % length of y-dimension divided by 2 to give the centered yslice
zslice = round(image_size(3) / 2);%  length of z-dimension divided by 2 to give the centered zslice

%% Displaying the axial slice (XY Plane)

figure; % creating figure object
sgtitle('Three Orthogonal Slices (Axial De-rotated)') % main title

subplot(2,2,1); % subplot for the axial slice 

axial = rotated_image(:,:,zslice); % storing the axial slice as a variable, axial = xy plane hence the z-axis index
imagesc(x_axis,y_axis,axial);  % axial slice (not squeezing from 3rd dimension)
colormap gray; axis image % gray colormap, keeping the image axis square
xlabel('Spatial coordinates / mm') % x-label
ylabel('Spatial coordinates / mm') % y-label
title (' Corrected Rotation Axial (XY Plane)') % Axial image/slice title

%% Displaying coronal slice

subplot(2,2,2); % subplot for the coronal slice 

% Coronal = yz plane, hence the z-axis index
% Squeezing because the imagesc function cannot accept higher-dimensional arrays beyond 2D as input
% Transposing using ' to correct the orientation of the image on the y-z axes 

coronal = squeeze(rotated_image(xslice,:,:)); % storing the coronal slice as a variable
imagesc(y_axis,z_axis,coronal'); % displaying the transposed coronal slice with the recalibrated axis
colormap gray; axis image % gray colormap, keeping the image axis square
xlabel('Spatial coordinates / mm') % x-label
ylabel('Spatial coordinates / mm') % y-label
title ('Coronal (YZ Plane)') % Coronal image/slice title 

%% Displaying sagittal slice  

subplot(2,2,3); % subplot for the sagittal slice 

% Sagittal = xz plane, hence the y-axis index
% Again, squeezing because the imagesc function cannot accept higher-dimensional arrays beyond 2D as input
% And transposing using ' to correct the orientation of the image on the x-z axes 

sagittal = squeeze(rotated_image(:,yslice,:)); % storing the sagittal slice as a variable
imagesc(x_axis,z_axis,sagittal'); % displaying the transposed saggital slice with the recalibrated axis
colormap gray; axis image % gray colormap, keeping the image axis square
xlabel('Spatial coordinates / mm') % x-label
ylabel('Spatial coordinates / mm') % y-label
title ('Sagittal (XZ Plane)') % Sagittal image/slice title 