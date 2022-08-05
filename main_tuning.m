% Fine-tuning of best parameters of ASR on semi-simulated data 
% (Phase 2 on reference paper)
% Last update: 2022-08-04
%
clear
close all
clc

% Paths - Change with your directory paths
addpath(".\ASR_tuning_functions\");
eeglab_path = 'C:\Users\Utente\Script\eeglab2021.1\';
addpath(eeglab_path);
addpath(genpath(strcat(eeglab_path,'functions')));
addpath(genpath(strcat(eeglab_path,'plugins\clean_rawdata2.5')));

% Iterative k and wl optimization
k_vect = zeros(1,20); wl_vect = zeros(1,20);
for id=0:19     % Semi-simulated data identification

    filename = strcat("..\sim8ch data\ALLEEG_simMRC_",num2str(id),".mat");
    load(filename);
    sim_ds = ALLEEG(1);
    cont_ds = ALLEEG(2);

    [best_k, best_wl] = ASR_tuning_fnc(sim_ds,cont_ds);

    k_vect(id+1) = best_k;
    wl_vect(id+1) = best_wl;

    fprintf("End of %d ° loop",id+1);
end

% Identification of mean k and wl for application on real data
k_real = mean(k_vect);
wl_real = mean(wl_vect);
% k_std = std(k_vect);
% wl_std = std(wl_vect);

% Application on real data (Phase 3 on reference paper)
% Load your real data
%   cont_eeg = load('real_data.mat');
%
% Apply ASR with selected k and wl values
% We chose to use the mean values (see reference paper)
%   corr_eeg = clean_asr(cont_eeg,k_real,wl_real);
%
% Visual inspection between original signal and corrected signal 
%   vis_artifacts(corr_eeg,cont_eeg);

