% Script to obtain semi-simulated EEG data contaminated with EOG+EMG artifacts
% emulating real data characteristics (Phase 1 of reference paper)
%
% REMEMBER:
% - The MRC simulator is accessible from: https://data.mrc.ox.ac.uk/data-set/simulated-eeg-data-generator
% - The denoiseNet artifacts dataset is accessible from: https://github.com/ncclabsustech/EEGdenoiseNet
% - The "eeglab" path must be added for the script to work. The toolbox is
%   accessible from: https://github.com/sccn/eeglab
% - The "clean_rawdata" path must be added for the function to work. The
%   plug-in is accessible from: https://github.com/sccn/clean_rawdata
% - Change paths with your directory paths 
%

clear
close all
clc

% Toolboxes paths
addpath('..\EEG_simulators\MRC_EEG_generator');
addpath('..\eeglab2021.1\');
addpath(genpath('..\eeglab2021.1\functions\'));
addpath(genpath('..\eeglab2021.1\plugins\firfilt'));

%% Phase 1: pure EEG simulation
% 31 simulated channels: 
% {FP1 FP2 AFZ F7 F3 FZ F4 F8 FT7 FC3 FCZ FC4 FT8 T7 C3 
% CZ C4 T8 TP7 CP3 CPZ CP4 TP8 P7 P3 PZ P4 P8 O1 OZ O2}
% Frames, trials and sampling rate to customize inside the function:
simEEG = simulatedEEG; 

% Selection of channels
indexes = [1,2,6,15,16,17,29,31];
lbl = {'Fp1' 'Fp2' 'Fz' 'C3' 'Cz' 'C4' 'O1' 'O2'};
simEEG = simEEG(indexes,:);

% Simulated signal characteristics
fs = 256;           % Hz
tr = 120;           % seconds
nch = length(lbl);  % number of channels


%% Phase 2: loading EOG and EMG segments
% From denoiseNet dataset:
load C:\Users\Utente\Script\EEG_simulators\artifacts_dataset\EOG_all_epochs.mat
load C:\Users\Utente\Script\EEG_simulators\artifacts_dataset\EMG_all_epochs.mat

% 30 random indexes to select artifacts segments
A = randsample(size(EMG_all_epochs,1),15);
B = randsample(size(EOG_all_epochs,1),15);
emg = []; eog = [];

% Monodimensional artifact signals
for i=1:15
    emg = [emg EMG_all_epochs(A(i),:)]; %#ok
    eog = [eog EOG_all_epochs(B(i),:)]; %#ok
end


%% Phase 3: linear mixing (pure signal + artifacts)
% Artifact signals adaptation on channels
factor = 300;
U = ones(nch,1)/factor;                              % EMG scaling factors
W = [1; 1; 0.73; 0.24; 0.01; 0.12; 0.31; 0.28]/3;    % EOG correlation coefficients + scaling factor
len = size(simEEG,2)/2;
mus_art = [zeros(nch,len),U*emg,zeros(nch,len/2)];
ocu_art = [zeros(nch,3*len/2),W*eog];

% Linear combination
contEEG = simEEG + mus_art + ocu_art;

%% Check SNR after rescaling artifacts amplitude
% Interval of muscle artifacts
intm = [len+1:len+length(emg)]; 
Sm = snr(simEEG(:,intm), contEEG(:,intm));
if (Sm<5) && (Sm>-20)      % dB
    disp('Muscle artifacts ok!')
else
    error('SNR out of limits, try again!')
end

% Interval of ocular artifacts
intv = [3*len/2+1:3*len/2+length(eog)]; 
So = snr(simEEG(:,intv), contEEG(:,intv));
if (So<5) && (So>-20)      % dB
    disp('Ocular artifacts ok!')
else
    error('SNR out of limits, try again!')
end

%% Pre-processing with EEGLAB
% (channel locations identification, filtering, base-normalization, resampling)
% Pure EEG
EEG = pop_importdata('dataformat','array','nbchan',nch,'data','simEEG','setname','simEEG','srate',256);
EEG.chanlocs = struct('labels',lbl);
EEG = pop_chanedit(EEG,'lookup','C:\Users\Utente\Script\eeglab2021.1\plugins\dipfit4.3\standard_BEM\elec\standard_1005.elc');
EEG = pop_eegfiltnew(EEG, 'locutoff',1,'hicutoff',50);
EEG = pop_rmbase(EEG,[],[]);
EEG = pop_resample(EEG, 200);
ALLEEG(1) = EEG;

% Contaminated EEG
EEG = pop_importdata('dataformat','array','nbchan',nch,'data','contEEG','setname','contEEG','srate',256);
EEG.chanlocs = struct('labels',lbl);
EEG = pop_chanedit(EEG,'lookup','C:\Users\Utente\Script\eeglab2021.1\plugins\dipfit4.3\standard_BEM\elec\standard_1005.elc');
EEG = pop_eegfiltnew(EEG, 'locutoff',1,'hicutoff',50);
EEG = pop_rmbase(EEG,[],[]);
EEG = pop_resample(EEG, 200);
ALLEEG(2) = EEG;

%% Saving semi-simulated dataset
% 1x2 struct with pure and contaminated data
filename = strcat("ALLEEG_simMRC_",datestr(now,'dd-mm-yy_HH-MM'),".mat");
save(filename,'ALLEEG');
