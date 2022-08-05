function corr_vect = correlation_metric_fnc(true_data,corr_data)

%This function computes the correlation between true and corrected EEG
%signals. The function returns the Correlation Coefficient and the lags
%with which correlations are calculated.
%
% Inputs:   true_data = pure true EEG signal (dimensions #channels * #samples)
%           corr_data = corrected EEG signal (dimensions #channels * #samples)
%
% Outputs:  corr_vect = correlation coefficients vector

nb = size(true_data,1);
corr_allchan = zeros(1,nb);

for i=1:nb
    [c,lag] = xcorr(true_data(i,:),corr_data(i,:),'normalized');
    %Search the index related to delay 0 (not interested in translating signals).
    ind = find(lag == 0); 
    corr = c(ind);
    %Create vector containing the correlation value for each channel
    corr_allchan(1,i) = corr;
end

%average of correlation coefficients for each channel
corr_vect = sum(corr_allchan)/nb;
end