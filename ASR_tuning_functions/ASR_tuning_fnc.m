function [best_k, best_wl] = ASR_tuning_fnc(sim_ds,cont_ds)

% This function implements the customization of the ASR user-selected 
% cutoff threshold parameter (k) and sliding window length (wl), 
% returning best values for the artifact removal on simulated data. 
%
%
% Inputs: sim_ds = pure semi-simulated EEG signal
%         cont_ds = contaminated semi-simulated EEG signal
%
%
% Outputs: [best_k, best_wl] = k and wl best values for signal 
%
%
% REMEMBER:
% - The "clean_rawdata" path must be added for the function to work. The
% plug-in is accessible from: https://github.com/sccn/clean_rawdata

    
    % Sampling frequency of the datasets
    fs = cont_ds.srate;
    
    % Cutoff parameter (k) search
    k_metrics = [];
    for k=5:1:30    % Search range for k
        % ASR
        corr_ds = clean_asr(cont_ds,k); 
        corr_ds.setname = strcat("ASR k=",num2str(k)," wl=0.5s");
        % Metrics assessment
        vett = metrics_fnc(sim_ds.data,cont_ds.data,corr_ds.data,fs);
        a = [k vett];
        k_metrics = [k_metrics; a]; %#ok
    end
    
    % Automatic choice for k based on metrics
    [best_k,~] = autochoice_fnc(k_metrics);
    
    % Window length (wl) search
    k = best_k;  % Best k value chosen above
    wl_metrics = [];
    for wl=0.2:0.1:2  % Search range for window length
    
        % ASR
        corr_dsw = clean_asr(cont_ds,k,wl);                                          
        corr_dsw.setname = strcat("ASR k=",num2str(k)," wl=",num2str(wl),"s"); 
        % Metrics assessment
        vett = metrics_fnc(sim_ds.data,cont_ds.data,corr_dsw.data,fs);
        a = [wl vett];
        wl_metrics = [wl_metrics; a]; %#ok
    
    end
    
    % Automatic choice for wl based on metrics
    [best_wl,~] = autochoice_fnc(wl_metrics);

end
