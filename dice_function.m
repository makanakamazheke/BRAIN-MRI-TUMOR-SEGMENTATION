function [dice_coefficient] = dice_function(ground_truth,mask)

% This function displays the dice coefficient for two images (a given ground truth mask and a custom mask in this case)
% The dice coefficient is a measure of how similar images are, 
% and is given by Dice(A,B) = 2⋅|A∩B|/(|A|+|B|)
% where ∣ 𝐴 ∣  and ∣ 𝐵 ∣  are the number of voxels in each mask, and ∣ 𝐴 ∩ 𝐵 ∣  is the number of voxels where both masks overlap/intersect.
% Inputs: Ground truth = The actual mask for the tumor/feature  
%           Mask = custom mask 
% Output: Dice Coefficient

% Note: The question does not specify if the function should be for this specific task or a generic function for any images
% Therefore, I named the variables specifically for this task, though it can be used for any two images 

%% Conversion to logical datatype

    logical_mask3D = logical(mask); % converting the mask to logical datatype for comparison
    logical_ground_truth = logical(ground_truth); % converting the ground truth data to logical datatype for comparison

    %% Error checking 

    % Size: they must be the same size
    if size(logical_ground_truth) ~= size(logical_mask3D) % checking for the sizes of the masks
        error('Error : Both images must be the same size') % error message for size mismatch
        return
    end
   
    %% Calculating number of overlaps

    overlap_mask = (logical_ground_truth & logical_mask3D); % finding the areas of overlap with & condition

    % nnz is for filtering out the 0=0 overlaps, retains only the 1's

    number_of_overlaps = nnz(overlap_mask(:)); % number of overlaps, only the 1's count

    %% Calculating the dice coefficient

    dice_coefficient = 2*number_of_overlaps/(nnz(logical_ground_truth) +  nnz(logical_mask3D)); % computing dice coeff as per formula
    
end

