% MAIN PROGRAM
% Main_Segment_Visualisation.m
%__________________________________________________________________________
%
% PURPOSE
% Plotting of segment features
%
% SYNOPSIS
% N/A (i.e., main program)
%
% DESCRIPTION
% Plotting of segment axes (u, w), endpoints (rP, rD) and markers (rM)
% (cf. data structure in user guide)
%__________________________________________________________________________
%
% CALLED FUNCTIONS (FROM 3D INVERSE DYNAMICS TOOLBOX) 
% Mprod_array3.m
% Q2Tu_array3.m
% 
% MATLAB VERSION
% Matlab R2007b
%__________________________________________________________________________
%
% CHANGELOG
% Created by Rapha�l Dumas
% March 2010
%__________________________________________________________________________

% *.mat
%uiload % Segment data

% Figure
figure;
hold on;
axis equal;

% ICS
quiver3(0,0,0,1,0,0,0.5,'k');
quiver3(0,0,0,0,1,0,0.5,'k');
quiver3(0,0,0,0,0,1,0.5,'k');

% Number of frames
n = size(StaticF(3).Q,3); % At least Q parameter for foot (or hand) segment

% Frames of interest
ni = [1:5:n]; % 1% 50% and 100% of cycle

% % Foot (or hand)
% % Proximal enpoint Pt
P1x=(permute(StaticF(2).Q(4,1,ni),[3,2,1]));
P1y=(permute(StaticF(2).Q(5,1,ni),[3,2,1]));
P1z=(permute(StaticF(2).Q(6,1,ni),[3,2,1]));
plot3(P1x,P1y,P1z,'ob');
% Distal endpoints D
D1x=(permute(StaticF(2).Q(7,1,ni),[3,2,1]));
D1y=(permute(StaticF(2).Q(8,1,ni),[3,2,1]));
D1z=(permute(Segment(2).Q(9,1,ni),[3,2,1]));
plot3(D1x,D1y,D1z,'.b');
plot3([P1x,D1x]',[P1y,D1y]',[P1z,D1z]','b');
% U axis
U1x=(permute(StaticF(2).Q(1,1,ni), [3,2,1]));
U1y=(permute(StaticF(2).Q(2,1,ni), [3,2,1]));
U1z=(permute(StaticF(2).Q(3,1,ni), [3,2,1]));
quiver3(P1x,P1y,P1z,U1x,U1y,U1z,0.5,'b');
% W axis
W1x=(permute(StaticF(2).Q(10,1,ni),[3,2,1]));
W1y=(permute(StaticF(2).Q(11,1,ni),[3,2,1]));
W1z=(permute(StaticF(2).Q(12,1,ni),[3,2,1]));
quiver3(D1x,D1y,D1z,W1x,W1y,W1z,0.5,'b');
% Markers
for j = 1:size(StaticF(2).rM,2)
    plot3(permute(StaticF(2).rM(1,j,ni),[3,2,1]),...
        permute(StaticF(2).rM(2,j,ni),[3,2,1]),...
        permute(StaticF(2).rM(3,j,ni),[3,2,1]),'+b');
end

% Leg (or forearm)
% Proximal enpoint P
P2x=(permute(StaticF(3).Q(4,1,ni),[3,2,1]));
P2y=(permute(StaticF(3).Q(5,1,ni),[3,2,1]));
P2z=(permute(StaticF(3).Q(6,1,ni),[3,2,1]));
plot3(P2x,P2y,P2z, 'or' );
% Distal endpoints D
D2x=(permute(StaticF(3).Q(7,1,ni),[3,2,1]));
D2y=(permute(StaticF(3).Q(8,1,ni),[3,2,1]));
D2z=(permute(StaticF(3).Q(9,1,ni),[3,2,1]));
plot3(D2x,D2y,D2z, '.r' );
plot3([P2x,D2x]',[P2y,D2y]',[P2z,D2z]','r');
% U axis
U2x=(permute(StaticF(3).Q(1,1,ni), [3,2,1]));
U2y=(permute(StaticF(3).Q(2,1,ni), [3,2,1]));
U2z=(permute(StaticF(3).Q(3,1,ni), [3,2,1]));
quiver3(P2x,P2y,P2z,U2x,U2y,U2z,0.5,'r');
% W axis
W2x=(permute(StaticF(3).Q(10,1,ni),[3,2,1]));
W2y=(permute(StaticF(3).Q(11,1,ni),[3,2,1]));
W2z=(permute(StaticF(3).Q(12,1,ni),[3,2,1]));
quiver3(D2x,D2y,D2z,W2x,W2y,W2z,0.5,'r');
% Markers
for j = 1:size(StaticF(3).rM,2)
    plot3(permute(StaticF(3).rM(1,j,ni),[3,2,1]),...
        permute(StaticF(3).rM(2,j,ni),[3,2,1]),...
        permute(StaticF(3).rM(3,j,ni),[3,2,1]),'+r');
end

