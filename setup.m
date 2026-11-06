function [] = setup()
% Setup of the dentate nucleus (DN) segmentation pipeline
%
% Run once before using the pipeline:
%   - checks that the required MATLAB toolboxes are installed and licensed
%   - downloads the NIfTI toolbox (load_untouch_nii / save_untouch_nii)
%     into download/NIfTI_tools if it is not already on the path
%   - adds download/ (CNN model and custom layer) and the NIfTI toolbox
%     to the MATLAB path

repo_path = fileparts(mfilename('fullpath'));
path_download = fullfile(repo_path, 'download');
ok = true;

%% 1) Required MathWorks toolboxes
% {folder name used by ver, license feature name, product name}
toolboxes = {
    'nnet',   'Neural_Network_Toolbox',   'Deep Learning Toolbox'
    'vision', 'Video_and_Image_Blockset', 'Computer Vision Toolbox'
    'images', 'Image_Toolbox',            'Image Processing Toolbox'
    };

disp('Checking required toolboxes...');
for i = 1:size(toolboxes, 1)
    installed = ~isempty(ver(toolboxes{i,1}));
    licensed = license('test', toolboxes{i,2});
    if installed && licensed
        fprintf('  [OK]      %s\n', toolboxes{i,3});
    elseif ~installed
        fprintf('  [MISSING] %s - install it from Home > Add-Ons\n', toolboxes{i,3});
        ok = false;
    else
        fprintf('  [NO LIC]  %s - installed but not licensed\n', toolboxes{i,3});
        ok = false;
    end
end

%% 2) NIfTI toolbox (Jimmy Shen, File Exchange #8797)
nifti_path = fullfile(path_download, 'NIfTI_tools');
if exist('load_untouch_nii', 'file') ~= 2 && ~isfile(fullfile(nifti_path, 'load_untouch_nii.m'))
    disp('Downloading NIfTI toolbox from File Exchange...');
    nifti_url = ['https://www.mathworks.com/matlabcentral/mlc-downloads/' ...
        'downloads/submissions/8797/versions/28/download/zip'];
    zip_file = fullfile(tempdir, 'NIfTI_tools.zip');
    try
        websave(zip_file, nifti_url);
        unzip(zip_file, nifti_path);
        delete(zip_file);
    catch err
        fprintf('  [ERROR]   NIfTI download failed: %s\n', err.message);
        disp('            Download it manually from https://www.mathworks.com/matlabcentral/fileexchange/8797');
        fprintf('            and unzip it in %s\n', nifti_path);
        ok = false;
    end
end
if isfolder(nifti_path)
    addpath(nifti_path);
end
if exist('load_untouch_nii', 'file') == 2
    disp('  [OK]      NIfTI toolbox');
end

%% 3) Pipeline scripts, CNN model and custom Dice layer (needed to load rete1.mat)
% the pipeline scripts cd into output_path, so the repo must be on the path
addpath(repo_path);
addpath(path_download);

%% 4) gzip / gunzip used by the pipeline scripts
[status_gz, ~] = system('which gzip gunzip');
if status_gz ~= 0
    disp('  [MISSING] gzip/gunzip command line tools');
    ok = false;
end

if ok
    disp('Setup completed: you can run resampling_normalize_2 and CNN_postprocessing_3.');
else
    disp('Setup NOT completed: fix the items above and run setup again.');
end
end
