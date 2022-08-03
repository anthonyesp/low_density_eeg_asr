function EEG = preprocessing_realdata(EEG,varargin)
% preprocessing_realdata: Function to pre-process the EEG data accessible
% at: https://github.com/stefan-ehrlich/dataset-automaticArtifactRemoval
%
% This function does the following:
% 1) filters the signal in range [1, 40] Hz
% 2) removes channel baseline means from EEG dataset
% 3) reduces the signal (which lasts about an hour) to about 8 min
% 4) removes EOG channels
%
% Input:   EEG = EEGLAB structure
%
% VARARGIN:
% 'stop_data' numbers of events to include in reduced signal: 
%       1 - discard marked artifacts
%		2 - apply an artifact removal technique (currently only ASR)
%       3 - discard marked artifacts and remove others
%
% Outputs: EEG = EEGLAB structure containing processed data
%
%
%% Paths
% REMEMBER:
% - The "eeglab" and the "firfilt" plug-in paths must be added for the script to work. The tolbox is
% accessible from: https://github.com/sccn/eeglab

% Varargin check
if (nargin > 2)
    error('Too many input arguments!');
elseif (nargin == 2)
    stop_data = varargin{1};
    if stop_data < 2 || stop_data > 92
        error('The numbers of events to include must be within the range [2,92] for the current dataset!')
    end
else
    stop_data = 12;
end

EEG = pop_eegfiltnew(EEG, 'locutoff',1,'hicutoff',40);  % filtering
EEG = pop_rmbase(EEG,[],[]);                            % base normalization

% Delete relax phase before baseline
ind1 = EEG.event(2).latency-1;   
EEG = eeg_eegrej(EEG,[1 ind1]); 

% Reduce the original EEG trace to ~ 8 min
typev = struct2table(EEG.event);
indx = find(contains(typev.type,'S 15'));
ind2 = EEG.event(indx(stop_data)).latency-1;
EEG = eeg_eegrej(EEG,[ind2 EEG.pnts]);

% Removing 3 EOG chans
EEG = pop_select(EEG,'nochannel',{'EOG1' 'EOG2' 'EOG3'});
end