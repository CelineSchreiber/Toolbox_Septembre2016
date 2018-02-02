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

function [Segment,Markers,Vmarkers] = prepareSegmentParametersFoot(Session,Markers,Gait,side)

% =========================================================================
% Initialisation
% =========================================================================
Segment=[];
Vmarkers=[];

if strcmp(Gait.foottrial,'yes')
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
            Segment(4).rM = [Markers.R_FPT,Markers.R_FST,Markers.R_FCC];
            % Calca joint center
            Vmarkers.r_cjc = (Markers.R_FPT+Markers.R_FST)/2;
            % Calca axes
            Z4 =Vnorm_array3(Markers.R_FPT-Vmarkers.r_cjc);
            Y4 =Vnorm_array3(Markers.R_FCC-Vmarkers.r_cjc);
            X4 =Vnorm_array3(cross(Y4,Z4));
            Z4 =Vnorm_array3(cross(X4,Y4)); %???
            % Z perpendiculaire?
            % Calca parameters
            rP4 = Markers.R_FCC;
            rD4 = Vmarkers.r_cjc;
            w4 = Z4;
            u4 = X4;
            Segment(4).Q = [u4;rP4;rD4;w4];

            % MidFoot parameters
            % -----------------------------------------------------------------
            Segment(3).rM = [Markers.R_FNT,Markers.R_FMT2,Markers.R_FMT5];
            % MidFoot joint center
            Vmarkers.r_mjc = (Markers.R_FNT+Markers.R_FMT5)/2;
            % MidFoot axes
            Z3 =Vnorm_array3(Vmarkers.r_mjc-Markers.R_FNT);
            Y3 =Vnorm_array3(Vmarkers.r_mjc-Markers.R_FMT2);
            X3 =Vnorm_array3(cross(Y3,Z3));
            Z3 =Vnorm_array3(cross(X3,Y3)); %???
            % MidFoot parameters
            rP3 = Vmarkers.r_mjc; 
            rD3 = Markers.R_FMT2; 
            w3 = Z3;
            u3 = X3;
            Segment(3).Q = [u3;rP3;rD3;w3];

            % ForeFoot parameters
            % -----------------------------------------------------------------
            Segment(2).rM = [Markers.R_FM1,Markers.R_FM5,Markers.R_FMT2];
            % MidFoot axes
            Z2 =Vnorm_array3(Markers.R_FM5-Markers.R_FM1); 
            Y2 =Vnorm_array3(Markers.R_FM2-Markers.R_FMT2);
            X2 =Vnorm_array3(cross(Y2,Z2));
            Z2 =Vnorm_array3(cross(X2,Y2));
            % ForeFoot parameters
            rP2 = Markers.R_FMT2; 
            rD2 = Markers.R_FM2;
            w2 = Z2;
            u2 = X2;
            Segment(2).Q = [u2;rP2;rD2;w2];

            % Global Foot parameters
            % -----------------------------------------------------------------
            Vmarkers.r_ajc=(Markers.R_FAL+Markers.R_TAM)/2;
            % Foot Markers 
            Segment(1).rM = [Markers.R_FCC,Markers.R_FM1,Markers.R_FM5];
            % Foot axes
            Z1 = Vnorm_array3(Markers.R_FM5-Markers.R_FM1); 
            Y1 = Vnorm_array3((Markers.R_FM5+Markers.R_FM1)/2-Markers.R_FCC);
            X1 = Vnorm_array3(cross(Y1,Z1));
            % Foot parameters
            rP1 = Vmarkers.r_ajc;
            rD1 = (Markers.R_FM5 + Markers.R_FM1)/2;
            w1 = Z1;
            u1 = X1;
            Segment(1).Q = [u1;rP1;rD1;w1];

        end

    elseif strcmp(side,'Left')

        if strcmp(Session.footmarkersset,'Leardini foot model')

            % Calca parameters
            % -----------------------------------------------------------------
            Segment(4).rM = [Markers.L_FPT,Markers.L_FST,Markers.L_FCC];
            % Calca joint center
            Vmarkers.l_cjc = (Markers.L_FPT+Markers.L_FST)/2;
            % Calca axes
            Z4 =Vnorm_array3(Markers.L_FPT-Vmarkers.l_cjc);
            Y4 =Vnorm_array3(Markers.L_FCC-Vmarkers.l_cjc);
            X4 =Vnorm_array3(cross(Y4,Z4));
            Z4 =Vnorm_array3(cross(X4,Y4)); %???
            % Z perpendiculaire?
            % Calca parameters
            rP4 = Markers.L_FCC;
            rD4 = Vmarkers.l_cjc;
            w4 = Z4;
            u4 = X4;
            Segment(4).Q = [u4;rP4;rD4;w4];

            % MidFoot parameters
            % -----------------------------------------------------------------
            Segment(3).rM = [Markers.L_FNT,Markers.L_FMT2,Markers.L_FMT5];
            % MidFoot joint center
            Vmarkers.l_mjc = (Markers.L_FNT+Markers.L_FMT5)/2;
            % MidFoot axes
            Z3 =Vnorm_array3(Vmarkers.l_mjc-Markers.L_FNT);
            Y3 =Vnorm_array3(Vmarkers.l_mjc-Markers.L_FMT2);
            X3 =Vnorm_array3(cross(Y3,Z3));
            Z3 =Vnorm_array3(cross(X3,Y3)); %???
            % MidFoot parameters
            rP3 = Vmarkers.l_mjc; 
            rD3 = Markers.L_FMT2; 
            w3 = Z3;
            u3 = X3;
            Segment(3).Q = [u3;rP3;rD3;w3];

            % ForeFoot parameters
            % -----------------------------------------------------------------
            Segment(2).rM = [Markers.L_FM1,Markers.L_FM5,Markers.L_FMT2];
            % MidFoot axes
            Z2 =Vnorm_array3(Markers.L_FM5-Markers.L_FM1); 
            Y2 =Vnorm_array3(Markers.L_FM2-Markers.L_FMT2);
            X2 =Vnorm_array3(cross(Y2,Z2));
            Z2 =Vnorm_array3(cross(X2,Y2));
            % ForeFoot parameters
            rP2 = Markers.L_FMT2; 
            rD2 = Markers.L_FM2;
            w2 = Z2;
            u2 = X2;
            Segment(2).Q = [u2;rP2;rD2;w2];
        
            % Global Foot parameters
            % -----------------------------------------------------------------
            Vmarkers.l_ajc=(Markers.L_FAL+Markers.L_TAM)/2;
            % Foot Markers 
            Segment(1).rM = [Markers.L_FCC,Markers.L_FM1,Markers.L_FM5];
            % Foot axes
            Z1 = Vnorm_array3(Markers.L_FM5-Markers.L_FM1); 
            Y1 = Vnorm_array3((Markers.L_FM5+Markers.L_FM1)/2-Markers.L_FCC);
            X1 = Vnorm_array3(cross(Y1,Z1));
            % Foot parameters
            rP1 = Vmarkers.l_ajc;
            rD1 = (Markers.L_FM5 + Markers.L_FM1)/2;
            w1 = Z1;
            u1 = X1;
            Segment(1).Q = [u1;rP1;rD1;w1];
        
        end
        
    end 
    
end