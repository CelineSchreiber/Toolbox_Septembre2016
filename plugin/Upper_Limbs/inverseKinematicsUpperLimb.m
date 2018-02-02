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

function Kinematics = inverseKinematicsUpperLimb(Segment,Markers,Gait,n,side)

% =========================================================================
% Initialisation
% =========================================================================
k = (1:n)';
ko = (linspace(1,n,101))';
Kinematics.ThoraxSag = [];
Kinematics.ThoraxFro = [];
Kinematics.ThoraxTra = [];
Kinematics.HumThoSag = [];
Kinematics.HumThoFro = [];
Kinematics.HumThoTra = [];
Kinematics.ElbowSag  = [];
Kinematics.ElbowFro  = [];
Kinematics.ElbowTra  = [];

if strcmp(Gait.upperlimbstrial,'yes')
    % =====================================================================
    % Segment angles and displacements
    % =====================================================================
    % Id => Ground/Ground
    temp1.R = repmat([-1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1],[1,1,n]);
    
    % Thorax
    %----------------------------------------------------------------------
%     Segment(2).T = Q2Tw_array3(Segment(2).Q);
%     Segment(2).Euler = R2fixedZYX_array3(Segment(2).T(1:3,1:3,:));%ZYX
    % Segment i/Ground
    Segment(2).R = [Segment(2).X Segment(2).Y Segment(2).Z Segment(2).SCSC;...
        repmat([ 0 0 0 1],[1,1,n])];
    Segment(2).T = Mprod_array3(Tinv_array3(Segment(2).R),temp1.R);
    Segment(2).Euler = R2mobileZXY_array3(Segment(2).T(1:3,1:3,:)); 

    % Humerus vs Clavicle
    %------------------------------------------------------------
    Segment(5).T = Mprod_array3(Tinv_array3(Q2Tw_array3(Segment(5).Q)),...
    Q2Tu_array3(Segment(2).Q));    
    % Euler angles
    Segment(5).Euler = R2mobileXYZ_array3(Segment(5).T(1:3,1:3,:));
    % Segment displacement about the Euler angle axes
    Segment(5).dj = Vnop_array3(...
        Segment(5).T(1:3,4,:),... Di+1 to Pi in SCS of segment i+1
        repmat([0;0;1],[1 1 n]),... % Zi+1 in SCS of segment i+1
        cross(Segment(5).T(1:3,2,:),repmat([0;0;1],[1 1 n])),...
        Segment(5).T(1:3,2,:)); % % Yi in SCS of segment i+1    
    
    % Elbow!
    %------------------------------------------------------------
    % Transformation from the proximal segment axes
    % (with origin at endpoint D and with Z = w)
    % to the distal segment axes
    % (with origin at point P and with X = u)
    Segment(6).T = Mprod_array3(Tinv_array3(Q2Tw_array3(Segment(6).Q)),...
    Q2Tu_array3(Segment(5).Q));    
    % Euler angles
    Segment(6).Euler = R2mobileXYZ_array3(Segment(6).T(1:3,1:3,:));
    % Segment displacement about the Euler angle axes
    Segment(6).dj = Vnop_array3(...
        Segment(6).T(1:3,4,:),... Di+1 to Pi in SCS of segment i+1
        repmat([0;0;1],[1 1 n]),... % Zi+1 in SCS of segment i+1
        cross(Segment(6).T(1:3,2,:),repmat([0;0;1],[1 1 n])),...
        Segment(6).T(1:3,2,:)); % % Yi in SCS of segment i+1    
    
    % =====================================================================
    % Export kinematics parameters
    % =====================================================================
    Kinematics.ThoraxSag = -interp1(k,permute(-Segment(2).Euler(1,1,:),[3,2,1])*180/pi,ko,'spline');
    Kinematics.ThoraxFro = -interp1(k,permute(Segment(2).Euler(1,2,:),[3,2,1])*180/pi,ko,'spline');
    Kinematics.ThoraxTra = interp1(k,permute(Segment(2).Euler(1,3,:),[3,2,1])*180/pi,ko,'spline');

    Kinematics.HumThoFro = interp1(k,permute(-Segment(5).Euler(1,1,:),[3,2,1])*180/pi,ko,'spline');
    Kinematics.HumThoTra = interp1(k,permute(Segment(5).Euler(1,2,:),[3,2,1])*180/pi,ko,'spline');
    Kinematics.HumThoSag = -interp1(k,permute(Segment(5).Euler(1,3,:),[3,2,1])*180/pi,ko,'spline');
    
    Kinematics.ElbowFro = interp1(k,permute(-Segment(6).Euler(1,1,:),[3,2,1])*180/pi,ko,'spline');
    Kinematics.ElbowTra = -interp1(k,permute(Segment(6).Euler(1,2,:),[3,2,1])*180/pi,ko,'spline');
    Kinematics.ElbowSag = interp1(k,permute(Segment(6).Euler(1,3,:),[3,2,1])*180/pi,ko,'spline');
end
    
