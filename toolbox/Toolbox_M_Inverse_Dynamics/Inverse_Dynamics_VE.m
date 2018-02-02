% FUNCTION
% Inverse_Dynamics_VE.m
%__________________________________________________________________________
%
% PURPOSE
% Computation of joint force and moment by vector and Euler angles method
%
% SYNOPSIS
% [Joint,Segment] = Inverse_Dynamics_VE(Joint,Segment,f,n)
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
% Data formatting and call of functions Kinematics_VE.m and Dynamics_VE.m
%__________________________________________________________________________
%
% CALLED FUNCTIONS (FROM 3D INVERSE DYNAMICS TOOLBOX) 
% Extend_Segment_Fields.m
% Kinematics_VE.m
% Dynamics_VE.m
% 
% MATLAB VERSION
% Matlab R2007b
%__________________________________________________________________________
%
% CHANGELOG
% Created by Raphaël Dumas
% March 2010
%__________________________________________________________________________

function [Joint,Segment] = Inverse_Dynamics_VE(Joint,Segment,f,n)

% Extend segment fields
Segment = Extend_Segment_Fields(Segment);

% Kinematics
Segment = Kinematics_VE(Segment,f,n);

% Dynamics
[Joint,Segment] = Dynamics_VE(Joint,Segment,n);

