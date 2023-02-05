function fnc_comparison(subj,ind,fpath)
% Comparison of different artifact removal techniques on real EEG data
% (from 27 to 2 EEG random channels)

% Data import
dname = strcat(num2str(ind),'_reduced_s0',num2str(subj),'.set');
ALLEEG = pop_loadset('filename',dname,'filepath',fpath);

% Removing 3 EOG chans
EOGind = [5,16,25];
ALLEEG.data(EOGind,:) = [];
ALLEEG.chanlocs(EOGind) = [];
ALLEEG.nbchan = ALLEEG.nbchan -3;

%% Randomization of channels
nch = 27;                   % number of channels
nit = 26;                   % number of iterations
index = randperm(nch,nch);  % new random index array

[ALLEEG, ~, ~] = pop_copyset(ALLEEG, 1, 2);
ALLEEG(2).data = ALLEEG(2).data(index,:);
ALLEEG(2).chanlocs = ALLEEG(2).chanlocs(index);

%% Iterations
for i=1:nit 
    a = 8*(i-1);    % index for new dataset placement in ALLEEG structure
    [ALLEEG, ~, ~] = pop_copyset(ALLEEG, 2, (3+a));

    %% ASR_less aggressive
    k = 25;     % cutoff value
    try
        clean_data = clean_asr(ALLEEG(2),k);        % ASR full process
        clean_data.setname = 'ASR_25 Cleaned Data';
        EEG = eeg_checkset(clean_data);
        [ALLEEG, ~, ~] = pop_newset(ALLEEG, EEG, 4+a,'gui','off');
 
    catch
        disp('ERROR!'); pause(3)
        [ALLEEG, ~, ~] = pop_copyset(ALLEEG, 2, 4+a);
        ALLEEG(4+a).setname = 'Error';
    end


    %% ASR_more aggressive
    k = 15;     % cutoff value
    try
        clean_data = clean_asr(ALLEEG(2),k);        % ASR full process
        clean_data.setname = 'ASR_15 Cleaned Data';
        EEG = eeg_checkset(clean_data);
        [ALLEEG, ~, ~] = pop_newset(ALLEEG, EEG, 5+a,'gui','off');

    catch
        disp('Error!'); pause(3)
        [ALLEEG, ~, ~] = pop_copyset(ALLEEG, 2, 5+a);
        ALLEEG(5+a).setname = 'Error';
    end


    %% rASR_less aggressive
    kr = 5;     % cutoff value
    try
        clean_data = clean_asr(ALLEEG(2),kr,[],[],[],[],[],[],[],'true');        % rASR full process
        clean_data.setname = 'rASR_5 Cleaned Data';
        EEG = eeg_checkset(clean_data);
        [ALLEEG, ~, ~] = pop_newset(ALLEEG, EEG, 6+a,'gui','off');

    catch
        disp('ERROR!'); pause(3)
        [ALLEEG, ~, ~] = pop_copyset(ALLEEG, 2, 6+a);
        ALLEEG(6+a).setname = 'Error';
    end


    %% rASR_more aggressive
    kr = 2;     % cutoff value
    try
        clean_data = clean_asr(ALLEEG(2),kr,[],[],[],[],[],[],[],'true');        % rASR full process
        clean_data.setname = 'rASR_2 Cleaned Data';
        EEG = eeg_checkset(clean_data);
        [ALLEEG, ~, ~] = pop_newset(ALLEEG, EEG, 7+a,'gui','off');

    catch
        disp('ERROR!'); pause(3)
        [ALLEEG, ~, ~] = pop_copyset(ALLEEG, 2, 7+a);
        ALLEEG(7+a).setname = 'Error';
    end



    %% InfoMAX ICA_less aggressive
    pcn = 0.9;      % threshold percent value for 'eye', 'muscle' and 'other' components
    try
        ica_EEG = pop_runica(ALLEEG(2), 'icatype', 'runica','extended',1,'interrupt','on');
        ica_EEG = pop_iclabel(ica_EEG, 'default');
        ica_EEG = pop_icflag(ica_EEG, [NaN NaN;pcn 1;pcn 1;NaN NaN;NaN NaN;NaN NaN;NaN NaN]);
        cm = find(ica_EEG.reject.gcompreject==1)';
        ica_EEG = pop_subcomp(ica_EEG, cm, 0);
        ica_EEG.setname = 'ICA 90 Cleaned Data';
        EEG = eeg_checkset(ica_EEG);
        [ALLEEG, ~, ~] = pop_newset(ALLEEG, EEG, 8+a,'gui','off');

    catch
        disp('ERROR!'); pause(3)
        [ALLEEG, ~, ~] = pop_copyset(ALLEEG, 2, 8+a);
        ALLEEG(8+a).setname = 'Error';
    end


    %% InfoMAX ICA_more aggressive
    pcn = 0.75;      % threshold percent value for 'eye', 'muscle' and 'other' components
    try
        ica2_EEG = pop_runica(ALLEEG(2), 'icatype','runica','extended',1,'interrupt','on');
        ica2_EEG = pop_iclabel(ica2_EEG, 'default'); 
        ica2_EEG = pop_icflag(ica2_EEG, [NaN NaN;pcn 1;pcn 1;NaN NaN;NaN NaN;NaN NaN;NaN NaN]);
        cm2 = find(ica2_EEG.reject.gcompreject==1)';
        ica2_EEG = pop_subcomp(ica2_EEG, cm2, 0);
        ica2_EEG.setname = 'ICA 75 Cleaned Data';
        EEG = eeg_checkset(ica2_EEG);
        [ALLEEG, ~, ~] = pop_newset(ALLEEG, EEG, 9+a,'gui','off');

    catch
        disp('ERROR!'); pause(3)
        [ALLEEG, ~, ~] = pop_copyset(ALLEEG, 2, 9+a);
        ALLEEG(9+a).setname = 'Error';
    end
    

    %% PCA_higher variance
    try
        [coeff, scores] = pca((ALLEEG(2).data)');
        signal = scores(:,2:end)*coeff(:,2:end)'; % removing PC with the higher variance value
        signal = signal';
        [ALLEEG, ~, ~] = pop_copyset(ALLEEG, 2, 10+a);
        ALLEEG(10+a).data = signal;
        ALLEEG(10+a).setname = 'PCA Cleaned Data';

    catch
        disp('ERROR!'); pause(3)
        [ALLEEG, ~, ~] = pop_copyset(ALLEEG, 2, 10+a);
        ALLEEG(10+a).setname = 'Error';
    end
    

    %% Removing the last channel from each randomized dataset
    ALLEEG(2).data(end,:) = [];
    ALLEEG(2).chanlocs(end) = [];
    ALLEEG(2).nbchan = ALLEEG(2).nbchan -1;
end

%% Performance evaluation with MSE
rmse_results = fnc_analysis(ALLEEG,nit);

%% Saving results in an Excel spreadsheet
dt = datetime; [h,m,~] = hms(dt); 
sh = char(strcat('iteration',num2str(ind),'_h',string(h),'-',string(m)));
rname = strcat('results_',num2str(subj),'.xlsx');
writetable(rmse_results,rname,'Sheet',sh);
save([sh,'_index'],'index');     % save channels index order
% save([sh,'_ALLEEG'],'ALLEEG');   % uncomment if you want to save all the datasets used in this iteration.

end
