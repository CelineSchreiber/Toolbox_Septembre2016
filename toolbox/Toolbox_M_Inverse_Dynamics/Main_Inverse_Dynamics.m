% MAIN PROGRAM
% Main_Inverse_Dynamics.m
%__________________________________________________________________________
%
% PURPOSE
% Computation and plotting of results from four 3D inverse dynamic methods
%
% SYNOPSIS
% N/A (i.e., main program)
%
% DESCRIPTION
% Data loading, call of functions and plotting of joint force and moment,
% segment linear and angular velocity and acceleration
%
% REFERENCE
% R Dumas, E Nicol, L Cheze. Influence of the 3D inverse dynamic method on
% the joint forces and moments during gait. Journal of Biomechanical 
% Engineering 2007;129(5):786-90.
%__________________________________________________________________________
%
% CALLED FUNCTIONS (FROM 3D INVERSE DYNAMICS TOOLBOX) 
% Inverse_Dynamics_VE.m
% Inverse_Dynamics_HM.m
% Inverse_Dynamics_WQ.m
% Inverse_Dynamics_GC.m
% 
% MATLAB VERSION
% Matlab R2007b
%__________________________________________________________________________
%
% CHANGELOG
% Created by Rapha�l Dumas
% March 2010
%
% Modified by Rapha�l Dumas
% December 2010
% Sequence ZYX for both ankle and wrist joints
% Figure captions
%__________________________________________________________________________

% *.mat
%uiload % Segment data
%uiload % Joint data

% Number of frames
n = size(Segment(2).Q,3); % At least Q parameter for foot (or hand) segment
% Interpolation parameters
k = 1:n;
ko = linspace(1,n,100);

% Acquisition frequency
f = input('Acquisition frequency? ');


% % Inverse dynamics using vector & Euler angles method
% [Joint,Segment] = Inverse_Dynamics_VE(Joint,Segment,f,n);
% 
% for i = 2:4 % i = 2 ankle (or wrist) to i = 4 hip (or shoulder)
%     % Proximal segment axis
%     Tw = Q2Tw_array3(Segment(i+1).Q); % Segment axis
%     if i == 2 % ZYX sequence of mobile axis
%         % Joint coordinate system for ankle (or wrist):
%         % Internal/extenal rotation on floating axis
%         % Joint force about the Euler angle axes
%         Joint(i).Fj = Vnop_array3(...
%             Joint(i).F,...
%             Tw(1:3,3,:),... % Zi+1 = wi+1 of segment i+1
%             cross(Segment(i).R(1:3,1,:),Tw(1:3,3,:)),...
%             Segment(i).R(1:3,1,:)); % Xi of segment i
%         % Joint moment about the Euler angle axes
%         Joint(i).Mj = Vnop_array3(...
%             Joint(i).M,...
%             Tw(1:3,3,:),... % Zi+1 = wi+1 of segment i+1
%             cross(Segment(i).R(1:3,1,:),Tw(1:3,3,:)),...
%             Segment(i).R(1:3,1,:)); % Xi of segment i
%     else % Same joint coordinate system for all joints
%         % ZXY sequence of mobile axis
%         % Joint force about the Euler angle axes
%         Joint(i).Fj = Vnop_array3(...
%             Joint(i).F,...
%             Tw(1:3,3,:),... % Zi+1 = wi+1 of segment i+1
%             cross(Segment(i).R(1:3,2,:),Tw(1:3,3,:)),...
%             Segment(i).R(1:3,2,:)); % Yi of segment i
%         % Joint moment about the Euler angle axes
%         Joint(i).Mj = Vnop_array3(...
%             Joint(i).M,...
%             Tw(1:3,3,:),... % Zi+1 = wi+1 of segment i+1
%             cross(Segment(i).R(1:3,2,:),Tw(1:3,3,:)),...
%             Segment(i).R(1:3,2,:)); % Yi of segment i
%     end
% end
% 
% % 100% of gait cycle (or of propulsive cycle)
% % Ankle (or wrist)
% LM2_VE = interp1(k,permute(Joint(2).Fj(1,1,:),[3,1,2]),ko,'spline')';  % in JCS
% PD2_VE = interp1(k,permute(Joint(2).Fj(2,1,:),[3,1,2]), ko,'spline')'; % in JCS
% AP2_VE = interp1(k,permute(Joint(2).Fj(3,1,:),[3,1,2]),ko,'spline')'; % in JCS
% FE2_VE = interp1(k,permute(Joint(2).Mj(1,1,:),[3,1,2]),ko,'spline')'; % in JCS
% IER2_VE = interp1(k,permute(Joint(2).Mj(2,1,:),[3,1,2]),ko,'spline')'; % in JCS
% AA2_VE = interp1(k,permute(Joint(2).Mj(3,1,:),[3,1,2]),ko,'spline')'; % in JCS
% OmegaX2_VE = interp1(k,permute(Segment(2).Omega(1,1,:),[3,1,2]),ko,'spline')'; % in ICS
% OmegaY2_VE = interp1(k,permute(Segment(2).Omega(2,1,:),[3,1,2]),ko,'spline')'; % in ICS
% OmegaZ2_VE = interp1(k,permute(Segment(2).Omega(3,1,:),[3,1,2]),ko,'spline')'; % in ICS
% AlphaX2_VE = interp1(k,permute(Segment(2).Alpha(1,1,:),[3,1,2]),ko,'spline')'; % in ICS
% AlphaY2_VE = interp1(k,permute(Segment(2).Alpha(2,1,:),[3,1,2]),ko,'spline')'; % in ICS
% AlphaZ2_VE = interp1(k,permute(Segment(2).Alpha(3,1,:),[3,1,2]),ko,'spline')'; % in ICS
% VX2_VE = interp1(k,permute(Segment(2).V(1,1,:),[3,1,2]),ko,'spline')'; % in ICS
% VY2_VE = interp1(k,permute(Segment(2).V(2,1,:),[3,1,2]),ko,'spline')'; % in ICS
% VZ2_VE = interp1(k,permute(Segment(2).V(3,1,:),[3,1,2]),ko,'spline')'; % in ICS
% AX2_VE = interp1(k,permute(Segment(2).A(1,1,:),[3,1,2]),ko,'spline')'; % in ICS
% AY2_VE = interp1(k,permute(Segment(2).A(2,1,:),[3,1,2]),ko,'spline')'; % in ICS
% AZ2_VE = interp1(k,permute(Segment(2).A(3,1,:),[3,1,2]),ko,'spline')'; % in ICS
% % Knee (or elbow)
% LM3_VE = interp1(k,permute(Joint(3).Fj(1,1,:),[3,1,2]),ko,'spline')'; % in JCS
% AP3_VE = interp1(k,permute(Joint(3).Fj(2,1,:),[3,1,2]),ko,'spline')'; % in JCS
% PD3_VE = interp1(k,permute(Joint(3).Fj(3,1,:),[3,1,2]),ko,'spline')'; % in JCS
% FE3_VE = interp1(k,permute(Joint(3).Mj(1,1,:),[3,1,2]),ko,'spline')'; % in JCS
% AA3_VE = interp1(k,permute(Joint(3).Mj(2,1,:),[3,1,2]),ko,'spline')'; % in JCS
% IER3_VE = interp1(k,permute(Joint(3).Mj(3,1,:),[3,1,2]),ko,'spline')'; % in JCS
% OmegaX3_VE = interp1(k,permute(Segment(3).Omega(1,1,:),[3,1,2]),ko,'spline')'; % in ICS
% OmegaY3_VE = interp1(k,permute(Segment(3).Omega(2,1,:),[3,1,2]),ko,'spline')'; % in ICS
% OmegaZ3_VE = interp1(k,permute(Segment(3).Omega(3,1,:),[3,1,2]),ko,'spline')'; % in ICS
% AlphaX3_VE = interp1(k,permute(Segment(3).Alpha(1,1,:),[3,1,2]),ko,'spline')'; % in ICS
% AlphaY3_VE = interp1(k,permute(Segment(3).Alpha(2,1,:),[3,1,2]),ko,'spline')'; % in ICS
% AlphaZ3_VE = interp1(k,permute(Segment(3).Alpha(3,1,:),[3,1,2]),ko,'spline')'; % in ICS
% VX3_VE = interp1(k,permute(Segment(3).V(1,1,:),[3,1,2]),ko,'spline')'; % in ICS
% VY3_VE = interp1(k,permute(Segment(3).V(2,1,:),[3,1,2]),ko,'spline')'; % in ICS
% VZ3_VE = interp1(k,permute(Segment(3).V(3,1,:),[3,1,2]),ko,'spline')'; % in ICS
% AX3_VE = interp1(k,permute(Segment(3).A(1,1,:),[3,1,2]),ko,'spline')'; % in ICS
% AY3_VE = interp1(k,permute(Segment(3).A(2,1,:),[3,1,2]),ko,'spline')'; % in ICS
% AZ3_VE = interp1(k,permute(Segment(3).A(3,1,:),[3,1,2]),ko,'spline')'; % in ICS
% % Hip (or shoulder)
% LM4_VE = interp1(k,permute(Joint(4).Fj(1,1,:),[3,1,2]),ko,'spline')';
% AP4_VE = interp1(k,permute(Joint(4).Fj(2,1,:),[3,1,2]),ko,'spline')';
% PD4_VE = interp1(k,permute(Joint(4).Fj(3,1,:),[3,1,2]),ko,'spline')';
% FE4_VE = interp1(k,permute(Joint(4).Mj(1,1,:),[3,1,2]),ko,'spline')';
% AA4_VE = interp1(k,permute(Joint(4).Mj(2,1,:),[3,1,2]),ko,'spline')';
% IER4_VE = interp1(k,permute(Joint(4).Mj(3,1,:),[3,1,2]),ko,'spline')';
% OmegaX4_VE = interp1(k,permute(Segment(4).Omega(1,1,:),[3,1,2]),ko,'spline')'; % in ICS
% OmegaY4_VE = interp1(k,permute(Segment(4).Omega(2,1,:),[3,1,2]),ko,'spline')'; % in ICS
% OmegaZ4_VE = interp1(k,permute(Segment(4).Omega(3,1,:),[3,1,2]),ko,'spline')'; % in ICS
% AlphaX4_VE = interp1(k,permute(Segment(4).Alpha(1,1,:),[3,1,2]),ko,'spline')'; % in ICS
% AlphaY4_VE = interp1(k,permute(Segment(4).Alpha(2,1,:),[3,1,2]),ko,'spline')'; % in ICS
% AlphaZ4_VE = interp1(k,permute(Segment(4).Alpha(3,1,:),[3,1,2]),ko,'spline')'; % in ICS
% VX4_VE = interp1(k,permute(Segment(4).V(1,1,:),[3,1,2]),ko,'spline')'; % in ICS
% VY4_VE = interp1(k,permute(Segment(4).V(2,1,:),[3,1,2]),ko,'spline')'; % in ICS
% VZ4_VE = interp1(k,permute(Segment(4).V(3,1,:),[3,1,2]),ko,'spline')'; % in ICS
% AX4_VE = interp1(k,permute(Segment(4).A(1,1,:),[3,1,2]),ko,'spline')'; % in ICS
% AY4_VE = interp1(k,permute(Segment(4).A(2,1,:),[3,1,2]),ko,'spline')'; % in ICS
% AZ4_VE = interp1(k,permute(Segment(4).A(3,1,:),[3,1,2]),ko,'spline')'; % in ICS


% Initialisation
for i = 2:4 % From i = 2 foot (or hand) to i = 4 (or arm)
    Segment(i).T = [];
    Joint(i).F = [];
    Joint(i).M = [];
end

% Inverse dynamics using homogenous matrix method
[Segment,Joint] = Inverse_Dynamics_HM(Segment,Joint,f,n);

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

% 100% of gait cycle (or of propulsive cycle)
% Ankle (or wrist)
LM2_HM = interp1(k,permute(Joint(2).Fj(1,1,:),[3,1,2]),ko,'spline')';  % in JCS
PD2_HM = interp1(k,permute(Joint(2).Fj(2,1,:),[3,1,2]), ko,'spline')'; % in JCS
AP2_HM = interp1(k,permute(Joint(2).Fj(3,1,:),[3,1,2]),ko,'spline')'; % in JCS
FE2_HM = interp1(k,permute(Joint(2).Mj(1,1,:),[3,1,2]),ko,'spline')'; % in JCS
IER2_HM = interp1(k,permute(Joint(2).Mj(2,1,:),[3,1,2]),ko,'spline')'; % in JCS
AA2_HM = interp1(k,permute(Joint(2).Mj(3,1,:),[3,1,2]),ko,'spline')'; % in JCS
OmegaX2_HM = interp1(k,permute(Segment(2).Omega(1,1,:),[3,1,2]),ko,'spline')'; % in ICS
OmegaY2_HM = interp1(k,permute(Segment(2).Omega(2,1,:),[3,1,2]),ko,'spline')'; % in ICS
OmegaZ2_HM = interp1(k,permute(Segment(2).Omega(3,1,:),[3,1,2]),ko,'spline')'; % in ICS
AlphaX2_HM = interp1(k,permute(Segment(2).Alpha(1,1,:),[3,1,2]),ko,'spline')'; % in ICS
AlphaY2_HM = interp1(k,permute(Segment(2).Alpha(2,1,:),[3,1,2]),ko,'spline')'; % in ICS
AlphaZ2_HM = interp1(k,permute(Segment(2).Alpha(3,1,:),[3,1,2]),ko,'spline')'; % in ICS
VX2_HM = interp1(k,permute(Segment(2).V(1,1,:),[3,1,2]),ko,'spline')'; % in ICS
VY2_HM = interp1(k,permute(Segment(2).V(2,1,:),[3,1,2]),ko,'spline')'; % in ICS
VZ2_HM = interp1(k,permute(Segment(2).V(3,1,:),[3,1,2]),ko,'spline')'; % in ICS
AX2_HM = interp1(k,permute(Segment(2).A(1,1,:),[3,1,2]),ko,'spline')'; % in ICS
AY2_HM = interp1(k,permute(Segment(2).A(2,1,:),[3,1,2]),ko,'spline')'; % in ICS
AZ2_HM = interp1(k,permute(Segment(2).A(3,1,:),[3,1,2]),ko,'spline')'; % in ICS
% Knee (or elbow)
LM3_HM = interp1(k,permute(Joint(3).Fj(1,1,:),[3,1,2]),ko,'spline')'; % in JCS
AP3_HM = interp1(k,permute(Joint(3).Fj(2,1,:),[3,1,2]),ko,'spline')'; % in JCS
PD3_HM = interp1(k,permute(Joint(3).Fj(3,1,:),[3,1,2]),ko,'spline')'; % in JCS
FE3_HM = interp1(k,permute(Joint(3).Mj(1,1,:),[3,1,2]),ko,'spline')'; % in JCS
AA3_HM = interp1(k,permute(Joint(3).Mj(2,1,:),[3,1,2]),ko,'spline')'; % in JCS
IER3_HM = interp1(k,permute(Joint(3).Mj(3,1,:),[3,1,2]),ko,'spline')'; % in JCS
OmegaX3_HM = interp1(k,permute(Segment(3).Omega(1,1,:),[3,1,2]),ko,'spline')'; % in ICS
OmegaY3_HM = interp1(k,permute(Segment(3).Omega(2,1,:),[3,1,2]),ko,'spline')'; % in ICS
OmegaZ3_HM = interp1(k,permute(Segment(3).Omega(3,1,:),[3,1,2]),ko,'spline')'; % in ICS
AlphaX3_HM = interp1(k,permute(Segment(3).Alpha(1,1,:),[3,1,2]),ko,'spline')'; % in ICS
AlphaY3_HM = interp1(k,permute(Segment(3).Alpha(2,1,:),[3,1,2]),ko,'spline')'; % in ICS
AlphaZ3_HM = interp1(k,permute(Segment(3).Alpha(3,1,:),[3,1,2]),ko,'spline')'; % in ICS
VX3_HM = interp1(k,permute(Segment(3).V(1,1,:),[3,1,2]),ko,'spline')'; % in ICS
VY3_HM = interp1(k,permute(Segment(3).V(2,1,:),[3,1,2]),ko,'spline')'; % in ICS
VZ3_HM = interp1(k,permute(Segment(3).V(3,1,:),[3,1,2]),ko,'spline')'; % in ICS
AX3_HM = interp1(k,permute(Segment(3).A(1,1,:),[3,1,2]),ko,'spline')'; % in ICS
AY3_HM = interp1(k,permute(Segment(3).A(2,1,:),[3,1,2]),ko,'spline')'; % in ICS
AZ3_HM = interp1(k,permute(Segment(3).A(3,1,:),[3,1,2]),ko,'spline')'; % in ICS
% Hip (or shoulder)
LM4_HM = interp1(k,permute(Joint(4).Fj(1,1,:),[3,1,2]),ko,'spline')';
AP4_HM = interp1(k,permute(Joint(4).Fj(2,1,:),[3,1,2]),ko,'spline')';
PD4_HM = interp1(k,permute(Joint(4).Fj(3,1,:),[3,1,2]),ko,'spline')';
FE4_HM = interp1(k,permute(Joint(4).Mj(1,1,:),[3,1,2]),ko,'spline')';
AA4_HM = interp1(k,permute(Joint(4).Mj(2,1,:),[3,1,2]),ko,'spline')';
IER4_HM = interp1(k,permute(Joint(4).Mj(3,1,:),[3,1,2]),ko,'spline')';
OmegaX4_HM = interp1(k,permute(Segment(4).Omega(1,1,:),[3,1,2]),ko,'spline')'; % in ICS
OmegaY4_HM = interp1(k,permute(Segment(4).Omega(2,1,:),[3,1,2]),ko,'spline')'; % in ICS
OmegaZ4_HM = interp1(k,permute(Segment(4).Omega(3,1,:),[3,1,2]),ko,'spline')'; % in ICS
AlphaX4_HM = interp1(k,permute(Segment(4).Alpha(1,1,:),[3,1,2]),ko,'spline')'; % in ICS
AlphaY4_HM = interp1(k,permute(Segment(4).Alpha(2,1,:),[3,1,2]),ko,'spline')'; % in ICS
AlphaZ4_HM = interp1(k,permute(Segment(4).Alpha(3,1,:),[3,1,2]),ko,'spline')'; % in ICS
VX4_HM = interp1(k,permute(Segment(4).V(1,1,:),[3,1,2]),ko,'spline')'; % in ICS
VY4_HM = interp1(k,permute(Segment(4).V(2,1,:),[3,1,2]),ko,'spline')'; % in ICS
VZ4_HM = interp1(k,permute(Segment(4).V(3,1,:),[3,1,2]),ko,'spline')'; % in ICS
AX4_HM = interp1(k,permute(Segment(4).A(1,1,:),[3,1,2]),ko,'spline')'; % in ICS
AY4_HM = interp1(k,permute(Segment(4).A(2,1,:),[3,1,2]),ko,'spline')'; % in ICS
AZ4_HM = interp1(k,permute(Segment(4).A(3,1,:),[3,1,2]),ko,'spline')'; % in ICS


% % Initialisation
% for i = 2:4  % From i = 2 foot (or hand) to i = 4 (or arm)
%     Segment(i).q = [];
%     Segment(i).R = [];
%     Segment(i).rP = [];
%     Joint(i).F = [];
%     Joint(i).M = [];
% end
% 
% % Inverse dynamics using wrench & quaternion method
% [Joint,Segment] = Inverse_Dynamics_WQ(Joint,Segment,f,n);
% 
% for i = 2:4 % i = 2 ankle (or wrist) to i = 4 hip (or shoulder)
%     % Proximal segment axis
%     Tw = Q2Tw_array3(Segment(i+1).Q); % Segment axis
%     if i == 2 % ZYX sequence of mobile axis
%         % Joint coordinate system for ankle (or wrist):
%         % Internal/extenal rotation on floating axis
%         % Joint force about the Euler angle axes
%         Joint(i).Fj = Vnop_array3(...
%             Joint(i).F,...
%             Tw(1:3,3,:),... % Zi+1 = wi+1 of segment i+1
%             cross(Segment(i).R(1:3,1,:),Tw(1:3,3,:)),...
%             Segment(i).R(1:3,1,:)); % Xi of segment i
%         % Joint moment about the Euler angle axes
%         Joint(i).Mj = Vnop_array3(...
%             Joint(i).M,...
%             Tw(1:3,3,:),... % Zi+1 = wi+1 of segment i+1
%             cross(Segment(i).R(1:3,1,:),Tw(1:3,3,:)),...
%             Segment(i).R(1:3,1,:)); % Xi of segment i
%     else % Same joint coordinate system for all joints
%         % ZXY sequence of mobile axis
%         % Joint force about the Euler angle axes
%         Joint(i).Fj = Vnop_array3(...
%             Joint(i).F,...
%             Tw(1:3,3,:),... % Zi+1 = wi+1 of segment i+1
%             cross(Segment(i).R(1:3,2,:),Tw(1:3,3,:)),...
%             Segment(i).R(1:3,2,:)); % Yi of segment i
%         % Joint moment about the Euler angle axes
%         Joint(i).Mj = Vnop_array3(...
%             Joint(i).M,...
%             Tw(1:3,3,:),... % Zi+1 = wi+1 of segment i+1
%             cross(Segment(i).R(1:3,2,:),Tw(1:3,3,:)),...
%             Segment(i).R(1:3,2,:)); % Yi of segment i
%     end
% end
% 
% % 100% of gait cycle (or of propulsive cycle)
% % Ankle (or wrist)
% LM2_WQ = interp1(k,permute(Joint(2).Fj(1,1,:),[3,1,2]),ko,'spline')';  % in JCS
% PD2_WQ = interp1(k,permute(Joint(2).Fj(2,1,:),[3,1,2]), ko,'spline')'; % in JCS
% AP2_WQ = interp1(k,permute(Joint(2).Fj(3,1,:),[3,1,2]),ko,'spline')'; % in JCS
% FE2_WQ = interp1(k,permute(Joint(2).Mj(1,1,:),[3,1,2]),ko,'spline')'; % in JCS
% IER2_WQ = interp1(k,permute(Joint(2).Mj(2,1,:),[3,1,2]),ko,'spline')'; % in JCS
% AA2_WQ = interp1(k,permute(Joint(2).Mj(3,1,:),[3,1,2]),ko,'spline')'; % in JCS
% OmegaX2_WQ = interp1(k,permute(Segment(2).Omega(1,1,:),[3,1,2]),ko,'spline')'; % in ICS
% OmegaY2_WQ = interp1(k,permute(Segment(2).Omega(2,1,:),[3,1,2]),ko,'spline')'; % in ICS
% OmegaZ2_WQ = interp1(k,permute(Segment(2).Omega(3,1,:),[3,1,2]),ko,'spline')'; % in ICS
% AlphaX2_WQ = interp1(k,permute(Segment(2).Alpha(1,1,:),[3,1,2]),ko,'spline')'; % in ICS
% AlphaY2_WQ = interp1(k,permute(Segment(2).Alpha(2,1,:),[3,1,2]),ko,'spline')'; % in ICS
% AlphaZ2_WQ = interp1(k,permute(Segment(2).Alpha(3,1,:),[3,1,2]),ko,'spline')'; % in ICS
% VX2_WQ = interp1(k,permute(Segment(2).V(1,1,:),[3,1,2]),ko,'spline')'; % in ICS
% VY2_WQ = interp1(k,permute(Segment(2).V(2,1,:),[3,1,2]),ko,'spline')'; % in ICS
% VZ2_WQ = interp1(k,permute(Segment(2).V(3,1,:),[3,1,2]),ko,'spline')'; % in ICS
% AX2_WQ = interp1(k,permute(Segment(2).A(1,1,:),[3,1,2]),ko,'spline')'; % in ICS
% AY2_WQ = interp1(k,permute(Segment(2).A(2,1,:),[3,1,2]),ko,'spline')'; % in ICS
% AZ2_WQ = interp1(k,permute(Segment(2).A(3,1,:),[3,1,2]),ko,'spline')'; % in ICS
% % Knee (or elbow)
% LM3_WQ = interp1(k,permute(Joint(3).Fj(1,1,:),[3,1,2]),ko,'spline')'; % in JCS
% AP3_WQ = interp1(k,permute(Joint(3).Fj(2,1,:),[3,1,2]),ko,'spline')'; % in JCS
% PD3_WQ = interp1(k,permute(Joint(3).Fj(3,1,:),[3,1,2]),ko,'spline')'; % in JCS
% FE3_WQ = interp1(k,permute(Joint(3).Mj(1,1,:),[3,1,2]),ko,'spline')'; % in JCS
% AA3_WQ = interp1(k,permute(Joint(3).Mj(2,1,:),[3,1,2]),ko,'spline')'; % in JCS
% IER3_WQ = interp1(k,permute(Joint(3).Mj(3,1,:),[3,1,2]),ko,'spline')'; % in JCS
% OmegaX3_WQ = interp1(k,permute(Segment(3).Omega(1,1,:),[3,1,2]),ko,'spline')'; % in ICS
% OmegaY3_WQ = interp1(k,permute(Segment(3).Omega(2,1,:),[3,1,2]),ko,'spline')'; % in ICS
% OmegaZ3_WQ = interp1(k,permute(Segment(3).Omega(3,1,:),[3,1,2]),ko,'spline')'; % in ICS
% AlphaX3_WQ = interp1(k,permute(Segment(3).Alpha(1,1,:),[3,1,2]),ko,'spline')'; % in ICS
% AlphaY3_WQ = interp1(k,permute(Segment(3).Alpha(2,1,:),[3,1,2]),ko,'spline')'; % in ICS
% AlphaZ3_WQ = interp1(k,permute(Segment(3).Alpha(3,1,:),[3,1,2]),ko,'spline')'; % in ICS
% VX3_WQ = interp1(k,permute(Segment(3).V(1,1,:),[3,1,2]),ko,'spline')'; % in ICS
% VY3_WQ = interp1(k,permute(Segment(3).V(2,1,:),[3,1,2]),ko,'spline')'; % in ICS
% VZ3_WQ = interp1(k,permute(Segment(3).V(3,1,:),[3,1,2]),ko,'spline')'; % in ICS
% AX3_WQ = interp1(k,permute(Segment(3).A(1,1,:),[3,1,2]),ko,'spline')'; % in ICS
% AY3_WQ = interp1(k,permute(Segment(3).A(2,1,:),[3,1,2]),ko,'spline')'; % in ICS
% AZ3_WQ = interp1(k,permute(Segment(3).A(3,1,:),[3,1,2]),ko,'spline')'; % in ICS
% % Hip (or shoulder)
% LM4_WQ = interp1(k,permute(Joint(4).Fj(1,1,:),[3,1,2]),ko,'spline')';
% AP4_WQ = interp1(k,permute(Joint(4).Fj(2,1,:),[3,1,2]),ko,'spline')';
% PD4_WQ = interp1(k,permute(Joint(4).Fj(3,1,:),[3,1,2]),ko,'spline')';
% FE4_WQ = interp1(k,permute(Joint(4).Mj(1,1,:),[3,1,2]),ko,'spline')';
% AA4_WQ = interp1(k,permute(Joint(4).Mj(2,1,:),[3,1,2]),ko,'spline')';
% IER4_WQ = interp1(k,permute(Joint(4).Mj(3,1,:),[3,1,2]),ko,'spline')';
% OmegaX4_WQ = interp1(k,permute(Segment(4).Omega(1,1,:),[3,1,2]),ko,'spline')'; % in ICS
% OmegaY4_WQ = interp1(k,permute(Segment(4).Omega(2,1,:),[3,1,2]),ko,'spline')'; % in ICS
% OmegaZ4_WQ = interp1(k,permute(Segment(4).Omega(3,1,:),[3,1,2]),ko,'spline')'; % in ICS
% AlphaX4_WQ = interp1(k,permute(Segment(4).Alpha(1,1,:),[3,1,2]),ko,'spline')'; % in ICS
% AlphaY4_WQ = interp1(k,permute(Segment(4).Alpha(2,1,:),[3,1,2]),ko,'spline')'; % in ICS
% AlphaZ4_WQ = interp1(k,permute(Segment(4).Alpha(3,1,:),[3,1,2]),ko,'spline')'; % in ICS
% VX4_WQ = interp1(k,permute(Segment(4).V(1,1,:),[3,1,2]),ko,'spline')'; % in ICS
% VY4_WQ = interp1(k,permute(Segment(4).V(2,1,:),[3,1,2]),ko,'spline')'; % in ICS
% VZ4_WQ = interp1(k,permute(Segment(4).V(3,1,:),[3,1,2]),ko,'spline')'; % in ICS
% AX4_WQ = interp1(k,permute(Segment(4).A(1,1,:),[3,1,2]),ko,'spline')'; % in ICS
% AY4_WQ = interp1(k,permute(Segment(4).A(2,1,:),[3,1,2]),ko,'spline')'; % in ICS
% AZ4_WQ = interp1(k,permute(Segment(4).A(3,1,:),[3,1,2]),ko,'spline')'; % in ICS


% % Initialisation
% for i = 2:4  % From i = 2 foot (or hand) to i = 4 (or arm)
%     Joint(i).F = [];
%     Joint(i).M = [];
% end
% 
% % Inverse dynamics using generalized coordinates method
% [Joint,Segment] = Inverse_Dynamics_GC(Joint,Segment,f,n);
% 
% for i = 2:4 % i = 2 ankle (or wrist) to i = 4 hip (or shoulder)
%     % Proximal segment axis
%     Tw = Q2Tw_array3(Segment(i+1).Q); % Segment axis
%     if i == 2 % ZYX sequence of mobile axis
%         % Joint coordinate system for ankle (or wrist):
%         % Internal/extenal rotation on floating axis
%         % Joint force about the Euler angle axes
%         Joint(i).Fj = Vnop_array3(...
%             Joint(i).F,...
%             Tw(1:3,3,:),... % Zi+1 = wi+1 of segment i+1
%             cross(Segment(i).R(1:3,1,:),Tw(1:3,3,:)),...
%             Segment(i).R(1:3,1,:)); % Xi of segment i
%         % Joint moment about the Euler angle axes
%         Joint(i).Mj = Vnop_array3(...
%             Joint(i).M,...
%             Tw(1:3,3,:),... % Zi+1 = wi+1 of segment i+1
%             cross(Segment(i).R(1:3,1,:),Tw(1:3,3,:)),...
%             Segment(i).R(1:3,1,:)); % Xi of segment i
%     else % Same joint coordinate system for all joints
%         % ZXY sequence of mobile axis
%         % Joint force about the Euler angle axes
%         Joint(i).Fj = Vnop_array3(...
%             Joint(i).F,...
%             Tw(1:3,3,:),... % Zi+1 = wi+1 of segment i+1
%             cross(Segment(i).R(1:3,2,:),Tw(1:3,3,:)),...
%             Segment(i).R(1:3,2,:)); % Yi of segment i
%         % Joint moment about the Euler angle axes
%         Joint(i).Mj = Vnop_array3(...
%             Joint(i).M,...
%             Tw(1:3,3,:),... % Zi+1 = wi+1 of segment i+1
%             cross(Segment(i).R(1:3,2,:),Tw(1:3,3,:)),...
%             Segment(i).R(1:3,2,:)); % Yi of segment i
%     end
% end
% 
% % 100% of gait cycle (or of propulsive cycle)
% % Ankle (or wrist)
% LM2_GC = interp1(k,permute(Joint(2).Fj(1,1,:),[3,1,2]),ko,'spline')';  % in JCS
% PD2_GC = interp1(k,permute(Joint(2).Fj(2,1,:),[3,1,2]), ko,'spline')'; % in JCS
% AP2_GC = interp1(k,permute(Joint(2).Fj(3,1,:),[3,1,2]),ko,'spline')'; % in JCS
% FE2_GC = interp1(k,permute(Joint(2).Mj(1,1,:),[3,1,2]),ko,'spline')'; % in JCS
% IER2_GC = interp1(k,permute(Joint(2).Mj(2,1,:),[3,1,2]),ko,'spline')'; % in JCS
% AA2_GC = interp1(k,permute(Joint(2).Mj(3,1,:),[3,1,2]),ko,'spline')'; % in JCS
% OmegaX2_GC = interp1(k,permute(Segment(2).Omega(1,1,:),[3,1,2]),ko,'spline')'; % in ICS
% OmegaY2_GC = interp1(k,permute(Segment(2).Omega(2,1,:),[3,1,2]),ko,'spline')'; % in ICS
% OmegaZ2_GC = interp1(k,permute(Segment(2).Omega(3,1,:),[3,1,2]),ko,'spline')'; % in ICS
% AlphaX2_GC = interp1(k,permute(Segment(2).Alpha(1,1,:),[3,1,2]),ko,'spline')'; % in ICS
% AlphaY2_GC = interp1(k,permute(Segment(2).Alpha(2,1,:),[3,1,2]),ko,'spline')'; % in ICS
% AlphaZ2_GC = interp1(k,permute(Segment(2).Alpha(3,1,:),[3,1,2]),ko,'spline')'; % in ICS
% VX2_GC = interp1(k,permute(Segment(2).V(1,1,:),[3,1,2]),ko,'spline')'; % in ICS
% VY2_GC = interp1(k,permute(Segment(2).V(2,1,:),[3,1,2]),ko,'spline')'; % in ICS
% VZ2_GC = interp1(k,permute(Segment(2).V(3,1,:),[3,1,2]),ko,'spline')'; % in ICS
% AX2_GC = interp1(k,permute(Segment(2).A(1,1,:),[3,1,2]),ko,'spline')'; % in ICS
% AY2_GC = interp1(k,permute(Segment(2).A(2,1,:),[3,1,2]),ko,'spline')'; % in ICS
% AZ2_GC = interp1(k,permute(Segment(2).A(3,1,:),[3,1,2]),ko,'spline')'; % in ICS
% % Knee (or elbow)
% LM3_GC = interp1(k,permute(Joint(3).Fj(1,1,:),[3,1,2]),ko,'spline')'; % in JCS
% AP3_GC = interp1(k,permute(Joint(3).Fj(2,1,:),[3,1,2]),ko,'spline')'; % in JCS
% PD3_GC = interp1(k,permute(Joint(3).Fj(3,1,:),[3,1,2]),ko,'spline')'; % in JCS
% FE3_GC = interp1(k,permute(Joint(3).Mj(1,1,:),[3,1,2]),ko,'spline')'; % in JCS
% AA3_GC = interp1(k,permute(Joint(3).Mj(2,1,:),[3,1,2]),ko,'spline')'; % in JCS
% IER3_GC = interp1(k,permute(Joint(3).Mj(3,1,:),[3,1,2]),ko,'spline')'; % in JCS
% OmegaX3_GC = interp1(k,permute(Segment(3).Omega(1,1,:),[3,1,2]),ko,'spline')'; % in ICS
% OmegaY3_GC = interp1(k,permute(Segment(3).Omega(2,1,:),[3,1,2]),ko,'spline')'; % in ICS
% OmegaZ3_GC = interp1(k,permute(Segment(3).Omega(3,1,:),[3,1,2]),ko,'spline')'; % in ICS
% AlphaX3_GC = interp1(k,permute(Segment(3).Alpha(1,1,:),[3,1,2]),ko,'spline')'; % in ICS
% AlphaY3_GC = interp1(k,permute(Segment(3).Alpha(2,1,:),[3,1,2]),ko,'spline')'; % in ICS
% AlphaZ3_GC = interp1(k,permute(Segment(3).Alpha(3,1,:),[3,1,2]),ko,'spline')'; % in ICS
% VX3_GC = interp1(k,permute(Segment(3).V(1,1,:),[3,1,2]),ko,'spline')'; % in ICS
% VY3_GC = interp1(k,permute(Segment(3).V(2,1,:),[3,1,2]),ko,'spline')'; % in ICS
% VZ3_GC = interp1(k,permute(Segment(3).V(3,1,:),[3,1,2]),ko,'spline')'; % in ICS
% AX3_GC = interp1(k,permute(Segment(3).A(1,1,:),[3,1,2]),ko,'spline')'; % in ICS
% AY3_GC = interp1(k,permute(Segment(3).A(2,1,:),[3,1,2]),ko,'spline')'; % in ICS
% AZ3_GC = interp1(k,permute(Segment(3).A(3,1,:),[3,1,2]),ko,'spline')'; % in ICS
% % Hip (or shoulder)
% LM4_GC = interp1(k,permute(Joint(4).Fj(1,1,:),[3,1,2]),ko,'spline')';
% AP4_GC = interp1(k,permute(Joint(4).Fj(2,1,:),[3,1,2]),ko,'spline')';
% PD4_GC = interp1(k,permute(Joint(4).Fj(3,1,:),[3,1,2]),ko,'spline')';
% FE4_GC = interp1(k,permute(Joint(4).Mj(1,1,:),[3,1,2]),ko,'spline')';
% AA4_GC = interp1(k,permute(Joint(4).Mj(2,1,:),[3,1,2]),ko,'spline')';
% IER4_GC = interp1(k,permute(Joint(4).Mj(3,1,:),[3,1,2]),ko,'spline')';
% OmegaX4_GC = interp1(k,permute(Segment(4).Omega(1,1,:),[3,1,2]),ko,'spline')'; % in ICS
% OmegaY4_GC = interp1(k,permute(Segment(4).Omega(2,1,:),[3,1,2]),ko,'spline')'; % in ICS
% OmegaZ4_GC = interp1(k,permute(Segment(4).Omega(3,1,:),[3,1,2]),ko,'spline')'; % in ICS
% AlphaX4_GC = interp1(k,permute(Segment(4).Alpha(1,1,:),[3,1,2]),ko,'spline')'; % in ICS
% AlphaY4_GC = interp1(k,permute(Segment(4).Alpha(2,1,:),[3,1,2]),ko,'spline')'; % in ICS
% AlphaZ4_GC = interp1(k,permute(Segment(4).Alpha(3,1,:),[3,1,2]),ko,'spline')'; % in ICS
% VX4_GC = interp1(k,permute(Segment(4).V(1,1,:),[3,1,2]),ko,'spline')'; % in ICS
% VY4_GC = interp1(k,permute(Segment(4).V(2,1,:),[3,1,2]),ko,'spline')'; % in ICS
% VZ4_GC = interp1(k,permute(Segment(4).V(3,1,:),[3,1,2]),ko,'spline')'; % in ICS
% AX4_GC = interp1(k,permute(Segment(4).A(1,1,:),[3,1,2]),ko,'spline')'; % in ICS
% AY4_GC = interp1(k,permute(Segment(4).A(2,1,:),[3,1,2]),ko,'spline')'; % in ICS
% AZ4_GC = interp1(k,permute(Segment(4).A(3,1,:),[3,1,2]),ko,'spline')'; % in ICS


% Figure for ankle (or wrist) joint force and moment
figure;
hold on;
% Lateral Medial
subplot(2,3,1);
hold on;
% plot(LM2_VE,'-r');
plot(LM2_HM,'--b');
% plot(LM2_WQ,':g');
% plot(LM2_GC,'-.k');
title ('Right Ankle (or Wrist) Lateral (+) /  Medial (-)');
xlabel('% of Gait (or Proplusion) Cycle');
ylabel('Force (in N)');
legend('VE','HM','WQ','GC');
% Anterior Posterior
subplot(2,3,2);
hold on;
% plot(AP2_VE,'-r');
plot(AP2_HM,'--b');
% plot(AP2_WQ,':g');
% plot(AP2_GC,'-.k');
title ('Right Ankle (or Wrist) Anterior (+) / Posterior (-)');
xlabel('% of Gait (or Proplusion) Cycle');
ylabel('Force (in N)');
% Proximal Distal
subplot(2,3,3);
hold on;
% plot(PD2_VE,'-r');
plot(PD2_HM,'--b');
% plot(PD2_WQ,':g');
% plot(PD2_GC,'-.k');
title ('Right Ankle (or Wrist)  Proximal (+) / Distal (-)');
xlabel('% of Gait (or Proplusion) Cycle');
ylabel('Force (in N)');
% Flexion Extension
subplot(2,3,4);
hold on;
% plot(FE2_VE,'-r');
plot(FE2_HM,'--b');
% plot(FE2_WQ,':g');
% plot(FE2_GC,'-.k');
title ('Right Ankle (or Wrist) Flexion (+) / Extension(-)');
xlabel('% of Gait (or Proplusion) Cycle');
ylabel('Moment (in N.m)');
% Adduction Abduction
subplot(2,3,5);
hold on;
% plot(AA2_VE,'-r');
plot(AA2_HM,'--b');
% plot(AA2_WQ,':g');
% plot(AA2_GC,'-.k');
title ('Right Ankle (or Wrist) Adduction (+) / Abduction (-)');
xlabel('% of Gait (or Proplusion) Cycle');
ylabel('Moment (in N.m)');
% Internal External Rotation
subplot(2,3,6);
hold on;
% plot(IER2_VE,'-r');
plot(IER2_HM,'--b');
% plot(IER2_WQ,':g');
% plot(IER2_GC,'-.k');
title ('Right Ankle (or Wrist) Internal (+) / External (-) Rotation');
xlabel('% of Gait (or Proplusion) Cycle');
ylabel('Moment (in N.m)');

% % Figure of foot (or hand) kinematic 1rst derivatives
% figure;
% hold on;
% % X-axis of ICS
% subplot(2,3,1);
% hold on;
% % plot(VX2_VE,'-r');
% plot(VX2_HM,'--b');
% % plot(VX2_WQ,':g');
% % plot(VX2_GC,'-.k');
% title ('Foot (or Hand) COM Velocity about X-axis of ICS');
% xlabel('% of Gait (or Proplusion) Cycle');
% ylabel('m/s');
% legend('VE','HM','WQ','GC');
% % Y-axis of ICS
% subplot(2,3,2);
% hold on;
% % plot(VY2_VE,'-r');
% plot(VY2_HM,'--b');
% % plot(VY2_WQ,':g');
% % plot(VY2_GC,'-.k');
% title ('Foot (or Hand) COM Velocity about Y-axis of ICS');
% xlabel('% of Gait (or Proplusion) Cycle');
% ylabel('m/s');
% % Z-axis of ICS
% subplot(2,3,3);
% hold on;
% % plot(VZ2_VE,'-r');
% plot(VZ2_HM,'--b');
% % plot(VZ2_WQ,':g');
% % plot(VZ2_GC,'-.k');
% title ('Foot (or Hand) COM Velocity about Z-axis of ICS');
% xlabel('% of Gait (or Proplusion) Cycle');
% ylabel('m/s');
% % X-axis of ICS
% subplot(2,3,4);
% hold on;
% % plot(OmegaX2_VE,'-r');
% plot(OmegaX2_HM,'--b');
% % plot(OmegaX2_WQ,':g');
% title ('Foot (or Hand) Angular Velocity about X-axis of ICS');
% xlabel('% of Gait (or Proplusion) Cycle');
% ylabel('rad/s');
% % Y-axis of ICS
% subplot(2,3,5);
% hold on;
% % plot(OmegaY2_VE,'-r');
% plot(OmegaY2_HM,'--b');
% % plot(OmegaY2_WQ,':g');
% title ('Foot (or Hand) Angular Velocity about Y-axis of ICS');
% xlabel('% of Gait (or Proplusion) Cycle');
% ylabel('rad/s');
% % Z-axis of ICS
% subplot(2,3,6);
% hold on;
% % plot(OmegaZ2_VE,'-r');
% plot(OmegaZ2_HM,'--b');
% % plot(OmegaZ2_WQ,':g');
% title ('Foot (or Hand) Angular Velocity about Z-axis of ICS');
% xlabel('% of Gait (or Proplusion) Cycle');
% ylabel('rad/s');
% 
% % Figure of foot (or hand) kinematic 2d derivatives
% figure;
% hold on;
% % X-axis of ICS
% subplot(2,3,1);
% hold on;
% % plot(AX2_VE,'-r');
% plot(AX2_HM,'--b');
% % plot(AX2_WQ,':g');
% % plot(AX2_GC,'-.k');
% title ('Foot (or Hand) COM Acceleration about X-axis of ICS');
% xlabel('% of Gait (or Proplusion) Cycle');
% ylabel('m/s^2');
% legend('VE','HM','WQ','GC');
% % Y-axis of ICS
% subplot(2,3,2);
% hold on;
% % plot(AY2_VE,'-r');
% plot(AY2_HM,'--b');
% % plot(AY2_WQ,':g');
% % plot(AY2_GC,'-.k');
% title ('Foot (or Hand) COM Acceleration about Y-axis of ICS');
% xlabel('% of Gait (or Proplusion) Cycle');
% ylabel('m/s^2');
% % Z-axis of ICS
% subplot(2,3,3);
% hold on;
% % plot(AZ2_VE,'-r');
% plot(AZ2_HM,'--b');
% % plot(AZ2_WQ,':g');
% % plot(AZ2_GC,'-.k');
% title ('Foot (or Hand) COM Acceleration about Z-axis of ICS');
% xlabel('% of Gait (or Proplusion) Cycle');
% ylabel('m/s^2');
% % X-axis of ICS
% subplot(2,3,4);
% hold on;
% % plot(AlphaX2_VE,'-r');
% plot(AlphaX2_HM,'--b');
% % plot(AlphaX2_WQ,':g');
% title ('Foot (or Hand) Angular Acceleration about X-axis of ICS');
% xlabel('% of Gait (or Proplusion) Cycle');
% ylabel('rad/s^2');
% % Y-axis of ICS
% subplot(2,3,5);
% hold on;
% % plot(AlphaY2_VE,'-r');
% plot(AlphaY2_HM,'--b');
% % plot(AlphaY2_WQ,':g');
% title ('Foot (or Hand) Angular Acceleration about Y-axis of ICS');
% xlabel('% of Gait (or Proplusion) Cycle');
% ylabel('rad/s^2');
% % Z-axis of ICS
% subplot(2,3,6);
% hold on;
% % plot(AlphaZ2_VE,'-r');
% plot(AlphaZ2_HM,'--b');
% % plot(AlphaZ2_WQ,':g');
% title ('Foot (or Hand) Angular Acceleration about Z-axis of ICS');
% xlabel('% of Gait (or Proplusion) Cycle');
% ylabel('rad/s^2');


% Figure for knee (or elbow) joint force and moment
figure;
hold on;
% Lateral Medial
subplot(2,3,1);
hold on;
% plot(LM3_VE,'-r');
plot(LM3_HM,'--b');
% plot(LM3_WQ,':g');
% plot(LM3_GC,'-.k');
title ('Right Knee (or Elbow) Lateral (+) /  Medial (-)');
xlabel('% of Gait (or Proplusion) Cycle');
ylabel('Force (in N)');
legend('VE','HM','WQ','GC');
% Anterior Posterior
subplot(2,3,2);
hold on;
% plot(AP3_VE,'-r');
plot(AP3_HM,'--b');
% plot(AP3_WQ,':g');
% plot(AP3_GC,'-.k');
title ('Right Knee (or Elbow) Anterior (+) / Posterior (-)');
xlabel('% of Gait (or Proplusion) Cycle');
ylabel('Force (in N)');
% Proximal Distal
subplot(2,3,3);
hold on;
% plot(PD3_VE,'-r');
plot(PD3_HM,'--b');
% plot(PD3_WQ,':g');
% plot(PD3_GC,'-.k');
title ('Right Knee (or Elbow) Proximal (+) / Distal (-)');
xlabel('% of Gait (or Proplusion) Cycle');
ylabel('Force (in N)');
% Flexion Extension
subplot(2,3,4);
hold on;
% plot(FE3_VE,'-r');
plot(FE3_HM,'--b');
% plot(FE3_WQ,':g');
% plot(FE3_GC,'-.k');
title (['  Right Knee Extension (+) / Flexion (-)   '; ...
    '(or Right Elbow Flexion (+) / Extension(-))']);
xlabel('% of Gait (or Proplusion) Cycle');
ylabel('Moment (in N.m)');
% Adduction Abduction
subplot(2,3,5);
hold on;
% plot(AA3_VE,'-r');
plot(AA3_HM,'--b');
% plot(AA3_WQ,':g');
% plot(AA3_GC,'-.k');
title ('Right Knee (or Elbow) Adduction (+) / Abduction (-)');
xlabel('% of Gait (or Proplusion) Cycle');
ylabel('Moment (in N.m)');
% Internal External Rotation
subplot(2,3,6);
hold on;
% plot(IER3_VE,'-r');
plot(IER3_HM,'--b');
% plot(IER3_WQ,':g');
% plot(IER3_GC,'-.k');
title ('Right Knee (or Elbow) Internal (+) / External (-) Rotation');
xlabel('% of Gait (or Proplusion) Cycle');
ylabel('Moment (in N.m)');

% % Figure of leg (or forearm) kinematic 1rst derivatives
% figure;
% hold on;
% % X-axis of ICS
% subplot(2,3,1);
% hold on;
% % plot(VX3_VE,'-r');
% plot(VX3_HM,'--b');
% % plot(VX3_WQ,':g');
% % plot(VX3_GC,'-.k');
% title ('Leg (or Forearm) COM Velocity about X-axis of ICS');
% xlabel('% of Gait (or Proplusion) Cycle');
% ylabel('m/s');
% legend('VE','HM','WQ','GC');
% % Y-axis of ICS
% subplot(2,3,2);
% hold on;
% % plot(VY3_VE,'-r');
% plot(VY3_HM,'--b');
% % plot(VY3_WQ,':g');
% % plot(VY3_GC,'-.k');
% title ('Leg (or Forearm) COM Velocity about Y-axis of ICS');
% xlabel('% of Gait (or Proplusion) Cycle');
% ylabel('m/s');
% % Z-axis of ICS
% subplot(2,3,3);
% hold on;
% % plot(VZ3_VE,'-r');
% plot(VZ3_HM,'--b');
% % plot(VZ3_WQ,':g');
% % plot(VZ3_GC,'-.k');
% title ('Leg (or Forearm) COM Velocity about Z-axis of ICS');
% xlabel('% of Gait (or Proplusion) Cycle');
% ylabel('m/s');
% % X-axis of ICS
% subplot(2,3,4);
% hold on;
% % plot(OmegaX3_VE,'-r');
% plot(OmegaX3_HM,'--b');
% % plot(OmegaX3_WQ,':g');
% title ('Leg (or Forearm) Angular Velocity about X-axis of ICS');
% xlabel('% of Gait (or Proplusion) Cycle');
% ylabel('rad/s');
% % Y-axis of ICS
% subplot(2,3,5);
% hold on;
% % plot(OmegaY3_VE,'-r');
% plot(OmegaY3_HM,'--b');
% % plot(OmegaY3_WQ,':g');
% title ('Leg (or Forearm) Angular Velocity about Y-axis of ICS');
% xlabel('% of Gait (or Proplusion) Cycle');
% ylabel('rad/s');
% % Z-axis of ICS
% subplot(2,3,6);
% hold on;
% % plot(OmegaZ3_VE,'-r');
% plot(OmegaZ3_HM,'--b');
% % plot(OmegaZ3_WQ,':g');
% title ('Leg (or Forarm) Angular Velocity about Z-axis of ICS');
% xlabel('% of Gait (or Proplusion) Cycle');
% ylabel('rad/s');
% 
% % Figure of leg (or forearm) kinematic 2d derivatives
% figure;
% hold on;
% % X-axis of ICS
% subplot(2,3,1);
% hold on;
% % plot(AX3_VE,'-r');
% plot(AX3_HM,'--b');
% % plot(AX3_WQ,':g');
% % plot(AX3_GC,'-.k');
% title ('Leg (or Forrarm) COM Acceleration about X-axis of ICS');
% xlabel('% of Gait (or Proplusion) Cycle');
% ylabel('m/s^2');
% legend('VE','HM','WQ','GC');
% % Y-axis of ICS
% subplot(2,3,2);
% hold on;
% % plot(AY3_VE,'-r');
% plot(AY3_HM,'--b');
% % plot(AY3_WQ,':g');
% % plot(AY3_GC,'-.k');
% title ('Leg (or Forearm) COM Acceleration about Y-axis of ICS');
% xlabel('% of Gait (or Proplusion) Cycle');
% ylabel('m/s^2');
% % Z-axis of ICS
% subplot(2,3,3);
% hold on;
% % plot(AZ3_VE,'-r');
% plot(AZ3_HM,'--b');
% % plot(AZ3_WQ,':g');
% % plot(AZ3_GC,'-.k');
% title ('Leg (or Foreram) COM Acceleration about Z-axis of ICS');
% xlabel('% of Gait (or Proplusion) Cycle');
% ylabel('m/s^2');
% % X-axis of ICS
% subplot(2,3,4);
% hold on;
% % plot(AlphaX3_VE,'-r');
% plot(AlphaX3_HM,'--b');
% % plot(AlphaX3_WQ,':g');
% title ('Leg (or Forearm) Angular Acceleration about X-axis of ICS');
% xlabel('% of Gait (or Proplusion) Cycle');
% ylabel('rad/s^2');
% % Y-axis of ICS
% subplot(2,3,5);
% hold on;
% % plot(AlphaY3_VE,'-r');
% plot(AlphaY3_HM,'--b');
% % plot(AlphaY3_WQ,':g');
% title ('Leg (or Forearm) Angular Acceleration about Y-axis of ICS');
% xlabel('% of Gait (or Proplusion) Cycle');
% ylabel('rad/s^2');
% % Z-axis of ICS
% subplot(2,3,6);
% hold on;
% % plot(AlphaZ3_VE,'-r');
% plot(AlphaZ3_HM,'--b');
% % plot(AlphaZ3_WQ,':g');
% title ('Leg (or Forearm) Angular Acceleration about Z-axis of ICS');
% xlabel('% of Gait (or Proplusion) Cycle');
% ylabel('rad/s^2');


% Figure for hip (or shoulder) joint force and moment
figure;
hold on;
% Lateral Medial
subplot(2,3,1);
hold on;
% plot(LM4_VE,'-r');
plot(LM4_HM,'--b');
% plot(LM4_WQ,':g');
% plot(LM4_GC,'-.k');
title ('Right Hip (or Shoulder) Lateral (+) /  Medial (-)');
xlabel('% of Gait (or Proplusion) Cycle');
ylabel('Force (in N)');
legend('VE','HM','WQ','GC');
% Anterior Posterior
subplot(2,3,2);
hold on;
% plot(AP4_VE,'-r');
plot(AP4_HM,'--b');
% plot(AP4_WQ,':g');
% plot(AP4_GC,'-.k');
title ('Right Hip (or Shoulder) Anterior (+) / Posterior (-)');
xlabel('% of Gait (or Proplusion) Cycle');
ylabel('Force (in N)');
% Proximal Distal
subplot(2,3,3);
hold on;
% plot(PD4_VE,'-r');
plot(PD4_HM,'--b');
% plot(PD4_WQ,':g');
% plot(PD4_GC,'-.k');
title ('Right Hip (or Shoulder) Proximal (+) / Distal (-)');
xlabel('% of Gait (or Proplusion) Cycle');
ylabel('Force (in N)');
% Flexion Extension
subplot(2,3,4);
hold on;
% plot(FE4_VE,'-r');
plot(FE4_HM,'--b');
% plot(FE4_WQ,':g');
% plot(FE4_GC,'-.k');
title ('Right Hip (or Shoulder) Flexion (+) / Extension(-)');
xlabel('% of Gait (or Proplusion) Cycle');
ylabel('Moment (in N.m)');
% Adduction Abduction
subplot(2,3,5);
hold on;
% plot(AA4_VE,'-r');
plot(AA4_HM,'--b');
% plot(AA4_WQ,':g');
% plot(AA4_GC,'-.k');
title ('Right Hip (or Shoulder) Adduction (+) / Abduction (-)');
xlabel('% of Gait (or Proplusion) Cycle');
ylabel('Moment (in N.m)');
% Internal External Rotation
subplot(2,3,6);
hold on;
% plot(IER4_VE,'-r');
plot(IER4_HM,'--b');
% plot(IER4_WQ,':g');
% plot(IER4_GC,'-.k');
title ('Right Hip (or Shoulder) Internal (+) / External (-) Rotation');
xlabel('% of Gait (or Proplusion) Cycle');
ylabel('Moment (in N.m)');

% % Figure of Thigh (or Arm) kinematic 1rst derivatives
% figure;
% hold on;
% % X-axis of ICS
% subplot(2,3,1);
% hold on;
% plot(VX4_VE,'-r');
% plot(VX4_HM,'--b');
% plot(VX4_WQ,':g');
% plot(VX4_GC,'-.k');
% title ('Thigh (or Arm) COM Velocity about X-axis of ICS');
% xlabel('% of Gait (or Proplusion) Cycle');
% ylabel('m/s');
% legend('VE','HM','WQ','GC');
% % Y-axis of ICS
% subplot(2,3,2);
% hold on;
% plot(VY4_VE,'-r');
% plot(VY4_HM,'--b');
% plot(VY4_WQ,':g');
% plot(VY4_GC,'-.k');
% title ('Thigh (or Arm) COM Velocity about Y-axis of ICS');
% xlabel('% of Gait (or Proplusion) Cycle');
% ylabel('m/s');
% % Z-axis of ICS
% subplot(2,3,3);
% hold on;
% plot(VZ4_VE,'-r');
% plot(VZ4_HM,'--b');
% plot(VZ4_WQ,':g');
% plot(VZ4_GC,'-.k');
% title ('Thigh (or Arm) COM Velocity about Z-axis of ICS');
% xlabel('% of Gait (or Proplusion) Cycle');
% ylabel('m/s');
% % X-axis of ICS
% subplot(2,3,4);
% hold on;
% plot(OmegaX4_VE,'-r');
% plot(OmegaX4_HM,'--b');
% plot(OmegaX4_WQ,':g');
% title ('Thigh (or Arm) Angular Velocity about X-axis of ICS');
% xlabel('% of Gait (or Proplusion) Cycle');
% ylabel('rad/s');
% % Y-axis of ICS
% subplot(2,3,5);
% hold on;
% plot(OmegaY4_VE,'-r');
% plot(OmegaY4_HM,'--b');
% plot(OmegaY4_WQ,':g');
% title ('Thigh (or Arm) Angular Velocity about Y-axis of ICS');
% xlabel('% of Gait (or Proplusion) Cycle');
% ylabel('rad/s');
% % Z-axis of ICS
% subplot(2,3,6);
% hold on;
% plot(OmegaZ4_VE,'-r');
% plot(OmegaZ4_HM,'--b');
% plot(OmegaZ4_WQ,':g');
% title ('Thigh (or Arm) Angular Velocity about Z-axis of ICS');
% xlabel('% of Gait (or Proplusion) Cycle');
% ylabel('rad/s');
% 
% % Figure of Thigh (or Arm) kinematic 2d derivatives
% figure;
% hold on;
% % X-axis of ICS
% subplot(2,3,1);
% hold on;
% plot(AX4_VE,'-r');
% plot(AX4_HM,'--b');
% plot(AX4_WQ,':g');
% plot(AX4_GC,'-.k');
% title ('Thigh (or Arm) COM Acceleration about X-axis of ICS');
% xlabel('% of Gait (or Proplusion) Cycle');
% ylabel('m/s^2');
% legend('VE','HM','WQ','GC');
% % Y-axis of ICS
% subplot(2,3,2);
% hold on;
% plot(AY4_VE,'-r');
% plot(AY4_HM,'--b');
% plot(AY4_WQ,':g');
% plot(AY4_GC,'-.k');
% title ('Thigh (or Arm) COM Acceleration about Y-axis of ICS');
% xlabel('% of Gait (or Proplusion) Cycle');
% ylabel('m/s^2');
% % Z-axis of ICS
% subplot(2,3,3);
% hold on;
% plot(AZ4_VE,'-r');
% plot(AZ4_HM,'--b');
% plot(AZ4_WQ,':g');
% plot(AZ4_GC,'-.k');
% title ('Thigh (or Arm) COM Acceleration about Z-axis of ICS');
% xlabel('% of Gait (or Proplusion) Cycle');
% ylabel('m/s^2');
% % X-axis of ICS
% subplot(2,3,4);
% hold on;
% plot(AlphaX4_VE,'-r');
% plot(AlphaX4_HM,'--b');
% plot(AlphaX4_WQ,':g');
% title ('Thigh (or Arm) Angular Acceleration about X-axis of ICS');
% xlabel('% of Gait (or Proplusion) Cycle');
% ylabel('rad/s^2');
% % Y-axis of ICS
% subplot(2,3,5);
% hold on;
% plot(AlphaY4_VE,'-r');
% plot(AlphaY4_HM,'--b');
% plot(AlphaY4_WQ,':g');
% title ('Thigh (or Arm) Angular Acceleration about Y-axis of ICS');
% xlabel('% of Gait (or Proplusion) Cycle');
% ylabel('rad/s^2');
% % Z-axis of ICS
% subplot(2,3,6);
% hold on;
% plot(AlphaZ4_VE,'-r');
% plot(AlphaZ4_HM,'--b');
% plot(AlphaZ4_WQ,':g');
% title ('Thigh (or Arm) Angular Acceleration about Z-axis of ICS');
% xlabel('% of Gait (or Proplusion) Cycle');
% ylabel('rad/s^2');
