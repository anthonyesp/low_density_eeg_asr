% Repeated evaluation for ALLEEG
% rmse_results = fnc_analysis(ALLEEG,nit)
% Inputs:  ALLEEG
%          nit = number of iterations in ALLEEG
%
% Outputs: rmse_results = table with all the results
%
function rmse_results = fnc_analysis(ALLEEG,nit)
    load("rmse_results.mat"); %#ok
    for i=1:nit
        a = 8*(i-1);
        start_data = ALLEEG(3+a).data;
        d_events = ALLEEG(3+a).event;
        j = 7*(i-1);
        rmse_results.trial((1+j):(7+j)) = i;
    
        %% ASR - less aggressive
        if string(ALLEEG(4+a).setname) == string('Error') %#ok
            rmse_results.technique(1+j) = 'Error';
        else
            cleaned_data = ALLEEG(4+a).data;
            RMSE_ASR25 = fnc_windows_analysis(start_data,cleaned_data,d_events);
            rmse_results.technique(1+j) = 'ASR_25';
            rmse_results.S1(1+j) = RMSE_ASR25(1);
            rmse_results.S2(1+j) = RMSE_ASR25(2);
            rmse_results.S8(1+j) = RMSE_ASR25(3);
            rmse_results.Seye(1+j) = RMSE_ASR25(4);
            rmse_results.Smus(1+j) = RMSE_ASR25(5);
        end
    
        %% ASR - more aggressive
        if string(ALLEEG(5+a).setname) == string('Error') %#ok
            rmse_results.technique(2+j) = 'Error';
        else
            cleaned_data = ALLEEG(5+a).data;
            RMSE_ASR15 = fnc_windows_analysis(start_data,cleaned_data,d_events);
            rmse_results.technique(2+j) = 'ASR_15';
            rmse_results.S1(2+j) = RMSE_ASR15(1);
            rmse_results.S2(2+j) = RMSE_ASR15(2);
            rmse_results.S8(2+j) = RMSE_ASR15(3);
            rmse_results.Seye(2+j) = RMSE_ASR15(4);
            rmse_results.Smus(2+j) = RMSE_ASR15(5);
        end
    
        %% rASR - less aggressive
        if string(ALLEEG(6+a).setname) == string('Error') %#ok
            rmse_results.technique(3+j) = 'Error';
        else
            cleaned_data = ALLEEG(6+a).data;
            RMSE_rASR5 = fnc_windows_analysis(start_data,cleaned_data,d_events);
            rmse_results.technique(3+j) = 'rASR_5';
            rmse_results.S1(3+j) = RMSE_rASR5(1);
            rmse_results.S2(3+j) = RMSE_rASR5(2);
            rmse_results.S8(3+j) = RMSE_rASR5(3);
            rmse_results.Seye(3+j) = RMSE_rASR5(4);
            rmse_results.Smus(3+j) = RMSE_rASR5(5);
        end
    
        %% rASR - more aggressive
        if string(ALLEEG(7+a).setname) == string('Error') %#ok
            rmse_results.technique(4+j) = 'Error';
        else
            cleaned_data = ALLEEG(7+a).data;
            RMSE_rASR2 = fnc_windows_analysis(start_data,cleaned_data,d_events);
            rmse_results.technique(4+j) = 'rASR_2';
            rmse_results.S1(4+j) = RMSE_rASR2(1);
            rmse_results.S2(4+j) = RMSE_rASR2(2);
            rmse_results.S8(4+j) = RMSE_rASR2(3);
            rmse_results.Seye(4+j) = RMSE_rASR2(4);
            rmse_results.Smus(4+j) = RMSE_rASR2(5);
        end
    
        %% ICA 90 - less aggressive
        if string(ALLEEG(8+a).setname) == string('Error') %#ok
            rmse_results.technique(5+j) = 'Error';
        else
            cleaned_data = ALLEEG(8+a).data;
            RMSE_ICA90 = fnc_windows_analysis(start_data,cleaned_data,d_events);
            rmse_results.technique(5+j) = 'ICA_90';
            rmse_results.S1(5+j) = RMSE_ICA90(1);
            rmse_results.S2(5+j) = RMSE_ICA90(2);
            rmse_results.S8(5+j) = RMSE_ICA90(3);
            rmse_results.Seye(5+j) = RMSE_ICA90(4);
            rmse_results.Smus(5+j) = RMSE_ICA90(5);
        end
    
        %% ICA 75 - more aggressive
        if string(ALLEEG(9+a).setname) == string('Error') %#ok
            rmse_results.technique(6+j) = 'Error';
        else
            cleaned_data = ALLEEG(9+a).data;
            RMSE_ICA75 = fnc_windows_analysis(start_data,cleaned_data,d_events);
            rmse_results.technique(6+j) = 'ICA_75';
            rmse_results.S1(6+j) = RMSE_ICA75(1);
            rmse_results.S2(6+j) = RMSE_ICA75(2);
            rmse_results.S8(6+j) = RMSE_ICA75(3);
            rmse_results.Seye(6+j) = RMSE_ICA75(4);
            rmse_results.Smus(6+j) = RMSE_ICA75(5);
        end

        %% PCA
        if string(ALLEEG(10+a).setname) == string('Error') %#ok
            rmse_results.technique(7+j) = 'Error';
        else
            cleaned_data = ALLEEG(10+a).data;
            RMSE_PCA = fnc_windows_analysis(start_data,cleaned_data,d_events);
            rmse_results.technique(7+j) = 'PCA';
            rmse_results.S1(7+j) = RMSE_PCA(1);
            rmse_results.S2(7+j) = RMSE_PCA(2);
            rmse_results.S8(7+j) = RMSE_PCA(3);
            rmse_results.Seye(7+j) = RMSE_PCA(4);
            rmse_results.Smus(7+j) = RMSE_PCA(5);
        end
    end
end