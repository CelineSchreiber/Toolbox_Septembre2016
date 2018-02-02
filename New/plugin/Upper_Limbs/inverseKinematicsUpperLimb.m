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
 
if strcmp(Gait.upperlimbstrial,'yes')
    % =====================================================================
    % Segment angles and displacements
    % =====================================================================

    % Thorax
    %----------------------------------------------------------------------
    Segment(3).T = Q2Tw_array3(Segment(3).Q);
    Segment(3).Euler = R2fixedZYX_array3(Segment(3).T(1:3,1:3,:));%ZYX

    % Humerus Segment vs Thorax!
    %------------------------------------------------------------
    % Transformation from the proximal segment axes
    % (with origin at endpoint D and with Z = w)
    % to the distal segment axes
    % (with origin at point P and with X = u)
    Segment(5).T = Mprod_array3(Tinv_array3(Q2Tw_array3(Segment(5).Q)),...
    Q2Tu_array3(Segment(3).Q));    
    % Euler angles
    Segment(5).Euler = R2mobileXYZ_array3(Segment(5).T(1:3,1:3,:));
    % Segment displacement about the Euler angle axes
    Segment(5).dj = Vnop_array3(...
        Segment(5).T(1:3,4,:),... Di+1 to Pi in SCS of segment i+1
        repmat([0;0;1],[1 1 n]),... % Zi+1 in SCS of segment i+1
        cross(Segment(5).T(1:3,2,:),repmat([0;0;1],[1 1 n])),...
        Segment(5).T(1:3,2,:)); % % Yi in SCS of segment i+1    

    % =====================================================================
    % Export kinematics parameters
    % =====================================================================
    Kinematics.ThoraxSag = interp1(k,permute(Segment(3).Euler(1,1,:),[3,2,1])*180/pi,ko,'spline');
    Kinematics.ThoraxFro = interp1(k,permute(Segment(3).Euler(1,3,:),[3,2,1])*180/pi,ko,'spline');
    Kinematics.ThoraxTra = interp1(k,permute(Segment(3).Euler(1,2,:),[3,2,1])*180/pi,ko,'spline');

    Kinematics.HumThoSag = interp1(k,permute(Segment(5).Euler(1,1,:),[3,2,1])*180/pi,ko,'spline');
    Kinematics.HumThoFro = interp1(k,permute(Segment(5).Euler(1,2,:),[3,2,1])*180/pi,ko,'spline');
    Kinematics.HumThoTra = interp1(k,permute(Segment(5).Euler(1,3,:),[3,2,1])*180/pi,ko,'spline');
    % Kinematics.HumThoLM  = interp1(k,permute(Segment(10).dj(1,1,:),[3,2,1]),ko,'spline');
    % Kinematics.HumThoPD  = interp1(k,permute(Segment(10).dj(2,1,:),[3,2,1]),ko,'spline');
    % Kinematics.HumThoAP  = interp1(k,permute(Segment(10).dj(3,1,:),[3,2,1]),ko,'spline');

end
    
