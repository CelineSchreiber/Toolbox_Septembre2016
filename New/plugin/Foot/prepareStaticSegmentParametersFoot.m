% =========================================================================
% REHAZENTER TOOLBOX
% =========================================================================
% File name:    prepareStaticSegmentParameters
% -------------------------------------------------------------------------
% Subject:      Define segments parameters
% -------------------------------------------------------------------------
% Inputs:       - Patient (structure)
%               - Session (structure)
%               - Markers (structure)
%               - side (char)
%               - system (char)
% Outputs:      - Static (structure)
%               - Markers (structure)
%               - Vmarkers (structure)
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber, A. Naaim
% Date of creation: 26/03/2014
% Version: 1
% -------------------------------------------------------------------------
% Updates: - 09/12/2014: Introduce right/left_leg_length in Session
% =========================================================================

function [Segment,Markers,Vmarkers] = prepareSegmentParametersFoot(Session,Markers,side)

% =========================================================================
% Initialisation
% =========================================================================
Segment=[];

% =========================================================================
% Transform left foot data into right foot data
% =========================================================================
if strcmp(side,'Left')
    names = fieldnames(Markers);
    for i = 1:size(names,1)
        eval(['Markers.',names{i},'(2,:,:) = -Markers.',names{i},'(2,:,:);']);
    end
end

% =========================================================================
% Segment parameters using Leardini markersset & Qualisys system
% =========================================================================
if strcmp(side,'Right')
    
    if strcmp(Session.footmarkersset,'Leardini foot model')
        
        % Calca parameters
        % -----------------------------------------------------------------
        Segment(3).rM = [Markers.R_CAL,Markers.R_CAM,Markers.R_FCC];
        % Calca joint center
        Vmarkers.r_cjc_static = (Markers.R_CAL+Markers.R_CAM)/2;
        % Calca axes
        Z3 =Vnorm_array3(Markers.R_CAL-Vmarkers.r_cjc_static);
        Y3 =Vnorm_array3(Markers.R_FCC-Vmarkers.r_cjc_static);
        X3 =Vnorm_array3(cross(Y3,Z3));
        Z3 =Vnorm_array3(cross(X3,Y3)); %???
        % Z perpendiculaire?
        % Calca parameters
        rP3 = Markers.R_FCC;
        rD3 = Vmarkers.r_cjc_static;
        w3 = Z3;
        u3 = X3;
        Segment(3).Q = [u3;rP3;rD3;w3];

        % MidFoot parameters
        % -----------------------------------------------------------------
        Segment(2).rM = [Markers.R_FNT,Markers.R_FMT2,Markers.R_FMT5];
        % MidFoot joint center
        Vmarkers.r_mjc_static = (Markers.R_FNT+Markers.R_FMT5)/2;
        % MidFoot axes
        Z2 =Vnorm_array3(Vmarkers.r_mjc_static-Markers.R_FNT);
        Y2 =Vnorm_array3(Vmarkers.r_mjc_static-Markers.R_FMT2);
        X2 =Vnorm_array3(cross(Y2,Z2));
        Z2 =Vnorm_array3(cross(X2,Y2)); %???
        % MidFoot parameters
        rP2 = Vmarkers.r_mjc_static; 
        rD2 = Markers.R_FMT2; 
        w2 = Z2;
        u2 = X2;
        Segment(2).Q = [u2;rP2;rD2;w2];

        % ForeFoot parameters
        % -----------------------------------------------------------------
        Segment(1).rM = [Markers.R_FM1,Markers.R_FM5,Markers.R_FMT2];
        % MidFoot axes
        Z1 =Vnorm_array3(Markers.R_FM5-Markers.R_FM1); 
        Y1 =Vnorm_array3(Markers.R_FM2-Markers.R_FMT2);
        X1 =Vnorm_array3(cross(Y1,Z1));
        Z1 =Vnorm_array3(cross(X1,Y1));
        % ForeFoot parameters
        rP1 = Markers.R_FMT2; 
        rD1 = Markers.R_FM2;
        w1 = Z1;
        u1 = X1;
        Segment(1).Q = [u1;rP1;rD1;w1];
    
    else
        
    end

elseif strcmp(side,'Left')

        
end
    
    for i = 1:size(Segment,2)
        Segment(i).T = Q2Tuv_array3(Segment(i).Q);
    end
    
end