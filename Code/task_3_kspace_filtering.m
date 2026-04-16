%% Task 3: Kspace filtering

% This script applies circular spectral filters(low-pass, high-pass, no filter) to k-space data by calling the kspace_filter_function
% 6-figure panel at the end displays the filtered k-spaces and reconstructed MRI spatial images for each filter applied

%% Loading and extracting data 

kspace = load('kspace_single_slice.mat'); % loading k-space data 
kspace_data = kspace.kspace_single_slice ; % extracting the kspace_single_slice variable

%% Calling the kspace_filter_function

% Inputs - k-space data loaded above, type of filter, and the cutoff(normalised) between 0 and 1
% Outputs - the filtered k-space and filtered spatial image 

[low_filtered_kspace, low_filtered_spatial_image] = kspace_filter_function(kspace,'low', 0.1); % Low-pass filtered k-space
[high_filtered_kspace, high_filtered_spatial_image] = kspace_filter_function(kspace,'High', 0.01); % High-pass filtered k-space, 
[unfiltered_kspace, unfiltered_spatial_image] = kspace_filter_function(kspace,'none', 0.0); % Unfiltered data 

%% Recalibrating the axis to run from -N/2 to +N/2 -1

% Recalibrating the freq axis (as per Coursework) from pixel indices to spatial frequency coordinates in mm-1 as follows
% FOV𝑥 = 𝑁𝑥 ⋅Δ𝑥,FOV𝑦 = 𝑁𝑦 ⋅Δ𝑦, where 𝑁𝑥 and 𝑁𝑦 are the image matrix dimensions in pixels;
% FO𝑉𝑥 and 𝐹𝑂𝑉𝑦 are the field of view in millimetres, and 𝛥𝑥 and 𝛥𝑦 are the pixel spacings in millimetres
% Then, Δ𝑘x and Δ𝑘y are the inverse of FOVx and FOVy
% So that the spatial indices kx and ky are as follows ;
% k𝑥 =(−𝑁𝑥/2,..., +𝑁𝑥/2 - 1)⋅Δ𝑘𝑥, and 𝑘y =(−𝑁y/2,..., +𝑁y/2 - 1)⋅Δ𝑘y,

% NOTE: Using literals for delta_x and delta_y because they are provided as literals in the coursework

delta_x = 0.43; % pixel spacing in the x-axis
delta_y = 0.43; % pixel spacing in the y-axis

[a, b ] = size(kspace_data); % extracting image size
n_x = b;  % image matrix dimension in the x-axis
n_y = a;  % image matrix dimension in the y-axis

fov_x = delta_x*n_x; % field of view in the x-axis
fov_y = delta_y*n_y ; % field of view in the y-axis

% computing delta k and y, inverses of the field of view values
delta_k_x = 1/fov_x ; % Δ𝑘x
delta_k_y =  1/fov_y; % Δ𝑘y

% computing the axes for the frequency domain in mm-1
x_axis_freq = (-n_x/2: n_x/2 -1)*delta_k_x; % x axis in mm-1
y_axis_freq = (-n_y/2: n_y/2 -1)*delta_k_y; % y-axis in mm-1

%%  Computing the axes in the spatial domain in mm

% Almost the same conceptually as the freq axes, but in mm 
% For x-y axes: Axis = (-n/2:n/2-1), multiplied by the pixel spacing and summed up with fov/2
% Added fov/2 for centering, without it the axes run from -100 to +100 (more intuitive with 0-200)

x_axis_spatial = (-n_x/2: n_x/2 -1)*delta_x + (fov_x/2) ; % x axis in mm
y_axis_spatial= (-n_y/2: n_y/2 -1)*delta_y + (fov_y/2); % y axis in mm

%% Log transforming kspace data for better visualisation

low_log_kspace = log10(abs((low_filtered_kspace))); % log transform of the low filtered kspace
high_log_kspace= log10(abs((high_filtered_kspace))); % log transform of the high filtered kspace
unfiltered_log_kspace= log10(abs((unfiltered_kspace))); % log transform of the unfiltered kspace

%% Displaying the unfiltered kspace and spatial image

figure; % creating a figure object
sgtitle('K-space Filtering For MRI Brain Data') % main title

% Unfiltered kspace 

subplot(3,2,1);
imagesc((unfiltered_log_kspace), "XData",x_axis_freq, "YData",y_axis_freq) % displaying the kspace image with the recalibrated axis
title('Unfiltered K-space MRI Data') % title of the image
xlabel('Frequency / mm-1') % xlabel
ylabel('Frequency / mm-1') % ylabel
colormap("gray") % gray colormap
axis image % keeping the image axis square

% Unfiltered Spatial Image 

subplot(3,2,2)
imagesc((unfiltered_spatial_image), "XData",x_axis_spatial, "YData",y_axis_spatial) 
title('Unfiltered Spatial MRI Data') % title of the image displayed
xlabel('Spatial / mm') % x-label
ylabel('Spatial / mm') % y-label
colormap('gray') % gray colormap
axis image  % keeping the image axis square

%% Displaying the low-pass filtered k-space and spatial image

% Low-pass filtered kspace 

subplot(3,2,3)
imagesc((low_log_kspace), "XData",x_axis_freq, "YData",y_axis_freq) % displaying the kspace image with the recalibrated axis
title('Low Pass Filtered K-space MRI Data') % title of the image
xlabel('Frequency / mm-1') % xlabel
ylabel('Frequency / mm-1') % ylabel
colormap("gray") % gray colormap
axis image % keeping the image axis square

% Low-pass filtered spatial image 

subplot(3,2,4)
imagesc((low_filtered_spatial_image), "XData",x_axis_spatial, "YData",y_axis_spatial) %  smoother but blurrier image
title('Low Pass Filtered Spatial MRI Data : (0.1) Cutoff') % title of the image and cutoff
xlabel('Spatial / mm') % x-label
ylabel('Spatial / mm') % y-label
colormap('gray') % gray colormap
axis image  % keeping the image axis square

%% Displaying the high-pass filtered kspace and spatial image

% High-pass filtered kspace 

subplot(3,2,5)
imagesc((high_log_kspace), "XData",x_axis_freq, "YData",y_axis_freq) % displaying the kspace image with the recalibrated axis
title('High Pass Filtered K-space MRI Data') % title of the image
xlabel('Frequency / mm-1') % xlabel
ylabel('Frequency / mm-1') % ylabel
colormap("gray") % gray colormap
axis image % keeping the image axis square

% High-pass filtered spatial image 

subplot(3,2,6)
imagesc((high_filtered_spatial_image),"XData",x_axis_spatial, "YData",y_axis_spatial ) % edges are sharper/enhanced but overall contrast is reduced
title('High Pass Filtered Spatial MRI Data : (0.01) Cutoff ') % title of the image and cutoff
xlabel('Spatial / mm') % x-label
ylabel('Spatial / mm') % y-label
colormap('gray') % gray colormap
axis image  % keeping the image axis square
