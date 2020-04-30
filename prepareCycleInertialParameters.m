% =========================================================================
% REHAZENTER TOOLBOX
% =========================================================================
% File name:    prepareCycleInertialParameters
% -------------------------------------------------------------------------
% Subject:      Define segments inertial parameters
% -------------------------------------------------------------------------
% Inputs:       - Patient (structure)
%               - Session (structure)
%               - Segment (structure)
%               - Gait (structure)
% Outputs:      - Segment (structure)
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber, A. Naaim
% Date of creation: 26/03/2014
% Version: 1
% -------------------------------------------------------------------------
% Updates: - 
% =========================================================================

function Segment = prepareCycleInertialParameters(Patient,Session,Segment)

    % =====================================================================
    % Load the regression table
    % =====================================================================
    if strcmp(Patient.gender,'Homme')
        r_BSIP = dlmread('r_BSIP_Male.csv',';','C2..L17');
    elseif strcmp(Patient.gender,'Femme')
        r_BSIP = dlmread('r_BSIP_Female.csv',';','C2..L17');
    end

    % =====================================================================
    % Apply regression table ratio to the subject segments
    % =====================================================================
    sindex = [13 12 11 10];
    for i = 2:5
        s = sindex(i-1);
        rPi = Segment(i).Q(4:6,:,:);
        rDi = Segment(i).Q(7:9,:,:);
        L(s) = mean(sqrt(sum((rPi-rDi).^2)),3); % length of segment
        Segment(i).m = r_BSIP(s,1)*Session.weight/100;
        Segment(i).rCs = [r_BSIP(s,2)*L(s)/100; ...
            r_BSIP(s,3)*L(s)/100; ...
            r_BSIP(s,4)*L(s)/100];
        Segment(i).Is = [((r_BSIP(s,5)*L(s)/100).^2)*Segment(i).m,...%(r_BSIP(s,1)*Session.weight/100), ...
            ((r_BSIP(s,8)*L(s)/100).^2)*Segment(i).m,...%(r_BSIP(s,1)*Session.weight/100), ...
            ((r_BSIP(s,9)*L(s)/100).^2)*Segment(i).m;...%(r_BSIP(s,1)*Session.weight/100); ...
            ((r_BSIP(s,8)*L(s)/100).^2)*Segment(i).m,...%(r_BSIP(s,1)*Session.weight/100), ...
            ((r_BSIP(s,6)*L(s)/100).^2)*Segment(i).m,...%(r_BSIP(s,1)*Session.weight/100), ...
            ((r_BSIP(s,10)*L(s)/100).^2)*Segment(i).m;...%(r_BSIP(s,1)*Session.weight/100);...
            ((r_BSIP(s,9)*L(s)/100).^2)*Segment(i).m,...%(r_BSIP(s,1)*Session.weight/100),...
            ((r_BSIP(s,10)*L(s)/100).^2)*Segment(i).m,...%(r_BSIP(s,1)*Session.weight/100), ...
            ((r_BSIP(s,7)*L(s)/100).^2)*Segment(i).m];%(r_BSIP(s,1)*Session.weight/100)];
    end