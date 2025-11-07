function [] = CNN_postprocessing_3(output_path, path_download, b0)
% Code 3 of the dentate nucleus (DN) segmentation pipeline
%
% Segmentation and post-processing of the dentate nucleus (DN) from B0 images using a CNN
%
% INPUTS:
%   output_path   - Folder where outputs will be saved and where previous outputs are located
%   path_download - Folder containing the pre-trained CNN model 'rete1.mat'
%   b0            - Full path to the original B0 NIfTI image
%
% OUTPUTS (saved in output_path):
%   - 'DN_CNN_125.nii'      : CNN segmentation in resampled space (1.25 mm)
%   - 'DN_CNN_orig.nii.gz'  : CNN segmentation mapped back to original B0 space
%   - 'DN_CNN_final.nii.gz' : Post-processed segmentation filtered by SUIT mask

%% Define paths to required files from previous steps
b0_resampled_mat = fullfile(output_path, 'b0_125.mat');      % from script 2
seg_den_suit     = fullfile(output_path, 'DN_diff_SUIT.nii.gz');    % from script 1

%% Load CNN model
cd(path_download)
load('rete1.mat');

%% Move to output folder
cd(output_path);

%% Initialize segmentation volume
dentati_sa = zeros(86, 71, 66);

% Load normalized B0 image
!gunzip -f B0_N.nii.gz
b0_struct = load_untouch_nii('B0_N.nii');
b0_img = b0_struct.img;
b0_test = b0_img(30:115, 10:80, 5:70); % crop as in original
!gzip -f B0_N.nii
    
% CNN segmentation slice-by-slice
for slice = 1:66
    [C, score] = semanticseg(b0_test(:,:,slice), net);
    dentati_sa_slice = uint8(C) - 1; % DN = 1, background = 0
    dentati_sa(:,:,slice) = dentati_sa_slice;
end
    
% Expand segmentation to full volume
dent_sa_dim = zeros(145, 174, 145);
dent_sa_dim(30:115, 10:80, 5:70) = dentati_sa;
    
% Save CNN segmentation in resampled space
dentati_sa_struct = b0_struct;
dentati_sa_struct.img = dent_sa_dim;
save_untouch_nii(dentati_sa_struct, 'DN_CNN.nii');
    
else
    disp('Required inputs from previous steps not found! Run scripts 1 and 2 first.');
end
