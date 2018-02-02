% FUNCTION
% Mfilt_array3.m
%__________________________________________________________________________
%
% PURPOSE
% Filtering of matrix 
%
% SYNOPSIS
% Mf = Mfilt_array3(M,f,fc)
%
% INPUT
% M (i.e., matrix) 
% f (i.e., sampling frequency)
% fc (i.e., cut frequency)
%
% OUTPUT
% Mf (i.e., matrix)
%
% DESCRIPTION
% Filtering, along with the 3rd dimension (i.e., all frames, cf. data 
% structure in user guide), of the matrix elements by a 4th order
% Butterworth
%__________________________________________________________________________
%
% CALLED FUNCTIONS (FROM 3D INVERSE DYNAMICS TOOLBOX) 
% Vfilt_array3.m
% 
% MATLAB VERSION
% Matlab R2007b
%__________________________________________________________________________
%
% CHANGELOG
% Created by Raphaël Dumas
% March 2010
%__________________________________________________________________________

function Mf = Mfilt_array3(M,f,fc)

% Case of rotation matrix
V_1 = Vfilt_array3(M(:,1,:),f,fc);
V_2 = Vfilt_array3(M(:,2,:),f,fc);
V_3 = Vfilt_array3(M(:,3,:),f,fc);
Mf = [V_1,V_2,V_3];

% Case of homogenous matrix
if size(M,1) == 4
    Mf(:,4,:) = Vfilt_array3(M(:,4,:),f,fc);
end
