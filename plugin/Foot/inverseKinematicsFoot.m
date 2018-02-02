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

function Kinematics = inverseKinematicsFoot(Segment,Markers,Gait,n,side)

% =========================================================================
% Initialisation
% =========================================================================
k = (1:n)';
ko = (linspace(1,n,101))';
Kinematics.FootSag = [];
Kinematics.FootFro = [];
Kinematics.FootTra = [];
Kinematics.CalMidSag = [];
Kinematics.CalMidFro = [];
Kinematics.CalMidTra = [];
Kinematics.MidMetSag = [];
Kinematics.MidMetFro = [];
Kinematics.MidMetTra = [];
    
if strcmp(Gait.foottrial,'yes')
    % =====================================================================
    % Segment angles and displacements
    % =====================================================================

    % Foot
    %----------------------------------------------------------------------
    Segment(1).T = Q2Tw_array3(Segment(1).Q);
    Segment(1).Euler = R2fixedZYX_array3(Segment(1).T(1:3,1:3,:));
    Foot.tilt = permute(Segment(1).Euler(:,1,:),[3,2,1])*180/pi-90;
    % Obliquity        
    Foot.obli = -permute(Segment(1).Euler(:,3,:),[3,2,1])*180/pi;
    % Progression angle (rotation)
    if strcmp(side,'Right')
        M1 = Markers.R_FCC;
        M2 = Markers.R_FM1;
        M3 = Markers.R_FM5;
    elseif strcmp(side,'Left')
        M1 = Markers.L_FCC;
        M2 = Markers.L_FM1;
        M3 = Markers.L_FM5;
    end
    beta = -20; % technical offset to avoid gimble lock
    V1 = Vnorm_array3(cross(M3-M2,M1-M2));
    V2 = repmat([0;0;1],[1,1,n]);
    V3 = cross(V1,V2);
    V4 = Vnorm_array3((M2+M3)/2-M1);
    V5 = cross(V4,V1);
    V6 = -sind(beta)*V4 + cosd(beta)*V5;
    for i = 1:n
        Foot.rota(i) = -(rad2deg(atan2(norm(cross(V6(:,:,i),V3(:,:,i))),...
            dot(V6(:,:,i),V3(:,:,i))))-90+beta);
    end

    % Foot Segment!
    %------------------------------------------------------------
    for i = 2:3
        % Transformation from the proximal segment axes
        % (with origin at endpoint D and with Z = w)
        % to the distal segment axes
        % (with origin at point P and with X = u)
        Segment(i).T = Mprod_array3(Tinv_array3(Q2Tw_array3(Segment(i+1).Q)),...
        Q2Tu_array3(Segment(i).Q));    
        % Euler angles
        Segment(i).Euler = R2mobileZYX_array3(Segment(i).T(1:3,1:3,:));
        % Segment displacement about the Euler angle axes
        Segment(i).dj = Vnop_array3(...
            Segment(i).T(1:3,4,:),... Di+1 to Pi in SCS of segment i+1
            repmat([0;0;1],[1 1 n]),... % Zi+1 in SCS of segment i+1
            cross(Segment(i).T(1:3,2,:),repmat([0;0;1],[1 1 n])),...
            Segment(i).T(1:3,2,:)); % % Yi in SCS of segment i+1
    end

    % =====================================================================
    % Export kinematics parameters
    % =====================================================================
    Kinematics.FootSag = interp1(k,Foot.tilt,ko,'spline');
    Kinematics.FootFro = interp1(k,Foot.rota,ko,'spline');
    Kinematics.FootTra = interp1(k,Foot.obli,ko,'spline');

    Kinematics.MidMetSag = interp1(k,permute(Segment(2).Euler(1,1,:),[3,2,1])*180/pi,ko,'spline');
    Kinematics.MidMetFro = interp1(k,permute(Segment(2).Euler(1,2,:),[3,2,1])*180/pi,ko,'spline');
    Kinematics.MidMetTra = interp1(k,permute(Segment(2).Euler(1,3,:),[3,2,1])*180/pi,ko,'spline');
    Kinematics.MidMetLM  = interp1(k,permute(Segment(2).dj(1,1,:),[3,2,1]),ko,'spline');
    Kinematics.MidMetPD  = interp1(k,permute(Segment(2).dj(2,1,:),[3,2,1]),ko,'spline');
    Kinematics.MidMetAP  = interp1(k,permute(Segment(2).dj(3,1,:),[3,2,1]),ko,'spline');

    Kinematics.CalMidSag = interp1(k,permute(Segment(3).Euler(1,1,:),[3,2,1])*180/pi,ko,'spline');
    Kinematics.CalMidFro = interp1(k,permute(Segment(3).Euler(1,2,:),[3,2,1])*180/pi,ko,'spline');
    Kinematics.CalMidTra = interp1(k,permute(Segment(3).Euler(1,3,:),[3,2,1])*180/pi,ko,'spline');
    Kinematics.CalMidLM  = interp1(k,permute(Segment(3).dj(1,1,:),[3,2,1]),ko,'spline');
    Kinematics.CalMidAP  = interp1(k,permute(Segment(3).dj(2,1,:),[3,2,1]),ko,'spline');
    Kinematics.CalMidPD  = interp1(k,permute(Segment(3).dj(3,1,:),[3,2,1]),ko,'spline');

end
