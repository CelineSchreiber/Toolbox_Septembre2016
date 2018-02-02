% =========================================================================
% REHAZENTER TOOLBOX
% =========================================================================
% File name:    exportEvents
% -------------------------------------------------------------------------
% Subject:      Export events
% -------------------------------------------------------------------------
% Inputs:       - Events (structure)
%               - Phases (structure)
%               - Gait (structure)
%               - n (int)
% Outputs:      - eEvents (structure)
%               - ePhases (structure)
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber, A. Naaim
% Date of creation: 26/03/2014
% Version: 1
% -------------------------------------------------------------------------
% Updates: - 
% =========================================================================

function [eEvents,ePhases] = exportEvents(Events,Phases,n)

% =========================================================================
% Initialisation
% =========================================================================
eEvents = [];
ePhases = [];

% =========================================================================
% Export events
% =========================================================================
names = fieldnames(Events);
eEvents.(names{1}) = Events.(names{1});
for i = 2:length(names)-1
    eEvents.(names{i}) = round(Events.(names{i})*101/n);
end
eEvents.(names{end}) = Events.(names{end}); % Events raw

% =========================================================================
% Export phases
% =========================================================================
names = fieldnames(Phases);
for i = 1:length(names)
    ePhases.(names{i}) = round(Phases.(names{i})*101/n);
end