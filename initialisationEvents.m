% =========================================================================
% REHAZENTER TOOLBOX
% =========================================================================
% File name:    inverseKinematics
% -------------------------------------------------------------------------
% Subject:      Compute inverse kinematics
% -------------------------------------------------------------------------
% Inputs:       - Static (structure)
%               - Segment (structure)
%               - Markers (structure)
%               - Vmarkers (structure)
%               - Gait (structure)
%               - Events (structure)
%               - n (int)
%               - side (int)
%               - system (char)
% Outputs:      - Kinematics (structure)
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber, A. Naaim
% Date of creation: 26/03/2014
% Version: 1
% -------------------------------------------------------------------------
% Updates: - 12/12/2014 - Introduce foot tilt and obliquity
%          - 16/04/2015 - Computation of foot progression angle for BTS
% =========================================================================

function [Events,Phases] = initialisationEvents()

% =========================================================================
% Initialisation
% =========================================================================

Events.IHS = [];
Events.ITO = [];
Events.CTO = [];
Events.CHS = [];
Events.COM = [];
Events.MAL = [];
Events.TIB = [];
Phases.p1  = [];
Phases.p2  = [];
Phases.p3  = [];
Phases.p4  = [];
Phases.p5  = [];
Phases.p6  = [];
Phases.p7  = [];
Phases.p8  = [];
