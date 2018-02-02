% FUNCTION
% Inverse_Dynamics_WQ.m
%__________________________________________________________________________
%
% PURPOSE
% Computation of joint force and moment by wrench and quaternion method
%
% SYNOPSIS
% [Joint,Segment] = Inverse_Dynamics_WQ(Joint,Segment,f,n)
%
% INPUT
% Joint (cf. data structure in user guide)
% Segment (cf. data structure in user guide)
% f (i.e., sampling frequency)
% n (i.e., number of frames)
%
% OUTPUT
% Joint (cf. data structure in user guide)
% Segment (cf. data structure in user guide)
%
% DESCRIPTION
% Data formatting and call of functions Kinematics_WQ.m and Dynamics_WQ.m
%__________________________________________________________________________
%
% CALLED FUNCTIONS (FROM 3D INVERSE DYNAMICS TOOLBOX) 
% Extend_Segment_Fields.m
% Kinematics_WQ.m
% Dynamics_WQ.m
% 
% MATLAB VERSION
% Matlab R2007b
%__________________________________________________________________________
%
% CHANGELOG
% Created by Raphaël Dumas
% March 2010
%__________________________________________________________________________

function [Joint,Segment] = Inverse_Dynamics_WQ(Joint,Segment,f,n)

% Extend segment fields
Segment = Extend_Segment_Fields(Segment);

% Kinematics
Segment = Kinematics_WQ(Segment,f,n);

% Dynamics
[Joint,Segment] = Dynamics_WQ(Joint,Segment,n);
