function vect = metrics_fnc(true_data,cont_data,corr_data,fs)

% This function computes RMSE, Gamma Value and Correlation Coefficient between
% original and corrected data.
%
% Inputs:   true_data = pure true EEG signal (dimensions #channels * #samples)
%           cont_data = contaminated EEG signal (dimensions #channels * #samples)
%           corr_data = corrected EEG signal (dimensions #channels * #samples)
%
% Outputs:  vett = vector of metrics, such as:
%               rmse_tot = RMSE on whole signal
%               rmse_base = RMSE on baseline
%               rmse_mus = RMSE on muscle artifact segment
%               rmse_ocu = RMSE on ocular artifact segment
%               gamma_tot = gamma ratio on whole signal
%               gamma_mus = gamma on muscle artifact segment
%               gamma_ocu = gamma ratio on ocular artifact segment
%               corr_tot = cross-correlation on whole signal
%               corr_mus = cross-correlation on muscle artifact segment
%               corr_ocu = cross-correlation on ocular artifact segment].
    
    true_data = double(true_data); 
    cont_data = double(cont_data); 
    corr_data = double(corr_data);
    
    % Signal/artifact conditions intervals
    int_base = [1:60*fs-1];       %#ok
    int_mus = [60*fs:90*fs-1];    %#ok
    int_ocu = [90*fs:120*fs];     %#ok
   
    %% RMSE orig-corr
    rmse_tot = sqrt(immse(true_data,corr_data));
    rmse_base = sqrt(immse(true_data(:,int_base),corr_data(:,int_base)));
    rmse_mus = sqrt(immse(true_data(:,int_mus),corr_data(:,int_mus)));
    rmse_ocu = sqrt(immse(true_data(:,int_ocu),corr_data(:,int_ocu)));
    
    %% Gamma gamma_value = gamma_metric_fnc(TrueSig,ContSig,CorrSig)
    gamma_tot = gamma_metric_fnc(true_data,cont_data,corr_data);
    gamma_mus = gamma_metric_fnc(true_data(:,int_mus),cont_data(:,int_mus),corr_data(:,int_mus));
    gamma_ocu = gamma_metric_fnc(true_data(:,int_ocu),cont_data(:,int_ocu),corr_data(:,int_ocu));
    
    %% Correlazione a ritardo 0 orig-corr
    corr_tot = correlation_metric_fnc(true_data,corr_data);
    corr_mus = correlation_metric_fnc(true_data(:,int_mus),corr_data(:,int_mus));
    corr_ocu = correlation_metric_fnc(true_data(:,int_ocu),corr_data(:,int_ocu));
    
    vect = [rmse_tot,rmse_base,rmse_mus,rmse_ocu,gamma_tot,gamma_mus,gamma_ocu,corr_tot,corr_mus,corr_ocu];

end


