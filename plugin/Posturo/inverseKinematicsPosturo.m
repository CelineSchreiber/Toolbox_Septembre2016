% =========================================================================
% REHAZENTER TOOLBOX
% =========================================================================
% File name:    inverseKinematicsPosturalangles
% -------------------------------------------------------------------------
% Subject:      Compute postural angles
% -------------------------------------------------------------------------
% Inputs:       - Segment (structure)
%               - Gait (structure)
%               - n (int)
% Outputs:      - Posturalangles (structure)
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber, A. Naaim
% Date of creation: 26/03/2014
% Version: 1
% -------------------------------------------------------------------------
% Updates: - 
% =========================================================================

function Posturalangles = inverseKinematicsPosturo(Segment,n)

% =========================================================================
% Initialisation
% =========================================================================
k = (1:n)';
ko = (linspace(1,n,101))';
s = size(Segment,2);
    
% =====================================================================
% Compute joint angles
% =====================================================================
% Id => Ground/Ground
temp1.R = repmat([-1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1],[1,1,n]);
% Segment i/Ground
for i = 5:s
    Segment(i).R = [Segment(i).X Segment(i).Y Segment(i).Z Segment(i).SCSC;...
        repmat([ 0 0 0 1],[1,1,n])];
    Segment(i).T.ground = Mprod_array3(Tinv_array3(Segment(i).R),temp1.R);
    Segment(i).Euler.ground = R2mobileZXY_array3(Segment(i).T.ground(1:3,1:3,:)); 
end
% Rachis/Pelvis
if s > 5
    Segment(6).T.seg  = Mprod_array3(Tinv_array3(Segment(6).R),Segment(5).R);
end
% Scapular belt/Pelvis
if s > 6
    Segment(7).T.seg  = Mprod_array3(Tinv_array3(Segment(7).R),Segment(5).R);   
end
% Head/Scapular belt
if s > 7
    Segment(8).T.seg  = Mprod_array3(Tinv_array3(Segment(8).R),Segment(7).R);
end
% Euler angles
for i = 6:s
    Segment(i).Euler.seg = R2mobileZXY_array3(Segment(i).T.seg(1:3,1:3,:));
end

% =====================================================================
% Store kinematic variables
% =====================================================================
% Pelvis/Ground
Posturalangles.Pgr_tilt = interp1(k,permute(-Segment(5).Euler.ground(1,1,:),...
    [3,2,1])*180/pi,ko,'spline');
Posturalangles.Pgr_rota = interp1(k,permute(Segment(5).Euler.ground(1,3,:),...
    [3,2,1])*180/pi,ko,'spline');
Posturalangles.Pgr_obli = interp1(k,permute(Segment(5).Euler.ground(1,2,:),...
    [3,2,1])*180/pi,ko,'spline');
if s > 5
    % Rachis/Ground
    Posturalangles.Rgr_tilt = interp1(k,permute(-Segment(6).Euler.ground(1,1,:),...
        [3,2,1])*180/pi,ko,'spline');
    Posturalangles.Rgr_rota = interp1(k,permute(Segment(6).Euler.ground(1,3,:),...
        [3,2,1])*180/pi,ko,'spline');
    Posturalangles.Rgr_obli = interp1(k,permute(Segment(6).Euler.ground(1,2,:),...
        [3,2,1])*180/pi,ko,'spline');
else
    Posturalangles.Rgr_tilt = [];
    Posturalangles.Rgr_rota = [];
    Posturalangles.Rgr_obli = [];
end
if s > 6
    % Scapular belt/Ground
    Posturalangles.Sgr_tilt = interp1(k,permute(-Segment(7).Euler.ground(1,1,:),[3,2,1])*180/pi,ko,'spline');
    Posturalangles.Sgr_rota = interp1(k,permute(Segment(7).Euler.ground(1,3,:),[3,2,1])*180/pi,ko,'spline');
    Posturalangles.Sgr_obli = interp1(k,permute(Segment(7).Euler.ground(1,2,:),[3,2,1])*180/pi,ko,'spline');
    % Scapular belt/Pelvis
    Posturalangles.Sseg_tilt = interp1(k,permute(-Segment(7).Euler.seg(1,1,:),[3,2,1])*180/pi,ko,'spline');
    Posturalangles.Sseg_rota = interp1(k,permute(Segment(7).Euler.seg(1,3,:),[3,2,1])*180/pi,ko,'spline');
    Posturalangles.Sseg_obli = interp1(k,permute(Segment(7).Euler.seg(1,2,:),[3,2,1])*180/pi,ko,'spline');
else
    Posturalangles.Sgr_tilt = [];
    Posturalangles.Sgr_rota = [];
    Posturalangles.Sgr_obli = [];
    Posturalangles.Sseg_tilt = [];
    Posturalangles.Sseg_rota = [];
    Posturalangles.Sseg_obli = [];
end
% Head/Ground
if s > 7
    Posturalangles.Hgr_tilt = interp1(k,permute(-Segment(8).Euler.ground(1,1,:),[3,2,1])*180/pi,ko,'spline');
    Posturalangles.Hgr_rota = interp1(k,permute(Segment(8).Euler.ground(1,3,:),[3,2,1])*180/pi,ko,'spline');
    Posturalangles.Hgr_obli = interp1(k,permute(Segment(8).Euler.ground(1,2,:),[3,2,1])*180/pi,ko,'spline');
    % Head/Scapular belt
    Posturalangles.Hseg_tilt = interp1(k,permute(-Segment(8).Euler.seg(1,1,:),[3,2,1])*180/pi,ko,'spline');
    Posturalangles.Hseg_rota = interp1(k,permute(Segment(8).Euler.seg(1,3,:),[3,2,1])*180/pi,ko,'spline');
    Posturalangles.Hseg_obli = interp1(k,permute(Segment(8).Euler.seg(1,2,:),[3,2,1])*180/pi,ko,'spline');
else
    Posturalangles.Hgr_tilt = [];
    Posturalangles.Hgr_rota = [];
    Posturalangles.Hgr_obli = [];
    Posturalangles.Hseg_tilt = [];
    Posturalangles.Hseg_rota = [];
    Posturalangles.Hseg_obli = [];
end
