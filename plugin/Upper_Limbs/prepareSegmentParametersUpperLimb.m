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

function [Segment,Markers,Vmarkers] = prepareSegmentParametersUpperLimb(Markers,Gait,n,side)

% =========================================================================
% Initialisation
% =========================================================================
Segment = [];
Vmarkers = [];

if strcmp(Gait.upperlimbstrial,'yes')
    
    % =========================================================================
    % Transform left arm data into right arm data
    % =========================================================================
    if strcmp(side,'Left')
        names = fieldnames(Markers);
        for i = 1:size(names,1)
            Markers.(names{i})(3,:,:) = -Markers.(names{i})(3,:,:);
        end
    end
    
    if strcmp(side,'Right')

         if isfield(Markers,'SJN') && isfield(Markers,'TV10') && isfield(Markers,'SXS')

            % Thorax parameters
            % -----------------------------------------------------------------
            Segment(2).rM = [Markers.CV7,Markers.SJN,Markers.TV10];
            % Thorax joint center
            Vmarkers.r_tjc = Markers.SJN;
            % Thorax axes
            Segment(2).Y = Vnorm_array3((Markers.CV7+Markers.SJN)/2-(Markers.TV10+Markers.SXS)/2);
            X            = Vnorm_array3((Markers.SJN-Markers.CV7)/2);
            Segment(2).Z = Vnorm_array3(cross(X,Segment(2).Y));
            Segment(2).X = Vnorm_array3(cross(Segment(2).Y,Segment(2).Z));
            Segment(2).SCSC = Markers.SJN;
            % Thorax parameters
            rP2 = (Markers.TV10+Markers.SXS)/2;
            rD2 = (Markers.CV7+Markers.SJN)/2;
            w2 = Segment(2).Z;
            u2 = Segment(2).X;
            Segment(2).Q = [u2;rP2;rD2;w2];
         end
         
         if isfield(Markers,'R_SAE') && isfield(Markers,'SJN')

            % Clavicle parameters
            % -----------------------------------------------------------------
            Segment(3).rM = [Markers.R_SAE,Markers.SJN];
            % Scapula joint center
            Vmarkers.r_sjc = Markers.R_SAE;
            Segment(2).SCSC = Markers.R_SAE;
            % Scapula axes
            Z3 =Vnorm_array3(Markers.SJN-Markers.R_SAE);
            X3 =Vnorm_array3(cross(Segment(2).Y,Z3));
            Y3 =Vnorm_array3(cross(Z3,X3));
            % Scapula parameters
            rP3 = Markers.SJN; 
            rD3 = Markers.R_SAE; 
            w3 = Z3;
            u3 = X3;
            Segment(3).Q = [u3;rP3;rD3;w3];
         end
         
         if isfield(Markers,'R_SAA') && isfield(Markers,'R_SRS') && isfield(Markers,'R_SIA')

            % Scapula parameters
            % -----------------------------------------------------------------
            Segment(4).rM = [Markers.R_SAA,Markers.R_SRS,Markers.R_SIA];
            % Scapula joint center
            Vmarkers.r_sjc = Markers.R_SAA;
            % Scapula axes
            Z4 =Vnorm_array3(Markers.R_SRS-Markers.R_SAA);
            Y  =Vnorm_array3(Markers.R_SIA-Markers.R_SRS);
            X4 =Vnorm_array3(cross(Y,Z4));
    %         Y4 =Vnorm_array3(cross(Z4,X4));
            % Scapula parameters
            rP4 = Markers.R_SIA; 
            rD4 = Markers.R_SRS; 
            w4 = Z4;
            u4 = X4;
            Segment(4).Q = [u4;rP4;rD4;w4];
        end

        if isfield(Markers,'R_HLE') && isfield(Markers,'R_HME') && isfield(Markers,'R_UHE') && isfield(Markers,'R_RSP')

            % Forearm parameters
            % -----------------------------------------------------------------
            Vmarkers.r_fjc=(Markers.R_RSP+Markers.R_UHE)/2;
            Segment(6).SCSC = (Markers.R_RSP+Markers.R_UHE)/2;
            % Forearm Markers 
            Segment(6).rM = [Markers.R_RSP,Markers.R_UHE,Markers.R_UOA];
            % Forearm axes
            Y6 = Vnorm_array3(Markers.R_UOA-(Markers.R_RSP+Markers.R_UHE)/2);
            Z  = Vnorm_array3(Markers.R_UHE-Markers.R_RSP); 
            X6 = Vnorm_array3(cross(Y6,Z));
            Z6 = Vnorm_array3(cross(X6,Y6));
            % Forearm parameters
            rP6 = Markers.R_UOA;
            rD6 = (Markers.R_UHE + Markers.R_RSP)/2;
            w6 = Z6;
            u6 = X6;
            Segment(6).Q = [u6;rP6;rD6;w6];
        end
        
        if isfield(Markers,'R_HLE') && isfield(Markers,'R_HME') && isfield(Markers,'R_SAE')

            % Humerus parameters
            % -----------------------------------------------------------------
            Segment(5).rM = [Markers.R_SAE,Markers.R_HLE,Markers.R_HME];
            % Humerus joint center
            Vmarkers.r_hjc = Markers.R_SAE;% Humerus axes
            Segment(5).SCSC = Markers.R_SAE;
            Y5 =Vnorm_array3(Markers.R_SAE-(Markers.R_HLE+Markers.R_HME)/2);
            Z5 =Vnorm_array3(cross(Y5,Y6)); 
            X5 =Vnorm_array3(cross(Y5,Z5));
            % Humerus parameters
            rP5 = Markers.R_SAE; 
            rD5 = (Markers.R_HLE+Markers.R_HME)/2;
            w5 = Z5;
            u5 = X5;
            Segment(5).Q = [u5;rP5;rD5;w5];
        end

        

    elseif strcmp(side,'Left')

        if isfield(Markers,'SJN') && isfield(Markers,'TV10') && isfield(Markers,'SXS')

            % Thorax parameters
            % -----------------------------------------------------------------
            Segment(2).rM = [Markers.CV7,Markers.SJN,Markers.TV10];
            % Thorax joint center
            Vmarkers.l_tjc = Markers.SJN;
            % Thorax axes
            Segment(2).Y = Vnorm_array3((Markers.CV7+Markers.SJN)/2-(Markers.TV10+Markers.SXS)/2);
            X            = Vnorm_array3((Markers.SJN-Markers.CV7)/2);
            Segment(2).Z = Vnorm_array3(cross(X,Segment(2).Y));
            Segment(2).X = Vnorm_array3(cross(Segment(2).Y,Segment(2).Z));
            Segment(2).SCSC = Markers.SJN;
            % Thorax parameters
            rP2 = (Markers.TV10+Markers.SXS)/2;
            rD2 = (Markers.CV7+Markers.SJN)/2;
            w2 = Segment(2).Z;
            u2 = Segment(2).X;
            Segment(2).Q = [u2;rP2;rD2;w2];
            
        end
        
        if isfield(Markers,'R_SAE') && isfield(Markers,'SJN')

            % Clavicle parameters
            % -----------------------------------------------------------------
            Segment(3).rM = [Markers.L_SAE,Markers.SJN];
            % Scapula joint center
            Vmarkers.r_sjc = Markers.L_SAE;
            Segment(2).SCSC = Markers.L_SAE;
            % Scapula axes
            Z3 =Vnorm_array3(Markers.SJN-Markers.L_SAE);
            X3 =Vnorm_array3(cross(Segment(2).Y,Z3));
            Y3 =Vnorm_array3(cross(Z3,X3));
            % Scapula parameters
            rP3 = Markers.SJN; 
            rD3 = Markers.R_SAE; 
            w3 = Z3;
            u3 = X3;
            Segment(3).Q = [u3;rP3;rD3;w3];
         end
        if isfield(Markers,'L_SAA') && isfield(Markers,'L_SRS') && isfield(Markers,'L_SIA')

            % Scapula parameters
            % -----------------------------------------------------------------
            Segment(4).rM = [Markers.L_SAA,Markers.L_SRS,Markers.L_SIA];
            % Scapula joint center
            Vmarkers.l_sjc = Markers.L_SAA;
            % Scapula axes
            Z4 =Vnorm_array3(Markers.L_SRS-Markers.L_SAA);
            Y  =Vnorm_array3(Markers.L_SIA-Markers.L_SRS);
            X4 =Vnorm_array3(cross(Y,Z4));
    %         Y4 =Vnorm_array3(cross(Z4,X4));
            % Scapula parameters
            rP4 = Markers.L_SIA; 
            rD4 = Markers.L_SRS; 
            w4 = Z4;
            u4 = X4;
            Segment(4).Q = [u4;rP4;rD4;w4];
        end

        if isfield(Markers,'L_HLE') && isfield(Markers,'L_HME') && isfield(Markers,'L_UHE') && isfield(Markers,'L_RSP')

            % Forearm parameters
            % -----------------------------------------------------------------
            Vmarkers.l_fjc=(Markers.L_RSP+Markers.L_UHE)/2;
            Segment(6).SCSC = (Markers.L_RSP+Markers.L_UHE)/2;
            % Forearm Markers 
            Segment(6).rM = [Markers.L_RSP,Markers.L_UHE,Markers.L_UOA];
            % Forearm axes
            Y6 = Vnorm_array3(Markers.L_UOA-(Markers.L_RSP+Markers.L_UHE)/2);
            Z  = Vnorm_array3(Markers.L_UHE-Markers.L_RSP); 
            X6 = Vnorm_array3(cross(Y6,Z));
            Z6 = Vnorm_array3(cross(X6,Y6));
            % Forearm parameters
            rP6 = Markers.L_UOA;
            rD6 = (Markers.L_UHE + Markers.L_RSP)/2;
            w6 = Z6;
            u6 = X6;
            Segment(6).Q = [u6;rP6;rD6;w6];
        end
        
        if isfield(Markers,'L_HLE') && isfield(Markers,'L_HME') && isfield(Markers,'L_SAE')

            % Humerus parameters
            % -----------------------------------------------------------------
            Segment(5).rM = [Markers.L_SAE,Markers.L_HLE,Markers.L_HME];
            % Humerus joint center
            Vmarkers.l_hjc = Markers.L_SAE;
            Segment(5).SCSC = Markers.L_SAE;
            % Humerus axes
            Y5 =Vnorm_array3(Markers.L_SAE-(Markers.L_HLE+Markers.L_HME)/2);
            Z5 =Vnorm_array3(cross(Y5,Y6)); 
            X5 =Vnorm_array3(cross(Y5,Z5));
            % Humerus parameters
            rP5 = Markers.L_SAE; 
            rD5 = (Markers.L_HLE+Markers.L_HME)/2;
            w5 = Z5;
            u5 = X5;
            Segment(5).Q = [u5;rP5;rD5;w5];
        end

    end
    
end