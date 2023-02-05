% fnc_rmse: function to compute RMSE 
% 
% Reference: Mannan et al.: Identification and Removal of
%            Physiological Artifacts From EEG Signals, 2018
%
% Example: [RMSEa] = fnc_rmse(TrueSig,CorrSig)
%
% Inputs:  TrueSig = initial EEG signal 
%          CorrSig = corrected EEG signal after an artifact removal technique
% Outputs: RMSEa = Root Mean Squared Error after artifact removal
%

function [RMSEa] = fnc_rmse(TrueSig,CorrSig)
    MSEa = immse(TrueSig,CorrSig);
    RMSEa = sqrt(MSEa);
return