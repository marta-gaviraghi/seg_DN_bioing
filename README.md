# Automatic dentate nuclei (DN) segmentation pipeline

## Description
This pipeline implements an automated method to segment the dentate nuclei (DN) from diffusion MRI data using a 2D CNN. It is implemented in MATLAB R2019a with the Deep Learning Toolbox.
The CNN was trained on high-resolution b0 images from the Human Connectome Project (HCP) and has been tested on clinical external datasets, including Temporal Lobe Epilepsy (TLE) patients.

![alt text](https://github.com/marta-gaviraghi/segmentDN/blob/master/figure/CNN_cap4_ok.png)

The pipeline consists of three scripts:

1) resampling_normalize_2.m: Resamples and normalizes the B0 image in the HCP space.

2) CNN_postprocessing_3.m: Performs CNN-based DN segmentation.

## Repository Structure
script/: Contains the MATLAB scripts for each processing step.

download/: Includes necessary reference files and templates.

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

**Option A - from MATLAB (easiest)**
Home > Add-Ons > Get Add-Ons, search for each toolbox and click Install.

**Option B - automatically from the terminal with MPM (MATLAB Package Manager)**
MPM downloads and installs the toolboxes into an existing MATLAB installation.
Replace `R2025b` with your MATLAB release and the destination with your MATLAB folder (in MATLAB: `matlabroot`).

macOS (Apple Silicon):
```bash
curl -L -o ~/mpm https://www.mathworks.com/mpm/maca64/mpm && chmod +x ~/mpm
sudo ~/mpm install --release=R2025b --destination=/Applications/MATLAB_R2025b.app --products Deep_Learning_Toolbox Computer_Vision_Toolbox Image_Processing_Toolbox
```
On an Intel Mac use `maci64` instead of `maca64` in the URL.

Linux:
```bash
wget -O ~/mpm https://www.mathworks.com/mpm/glnxa64/mpm && chmod +x ~/mpm
sudo ~/mpm install --release=R2025b --destination=/usr/local/MATLAB/R2025b --products Deep_Learning_Toolbox Computer_Vision_Toolbox Image_Processing_Toolbox
```

Windows: download [mpm.exe](https://www.mathworks.com/mpm/win64/mpm), open a Command Prompt **as administrator** in the download folder and run:
```bat
mpm.exe install --release=R2025b --destination="C:\Program Files\MATLAB\R2025b" --products Deep_Learning_Toolbox Computer_Vision_Toolbox Image_Processing_Toolbox
```

`sudo` / administrator rights are needed because MPM writes into the MATLAB installation folder.

**Option C - MATLAB Online**
With the university license, [MATLAB Online](https://matlab.mathworks.com) already includes all the toolboxes: no installation needed.

## Usage
Clone the repository:
```bash
git clone https://github.com/marta-gaviraghi/seg_DN_bioing
```

In MATLAB, go to the repository folder and run once:
```matlab
setup
```
It checks the required toolboxes, downloads the NIfTI toolbox into `download/NIfTI_tools` and adds the repository to the MATLAB path.
Note: the scripts gunzip/gzip the input images in place, so work on a copy of your data.

Run the scripts in order:


#### resampling_normalize_2.m
**Inputs:** B0 image, brain mask, download folder, output folder  
**Outputs:** Resampled B0 (`b0_125.nii.gz`), normalized B0 (`B0_N.nii.gz`)  

#### CNN_postprocessing_3.m
**Inputs:** Output folder, download folder, original B0 image  
**Outputs:** CNN segmentation (`DN_CNN_final.nii.gz`)

## Citation
For more details, see the original publication:  

Gaviraghi et al., 2021, Automatic Segmentation of Dentate Nuclei for Microstructure Assessment: Example of Application to Temporal Lobe Epilepsy Patients
DOI: 10.1007/978-3-030-73018-5_21

**If you use this code in your work, please cite the above paper.**


### CNN Architecture


![alt text](https://github.com/marta-gaviraghi/segmentDN/blob/master/figure/Figure_1.bmp)
