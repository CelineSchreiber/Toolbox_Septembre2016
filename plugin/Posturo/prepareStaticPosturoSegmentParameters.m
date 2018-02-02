% =========================================================================
% REHAZENTER TOOLBOX
% =========================================================================
% File name:    prepareStaticPosturoSegmentParameters
% -------------------------------------------------------------------------
% Subject:      Define postursl segments parameters
% -------------------------------------------------------------------------
% Inputs:       - Markers (structure)
%               - system (char)
% Outputs:      - Static (structure)
%               - Vmarkers (structure)
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber, A. Naaim
% Date of creation: 26/03/2014
% Version: 1
% -------------------------------------------------------------------------
% Updates: - 
% =========================================================================

function [Static,Vmarkers] = prepareStaticPosturoSegmentParameters(Markers,system)

% =========================================================================
% Initialisation
% =========================================================================
Static = [];
Vmarkers = [];

% =========================================================================
% Segment parameters using BTS system (Davis markersset)
% =========================================================================
% Davis RB. Õunpuu S. Tyburski DT. and Gage JR. 
% A gait analysis data collection and reduction technique
% Hum Move Sci. 10:575-588, 1991.
% =========================================================================
if strcmp(system,'BTS')

    % Pelvis parameters
    % ---------------------------------------------------------------------
    % Pelvis axes
    if isfield(Markers,'r_asis') && isfield(Markers,'l_asis') && isfield(Markers,'sacrum')
        Static(5).Z = Vnorm_array3(Markers.r_asis - Markers.l_asis);
        Static(5).Y = Vnorm_array3(cross(Static(5).Z,...
            ((Markers.r_asis + Markers.l_asis)/2 - Markers.sacrum)));
        Static(5).X = Vnorm_array3(cross(Static(5).Y, Static(5).Z));
        Static(5).SCSC = (Markers.r_asis + Markers.l_asis)/2;
    end
    
    % Rachis (axe occipital) parameters
    % ---------------------------------------------------------------------
    if isfield(Markers,'c7') && isfield(Markers,'sacrum') && isfield(Markers,'r_should') && isfield(Markers,'l_should')
        % Rachis axes
        Static(6).Y = Vnorm_array3(Markers.c7 - Markers.sacrum);
        Static(6).X = Vnorm_array3(cross(Static(6).Y,Markers.r_should - Markers.l_should)); 
        Static(6).Z = Vnorm_array3(cross(Static(6).X,Static(6).Y));
        Static(6).SCSC = Markers.sacrum;
        % Rachis markers
        Static(6).rM = [Markers.r_should,Markers.c7,Markers.sacrum];
        % Rachis parameters
        rD6 = Markers.sacrum;
        rP6 = Markers.c7;
        w6 = Static(6).Z;
        u6 = Static(6).X;
        Static(6).Q = [u6;rP6;rD6;w6]; % échanger P et D?
    end 
    
    % Scapular belt parameters
    % ---------------------------------------------------------------------
    if isfield(Markers,'r_should') && isfield(Markers,'l_should') && isfield(Markers,'c7')
        % Scapular belt axes
        Static(7).Z = Vnorm_array3(Markers.r_should-Markers.l_should);    
        Static(7).Y = Vnorm_array3(cross(Static(7).Z,((Markers.r_should+Markers.l_should)/2 - Markers.c7)));
        Static(7).X = Vnorm_array3(cross(Static(7).Y,Static(7).Z)); 
        Static(7).SCSC = (Markers.r_should+Markers.l_should)/4 + (Markers.c7)/2 ;
        % Scapular belt markers
        Static(7).rM = [Markers.r_should,Markers.l_should,Markers.c7];
        % Scapular belt parameters
        rP7 = Markers.c7;
        rD7 = Static(7).SCSC;
        w7 = Static(7).Z;
        u7 = Static(7).X;
        Static(7).Q = [u7;rP7;rD7;w7];
    end
    
    % Head parameters
    % ---------------------------------------------------------------------    
    if isfield(Markers,'r_head_front') && isfield(Markers,'l_head_front') && isfield(Markers,'r_head_back') && isfield(Markers,'l_head_back')
        % Head axes
        Static(8).Z = Vnorm_array3(Markers.r_head_front-Markers.l_head_front);
        Static(8).Y = Vnorm_array3(cross(Static(8).Z,...
                   (((Markers.r_head_front+Markers.l_head_front)/2) - ((Markers.r_head_back+Markers.l_head_back)/2))));
        Static(8).X = Vnorm_array3(cross(Static(8).Y, Static(8).Z)); 
        Static(8).SCSC = (Markers.r_head_front+Markers.l_head_front+Markers.r_head_back+Markers.l_head_back)/4;
        % Head parameters
        rP8 = (Markers.r_head_back+Markers.l_head_back)/2;
        rD8 = (Markers.r_head_front+Markers.l_head_front)/2;
        w8 = Static(8).Z;
        u8 = Static(8).X;
        Static(8).Q = [u8;rP8;rD8;w8];
        % Head markers
        Static(8).rM_LHDB = [Markers.r_head_front,Markers.l_head_front,Markers.r_head_back];
        Static(8).rM_RHDB = [Markers.r_head_front,Markers.l_head_front,Markers.l_head_back];
        Static(8).rM_LHDF = [Markers.r_head_front,Markers.l_head_back,Markers.r_head_back];
        Static(8).rM_RHDF = [Markers.l_head_front,Markers.l_head_back,Markers.r_head_back];
        % Technical markers
        Vmarkers.r_head_front = Markers.r_head_front;
        Vmarkers.l_head_front = Markers.l_head_front;
        Vmarkers.r_head_back = Markers.r_head_back;
        Vmarkers.l_head_back = Markers.l_head_back;
        Vmarkers.SCSC = Static(8).SCSC;
    end  
    
    % Thigh parameters
    % ---------------------------------------------------------------------       
%     if side=='Left'
%         if isfield(Markers,'l_thigh') && isfield(Markers,'l_bar_1') && isfield(Markers,'l_knee_1')
%             Segment(4).Z = Vnorm_array3(Markers.l_knee_1-Vmarkers.l_kjc);
%             Segment(4).Y = Vnorm_array3(Vmarkers.l_hjc-Vmarkers.l_kjc);
%             Segment(4).X = Vnorm_array3(cross(Segment(4).Y,Segment(4).Z));
%             Segment(4).SCSC = Vmarkers.l_kjc;
%         end
%     elseif side=='Right'
%         if isfield(Markers,'r_thigh') && isfield(Markers,'r_bar_1') && isfield(Markers,'r_knee_1')
%             Segment(4).Z = Vnorm_array3(Markers.r_knee_1-Vmarkers.r_kjc);
%             Segment(4).Y = Vnorm_array3(Vmarkers.r_hjc-Vmarkers.r_kjc);
%             Segment(4).X = Vnorm_array3(cross(Segment(4).Y,Segment(4).Z));
%             Segment(4).SCSC = Vmarkers.r_kjc;
%         end
%     end
    
% =========================================================================
% Segment parameters using Qualisys system (Leardini markersset)
% =========================================================================
% Leardini A, Sawacha Z, Paolini G, Ingrosso S, Nativo R, Benedetti MG.
% A new anatomically based protocol for gait analysis in children
% Gait Posture. 2007 Oct;26(4):560-71
% ========================================================================= 
elseif strcmp(system,'Qualisys')

    % Pelvis parameters
    % ---------------------------------------------------------------------
    % Pelvis axes
    if isfield(Markers,'R_IPS') && isfield(Markers,'L_IPS') && isfield(Markers,'R_IAS') && isfield(Markers,'L_IAS')
        Markers.sacrum = (Markers.R_IPS+Markers.L_IPS)/2;
        Static(5).Z = Vnorm_array3(Markers.R_IAS - Markers.L_IAS);
        Static(5).Y = Vnorm_array3(cross(Static(5).Z,...
               ((Markers.R_IAS + Markers.L_IAS)/2 - Markers.sacrum)));
        Static(5).X = Vnorm_array3(cross(Static(5).Y, Static(5).Z)); 
        Static(5).SCSC = (Markers.R_IAS + Markers.L_IAS)/2;
    end
    
    % Rachis (axe occipital) parameters
    % ---------------------------------------------------------------------
    if isfield(Markers,'R_IPS') && isfield(Markers,'L_IPS')
        Markers.sacrum = (Markers.R_IPS+Markers.L_IPS)/2;
    end
    if isfield(Markers,'sacrum')&& isfield(Markers,'CV7') && isfield(Markers,'R_SAE') && isfield(Markers,'L_SAE')  
        % Rachis axes
        Static(6).Y = Vnorm_array3(Markers.CV7 - Markers.sacrum);
        Static(6).X = Vnorm_array3(cross(Static(6).Y,Markers.R_SAE - Markers.L_SAE)); 
        Static(6).Z = Vnorm_array3(cross(Static(6).X,Static(6).Y));
        Static(6).SCSC = Markers.sacrum;
        % Rachis markers
        Static(6).rM = [Markers.R_SAE,Markers.CV7,Markers.R_IPS];
        % Rachis parameters
        rD6 = Markers.sacrum;
        rP6 = Markers.CV7;
        w6 = Static(6).Z;
        u6 = Static(6).X;
        Static(6).Q = [u6;rP6;rD6;w6]; % échanger P et D?
    end
    
    % Scapular belt parameters
    % ---------------------------------------------------------------------
    if isfield(Markers,'CV7') && isfield(Markers,'R_SAE') && isfield(Markers,'L_SAE') 
        % Scapular belt axes
        Static(7).Z = Vnorm_array3(Markers.R_SAE-Markers.L_SAE);    
        Static(7).Y = Vnorm_array3(cross(Static(7).Z,((Markers.R_SAE+Markers.L_SAE)/2 - Markers.CV7)));
        Static(7).X = Vnorm_array3(cross(Static(7).Y,Static(7).Z)); 
        Static(7).SCSC = (Markers.R_SAE+Markers.L_SAE)/4 + (Markers.CV7)/2;
        % Scapular belt markers
        Static(7).rM = [Markers.R_SAE,Markers.L_SAE,Markers.CV7];
        % Scapular belt parameters
        rP7 = Markers.CV7;
        rD7 = Static(7).SCSC;
        w7 = Static(7).Z;
        u7 = Static(7).X;
        Static(7).Q = [u7;rP7;rD7;w7];
    end
    
    % Head parameters
    % ---------------------------------------------------------------------    
    if isfield(Markers,'R_HDF') && isfield(Markers,'R_HDB') && isfield(Markers,'L_HDF') && isfield(Markers,'L_HDB'); 
        % Head axes
        Static(8).Z = Vnorm_array3((Markers.R_HDF+Markers.R_HDB)/2 - (Markers.L_HDF+Markers.L_HDB)/2);
        Static(8).Y = Vnorm_array3(cross(Static(8).Z,...
                   ((Markers.R_HDF+Markers.L_HDF)/2 - (Markers.R_HDB+Markers.L_HDB)/2)));
        Static(8).X = Vnorm_array3(cross(Static(8).Y, Static(8).Z)); 
        Static(8).SCSC = (Markers.R_HDF+Markers.L_HDF+Markers.R_HDB+Markers.L_HDB)/4;
        % Head parameters
        rP8 = (Markers.R_HDB+Markers.L_HDB)/2;
        rD8 = (Markers.R_HDF+Markers.L_HDF)/2;
        w8 = Static(8).Z;
        u8 = Static(8).X;
        Static(8).Q = [u8;rP8;rD8;w8];
        % Head markers
        % The set of markers depends on the available markers
        Static(8).rM_LHDB = [Markers.R_HDF,Markers.L_HDF,Markers.R_HDB];
        Static(8).rM_RHDB = [Markers.R_HDF,Markers.L_HDF,Markers.L_HDB];
        Static(8).rM_LHDF = [Markers.R_HDF,Markers.L_HDB,Markers.R_HDB];
        Static(8).rM_RHDF = [Markers.L_HDF,Markers.L_HDB,Markers.R_HDB];
        Vmarkers.R_HDF = Markers.R_HDF;
        Vmarkers.L_HDF = Markers.L_HDF;
        Vmarkers.R_HDB = Markers.R_HDB;
        Vmarkers.L_HDB = Markers.L_HDB;
        Vmarkers.SCSC = Static(8).SCSC;
    end
end
    
%     % Thigh parameters
%     % ---------------------------------------------------------------------
%     % Thigh axes
%     if side=='Left'
%         if isfield(Markers,'L_FLE')
%             Static(4).Z = Vnorm_array3(Markers.L_FLE-Vmarkers.l_kjc_static);
%             Static(4).Y = Vnorm_array3(Vmarkers.l_hjc_static-Vmarkers.l_kjc_static);
%             Static(4).X = Vnorm_array3(cross(Static(4).Y,Static(4).Z));
%             Static(4).SCSC = Vmarkers.l_kjc_static;
%         end
%     elseif side == 'Right'
%         if isfield(Markers,'R_FLE')
%             Static(4).Z = Vnorm_array3(Markers.R_FLE-Vmarkers.r_kjc_static);
%             Static(4).Y = Vnorm_array3(Vmarkers.r_hjc_static-Vmarkers.r_kjc_static);
%             Static(4).X = Vnorm_array3(cross(Static(4).Y,Static(4).Z));
%             Static(4).SCSC = Vmarkers.r_kjc_static;
%         end
%     end
end