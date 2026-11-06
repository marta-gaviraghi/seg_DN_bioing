# Automatic dentate nuclei (DN) segmentation pipeline

## Description
This pipeline implements an automated method to segment the dentate nuclei (DN) from diffusion MRI data using a 2D CNN. It is implemented in MATLAB R2019a with the Deep Learning Toolbox.
The CNN was trained on high-resolution b0 images from the Human Connectome Project (HCP) and has been tested on clinical external datasets, including Temporal Lobe Epilepsy (TLE) patients.

![alt text](https://github.com/marta-gaviraghi/segmentDN/blob/master/figure/CNN_cap4_ok.png)

The pipeline consists of two scripts:

1) resampling_normalize_2.m: Normalizes the intensity of the B0 image within the brain mask. The B0 must already be in the HCP space (145x174x145 voxels, 1.25 mm isotropic), so no resampling is performed.

2) CNN_postprocessing_3.m: Performs CNN-based DN segmentation.

## Repository Structure
setup.m: Checks the requirements and prepares the MATLAB path.

resampling_normalize_2.m, CNN_postprocessing_3.m: The pipeline scripts.

SIGNAL.nii.gz, nodif_brain_mask.nii.gz, T1w_acpc_dc_restore_1.25.nii.gz: Example images (B0, brain mask and T1w).

download/: Contains the trained CNN (`rete1.mat`), the custom Dice layer (`dicePixelClassificationLayer.m`) and `matRead.m`. `setup.m` adds the NIfTI toolbox here (`NIfTI_tools/`).

## Requirements
- MATLAB (R2019 or later) with:
  - Deep Learning Toolbox
  - Computer Vision Toolbox (provides `semanticseg`)
  - Image Processing Toolbox
- NIfTI toolbox (`load_untouch_nii` / `save_untouch_nii`), downloaded automatically by `setup.m`
- `gzip` / `gunzip` command line tools
- FSL (FMRIB Software Library)

## Installing the MATLAB toolboxes
Check first which toolboxes you already have: in MATLAB run `ver`.
Your MATLAB license must include the toolboxes (the university campus license usually does).

In MATLAB go to Home > Add-Ons > Get Add-Ons, search for each toolbox and click Install.

## Usage
Clone the repository:
```bash
git clone https://github.com/marta-gaviraghi/seg_DN_bioing
```

In MATLAB, go to the repository folder and run:
```matlab
setup
```
It checks the required toolboxes, downloads the NIfTI toolbox into `download/NIfTI_tools` and adds the repository to the MATLAB path.
The path is not saved, so run `setup` again each time you restart MATLAB.
Note: the scripts gunzip/gzip the input images in place, so work on a copy of your data.

Before running the scripts, look at the network:
```matlab
load(fullfile('download', 'rete1.mat'), 'net');
analyzeNetwork(net)
```
It opens a window with the network graph and, for each layer, its type, output size and number of learnable parameters.

Run the scripts in order:


#### resampling_normalize_2.m
**Inputs:** B0 image and brain mask (full paths without `.nii.gz`), download folder, output folder (must already exist)  
**Outputs:** Normalized B0 (`B0_N.nii.gz`)  

#### CNN_postprocessing_3.m
**Inputs:** Output folder, download folder, B0 image (full path without `.nii.gz`)  
**Outputs:** CNN segmentation (`DN_CNN.nii`)

## Citation
For more details, see the original publication:  

Gaviraghi et al., 2021, Automatic Segmentation of Dentate Nuclei for Microstructure Assessment: Example of Application to Temporal Lobe Epilepsy Patients
DOI: 10.1007/978-3-030-73018-5_21

**If you use this code in your work, please cite the above paper.**


### CNN Architecture


![alt text](https://github.com/marta-gaviraghi/segmentDN/blob/master/figure/Figure_1.bmp)
