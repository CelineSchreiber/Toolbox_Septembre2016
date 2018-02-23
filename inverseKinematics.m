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

function Kinematics = inverseKinematics(Static,Segment,Markers,Vmarkers,Events,n,side,system)

% =========================================================================
% Initialisation
% =========================================================================
% Kinematics = [];
k = (1:n)';
ko = (linspace(1,n,101))';
Kinematics.Pobli = [];
Kinematics.Prota = [];
Kinematics.Ptilt = [];
Kinematics.Fobli = [];
Kinematics.Frota = [];
Kinematics.Ftilt = [];
Kinematics.Clearance = [];
Kinematics.FE2 = [];
Kinematics.IER2 = [];
Kinematics.AA2 = [];
Kinematics.LM2 = [];
Kinematics.PD2 = [];
Kinematics.AP2 = [];
Kinematics.FE3 = [];
Kinematics.AA3 = [];
Kinematics.IER3 = [];
Kinematics.LM3 = [];
Kinematics.AP3 = [];
Kinematics.PD3 = [];
Kinematics.FE4 = [];
Kinematics.AA4 = [];
Kinematics.IER4 = [];
Kinematics.LM4 = [];
Kinematics.AP4 = [];
Kinematics.PD4 = [];

% =====================================================================
% Segment angles and displacements
% =====================================================================

for i = 2:4 % From i = 2 ankle to i = 4 hip    
    % Transformation from the proximal segment axes
    % (with origin at endpoint D and with Z = w)
    % to the distal segment axes
    % (with origin at point P and with X = u)
    Segment(i).T = Mprod_array3(Tinv_array3(Q2Tw_array3(Segment(i+1).Q)),...
        Q2Tu_array3(Segment(i).Q));    
    if i == 4 % Special case for i = 4 thigh (or arm)        
        % Origin of proximal segment at mean position of Pi
        % in proximal segment (rather than endpoint Di+1)
        Segment(4).T(1:3,4,:) = Segment(4).T(1:3,4,:) - ...
            repmat(mean(Segment(4).T(1:3,4,:),3),[1 1 n]);            
    end    
    if i == 2 % ZYX sequence of mobile axis
        % Segment coordinate system for ankle (or wrist):
        % Internal/extenal rotation on floating axis
        % Euler angles
        Segment(i).Euler = R2mobileZYX_array3(Segment(i).T(1:3,1:3,:));
        % Segment displacement about the Euler angle axes
        Segment(i).dj = Vnop_array3(...
            Segment(i).T(1:3,4,:),... Di+1 to Pi in SCS of segment i+1
            repmat([0;0;1],[1 1 n]),... % Zi+1 in SCS of segment i+1
            cross(Segment(i).T(1:3,1,:),repmat([0;0;1],[1 1 n])),...
            Segment(i).T(1:3,1,:)); % % Xi in SCS of segment i+1
    else % ZXY sequence of mobile axis
        % Euler angles
        Segment(i).Euler = R2mobileZXY_array3(Segment(i).T(1:3,1:3,:));
        % Segment displacement about the Euler angle axes
        Segment(i).dj = Vnop_array3(...
            Segment(i).T(1:3,4,:),... Di+1 to Pi in SCS of segment i+1
            repmat([0;0;1],[1 1 n]),... % Zi+1 in SCS of segment i+1
            cross(Segment(i).T(1:3,2,:),repmat([0;0;1],[1 1 n])),...
            Segment(i).T(1:3,2,:)); % % Yi in SCS of segment i+1
    end
end

% =====================================================================
% Pelvis orientation
% =====================================================================
Pelvis.T = Q2Tw_array3(Segment(5).Q);
Pelvis.Euler = R2fixedZYX_array3(Pelvis.T(1:3,1:3,:));

% =====================================================================
% Foot orientation - Tilt and progression angle (rotation)
% Validate for a potential PA between 70 IntRot to 110 ExtRot
% =====================================================================
if strcmp(system,'BTS')
    % Tilt        
    Foot.T = Q2Tw_array3(Segment(2).Q);
    Foot.Euler = R2fixedZYX_array3(Foot.T(1:3,1:3,:));
    Foot.tilt = permute(Foot.Euler(:,1,:),[3,2,1])*180/pi-90 + ...
        (90-Static(2).offset);
%         if strcmp(side,'Left')
%             Foot.tilt(1:Events.CHS) = Foot.tilt(Events.CHS);  %ZZZ
%         end
%         Foot.tilt = Foot.tilt - 3.4;
    % Progression angle (rotation)
    if strcmp(side,'Right')
        M1 = Vmarkers.r_ajc;
        M2 = Markers.r_mall;
        M3 = Markers.r_met;
    elseif strcmp(side,'Left')
        M1 = Vmarkers.l_ajc;
        M2 = Markers.l_mall;
        M3 = Markers.l_met;
    end
    beta = -20; % technical offset to avoid gimble lock
    V1 = Vnorm_array3(cross(M2-M1,M3-M1));
    V2 = repmat([0;0;1],[1,1,n]);
    V3 = cross(V1,V2);
    V4 = Vnorm_array3(M3-M2);
    V5 = cross(V4,V1);
    V6 = -sind(beta)*V4 + cosd(beta)*V5;
    for i = 1:n
        Foot.rota(i) = -(rad2deg(atan2(norm(cross(V6(:,:,i),V3(:,:,i))),...
            dot(V6(:,:,i),V3(:,:,i))))-90-beta);
    end
    % Obliquity 
    Foot.obli = [];
elseif strcmp(system,'Qualisys')
    % Tilt        
    Foot.T = Q2Tw_array3(Segment(2).Q);
    Foot.Euler = R2fixedZYX_array3(Foot.T(1:3,1:3,:));
    Foot.tilt = permute(Foot.Euler(:,1,:),[3,2,1])*180/pi-90;
    % Obliquity        
    Foot.obli = -permute(Foot.Euler(:,3,:),[3,2,1])*180/pi;
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
end

% =====================================================================
% Clearance (height of the 5th foot metatarsal)
% =====================================================================
if strcmp(system,'BTS')
    if strcmp(side,'Right')
        met = permute(Markers.r_met,[3,1,2]);
        Clearance = met(:,2);
        Clearance = Clearance - min(Clearance);
    elseif strcmp(side,'Left')
        met = permute(Markers.l_met,[3,1,2]);
        Clearance = met(:,2);
        Clearance = Clearance - Clearance(Events.CHS);
    end
elseif strcmp(system,'Qualisys')
    if strcmp(side,'Right')
        met = permute(Markers.R_FM5,[3,1,2]);
        Clearance = met(:,2);
%         Clearance = Clearance - min(Clearance);
    elseif strcmp(side,'Left')
        met = permute(Markers.L_FM5,[3,1,2]);
        Clearance = met(:,2);
%         Clearance = Clearance - min(Clearance);
    end
end

% =====================================================================
% Export kinematics parameters
% =====================================================================
% Pelvis
Kinematics.Ptilt = interp1(k,permute(Pelvis.Euler(1,1,:),[3,2,1])*180/pi,ko,'spline');
Kinematics.Prota = interp1(k,permute(Pelvis.Euler(1,2,:),[3,2,1])*180/pi,ko,'spline');
Kinematics.Pobli = interp1(k,permute(Pelvis.Euler(1,3,:),[3,2,1])*180/pi,ko,'spline');
% Foot
if strcmp(system,'BTS')
    Kinematics.Ftilt = interp1(k,Foot.tilt,ko,'spline');
    Kinematics.Frota = interp1(k,Foot.rota,ko,'spline');
    Kinematics.Fobli = [];    
elseif strcmp(system,'Qualisys')
    Kinematics.Ftilt = interp1(k,Foot.tilt,ko,'spline');
    Kinematics.Frota = interp1(k,Foot.rota,ko,'spline');
    Kinematics.Fobli = interp1(k,Foot.obli,ko,'spline');
end
% Foot clearance
Kinematics.Clearance = interp1(k,Clearance,ko,'spline');
% Ankle (or wrist) Segment angles and displacements
Kinematics.FE2 = interp1(k,permute(Segment(2).Euler(1,1,:),[3,2,1])*180/pi,ko,'spline') - ...
    Static(2).offset;
if strcmp(system,'BTS')
    Kinematics.AA2 = [];
    Kinematics.IER2 = [];
    Kinematics.LM2 = [];
    Kinematics.PD2 = [];
    Kinematics.AP2 = [];
elseif strcmp(system,'Qualisys')
    Kinematics.AA2 = interp1(k,permute(Segment(2).Euler(1,2,:),[3,2,1])*180/pi,ko,'spline');
    Kinematics.IER2 = interp1(k,permute(Segment(2).Euler(1,3,:),[3,2,1])*180/pi,ko,'spline');
    Kinematics.LM2 = interp1(k,permute(Segment(2).dj(1,1,:),[3,2,1]),ko,'spline');
    Kinematics.PD2 = interp1(k,permute(Segment(2).dj(2,1,:),[3,2,1]),ko,'spline');
    Kinematics.AP2 = interp1(k,permute(Segment(2).dj(3,1,:),[3,2,1]),ko,'spline');
end
% Knee (or elbow) Segment angles and displacements
Kinematics.FE3 = interp1(k,permute(Segment(3).Euler(1,1,:),[3,2,1])*180/pi,ko,'spline')-Static(3).offset;
Kinematics.AA3 = interp1(k,permute(Segment(3).Euler(1,2,:),[3,2,1])*180/pi,ko,'spline');
Kinematics.IER3 = interp1(k,permute(Segment(3).Euler(1,3,:),[3,2,1])*180/pi,ko,'spline');
Kinematics.LM3 = interp1(k,permute(Segment(3).dj(1,1,:),[3,2,1]),ko,'spline');
Kinematics.AP3 = interp1(k,permute(Segment(3).dj(2,1,:),[3,2,1]),ko,'spline');
Kinematics.PD3 = interp1(k,permute(Segment(3).dj(3,1,:),[3,2,1]),ko,'spline');
% Hip (or shoulder) Segment angles and displacements
Kinematics.FE4 = interp1(k,permute(Segment(4).Euler(1,1,:),[3,2,1])*180/pi,ko,'spline');
Kinematics.AA4 = interp1(k,permute(Segment(4).Euler(1,2,:),[3,2,1])*180/pi,ko,'spline');
Kinematics.IER4 = interp1(k,permute(Segment(4).Euler(1,3,:),[3,2,1])*180/pi,ko,'spline');
Kinematics.LM4 = interp1(k,permute(Segment(4).dj(1,1,:),[3,2,1]),ko,'spline');
Kinematics.AP4 = interp1(k,permute(Segment(4).dj(2,1,:),[3,2,1]),ko,'spline');
Kinematics.PD4 = interp1(k,permute(Segment(4).dj(3,1,:),[3,2,1]),ko,'spline');  