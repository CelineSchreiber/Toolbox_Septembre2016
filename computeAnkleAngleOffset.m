% =========================================================================
% REHAZENTER TOOLBOX
% =========================================================================
% File name:    computeAnkleAngleOffset
% -------------------------------------------------------------------------
% Subject:      Compute angle offset and ankle joint
% -------------------------------------------------------------------------
% Inputs:       - Static (structure)
%               - Markers (structure)
%               - Vmarkers (structure)
%               - side (char)
%               - system (char)
% Outputs:      - Static (structure)
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber, A. Naaim
% Date of creation: 26/03/2014
% Version: 1
% -------------------------------------------------------------------------
% Updates: 
% =========================================================================

function Static = computeAnkleAngleOffset(Static,Markers,side,system)

% =========================================================================
% Compute angle between [Heel Met] and [Mall Met]
% =========================================================================
if strcmp(system,'BTS')    
    if strcmp(side,'Right')
        vec1 = permute([Markers.r_mall(1,:,:);...
            Markers.r_mall(2,:,:);...
            Markers.r_met(3,:,:)] - Markers.r_met,[3,1,2]);
        vec2 = permute(Markers.r_mall - Markers.r_met,[3,1,2]);
        theta1 = atan2(norm(cross(vec1,vec2)), dot(vec1,vec2))*180/pi;
    elseif strcmp(side,'Left')
        vec1 = permute([Markers.l_mall(1,:,:);...
            Markers.l_mall(2,:,:);...
            Markers.l_met(3,:,:)] - Markers.l_met,[3,1,2]);
        vec2 = permute(Markers.l_mall - Markers.l_met,[3,1,2]);
        theta1 = atan2(norm(cross(vec1,vec2)), dot(vec1,vec2))*180/pi;
    end
    Static(2).offset = 90-theta1;    
elseif strcmp(system,'Qualisys')    
    Static(2).offset = 90;   
%     Static(2).T = Mprod_array3(Tinv_array3(Q2Tw_array3(Static(3).Q)),...
%         Q2Tu_array3(Static(2).Q));    
%     Static(2).Euler = R2mobileZXY_array3(Static(2).T(1:3,1:3,:));
%     Static(2).offset = permute(Static(2).Euler(1,1,:),[3,2,1])*180/pi;
end
Static(3).offset =0;