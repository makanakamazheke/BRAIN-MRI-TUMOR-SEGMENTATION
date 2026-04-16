%% Task 4

% This script  applies a 3D IFFT to 3D k-space and displays three orthogonal slices centred within the image volume in one axis. 
% A bit similar to task 2 reconstruction, but now in 3D volume space, so I will be using similar principles

%% Loading the k-space volume data and extracting the variable

vol_data = load('kspace3D_tumour.mat'); % loading k-space data 
vol_kspace_data = vol_data.kspace_3D ; % extracting the kspace_3D variable

%% Converting the k-space data to spatial via ND Inverse Fourier Transform

vol_spatial_image = ifftn(single(vol_kspace_data));% inverse fourier transform for 3D k-space data

%% Shifting and scaling/normalising the image 

vol_abs_image = abs(vol_spatial_image); % absolute value of the image
vol_scaled_image = vol_abs_image /max(vol_abs_image(:)); % normalising by dividing by the absolute maximum value in all dimensions

%% Setting the dimensions and axis before displaying 

image_size = size(vol_scaled_image); % size of the image : [xyz]
voxel_sizes = [0.43 0.43 5]; % in mm : 0.43 for x, y axes and 5 for z-axis

% Computing the  actual spatial coordinates of the voxels, similar to Task 2 axes calibration, but now in 3D
% Again just multiplying the image dimensions and the voxel sizes(same as the pixel distances in previous tasks) 

x_axis = (0:image_size(1)-1) * voxel_sizes(1); % x axis in mm
y_axis = (0:image_size(2)-1) * voxel_sizes(2); % y axis in mm
z_axis = (0:image_size(3)-1) * voxel_sizes(3); % z axis in mm

%% Centering indices first, by halving each slice

xslice = round(image_size(1) / 2); % length of x-dimension divided by 2 to give the centered xslice
yslice = round(image_size(2) / 2); % length of y-dimension divided by 2 to give the centered yslice
zslice = round(image_size(3) / 2);%  length of z-dimension divided by 2 to give the centered zslice

%% Displaying the axial slice (XY Plane)

figure; % creating figure object
sgtitle('Three Orthogonal Slices For MRI Brain Scan') % main title
subplot(2,2,1); % subplot for the axial slice 

axial = vol_scaled_image(:,:,zslice); % storing the axial slice as a variable, axial = xy plane hence the z-axis index
imagesc(x_axis,y_axis,axial);  % axial slice (not squeezing from 3rd dimension)
colormap gray; axis image % gray colormap, keeping the image axis square
xlabel('Spatial Coordinates / mm') % x-label
ylabel('Spatial Coordinates / mm') % y-label
title ('Axial (XY Plane)') % Axial image/slice title

%% Displaying sagittal slice  

subplot(2,2,2); % subplot for the sagittal slice 

% Sagittal = xz plane, hence the y-axis index
% Squeezing because the imagesc function cannot accept higher-dimensional arrays beyond 2D as input
% And transposing using ' to correct the orientation of the image on the x-z axes 

sagittal = squeeze(vol_scaled_image(:,yslice,:)); % storing the sagittal slice as a variable
imagesc(x_axis,z_axis,sagittal'); % displaying the transposed saggital slice with the recalibrated axis
colormap gray; axis image % gray colormap, keeping the image axis square
xlabel('Spatial Coordinates / mm') % x-label
ylabel('Spatial Coordinates / mm') % y-label
title ('Sagittal (XZ Plane)') % Sagittal image/slice title 

%% Displaying coronal slice

subplot(2,2,3); % subplot for the coronal slice 

% Coronal = yz plane, hence the z-axis index
% Again, squeezing because the imagesc function cannot accept higher-dimensional arrays beyond 2D as input
% And transposing using ' to correct the orientation of the image on the y-z axes 

coronal = squeeze(vol_scaled_image(xslice,:,:)); % storing the coronal slice as a variable
imagesc(y_axis,z_axis,coronal'); % displaying the transposed coronal slice with the recalibrated axis
colormap gray; axis image % gray colormap, keeping the image axis square
xlabel('Spatial Coordinates / mm') % x-label
ylabel('Spatial Coordinates / mm') % y-label
title ('Coronal (YZ Plane)') % Coronal image/slice title 


