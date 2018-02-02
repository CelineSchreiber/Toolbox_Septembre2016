% =========================================================================
% REHAZENTER TOOLBOX
% =========================================================================
% File name:    inverseDynamics
% -------------------------------------------------------------------------
% Subject:      Compute inverse dynamics
% -------------------------------------------------------------------------
% Inputs:       - Session (structure)
%               - Segment (structure)
%               - Joint (structure)
%               - Gait (structure)
%               - n (int)
%               - f (int)
%               - s (int)
% Outputs:      - Dynamics (structure)
%               - Segment (structure)
%               - Joint (structure)
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber, A. Naaim
% Date of creation: 26/03/2014
% Version: 1
% -------------------------------------------------------------------------
% Updates: - 
% =========================================================================

function [Dynamics,Segment,Joint] = inverseDynamics(Session,Segment,Joint,n,f,s,side)

% =========================================================================
% Initialisation
% =========================================================================
k = 1:n;
ko = linspace(1,n,101);
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
Dynamics.LM3 = [];
Dynamics.AP3 = [];
Dynamics.PD3 = [];
Dynamics.FE3 = [];
Dynamics.AA3 = [];
Dynamics.IER3 = [];
Dynamics.Power3 = [];
Dynamics.LM4 = [];
Dynamics.AP4 = [];
Dynamics.PD4 = [];
Dynamics.FE4 = [];
Dynamics.AA4 = [];
Dynamics.IER4 = [];
Dynamics.Power4 = [];

% =========================================================================
% Parameters for dimensionless computations
% =========================================================================
g = 9.81;
m0 = Session.weight;
if strcmp(side,'Right')
    l0 = Session.right_leg_length;
elseif strcmp(side,'Left')
    l0 = Session.left_leg_length;
end

% =====================================================================
% Inverse dynamics process
% =====================================================================
if s ~= 0

    % Extend segment fields
    % -----------------------------------------------------------------
    Segment = Extend_Segment_Fields(Segment);

    % Homogenous matrix of pseudo-inertia expressed in SCS (Js)
    % -----------------------------------------------------------------
    for i = 2:4  % From i = 2 foot (or hand) to i = 4 thigh (or arm)        
        Segment(i).Js = ...
            [(Segment(i).Is(1,1) + ...
            Segment(i).Is(2,2) + ...
            Segment(i).Is(3,3))/2 * ...
            eye(3) - Segment(i).Is,Segment(i).m * Segment(i).rCs;
            Segment(i).m * (Segment(i).rCs)',Segment(i).m];
    end

    % Transformation form origin of ICS to COP in ICS
    % -----------------------------------------------------------------
    T(1:3,4,:) = Segment(1).T(1:3,4,:);
    T(1,1,:) = 1; % in ICS
    T(2,2,:) = 1; % in ICS
    T(3,3,:) = 1; % in ICS
    T(4,4,:) = 1;

    % Homogenous matrix of GR force and moment at origin of ICS (phi)
    % with transpose = permute( ,[2,1,3])
    % -----------------------------------------------------------------
    Joint(1).phi = Mprod_array3(T,Mprod_array3(...
        [Vskew_array3(Joint(1).M),Joint(1).F;...
        - permute(Joint(1).F,[2,1,3]),zeros(1,1,n)],...
        permute(T,[2,1,3])));

    % Kinematics
    % -----------------------------------------------------------------
    Segment = Kinematics_HM(Segment,f,n);

    % Dynamics
    % -----------------------------------------------------------------
    [Joint,Segment] = Dynamics_HM(Joint,Segment,n);

    for i = 2:4 % i = 2 ankle (or wrist) to i = 4 hip (or shoulder)
        % Proximal segment axis
        Tw = Q2Tw_array3(Segment(i+1).Q); % Segment axis
        if i == 2 % ZYX sequence of mobile axis
            % Joint coordinate system for ankle (or wrist):
            % Internal/extenal rotation on floating axis
            % Joint force about the Euler angle axes
            Joint(i).Fj = Vnop_array3(...
                Joint(i).F,...
                Tw(1:3,3,:),... % Zi+1 = wi+1 of segment i+1
                cross(Segment(i).R(1:3,1,:),Tw(1:3,3,:)),...
                Segment(i).R(1:3,1,:)); % Xi of segment i
            % Joint moment about the Euler angle axes
            Joint(i).Mj = Vnop_array3(...
                Joint(i).M,...
                Tw(1:3,3,:),... % Zi+1 = wi+1 of segment i+1
                cross(Segment(i).R(1:3,1,:),Tw(1:3,3,:)),...
                Segment(i).R(1:3,1,:)); % Xi of segment i
        else % Same joint coordinate system for all joints
            % ZXY sequence of mobile axis
            % Joint force about the Euler angle axes
            Joint(i).Fj = Vnop_array3(...
                Joint(i).F,...
                Tw(1:3,3,:),... % Zi+1 = wi+1 of segment i+1
                cross(Segment(i).R(1:3,2,:),Tw(1:3,3,:)),...
                Segment(i).R(1:3,2,:)); % Yi of segment i
            % Joint moment about the Euler angle axes
            Joint(i).Mj = Vnop_array3(...
                Joint(i).M,...
                Tw(1:3,3,:),... % Zi+1 = wi+1 of segment i+1
                cross(Segment(i).R(1:3,2,:),Tw(1:3,3,:)),...
                Segment(i).R(1:3,2,:)); % Yi of segment i
        end
    end

    % Dimensionless joint power and 3D angle
    % Hof, Scaling gait data to body size
    % Gait and Posture 4 (1996) 22-223
    % -----------------------------------------------------------------
    if s ~= 0
        for j = 1:n
            M = permute(Joint(2).Mj(:,:,j),[3,1,2]);
            Omega = permute(Segment(3).Omega(:,:,j) - Segment(2).Omega(:,:,j),[3,1,2]); % in ICS
            Joint(2).power(:,:,j) = dot(M,Omega); % 3D joint power
            Joint(2).alpha(:,:,j) = atan(norm(cross(M,Omega))/dot(M,Omega));
            M = permute(Joint(3).Mj(:,:,j),[3,1,2]);
            Omega = -permute(Segment(4).Omega(:,:,j) - Segment(3).Omega(:,:,j),[3,1,2]); % in ICS
            Joint(3).power(:,:,j) = dot(M,Omega); % 3D joint power
            Joint(3).alpha(:,:,j) = atan(norm(cross(M,Omega))/dot(M,Omega));
            M = permute(Joint(4).Mj(:,:,j),[3,1,2]);
            Omega = permute(Segment(5).Omega(:,:,j) - Segment(4).Omega(:,:,j),[3,1,2]); % in ICS
            Joint(4).power(:,:,j) = dot(M,Omega); % 3D joint power
            Joint(4).alpha(:,:,j) = atan(norm(cross(M,Omega))/dot(M,Omega));
        end
        Dynamics.Power2 = interp1(k,permute(Joint(2).power,[3,1,2]),ko,'spline')' / ...
            (m0*g^(1/2)*l0^(3/2));
        Dynamics.Power3 = interp1(k,permute(Joint(3).power,[3,1,2]),ko,'spline')' / ...
            (m0*g^(1/2)*l0^(3/2));
        Dynamics.Power4 = interp1(k,permute(Joint(4).power,[3,1,2]),ko,'spline')' / ...
            (m0*g^(1/2)*l0^(3/2));
    else 
        Dynamics.Power2 = [];
        Dynamics.Power3 = [];
        Dynamics.Power4 = [];
    end

    % Dimensionless forces and moments
    % Hof, Scaling gait data to body size
    % Gait and Posture 4 (1996) 22-223
    % -----------------------------------------------------------------
    % GRF
    Dynamics.LM1 = interp1(k,permute(Joint(1).F(3,1,:),[3,1,2]),ko,'spline')' / ...
            (m0*g);  % in JCS
    Dynamics.PD1 = interp1(k,permute(Joint(1).F(2,1,:),[3,1,2]),ko,'spline')' / ...
            (m0*g);  % in JCS
    Dynamics.AP1 = interp1(k,permute(Joint(1).F(1,1,:),[3,1,2]),ko,'spline')' / ...
            (m0*g);  % in JCS
    % Ankle (or wrist)
    Dynamics.LM2 = interp1(k,permute(Joint(2).Fj(1,1,:),[3,1,2]),ko,'spline')' / ...
            (m0*g);  % in JCS
    Dynamics.PD2 = interp1(k,permute(Joint(2).Fj(2,1,:),[3,1,2]), ko,'spline')' / ...
            (m0*g);  % in JCS
    Dynamics.AP2 = interp1(k,permute(Joint(2).Fj(3,1,:),[3,1,2]),ko,'spline')' / ...
            (m0*g);  % in JCS
    Dynamics.FE2 = interp1(k,permute(Joint(2).Mj(1,1,:),[3,1,2]),ko,'spline')' / ...
            (m0*g*l0);  % in JCS
    Dynamics.IER2 = interp1(k,permute(Joint(2).Mj(2,1,:),[3,1,2]),ko,'spline')' / ...
            (m0*g*l0);  % in JCS
    Dynamics.AA2 = interp1(k,permute(Joint(2).Mj(3,1,:),[3,1,2]),ko,'spline')' / ...
            (m0*g*l0);  % in JCS
    % Knee (or elbow)
    Dynamics.LM3 = interp1(k,permute(Joint(3).Fj(1,1,:),[3,1,2]),ko,'spline')' / ...
            (m0*g);  % in JCS
    Dynamics.AP3 = interp1(k,permute(Joint(3).Fj(2,1,:),[3,1,2]),ko,'spline')' / ...
            (m0*g);  % in JCS
    Dynamics.PD3 = interp1(k,permute(Joint(3).Fj(3,1,:),[3,1,2]),ko,'spline')' / ...
            (m0*g);  % in JCS
    Dynamics.FE3 = interp1(k,permute(Joint(3).Mj(1,1,:),[3,1,2]),ko,'spline')' / ...
            (m0*g*l0);  % in JCS
    Dynamics.AA3 = interp1(k,permute(Joint(3).Mj(2,1,:),[3,1,2]),ko,'spline')' / ...
            (m0*g*l0);  % in JCS
    Dynamics.IER3 = interp1(k,permute(Joint(3).Mj(3,1,:),[3,1,2]),ko,'spline')' / ...
            (m0*g*l0);  % in JCS
    % Hip (or shoulder)
    Dynamics.LM4 = interp1(k,permute(Joint(4).Fj(1,1,:),[3,1,2]),ko,'spline')' / ...
            (m0*g);  % in JCS
    Dynamics.AP4 = interp1(k,permute(Joint(4).Fj(2,1,:),[3,1,2]),ko,'spline')' / ...
            (m0*g);  % in JCS
    Dynamics.PD4 = interp1(k,permute(Joint(4).Fj(3,1,:),[3,1,2]),ko,'spline')' / ...
            (m0*g);  % in JCS
    Dynamics.FE4 = interp1(k,permute(Joint(4).Mj(1,1,:),[3,1,2]),ko,'spline')' / ...
            (m0*g*l0);  % in JCS
    Dynamics.AA4 = interp1(k,permute(Joint(4).Mj(2,1,:),[3,1,2]),ko,'spline')' / ...
            (m0*g*l0);  % in JCS
    Dynamics.IER4 = interp1(k,permute(Joint(4).Mj(3,1,:),[3,1,2]),ko,'spline')' / ...
            (m0*g*l0);  % in JCS
end