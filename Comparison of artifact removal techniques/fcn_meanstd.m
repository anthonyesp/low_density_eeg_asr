function [hl_S1,hl_S2,hl_S8,hl_Seye,hl_Smus] = fcn_meanstd(Ttot,texttitle)
    % Mean and standard deviation for resulted rmse 
    % Inputs: Ttot = subtable with rows of only one technique
    %         texttile = string with technique's name for plot
    %
    nit = 26;

    % Initialization
    S1mean = []; S1std = []; S2mean = []; S2std = []; S8mean = []; S8std = [];
    Seyemean = []; Seyestd = []; Smusmean = []; Smusstd = [];
    for i=1:nit
    % S1
        S1v = Ttot.S1(Ttot.trial==i);
        S1mean(end+1) = mean(S1v);
        S1std(end+1) = std(S1v);
    
    % S2
        S2v = Ttot.S2(Ttot.trial==i);
        S2mean(end+1) = mean(S2v);
        S2std(end+1) = std(S2v);
    
    % S8
        S8v = Ttot.S8(Ttot.trial==i);
        S8mean(end+1) = mean(S8v);
        S8std(end+1) = std(S8v);
    
    % Seye
        Seyev = Ttot.Seye(Ttot.trial==i);
        Seyemean(end+1) = mean(Seyev);
        Seyestd(end+1) = std(Seyev);
    
    % Smus
        Smusv = Ttot.Smus(Ttot.trial==i);
        Smusmean(end+1) = mean(Smusv);
        Smusstd(end+1) = std(Smusv);
    end
    
    % Bounded line plot
    chs = linspace(1,nit,nit);
    [hl_S1]=boundedline(chs,S1mean,S1std,'k','alpha');
    hold on
    [hl_S2]=boundedline(chs,S2mean,S2std,'y','alpha');
    hold on
    [hl_S8]=boundedline(chs,S8mean,S8std,'m','alpha');
    hold on
    [hl_Seye]=boundedline(chs,Seyemean,Seyestd,'g','alpha');
    hold on
    [hl_Smus]=boundedline(chs,Smusmean,Smusstd,'r','alpha');
    axis([1 nit 0 45]); grid on; title(texttitle);
    yticks(linspace(0,45,10));
    xticks(linspace(1,nit,nit));
    xticklabels({'27','26','25','24','23','22','21','20','19','18','17','16','15','14','13','12','11','10','9','8','7','6','5','4','3','2'});
    hold off
return
