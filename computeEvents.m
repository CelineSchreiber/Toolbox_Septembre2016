% =========================================================================
% REHAZENTER TOOLBOX
% =========================================================================
% File name:    computeBiomechanicalParameters
% -------------------------------------------------------------------------
% Subject:      Compute a set of biomechanical parameters
% -------------------------------------------------------------------------
% Inputs:       - Patient (structure)
%               - Session (structure)
%               - Condition (structure)
% Outputs:      - Session (structure)
%               - Condition (structure)
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber, A. Naaim
% Date of creation: 26/03/2014
% Version: 1
% -------------------------------------------------------------------------
% Updates: - 16/09/2014: Outputs have 101 rows (frames 0 to 100)
%          - 26/09/2014: Auto selection the static file corresponding to 
%            the current condition OR ' TOUTES CONDITIONS' !!!!
% =========================================================================

function [Session] = computeEvents(Session)

% =========================================================================
% Gait cycles
% =========================================================================
disp(['    - Events OK']);  
for i = 1:length(Session.Gait)
      
    gait = Session.Gait(i).file;

    % Prepare gait cycle data
    % ----------------------------------------------------------------- 
    % Initialise variables
    clear f1 f2 e;      
    n0 = btkGetFirstFrame(gait);
    n1 = btkGetLastFrame(gait)-btkGetFirstFrame(gait)+1;
    % Detect foot strike and foot off events
    e = btkGetEvents(gait);
    % Set events data in the correct format
    Session.Gait(i).e = prepareEventsData(e);
end