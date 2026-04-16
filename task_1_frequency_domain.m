%% Task 1

% This script loads  "kspace_single_slice.mat"  which contains the raw k-space for a single MRI slice,
% and displays the logarithmic transform of the magnitude of the k-space values
% by computing L=|log10(kspace)| for better visualisation 

%% Loading the data and log transforming it for better visualisation

kspace = load('kspace_single_slice.mat'); % loading data
kspace_data= kspace.kspace_single_slice ; % extracting the kspace_single_slice variable
log_kspace = log10(abs((kspace_data))); % log transform of the absolute of kspace variable data

%% Recalibrating the axis to run from (-N/2 to +N/2 -1)Δ𝑘

% Recalibrating the axis (as per Coursework instructions) from pixel indices to spatial frequency coordinates in mm-1 as follows
% FOV𝑥 = 𝑁𝑥 ⋅Δ𝑥,FOV𝑦 = 𝑁𝑦 ⋅Δ𝑦, where 𝑁𝑥 and 𝑁𝑦 are the image matrix dimensions in pixels;
% FO𝑉𝑥 and 𝐹𝑂𝑉𝑦 are the field of view in millimetres, and 𝛥𝑥 and 𝛥𝑦 are the pixel spacings in millimetres
% Then, Δ𝑘x and Δ𝑘y are the inverse of FOVx and FOVy
% So that the spatial indices kx and ky are as follows ;
% k𝑥 =(−𝑁𝑥/2,..., +𝑁𝑥/2 - 1)⋅Δ𝑘𝑥, and 𝑘y =(−𝑁y/2,..., +𝑁y/2 - 1)⋅Δ𝑘y,

% Using literals for delta_x and delta_y because they are provided as literals

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

%% Displaying the image with the appropriate axes and frequencies

figure; % creating a figure object
max_val = max(log_kspace(:));          % reference (peak) value
imagesc((log_kspace), "XData",x_axis_freq, "YData",y_axis_freq) % displaying the image with the recalibrated axis
% NOTE: The coursework requires a 20dB range
% However, after checking, the actual data range is 7dB range, so the image has a loss of contrast (it looks 'washed') 
clim([max_val - 20, max_val]);         % enforcing 20 dB dynamic range as per coursework

title('Log Absolute Values of K-space MRI Data') % title of the image displayed
xlabel('kx/ mm-1') % xlabel
ylabel('ky/ mm-1') % ylabel
colormap("gray") % gray colormap
colorbar % displaying the colorbar
