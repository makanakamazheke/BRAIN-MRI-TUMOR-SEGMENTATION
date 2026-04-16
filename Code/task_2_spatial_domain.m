%% Task 2

% This script reconstructs the MRI image
% By applying a 2D inverse Fourier transform(ifft2) on the k-space data and scaling/normalising the image 
% So that the maximum pixel value of the image equals 1

%% Loading the data

kspace = load('kspace_single_slice.mat'); % loading data from mat file kspace_single_slice
kspace_data = kspace.kspace_single_slice ; % extracting the kspace_single_slice variable

%% Converting the k-space data to spatial via 2D Inverse Fourier Transform

spatial_image = ifft2(double(kspace_data));% inverse fourier transform for 2D data, double to maintain precision 

%% Shifting and scaling/normalising the image 

shifted_image = fftshift(spatial_image); % shifting the zero frequency component
abs_image = abs(shifted_image); % absolute value of the image
scaled_image = abs_image /max(abs_image(:)); % normalising by dividing by the absolute max value

%% Calibrating the axes as in task 1, now for the spatial image

% Note: This was not specified in the question, but I'm assuming it's required for the correct axes
% Converting from spatial indices to actual mm spatial coordinates
% Using literals for delta_x and delta_y because they are provided as literals

% 𝛥𝑥 and 𝛥𝑦 are the pixel spacings in millimetres
delta_x = 0.43; % pixel spacing in the x-axis
delta_y = 0.43; % pixel spacing in the y-axis

[a, b ] = size(kspace_data); % extracting image size
n_x = b;  % image matrix dimension in the x-axis
n_y = a;  % image matrix dimension in the y-axis

% FO𝑉𝑥 and 𝐹𝑂𝑉𝑦 are the field of view in millimetres 
fov_x = delta_x*n_x; % field of view in the x-axis
fov_y = delta_y*n_y ; % field of view in the y-axis

%%  Computing the axes in the spatial domain in mm

% Almost the same conceptually as the freq axes, but in mm 
% For x-y axes: Axis = (-n/2:n/2-1), multiplied by the pixel spacing and summed up with fov/2
% Added fov/2 for centering, without it the axes run from -100 to +100 (more intuitive with 0-200)

x_axis = (-n_x/2: n_x/2 -1)*delta_x + (fov_x/2) ; % x axis in mm
y_axis = (-n_y/2: n_y/2 -1)*delta_y + (fov_y/2); % y axis in mm

%% Displaying the normalised image

figure; % creating a figure object
imagesc((scaled_image), "XData",x_axis, "YData",y_axis) % displaying the image with the recalibrated axis

title('Spatial MRI For Brain Data Reconstructed')  % title of the image displayed
xlabel('Spatial / mm') % x-label
ylabel('Spatial / mm') % y-label
colormap('gray') % gray colormap
colorbar % displaying the colorbar

