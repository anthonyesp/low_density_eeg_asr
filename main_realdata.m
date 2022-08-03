% Script  meant to iterate the testing process hybrid MEMD-ASR
close all
clear
clc

%% Paths
% REMEMBER:
% - The dataset is accesible from: https://github.com/stefan-ehrlich/dataset-automaticArtifactRemoval
% - The "eeglab" path must be added for the script to work. The tolbox is
% accessible from: https://github.com/sccn/eeglab
% - The "clean_rawdata" path must be added for the function to work. The
% plug-in is accessible from: https://github.com/sccn/clean_rawdata
% - The "NAMEMD" path must be added for the function to work. The plug-in
% is accessible from: https://www.neuro.uestc.edu.cn/NA-MEMD.html

addpath('./memd_asr_functions/')

%% Load data to be cleaned
[filename,filepath] = uigetfile('*.set');
ALLEEG = pop_loadset('filename',filename,'filepath',filepath);

% Filter the signal, reduce it to ~ 8 min, and remove EOG channels 
ALLEEG = preprocessing_realdata(ALLEEG);

% Parameter for ASR
w = 0.5; % window width for ASR

% Dataset informations
nch = ALLEEG.nbchan;
max_nch_hybrid = 4; % maximum number of channels to be corrected with MEMD-ASR
max_iter = 15; % number of times the channel subset (4 to 1) is randomly selected from the available channels
fs = ALLEEG.srate;

% Select baseline segment
cal_int = 1:round(ALLEEG.event(3).latency)+1;

%% Test hybrid method on decrescent number of channels from 4
for i=1:max_nch_hybrid
    for t = 1:max_iter % try 15 times the channel selection
        disp(["Trial number: ",num2str(t)])
        results = struct();
        % Random channel selection
        sub_ch = randperm(nch,max_nch_hybrid-(i-1));
        try
            signal = ALLEEG.data(sub_ch,:)';
            % cut-off parameter for ASR
            if size(signal,2) == 4  % 4 channels
                k = 9;
            elseif size(signal,2) == 3 || size(signal,2) == 2   % 3 or 2 channels
                k = 8;
            elseif size(signal,2) == 1   % 1 channel
                k = 7;
            end
            cleaned = memd_asr(signal,cal_int,k,fs,w);
            results.data = cleaned;
            results.channels = string({ALLEEG.chanlocs(1,sub_ch).labels});

            clc
            nm = strcat(filepath,char(filename),"_numCh_",num2str(max_nch_hybrid+1-i),"_it_",num2str(t));
            save(nm,'results');

        catch
            disp('ERROR!');
        end
    end
end