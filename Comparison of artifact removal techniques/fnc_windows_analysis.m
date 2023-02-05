% Function for the RMSE evaluation of specific portions of the signal
% RMSE_vector = windows_analysis(start_data,cleaned_data,d_events)
%
% Inputs:  start_data = ALLEEG(sd_index).data;
%          cleaned_data = ALLEEG(cd_index).data;
%          d_events = ALLEEG(sd_index).event;
% Outputs: RMSE_vector = [S1_mse,S2_mse,S8_mse,Seye_mse,Smus_mse]
%
% Signal portions:
%   S1 - focused
%   S2 - closed eyes 
%   S3:6 - eye movements 
%   S8 - eye blinking 
%   S9:10 - muscle artifacts 
%   S15 - relax phase
% 

function RMSE_vector = fnc_windows_analysis(start_data,cleaned_data,d_events)

    %% Clean segments evaluation
    % Two 30-seconds S1 events 
    S1_ind = [];
    for i=1:length(d_events)
        if (string(d_events(i).type)==string("S  1"))   %#ok
            A = ceil(d_events(i).latency);
            B = ceil(d_events(i+1).latency-1);      % S15 relax point
            rmse = fnc_rmse(start_data(:,[A:B]),cleaned_data(:,[A:B]));
            S1_ind(end+1) = rmse; %#ok
        end
    end
    S1_mse = mean(S1_ind);
    
    %% Closed eyes segment evalution
    % One 10-seconds S2 event
    S2_ind = [];
    for i=1:length(d_events)
        if (string(d_events(i).type)==string('S  2')) %#ok
            A = ceil(d_events(i).latency);
            B = ceil(d_events(i).latency +1998);      % S15 relax point
            rmse = fnc_rmse(start_data(:,[A:B]),cleaned_data(:,[A:B]));
            S2_ind(end+1) = rmse; %#ok
        end
    end
    S2_mse = mean(S2_ind);
    
    %% Eye movements removal evaluation
    % One 10-seconds S3, S4, S5, S6 event
    Seye_ind = [];
    for i=1:length(d_events)
        st = string(d_events(i).type);
        if (st==string('S  3')) || (st==string('S  4')) || (st==string('S  5')) || (st==string('S  6'))  %#ok 
            A = ceil(d_events(i).latency);
            B = ceil(d_events(i).latency +1998);      
            rmse = fnc_rmse(start_data(:,[A:B]),cleaned_data(:,[A:B]));
            Seye_ind(end+1) = rmse; %#ok
        end
    end
    Seye_mse = mean(Seye_ind);
    
    %% Blinking removal evaluation
    % One 10-seconds S8 event
    S8_ind = [];
    for i=1:length(d_events)
        st = string(d_events(i).type);
        if (st==string('S  8'))  %#ok 
            A = ceil(d_events(i).latency);
            B = ceil(d_events(i).latency +1998);      
            rmse = fnc_rmse(start_data(:,[A:B]),cleaned_data(:,[A:B]));
            S8_ind(end+1) = rmse; %#ok
        end
    end
    S8_mse = mean(S8_ind);
    
    %% Muscle artifact removal evaluation
    % One 10-seconds S9, S10 event
    Smus_ind = [];
    for i=1:length(d_events)
        st = string(d_events(i).type);
        if (st==string('S  9')) || (st==string('S 10'))  %#ok 
            A = ceil(d_events(i).latency);
            B = ceil(d_events(i).latency +1998);      
            rmse = fnc_rmse(start_data(:,[A:B]),cleaned_data(:,[A:B]));
            Smus_ind(end+1) = rmse; %#ok
        end
    end
    Smus_mse = mean(Smus_ind);

    %% Total rmse vector
    RMSE_vector = [S1_mse,S2_mse,S8_mse,Seye_mse,Smus_mse];
end