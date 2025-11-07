% ------------------------------------------------------------------------------
% Author: Marta Gaviraghi
% Contact: marta.gaviraghi01@universitadipavia.it
% Date: last version - June 2025
%
% Description:
%   This script is part of a pipeline for the automatic segmentation 
%   of the dentate nuclei (DN) using CCN
%
% Citation:
%   If you use this code in your research or software, please cite the following paper:
%
%   Gaviraghi et al 2021
%   Automatic Segmentation of Dentate Nuclei for Microstructure Assessment:
%   Example of Application to Temporal Lobe Epilepsy Patients.
%   https://doi.org/10.1007/978-3-030-73018-5_21
%   In Computational Diffusion MRI (CDMRI 2020), MICCAI 2020 Workshop.
%   Mathematics and Visualization, pp. 263–278.
% ------------------------------------------------------------------------------

function [] = resampling_normalize_2(b0, mask_brain, path_download, output_path)

% Code 2 of the dentate nucleus (DN) segmentation pipeline
%
% Resamples and normalizes a B0 image for dentate nucleus segmentation
%
% INPUTS:
%   b0           - Full path to the B0 image (NIfTI)
%   mask_brain   - Full path to the brain mask in B0 space (NIfTI)
%   path_download- Path to the folder containing the reference image SIGNAL.nii.gz
%   output_path  - Path to the folder where all outputs will be saved
%
% OUTPUTS (saved in output_path):
%   - 'b0_125.nii.gz'        : Resampled B0 image
%   - 'b0_125.mat'           : Transformation matrix
%   - 'mask_125.nii.gz'  : Resampled brain mask (B0 space)
%   - 'B0_N.nii.gz'          : Normalized B0 image

cd(output_path);


% Load B0 image and replace NaN with 0
b0_gz = horzcat(b0, '.nii.gz');
b0_nii = horzcat(b0, '.nii');
eval(['!gunzip -f ', b0_gz]);
b0_struct = load_untouch_nii(b0_nii);
b0_img = b0_struct.img;
b0_img(isnan(b0_img)) = 0;
eval(['!gzip -f ', b0_nii]);

% Load resampled brain mask
mask_gz = horzcat(mask_brain, '.nii.gz');
mask_nii = horzcat(mask_brain, '.nii');

eval(['!gunzip -f ', mask_gz]);
mask_struct = load_untouch_nii(mask_nii);
mask_img = mask_struct.img;
eval(['!gzip -f ', mask_nii]);

%% 2) Intensity normalization within brain mask
disp('Normalizing B0 image intensity within brain mask...');
b0_vector = b0_img(:);
mask_vector = mask_img(:);
brain_indices = find(mask_vector == 1);
brain_voxels = b0_vector(brain_indices);
mean_brain = mean(brain_voxels);
std_brain = std(brain_voxels);

b0_3d = reshape(b0_vector, size(b0_img));
b0_norm = (b0_3d - mean_brain) / std_brain;

b0_struct.img = b0_norm;
save_untouch_nii(b0_struct, 'B0_N.nii');
!gzip -f B0_N.nii

disp('Resampling and normalization completed!');
end
