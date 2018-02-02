% =========================================================================
% REHAZENTER TOOLBOX
% =========================================================================
% File name:    exportEmg
% -------------------------------------------------------------------------
% Subject:      Store filtered and time-normalized EMG data
% -------------------------------------------------------------------------
% Inputs:       - eEmg (structure)
%               - Gait (structure)
%               - n (int)
% Outputs:      - Emg (structure)
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber, A. Naaim
% Date of creation: 26/03/2014
% Version: 1
% -------------------------------------------------------------------------
% Updates: - 
% =========================================================================

function eEmg = exportEmg(Emg,Gait,n)

% =========================================================================
% Initialisation
% =========================================================================
k = (1:n)';
ko = (linspace(1,n,101))';
eEmg = [];

% =========================================================================
% Export Emg parameters
% =========================================================================
if strcmp(Gait.emgtrial,'yes')
    names = fieldnames(Emg);
    for i = 1:length(names)
        if strfind(names{i},'_cycle_filt')
            eEmg.(names{i}) = interp1(k,permute(Emg.(names{i}),[3,2,1]),ko,'spline');
        else
            eEmg.(names{i}) = permute(Emg.(names{i}),[3,2,1]);
        end
    end
end