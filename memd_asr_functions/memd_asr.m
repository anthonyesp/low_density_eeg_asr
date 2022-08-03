function cleaned_signal = memd_asr(signal, cal_int, k, samp_r, w)
% This function implements a hybrid MEMD+ASR method for EEG artifact removal.
%
%
% Inputs: signal = original EEG signal with (#samplings*#channels) dimensions
%         cal_int = calibration interval for ASR. It shoud be a
%         one-dimesional array containing the indices of the samples of signal matrix 
%         to be used for calibration.
%         k = cut-off parameter for ASR
%         samp_r = sampling rate of the original signal
%         w = width of the sliding window for ASR
%
% Outputs: cleaned_signal = reconstructed signal with (#samplings*#channels) dimensions
%
%
% REMEMBER:
% - The "clean_rawdata" path must be added for the function to work. The
% plug-in is accessible from: https://github.com/sccn/clean_rawdata
% - The "NAMEMD" path must be added for the function to work. The plug-in
% is accessible from: https://www.neuro.uestc.edu.cn/NA-MEMD.html

if size(signal,2) > 4
    error('Please, use ASR alone!')
end

if length(cal_int) < 30*samp_r
    error('The calibration interval must be 30-seconds-long at least!')
end

if isempty(samp_r)
    error('The sampling frequency is required!')
end

if isempty(k)
    if size(signal,2) == 4
        k = 9;
    elseif size(signal,2) == 3 || size(signal,2) == 2
        k = 8;
    elseif size(signal,2) == 1
        k = 7;
    end
end

if isempty(w)
    w = 0.5;
end

% Parameter definition
nbchan = size(signal,2);
ndir = 2 * (nbchan+1);

%% Pre-processing
sampls = samp_r/4;
chunk = flipud(signal(end-(sampls-1):end,:));
signal = [signal;chunk];                  % o remove at the end
if (ndir < 6)
    ndir = 6;
end

%% Decomposition
if nbchan <= 4 && nbchan > 1
    % MEMD
    imfs = namemd(signal,ndir);
elseif nbchan == 1
    % EMD
    [imf,res] = emd(signal);
    imfs = {[imf,res]'};
end

%% IMF grouping
% initializing
RANGE = zeros(nbchan,1);
n_imfs = size(imfs{1,1},1);
range = zeros(nbchan, n_imfs);
below_th = zeros(nbchan, n_imfs);
imf_to_sum = zeros(1,n_imfs);

for ch = 1:nbchan
    % values range per each channel (90° and 10° percentile)
    RANGE(ch) = prctile(signal(cal_int,ch),90) - prctile(signal(cal_int,ch),10);

    % process IMFs per channel
    temp = imfs{ch,1};
    for im = 1:n_imfs
        % values range per each imf (90° and 10° percentile)
        range(ch,im) = prctile(temp(im,cal_int),90) - prctile(temp(im,cal_int),10);

        % identify imf ranges below threshold
        below_th(ch,im) = range(ch,im) < 0.1*RANGE(ch);
    end

    % consider the IMF to sum: at least in a channel below threshold
    imf_to_sum = imf_to_sum|below_th(ch,:);
end

% sum all the IMFs below threshold with the closest above threshold!
[~, closest] = min(mean(range(:,imf_to_sum==0),1));
imf_to_sum(closest) = 1;
imfs_short = cell(nbchan,1);
for ch = 1:nbchan
    temp = imfs{ch,1};
    imfs_short{ch,1} = [temp(imf_to_sum==0,:);sum(temp(imf_to_sum==1,:))];
end

res_imfs = size(cell2mat(imfs_short(1,1)),1);   % Number of resulted IMFs for each channel

%% ASR
f = w/2;
ds = cell2mat(imfs_short);                      % Transformation in matrix form
StateA = asr_calibrate(ds(:,cal_int),samp_r,k);
ds = asr_process(ds,samp_r,StateA,w,f);

%% Signal reconstruction
reconstr = zeros(size(signal));            % Empty matrix with same size as signal
a = 0;
for i=1:nbchan
    A = ds([1+a:res_imfs+a],:);
    a=a+res_imfs;
    reconstr(:,i)=sum(A,1);
end
cleaned_signal = reconstr((sampls+1):end,:);      % Reconstructed signal
end