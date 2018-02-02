% =========================================================================
% REHAZENTER TOOLBOX
% =========================================================================
% File name:    cutCycleData
% -------------------------------------------------------------------------
% Subject:      Keep only data between two consecutive "foot strikes"
% -------------------------------------------------------------------------
% Inputs:       - Markers (structure)
%               - Grf (structure)
%               - Emg (structure)
%               - Gait (structure)
%               - n0 (int)
%               - f1 (int)
%               - f2 (int)
%               - e (structure)
%               - s (int)
%               - side (char)
% Outputs:      - Markers (structure)
%               - sGrf (structure)
%               - Emg (structure)
%               - n1 (int)
%               - n2 (int)
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber, A. Naaim
% Date of creation: 26/03/2014
% Version: 1
% -------------------------------------------------------------------------
% Updates: - 
% =========================================================================

function [Markers,sGrf,Emg,n1,n2] = cutCycleData(Markers,Grf,Emg,n0,f1,f2,e,s,side)

% =====================================================================
% Initialisation
% =====================================================================
sGrf=[];n1=0;n2=0;

% =====================================================================
% Define start and stop frames for kinematic and kinetic data
% Set the new number of frames n1
% =====================================================================
if strcmp(side,'Right')
    start = (e.RHS(1)*f1)-n0+1;
    stop = (e.RHS(2)*f1)-n0+1;
elseif strcmp(side,'Left')
    start = (e.LHS(1)*f1)-n0+1;
    stop = (e.LHS(2)*f1)-n0+1;
end
n1 = fix(stop-start+1);

% =====================================================================
% Export the new values
% =====================================================================
if ~isempty(Markers)
    names = fieldnames(Markers);
    for i = 1:size(names,1)
        Markers.(names{i}) = Markers.(names{i})(:,:,start:stop);
    end
else
    Markers = [];
end

if s ~= 0 && ~isempty(Grf)
    sGrf.P = Grf(s).P(:,:,start:stop);
    sGrf.F = Grf(s).F(:,:,start:stop);
    sGrf.M = Grf(s).M(:,:,start:stop);
else
    sGrf.P = zeros(3,1,n1);
    sGrf.F = zeros(3,1,n1);
    sGrf.M = zeros(3,1,n1);    
end

% =====================================================================
% Define start and stop frames for EMG data
% Set the new number of frames n2
% =====================================================================
if strcmp(side,'Right')
    start = (e.RHS(1)*f2)-n0*f2/f1+1;
    if start < 0
        start = 0; % needed for cases were EMG is investigated "on table"
    end
    stop = (e.RHS(2)*f2)-n0*f2/f1+1;
elseif strcmp(side,'Left')
    start = (e.LHS(1)*f2)-n0*f2/f1+1;
    if start < 0
        start = 0; % needed for cases were EMG is investigated "on table"
    end
    stop = (e.LHS(2)*f2)-n0*f2/f1+1;
end
n2 = fix(stop-start+1);

% =====================================================================
% Export the new values
% =====================================================================

if ~isempty(Emg)
    names = fieldnames(Emg);
    for i = 1:size(names,1)
        if strfind(names{i},'_cycle_filt')
            Emg.(names{i}) = Emg.(names{i})(start:stop);
        end
    end
end