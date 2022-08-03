% rrmse: Function to compute Relative Root Mean Squared Error.
%
% Example: RRMSE_value = rrmse(TrueSig,CorrSig)
%
% Inputs:  TrueSig = initial EEG signal 
%          CorrSig = corrected EEG signal after an artifact removal technique
% Outputs: RRMSE_value = relative root mean squared error

function RRMSE = rrmse(TrueSig,CorrSig)
    TrueSig = double(TrueSig); CorrSig = double(CorrSig);
    MSEa = immse(TrueSig,CorrSig);
    MSEb = immse(TrueSig,zeros(size(TrueSig),'like',TrueSig));
    RMSEa = sqrt(MSEa);
    RMSEb = sqrt(MSEb);
    RRMSE = RMSEa/RMSEb;
return