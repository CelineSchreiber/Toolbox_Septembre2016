% =========================================================================
% REHAZENTER TOOLBOX
% =========================================================================
% File name:    prepareCycleSegmentParameters
% -------------------------------------------------------------------------
% Subject:      Define segments parameters
% -------------------------------------------------------------------------
% Inputs:       - Static (structure)
%               - Markers (structure)
%               - Vmarkers (structure)
%               - Grf (structure)
%               - Gait (structure)
%               - n (int)
%               - side (char)
%               - system (char)
% Outputs:      - Segment (structure)
%               - Markers (structure)
%               - Vmarkers (structure)
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber, A. Naaim
% Date of creation: 26/03/2014
% Version: 1
% -------------------------------------------------------------------------
% Updates: - 
% =========================================================================

function [Segment,Markers,Vmarkers] = prepareCycleSegmentParametersFoot(Session,Markers,side)

% =========================================================================
% Initialisation
% =========================================================================
Segment=[];
    % =====================================================================
    % Transform left limb data into right limb data
    % =====================================================================
    
    if strcmp(side,'Left')
        names = fieldnames(Markers);
        for i = 1:size(names,1)
            eval(['Markers.',names{i},'(3,:,:) = -Markers.',names{i},'(3,:,:);']);
        end
    end

    % =====================================================================
    % Segment parameters using Qualisys system (Leardini markersset)
    % =====================================================================
    if strcmp(side,'Right')

        % Foot parameters
        % -------------------------------------------------------------
        % Foot Markers 
        Segment(2).rM = [Markers.R_FCC,Markers.R_FM1,Markers.R_FM5];
        % Foot axes
        Z2 = Vnorm_array3(Markers.R_FM5-Markers.R_FM1);
        Y2 = Vnorm_array3(Markers.R_FCC-(Markers.R_FM5+Markers.R_FM1)/2);
        X2 = Vnorm_array3(cross(Y2,Z2));
        % Foot parameters
        rP2 = Vmarkers.r_ajc;
        rD2 = (Markers.R_FM5+Markers.R_FM1)/2;
        w2 = Z2;
        u2 = X2;
        Segment(2).Q = [u2;rP2;rD2;w2];

            
    elseif strcmp(side,'Left')

            % Foot parameters
            % -------------------------------------------------------------
            % Foot Markers 
            Segment(2).rM = [Markers.L_FCC,Markers.L_FM1,Markers.L_FM5];
            % Foot axes
            Z2 = Vnorm_array3(Markers.L_FM5-Markers.L_FM1);
            Y2 = Vnorm_array3(Markers.L_FCC-(Markers.L_FM5+Markers.L_FM1)/2);
            X2 = Vnorm_array3(cross(Y2,Z2));
            % Foot parameters
            rP2 = Vmarkers.l_ajc;
            rD2 = (Markers.L_FM5+Markers.L_FM1)/2;
            w2 = Z2;
            u2 = X2;
            Segment(2).Q = [u2;rP2;rD2;w2];

            
    end

end