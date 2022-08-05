
function rapp = gamma_metric_fnc(TrueSig,ContSig,CorrSig)

% This function computes Gamma Value as 10*Log(SARa/SARb).
%
%
% Inputs:  TrueSig = pure true EEG signal (dimensions #channels * #samples)
%          ContSig = contaminated EEG signal (dimensions #channels * #samples)
%          CorrSig = corrected EEG signal after an artifact removal
%          technique (dimensions #channels * #samples)
% 
%
% Outputs: rapp = gamma
%
% Example: rapp = gamma_metric_fnc(TrueSig,ContSig,CorrSig)

    TrueSig = double(TrueSig); ContSig = double(ContSig); CorrSig = double(CorrSig);
    MSEb = immse(TrueSig,ContSig);
    MSEa = immse(TrueSig,CorrSig);
    SigV = var(TrueSig');       %#ok
    SARb = sum(SigV/MSEb);      % I chose to sum all channels contributions
    SARa = sum(SigV/MSEa);      % Computing the mean can be an alternative
    rapp = 10*log10(SARa/SARb); % In both cases, this ratio does not change
return