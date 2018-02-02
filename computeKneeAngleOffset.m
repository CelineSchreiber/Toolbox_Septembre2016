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

function Static = computeKneeAngleOffset(Static,Markers,side,system)

% =========================================================================
% Compute angle between [Heel Met] and [Mall Met]
% =========================================================================
Static(2).T = Mprod_array3(Tinv_array3(Q2Tw_array3(Static(3).Q)),...
        Q2Tu_array3(Static(2).Q));    
    Static(2).Euler = R2mobileZXY_array3(Static(2).T(1:3,1:3,:));
    Static(2).offset = permute(Static(2).Euler(1,1,:),[3,2,1])*180/pi;
    
Static(3).T = Mprod_array3(Tinv_array3(Q2Tw_array3(Static(4).Q)),...
    Q2Tu_array3(Static(3).Q));    
Static(3).Euler = R2mobileZXY_array3(Static(3).T(1:3,1:3,:));
Static(3).offset = permute(Static(3).Euler(1,1,:),[3,2,1])*180/pi;
Static(3).offset
