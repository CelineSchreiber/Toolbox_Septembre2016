% FUNCTION
% Vfilt_array3.m
%__________________________________________________________________________
%
% PURPOSE
% Filtering of vector 
%
% SYNOPSIS
% Vf = Vfilt_array3(V,f,fc)
%
% INPUT
% V (i.e., vector) 
% f (i.e., sampling frequency)
% fc (i.e., cut frequency)
%
% OUTPUT
% Vf (i.e., vector)
%
% DESCRIPTION
% Filtering, along with the 3rd dimension (i.e., all frames, cf. data
% structure in user guide), of the vector components by a 4th order
% Butterworth with special attention when the vector is a column of an
% homogenous matrix
%__________________________________________________________________________
%
% CALLED FUNCTIONS (FROM 3D INVERSE DYNAMICS TOOLBOX) 
% None
% 
% MATLAB VERSION
% Matlab R2007b with Signal Processing Toolbox
%__________________________________________________________________________
%
% CHANGELOG
% Created by Raphaël Dumas
% March 2010
%__________________________________________________________________________

function Vf = Vfilt_array3(V,f,fc)

% Butterworth
[af,bf] = butter(4,fc./(f/2));

% Case of 3D vector
V1 = filtfilt(af,bf,permute(V(1,1,:),[3,1,2]));
V2 = filtfilt(af,bf,permute(V(2,1,:),[3,1,2]));
V3 = filtfilt(af,bf,permute(V(3,1,:),[3,1,2]));
Vf = [permute(V1,[3,2,1]);permute(V2,[3,2,1]);permute(V3,[3,2,1])];

% Case of 4D vector
if (size(V,1) == 4 ...
        & V(4,1,1) ~= 1 ...
        & V(4,1,1) ~= 0) % Quaternion
    V4 = filtfilt(af,bf,permute(V(4,1,:),[3,1,2]));
    Vf(4,1,:) = permute(V4,[3,2,1]);
    
elseif size(V,1) == 4 % Column of homogenous matrix
    % No filtering
    Vf(4,1,:) = V(4,1,:);
end
