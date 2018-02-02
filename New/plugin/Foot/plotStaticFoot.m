% =========================================================================
% REHAZENTER TOOLBOX
% =========================================================================
% File name:    plotStatic
% -------------------------------------------------------------------------
% Subject:      Plot markers during static
% -------------------------------------------------------------------------
% Inputs:       - Markers (structure)
%               - Vmarkers (structure)
%               - system (char)
% Outputs:      
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber, A. Naaim
% Date of creation: 26/03/2014
% Version: 1
% -------------------------------------------------------------------------
% Updates:
% =========================================================================

function plotStaticFoot(Markers,Vmarkers,Static)

fig = figure; hold on; axis equal;

    plot3(permute(Markers.R_BD6(1,1,1),[3,1,2]),permute(-Markers.R_BD6(3,1,1),[3,1,2]),permute(Markers.R_BD6(2,1,1),[3,1,2]), ...
        'Marker','.','Color','yellow','Markersize',20);
    plot3(permute(Markers.R_FM1(1,1,1),[3,1,2]),permute(-Markers.R_FM1(3,1,1),[3,1,2]),permute(Markers.R_FM1(2,1,1),[3,1,2]), ...
        'Marker','.','Color','Red','Markersize',20);
    plot3(permute(Markers.R_FM2(1,1,1),[3,1,2]),permute(-Markers.R_FM2(3,1,1),[3,1,2]),permute(Markers.R_FM2(2,1,1),[3,1,2]), ...
        'Marker','.','Color','Red','Markersize',20);
    plot3(permute(Markers.R_FM5(1,1,1),[3,1,2]),permute(-Markers.R_FM5(3,1,1),[3,1,2]),permute(Markers.R_FM5(2,1,1),[3,1,2]), ...
        'Marker','.','Color','Red','Markersize',20);
    plot3(permute(Markers.R_FMT5(1,1,1),[3,1,2]),permute(-Markers.R_FMT5(3,1,1),[3,1,2]),permute(Markers.R_FMT5(2,1,1),[3,1,2]), ...
        'Marker','.','Color','Red','Markersize',20);
    plot3(permute(Markers.R_FMT2(1,1,1),[3,1,2]),permute(-Markers.R_FMT2(3,1,1),[3,1,2]),permute(Markers.R_FMT2(2,1,1),[3,1,2]), ...
        'Marker','.','Color','Red','Markersize',20);
    plot3(permute(Markers.R_FNT(1,1,1),[3,1,2]),permute(-Markers.R_FNT(3,1,1),[3,1,2]),permute(Markers.R_FNT(2,1,1),[3,1,2]), ...
        'Marker','.','Color','Green','Markersize',20);
    plot3(permute(Markers.R_CAL(1,1,1),[3,1,2]),permute(-Markers.R_CAL(3,1,1),[3,1,2]),permute(Markers.R_CAL(2,1,1),[3,1,2]), ...
        'Marker','.','Color','blue','Markersize',20);
    plot3(permute(Markers.R_CAM(1,1,1),[3,1,2]),permute(-Markers.R_CAM(3,1,1),[3,1,2]),permute(Markers.R_CAM(2,1,1),[3,1,2]), ...
        'Marker','.','Color','blue','Markersize',20);
    plot3(permute(Markers.R_FCC(1,1,1),[3,1,2]),permute(-Markers.R_FCC(3,1,1),[3,1,2]),permute(Markers.R_FCC(2,1,1),[3,1,2]), ...
        'Marker','.','Color','blue','Markersize',20);
   
%     plot3(permute(Vmarkers.cjc_static(1,1,1),[3,1,2]),permute(-Vmarkers.cjc_static(3,1,1),[3,1,2]),permute(Vmarkers.cjc_static(2,1,1),[3,1,2]), ...
%         'Marker','.','Color','Blue','Markersize',20);
    plot3(permute(Vmarkers.r_mjc_static(1,1,1),[3,1,2]),permute(-Vmarkers.r_mjc_static(3,1,1),[3,1,2]),permute(Vmarkers.r_mjc_static(2,1,1),[3,1,2]), ...
        'Marker','.','Color','Black','Markersize',20);
    
    % ICS
    quiver3(0,0,0,1,0,0,0.5,'k');
    quiver3(0,0,0,0,1,0,0.5,'k');
    quiver3(0,0,0,0,0,1,0.5,'k');

    % Number of frames
    n = size(Static(3).Q,3); % At least Q parameter for foot (or hand) segment

    % Frames of interest
    ni = [1:5:n]; % 1% 50% and 100% of cycle
    
    P1x=(permute(Static(2).Q(4,1,ni),[3,2,1]));
    P1y=(permute(Static(2).Q(5,1,ni),[3,2,1]));
    P1z=(permute(Static(2).Q(6,1,ni),[3,2,1]));
    plot3(P1x,P1y,P1z,'ob');
    % Distal endpoints D
    D1x=(permute(Static(2).Q(7,1,ni),[3,2,1]));
    D1y=(permute(Static(2).Q(8,1,ni),[3,2,1]));
    D1z=(permute(Static(2).Q(9,1,ni),[3,2,1]));
    plot3(D1x,D1y,D1z,'.b');
    plot3([P1x,D1x]',[P1y,D1y]',[P1z,D1z]','b');
    U1x=(permute(Static(2).Q(1,1,ni), [3,2,1]));
    U1y=(permute(Static(2).Q(2,1,ni), [3,2,1]));
    U1z=(permute(Static(2).Q(3,1,ni), [3,2,1]));
    quiver3(P1x,P1y,P1z,U1x,U1y,U1z,0.5,'b');
    % W axis
    W1x=(permute(Static(2).Q(10,1,ni),[3,2,1]));
    W1y=(permute(Static(2).Q(11,1,ni),[3,2,1]));
    W1z=(permute(Static(2).Q(12,1,ni),[3,2,1]));
    quiver3(D1x,D1y,D1z,W1x,W1y,W1z,0.5,'b');
        
end