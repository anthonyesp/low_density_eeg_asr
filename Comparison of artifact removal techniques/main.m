% Script related to MeMeA 2022
% Last update: 31-jan-2023
%
close all
clear 
clc

%% Important paths - Edit with your path!
eeglabpath = "C:\Users\Utente\OneDrive\Documenti\MATLAB\eeglab2021.1\";

% Pay attention to the plugin's version
addpath(eeglabpath);
addpath(genpath(strcat(eeglabpath,"plugins\clean_rawdata2.7")));
addpath(genpath(strcat(eeglabpath,"plugins\firfilt")));
addpath(strcat(eeglabpath,"plugins\ICLabel"));
addpath(genpath(strcat(eeglabpath,"functions")));

%% Techniques confrontation
for subj=[1,2,4]    % Subject's ID
    for it=1:5      % Number of desired random iterations
        % Indicate the path with the reduced datasets:
        fpath = 'C:\Users\Utente\OneDrive\Documenti\DS\'; 
        fnc_comparison(subj,it,fpath);
    end
end

%% RMSE Plot
% To obtain boundedline function:
addpath(genpath('C:\Users\Utente\OneDrive\Documenti\MATLAB\github_repo')); 

for subj=[1,2,4]    % Subject's ID
    results_file = strcat("results_",num2str(subj),".xlsx");  % Subject's results selector
    fig = fnc_boundedplots(results_file);
    % Save figure as an .eps file:
    exportgraphics(fig,strcat(num2str(subj),"_rmse.eps"),'BackgroundColor','white')
end
