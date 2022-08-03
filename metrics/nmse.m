% nmse: Function to compute Normalized Mean Squared Error.
%
% Example: NMSE_value = nmse(TrueSig,CorrSig)
%
% Inputs:  TrueSig = initial EEG signal 
%          CorrSig = corrected EEG signal after an artifact removal technique
% Outputs: NMSE_value = normalized mean squared error

function NMSE = nmse(TrueSig,CorrSig)
    TrueSig = double(TrueSig); CorrSig = double(CorrSig);
    MSEa = immse(TrueSig,CorrSig);
    MSEb = immse(TrueSig,zeros(size(TrueSig),'like',TrueSig));
    NMSE = MSEa/MSEb;
return