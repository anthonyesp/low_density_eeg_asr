function fig = fnc_boundedplots(results_file)
    % Script to visualize resulted RMSE in a plot with line bounds for each
    % considered artifact removal technique - Single plot
    % Last update: 31-jan-2023
    %
    TT = [];
    n_sheets = 3;
    for ns=1:n_sheets
        % Reading results from the spreadsheet
        T = readtable(results_file,'Sheet',ns);      
        cz = (1:182);
        TT = [TT;T(cz,:)];
    end

    fig = figure;
    
    %% ASR 25 evaluation
    subplot(4,2,1);
    indt = find(TT.technique == "ASR_25");
    Ta = TT(indt,:); %#ok
    texttitle = 'ASR, k=25';
    [hl_S1,hl_S2,hl_S8,hl_Seye,hl_Smus] = fcn_meanstd(Ta,texttitle); %#ok
    
    %% ASR 15 evaluation
    subplot(4,2,2);
    indt = find(TT.technique == "ASR_15");
    Ta = TT(indt,:); %#ok
    texttitle = 'ASR, k=15';
    [hl_S1,hl_S2,hl_S8,hl_Seye,hl_Smus] = fcn_meanstd(Ta,texttitle); %#ok
    
    %% rASR 5 evaluation
    subplot(4,2,3);
    indt = find(TT.technique == "rASR_5");
    Ta = TT(indt,:); %#ok
    texttitle = 'rASR, k=5';
    [hl_S1,hl_S2,hl_S8,hl_Seye,hl_Smus] = fcn_meanstd(Ta,texttitle); %#ok
    
    %% rASR 2 evaluation
    subplot(4,2,4);
    indt = find(TT.technique == "rASR_2");
    Ta = TT(indt,:); %#ok
    texttitle = 'rASR, k=2';
    [hl_S1,hl_S2,hl_S8,hl_Seye,hl_Smus] = fcn_meanstd(Ta,texttitle); %#ok
    
    %% ICA 90 evaluation
    subplot(4,2,5);
    indt = find(TT.technique == "ICA_90");
    Ta = TT(indt,:); %#ok
    texttitle = 'ICA, th=90';
    [hl_S1,hl_S2,hl_S8,hl_Seye,hl_Smus] = fcn_meanstd(Ta,texttitle); %#ok
    
    %% ICA 75 evaluation
    subplot(4,2,6);
    indt = find(TT.technique == "ICA_75");
    Ta = TT(indt,:); %#ok
    texttitle = 'ICA, th=75';
    [hl_S1,hl_S2,hl_S8,hl_Seye,hl_Smus] = fcn_meanstd(Ta,texttitle); %#ok
    
    %% PCA evaluation
    subplot(4,2,7);
    indt = find(TT.technique == "PCA");
    Ta = TT(indt,:); %#ok
    texttitle = 'PCA';
    [hl_S1,hl_S2,hl_S8,hl_Seye,hl_Smus] = fcn_meanstd(Ta,texttitle); 
    
    %% Final plot properties (change the string for a different subject)   
    legend([hl_S1,hl_S2,hl_S8,hl_Seye,hl_Smus],{'Baseline segment','Closed eyes segment','Eye blinking segment','Eye movements segment','Muscle artifacts segment'})
    han=axes(fig,'visible','off');
    han.XLabel.Visible='on';
    han.YLabel.Visible='on';
    xlabel(han,{'';'N. of channels'})
    ylabel(han,{'RMSE';''})

end