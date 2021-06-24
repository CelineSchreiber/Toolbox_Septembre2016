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

function [Kinematics,Dynamics,Events,Phases] = initialisationKinematicsDynamics()

% =========================================================================
% Initialisation
% =========================================================================

Kinematics.Pobli = [];
Kinematics.Prota = [];
Kinematics.Ptilt = [];
Kinematics.Fobli = [];
Kinematics.Frota = [];
Kinematics.Ftilt = [];
Kinematics.Clearance = [];
Kinematics.FE2 = [];
Kinematics.IER2 = [];
Kinematics.AA2 = [];
Kinematics.LM2 = [];
Kinematics.PD2 = [];
Kinematics.AP2 = [];
Kinematics.FE3 = [];
Kinematics.AA3 = [];
Kinematics.IER3 = [];
Kinematics.LM3 = [];
Kinematics.AP3 = [];
Kinematics.PD3 = [];
Kinematics.FE4 = [];
Kinematics.AA4 = [];
Kinematics.IER4 = [];
Kinematics.LM4 = [];
Kinematics.AP4 = [];
Kinematics.PD4 = [];
Kinematics.Ttilt = [];

Dynamics = [];
Dynamics.LM1 = [];
Dynamics.PD1 = [];
Dynamics.AP1 = [];
Dynamics.LM2 = [];
Dynamics.PD2 = [];
Dynamics.AP2 = [];
Dynamics.FE2 = [];
Dynamics.IER2 = [];
Dynamics.AA2 = [];
Dynamics.Power2 = [];
% Dynamics.PowerX2 = [];
% Dynamics.PowerY2 = [];
% Dynamics.PowerZ2 = [];
Dynamics.LM3 = [];
Dynamics.AP3 = [];
Dynamics.PD3 = [];
Dynamics.FE3 = [];
Dynamics.AA3 = [];
Dynamics.IER3 = [];
Dynamics.Power3 = [];
% Dynamics.PowerX3 = [];
% Dynamics.PowerY3 = [];
% Dynamics.PowerZ3 = [];
Dynamics.LM4 = [];
Dynamics.AP4 = [];
Dynamics.PD4 = [];
Dynamics.FE4 = [];
Dynamics.AA4 = [];
Dynamics.IER4 = [];
Dynamics.Power4 = [];
% Dynamics.PowerX4 = [];
% Dynamics.PowerY4 = [];
% Dynamics.PowerZ4 = [];

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
