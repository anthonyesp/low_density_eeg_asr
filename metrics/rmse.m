% rmse: Function to compute Root Mean Squared Error.
%
% Example: RMSE_value = rmse(TrueSig,CorrSig)
%
% Inputs:  TrueSig = initial EEG signal 
%          CorrSig = corrected EEG signal after an artifact removal technique
% Outputs: RMSE_value = rroot mean squared error

function RMSEa = rmse(TrueSig,CorrSig)
    TrueSig = double(TrueSig); CorrSig = double(CorrSig);
    MSEa = immse(TrueSig,CorrSig);
    RMSEa = sqrt(MSEa);
return