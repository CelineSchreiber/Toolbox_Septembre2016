% FUNCTION
% Kinematics_WQ.m
%__________________________________________________________________________
%
% PURPOSE
% Computation of segment kinematics by quaternion method
%
% SYNOPSIS
% Segment = Kinematics_WQ(Segment,f,n)
%
% INPUT
% Segment (cf. data structure in user guide)
% f (i.e., sampling frequency)
% n (i.e., number of frames)
%
% OUTPUT
% Segment (cf. data structure in user guide)
%
% DESCRIPTION
% Computation of segment angular velocity and acceleration (alpha, omega), 
% linear velocity and acceleration of centre of mass (v, a) expressed in
% ICS, as a function of:
% *	position of proximal endpoint (rP) expressed in ICS
% *	quaternion (q) of transformation from ICS to SCS
% *	position of centre of mass (rCs) expressed in SCS
%
% REFERENCE
% R Dumas, R Aissaoui, J A de Guise. A 3D generic inverse dynanmic method 
% using wrench notation and quaternion algebra. Computer Methods in 
% Biomechanics and Biomedical Engineering 2004;7(3):159-166.
%__________________________________________________________________________
%
% CALLED FUNCTIONS (FROM 3D INVERSE DYNAMICS TOOLBOX) 
% qprod_array3.m
% Derive_array3.m
% qinv_array3.m
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

function [Segment] = Kinematics_WQ(Segment,f,n)

% Time sampling
dt = 1/f;
% Cut frequency for filtering
fc = 5;

for i = 2:5 % From i = 2 foot (or hand) to i = 5 pelvis (or thorax)

    % Angular velocity expressed in ICS
    % Omega = 2(dq/dt)xq*
    Segment(i).Omega = 2*(qprod_array3(Derive_array3(Segment(i).q,dt), ...
        qinv_array3(Segment(i).q)));
    Segment(i).Omega = Segment(i).Omega (2:4,1,:);
    % Filtering
    Segment(i).Omega = Vfilt_array3(Segment(i).Omega,f,fc); % Overwrite
    
    % Angular acceleration expressed in ICS
    % Alpha = 2[d/dt(dq/dt)]xq* + 2(dq/dt)x(dq*/dt)
    Segment(i).Alpha = 2*(qprod_array3(Derive_array3(Derive_array3 ...
        (Segment(i).q,dt),dt),qinv_array3(Segment(i).q)) + ...
        qprod_array3(Derive_array3 (Segment(i).q,dt), ...
        Derive_array3(qinv_array3(Segment(i).q),dt)));
    Segment(i).Alpha = Segment(i).Alpha (2:4,1,:);
    % Filtering
    Segment(i).Alpha = Vfilt_array3(Segment(i).Alpha,f,fc); % Overwrite

    % Quaternion of position of proximal endpoint [0;rP]
    % in dimension (4*1*n) expressed in ICS
    qrP (1,1,1:n) = 0;
    qrP (2:4,1,1:n) = Segment(i).rP;
    % Quaternion of position of COM [O;rCs] in dimension (4*1*n)
    % expressed in SCS
    qrCs(1,1,1:n) = 0;
    qrCs(2,1,1:n) = Segment(i).rCs(1,:); 
    qrCs(3,1,1:n) = Segment(i).rCs(2,:);
    qrCs(4,1,1:n) = Segment(i).rCs(3,:);
    
    % Linear velocity of COM expressed in ICS
    Segment(i).V = Derive_array3(qrP,dt) + ...
        qprod_array3(Derive_array3(Segment(i).q,dt),qprod_array3(qrCs, ...
        qinv_array3(Segment(i).q))) + qprod_array3(Segment(i).q, ...
        qprod_array3(qrCs,Derive_array3(qinv_array3(Segment(i).q),dt)));
    Segment(i).V = Segment(i).V(2:4,1,:);
    % Filtering
    Segment(i).V = Vfilt_array3(Segment(i).V, f,fc); % Overwrite

    % Linear acceleration of COM expressed in ICS
    Segment(i).A = Derive_array3(Derive_array3(qrP,dt),dt) + ...
        qprod_array3(Derive_array3(Derive_array3(Segment(i).q,dt),dt), ...
        qprod_array3(qrCs,qinv_array3(Segment(i).q))) + ...
        2*(qprod_array3(Derive_array3(Segment(i).q,dt),qprod_array3(qrCs, ...
        Derive_array3(qinv_array3(Segment(i).q),dt)))) + ...
        qprod_array3(Segment(i).q, qprod_array3(qrCs,Derive_array3(...
        Derive_array3(qinv_array3(Segment(i).q),dt),dt)));
    Segment(i).A = Segment(i).A (2:4,1,:);
    % Filtering
    Segment(i).A = Vfilt_array3(Segment(i).A,f,fc); % Overwrite

end
