# Artifact Subspace Reconstruction (ASR) vs EEG

## This repository at a glance
Scripts are provided to investigate or apply artifact removal to EEG signals with a focus on a few channels case (i.e., low-density EEG). 

These scripts are related to:
 - finding optimal parameters for ASR,
 - using multivariate empirical mode decomposition (MEMD) with ASR to deal with few channels

## Suggested data
You can use any data, but if you are willing to replicate the results of the references below, we suggest:

 - MRC EEG data simulator (https://doi.org/10.1111/j.1469-8986.2004.00239.x) + EEGdenoiseNet (https://github.com/ncclabsustech/EEGdenoiseNet)
 - SEED-G simulator (https://doi.org/10.3390/s21113632) + EEGdenoiseNet (https://github.com/ncclabsustech/EEGdenoiseNet)
 - real data with artifact from https://github.com/stefan-ehrlich/dataset-automaticArtifactRemoval
 
## Requirements 

 - EEGLAB version 2021.1

## How to
Don't worry, we are going to explain... in the meanwhile, you will find what we did in the following references!

## Further details

1. A. Cataldo, S. Criscuolo, E. De Benedetto, A. Masciullo, M. Pesola, R. Schiavoni, and S. Invitto "A Method for Optimizing the ASR Performance in low-density EEG", submitted to IEEE Sensors Journal (August 2022)
2. P. Arpaia, E. De Benedetto, A. Esposito, A. Natalizio, M. Parvis, and M. Pesola, "Low-density EEG correction with multivariate decomposition and artifact subspace reconstruction", submitted to IEEE Transactions on Instrumentation and Measurement (August 2022)
3. P. Arpaia, E. De Benedetto, A. Esposito, A. Natalizio, M. Parvis, and M. Pesola, "Comparing artifact removal techniques for daily-life electroencephalography with few channels", in IEEE International Symposium on Medical Measurements and Applications, (Taormina, Italy), 2022.
