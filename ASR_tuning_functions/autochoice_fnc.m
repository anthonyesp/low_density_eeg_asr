function [p,indwin] = autochoice_fnc(p_metrics)

% This function performs a weighted automatic choice for
% best parameter (k or wl), finding and counting the optimal values of the metrics.
% In particular, you want the Root Mean Square Error (RMSE) between EEG true 
% and EEGcorr was minimum, whereas the Gamma Value and Correlation Coefficient between
% EEGtrue and EEGcorr was maximum.
%
%
% Input: p_metrics = matrix of metrics obtained for 
%                     the parameter values investigated.
%                     In this matrix, the first columns are associated with
%                     RMSE. The remaining columns are associated with 
%                     Gamma Value and Correlation Coefficient
%                     
%
% Outputs: [p,indwin] = parameter best value and its index in the matrix

    sz = size(p_metrics);
    % Counting array
    ii = zeros(sz(1),1);
    % Iterations along the columns
    for c=2:sz(2)
        if c<6
            [value,~] = min(p_metrics(:,c)); 
            p1 = find(p_metrics(:,c)==value);
        else
            [value,~] = max(p_metrics(:,c)); 
            p1 = find(p_metrics(:,c)==value);
        end
        ii(p1) = ii(p1)+1;
    end
    % Identification of the best value
    [~,indwin] = max(ii);
    p = p_metrics(indwin,1);

end