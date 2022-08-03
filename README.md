# Artifact Subspace Reconstruction (ASR) vs EEG

## This repository at a glance
Scripts are provided to investigate or apply artifact removal to EEG signals with a focus on a few channels case (i.e., low-density EEG). 
These are related to:
 - finding optimal parameters for ASR
 - using multivariate empirical mode decomposition (MEMD) with ASR to deal with few channels

## Suggested data
You can use any data, but if you are willing to replicate the results of the references below, we suggest:
 - SEED-G simulator (https://doi.org/10.3390/s21113632) + EEGdenoiseNet (https://github.com/ncclabsustech/EEGdenoiseNet)
 - real data with artifact from https://github.com/stefan-ehrlich/dataset-automaticArtifactRemoval

## Further details

1. ???
2. P. Arpaia, E. De Benedetto, A. Esposito, A. Natalizio, M. Parvis, and M. Pesola, "Low-density EEG correction with multivariate decomposition and artifact subspace reconstruction", submitted to IEEE Transactions on Instrumentation and Measurement (August 2022)
3. P. Arpaia, E. De Benedetto, A. Esposito, A. Natalizio, M. Parvis, and M. Pesola, "Comparing artifact removal techniques for daily-life electroencephalography with few channels", in IEEE International Symposium on Medical Measurements and Applications, (Taormina, Italy), 2022.