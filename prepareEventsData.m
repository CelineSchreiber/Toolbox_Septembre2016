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

function [e] = prepareEventsData(e)

% =====================================================================
% Rename events created under Mokka
% =====================================================================
if isfield(e,'Right_Foot_Strike')
    e.RHS = e.Right_Foot_Strike;
    e.LHS = e.Left_Foot_Strike;
    e.RTO = e.Right_Foot_Off;
    e.LTO = e.Left_Foot_Off;
    e = rmfield(e,'Right_Foot_Strike');
    e = rmfield(e,'Left_Foot_Strike');
    e = rmfield(e,'Right_Foot_Off');
    e = rmfield(e,'Left_Foot_Off');
end
if isfield(e,'General_RHS')
    if isfield(e,'RHS')
        e.RHS(end+1) = e.General_RHS;
    else
        e.RHS = e.General_RHS;
    end
    e = rmfield(e,'General_RHS');
end
if isfield(e,'General_LHS')
    if isfield(e,'LHS')
        e.LHS(end+1) = e.General_LHS;
    else
        e.LHS = e.General_LHS;
    end
    e = rmfield(e,'General_LHS');
end
if isfield(e,'General_RTO')
    if isfield(e,'RTO')
        e.RTO(end+1) = e.General_RTO;
    else
        e.RTO = e.General_RTO;
    end
    e = rmfield(e,'General_RTO');
end
if isfield(e,'General_LTO')
    if isfield(e,'LTO')
        e.LTO(end+1) = e.General_LTO;
    else
        e.LTO = e.General_LTO;
    end
    e = rmfield(e,'General_LTO');
end