%% Task 3
% Filtering in the frequency/k-space domain function

function [filtered_kspace_image,filtered_spatial_image] = kspace_filter_function(kspace,filter, cutoff_normalised)
% [filtered_kspace_image,filtered_spatial_image] = kspace_filter_function(kspace,filter, cutoff_normalised)

% This function applies a circular spectral filter to k-space data and reconstructs the spatial image. 
% It loads kspace data, takes arguments for the filter type (low-pass, high-pass, or no filter), and the cut-off frequency.
% The cut-off frequency input is also normalised with values between 0 and 1

% INPUTS : 

% kspace - raw kspace dataset
% filter - filter type (low-pass, high-pass, or no filter)
% cutoff_normalised - cutoff between 0 and 1

% OUTPUTS
% filtered_kspace_image - the filtered kspace image data 
% filtered_spatial_image - the filtered spatial image data

    %% Passing in kspace data
    
    kspace_data = kspace.kspace_single_slice ; % extracting the kspace_single_slice variable
    filter = lower(filter); % for case insensitive inputs. For example, inputs:high, HIGH, hIgH will return the same result. Same as LOw, LOW, low etc

    %% Error checking

    % Checking for valid cutoffs in this block, and then for valid filters in the case switch block

    valid_cutoffs = 0:.01:1; % numbers between 0 and 1, with a precision of 0.01 

    if ~ismember(valid_cutoffs,cutoff_normalised) % membership operator to check if the input cutoff is valid 

        error('Invalid Cutoff. Please choose a cutoff between 0 and 1 with 0.01 precision') % return error message
        
    end

    %% Defining parameters for a mask

    % This section creates a distance grid for a circular mask using the image/kspace data dimensions to define coordinates
    
    [a, b ] = size(kspace_data); % extracting image size, rows a and columns b

    
    [column,row] = meshgrid(1:b, 1:a); % creating a grid/matrix with coordinates up to the dimensions of the kspace data

    % Computing distance of each point from the centre of k-space,(i'm assuming the image is square...)
    % This will be used to define the circular mask

    distance = sqrt((column - b/2).^2 + (row - a/2).^2); % distance of each point from the centre of k-space, centre coordinates are a/2 and b/2

    %% Computing cutoff radius in pixels
    % The maximum possible radius is the same as the max frequency formula
    % ... provided in the question but using pixel indices instead (more intuitive)
    
    max_possible_radius = sqrt((b/2)^2 + (a/2)^2); % the maximum possible radius is the maximum possible distance from the centre
    cutoff = cutoff_normalised*max_possible_radius; % Scaling the normalized cutoff input argument (0 to 1) to the maximum possible distance


    %% Low-Pass Filter

    %  For a low-pass filter, high frequencies outside the cutoff radius are excluded

    switch filter   % If-else actually worked just as well, but case switch is more appropriate for discrete values

        case 'low' % low-pass filter
            mask = distance <= (cutoff); % exclude high frequencies outside the cutoff

            % Filtering/convolution in the spatial domain is equivalent to pointwise multiplication in the frequency domain

            filtered_kspace_image = mask .* kspace_data; % applying the filter to the kspace data via pointwise multiplication

    %% High-Pass Filter

    %  For a high-pass filter, low frequencies inside the cutoff radius are excluded

        case 'high' % high-pass filter
            mask = distance >= (cutoff); % exclude frequencies inside the cutoff
            filtered_kspace_image = mask .*kspace_data;

     %% No filter, returning unfiltered data

        case 'none'
            filtered_kspace_image = kspace_data; % return unfiltered data 
        otherwise
            error('Invalid filter input. Valid Options are low, high and none') % error checking for invalid inputs
    end

%% Reconstruction of filtered spatial data from filtered k-space

    spatial_image = ifft2(double(filtered_kspace_image));% inverse fourier transform for 2D data, double to maintain precision
    
    %% Shifting and scaling/normalising the image 

    shifted_image = fftshift(spatial_image); % shifting the zero frequency component
    abs_image = abs(shifted_image); % absolute value of the image
    filtered_spatial_image = abs_image /max(abs_image(:)); % normalising by dividing by the absolute maximum value of the image
    
end
