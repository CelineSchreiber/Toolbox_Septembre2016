% =========================================================================
% REHAZENTER TOOLBOX
% =========================================================================
% File name:    preparePosturoSegmentParameters
% -------------------------------------------------------------------------
% Subject:      Define postural segments parameters
% -------------------------------------------------------------------------
% Inputs:       - Segment (structure)
%               - Segment (structure)
%               - Markers (structure)
%               - Vmarkers (structure)
%               - Pvmarkers (structure)
%               - Gait (structure)
%               - side (char)
%               - system (char)
% Outputs:      - Segment (structure)
%               - Markers (structure)
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber, A. Naaim
% Date of creation: 26/03/2014
% Version: 1
% -------------------------------------------------------------------------
% Updates: - 02/10/2014: Modif pour côté gauche (l27 à 32) et suppression
% de Markers dans les output
% =========================================================================

function [Segment] = preparePosturoSegmentParameters(Static,Segment,Markers,Pvmarkers,Gait,side,system)

if strcmp(Gait.posturetrial,'yes')

    % =====================================================================
    % Segment parameters using BTS system (Davis markersset)
    % =====================================================================
    % Davis RB. Õunpuu S. Tyburski DT. and Gage JR. 
    % A gait analysis data collection and reduction technique
    % Hum Move Sci. 10:575-588, 1991.
    % =====================================================================
    
    names = fieldnames(Markers);
    if strcmp(side,'Left')
        for i = 1:size(names,1)
            Markers.(names{i})(3,:,:) = -Markers.(names{i})(3,:,:);
        end
    end
    
    if strcmp(system,'BTS')

        % Pelvis parameters
        % -----------------------------------------------------------------
        % Pelvis axes
        if isfield(Markers,'r_asis') && isfield(Markers,'l_asis') && isfield(Markers,'sacrum')
            Segment(5).Z = Vnorm_array3(Markers.r_asis - Markers.l_asis);
            Segment(5).Y = Vnorm_array3(cross(Segment(5).Z,...
                ((Markers.r_asis + Markers.l_asis)/2 - Markers.sacrum)));
            Segment(5).X = Vnorm_array3(cross(Segment(5).Y, Segment(5).Z));
            Segment(5).SCSC = (Markers.r_asis + Markers.l_asis)/2;
        end

        % Rachis (axe occipital) parameters
        % -----------------------------------------------------------------
        if isfield(Markers,'c7') && isfield(Markers,'sacrum') && isfield(Markers,'r_should') && isfield(Markers,'l_should')
            % Rachis axes
            Segment(6).Y = Vnorm_array3(Markers.c7 - Markers.sacrum);
            Segment(6).X = Vnorm_array3(cross(Segment(6).Y,Markers.r_should - Markers.l_should)); 
            Segment(6).Z = Vnorm_array3(cross(Segment(6).X,Segment(6).Y));
            Segment(6).SCSC = Markers.sacrum;
            % Rachis markers
            Segment(6).rM = [Markers.r_should,Markers.c7,Markers.sacrum];
            % Rachis parameters
            rD6 = Markers.sacrum;
            rP6 = Markers.c7;
            w6 = Segment(6).Z;
            u6 = Segment(6).X;
            Segment(6).Q = [u6;rP6;rD6;w6]; % échanger P et D?
        end 

        % Scapular belt parameters
        % -----------------------------------------------------------------
        if isfield(Markers,'r_should') && isfield(Markers,'l_should') && isfield(Markers,'c7')
            % Scapular belt axes
            Segment(7).Z = Vnorm_array3(Markers.r_should-Markers.l_should);    
            Segment(7).Y = Vnorm_array3(cross(Segment(7).Z,((Markers.r_should+Markers.l_should)/2 - Markers.c7)));
            Segment(7).X = Vnorm_array3(cross(Segment(7).Y,Segment(7).Z)); 
            Segment(7).SCSC = (Markers.r_should+Markers.l_should)/4 + (Markers.c7)/2 ;
            % Scapular belt markers
            Segment(7).rM = [Markers.r_should,Markers.l_should,Markers.c7];
            % Scapular belt parameters
            rP7 = Markers.c7;
            rD7 = Segment(7).SCSC;
            w7 = Segment(7).Z;
            u7 = Segment(7).X;
            Segment(7).Q = [u7;rP7;rD7;w7];
        end

        % Head parameters
        % -----------------------------------------------------------------  
        if isfield(Markers,'r_head_front') && isfield(Markers,'l_head_front') && isfield(Markers,'r_head_back') && isfield(Markers,'l_head_back')
            nmarkers = isfield(Markers,'r_head_front')+isfield(Markers,'l_head_front')+isfield(Markers,'r_head_back')+isfield(Markers,'l_head_back');
            if nmarkers == 3
                % Head markers
                if isfield(Markers,'r_head_front') && isfield(Markers,'l_head_front') && isfield(Markers,'r_head_back') % no L_HDB
                    Segment(8).rM = [Markers.r_head_front,Markers.l_head_front,Markers.r_head_back];
                    n = size(Markers.r_head_front,3);
                    Rotation = [];
                    Translation = [];
                    RMS = [];
                    for i = 1:n
                        [Rotation(:,:,i),Translation(:,:,i),RMS(:,:,i)] ...
                            = soder(Static(8).rM_LHDB',Segment(8).rM(:,:,i)');
                    end
                    Markers.l_head_back = ...
                        Mprod_array3(Rotation , repmat(Pvmarkers.L_HDB,[1 1 n])) ...
                        + Translation;
                    Markers.l_head_back = Markers.l_head_back(1:3,:,:);
                elseif isfield(Markers,'r_head_front') && isfield(Markers,'l_head_front') && isfield(Markers,'l_head_back') % no r_head_back
                    Segment(8).rM = [Markers.r_head_front,Markers.l_head_front,Markers.l_head_back];
                    n = size(Markers.r_head_front,3);
                    Rotation = [];
                    Translation = [];
                    RMS = [];
                    for i = 1:n
                        [Rotation(:,:,i),Translation(:,:,i),RMS(:,:,i)] ...
                            = soder(Static(8).rM_RHDB',Segment(8).rM(:,:,i)');
                    end
                    Markers.r_head_back = ...
                        Mprod_array3(Rotation , repmat(Pvmarkers.r_head_back,[1 1 n])) ...
                        + Translation;
                    Markers.r_head_back = Markers.r_head_back(1:3,:,:);
                elseif isfield(Markers,'r_head_front') && isfield(Markers,'l_head_back') && isfield(Markers,'r_head_back') % no l_head_front
                    Segment(8).rM = [Markers.r_head_front,Markers.l_head_back,Markers.r_head_back];
                    n = size(Markers.r_head_front,3);
                    Rotation = [];
                    Translation = [];
                    RMS = [];
                    for i = 1:n
                        [Rotation(:,:,i),Translation(:,:,i),RMS(:,:,i)] ...
                            = soder(Static(8).rM_LHDF',Segment(8).rM(:,:,i)');
                    end
                    Markers.l_head_front = ...
                        Mprod_array3(Rotation , repmat(Pvmarkers.l_head_front,[1 1 n])) ...
                        + Translation;
                    Markers.l_head_front = Markers.l_head_front(1:3,:,:);
                elseif isfield(Markers,'l_head_front') && isfield(Markers,'l_head_back') && isfield(Markers,'r_head_back') % no r_head_front
                    Segment(8).rM = [Markers.l_head_front,Markers.l_head_back,Markers.r_head_back];
                    n = size(Markers.l_head_front,3);
                    Rotation = [];
                    Translation = [];
                    RMS = [];
                    for i = 1:n
                        [Rotation(:,:,i),Translation(:,:,i),RMS(:,:,i)] ...
                            = soder(Static(8).rM_RHDF',Segment(8).rM(:,:,i)');
                    end
                    Markers.r_head_front = ...
                        Mprod_array3(Rotation , repmat(Pvmarkers.r_head_front,[1 1 n])) ...
                        + Translation;
                    Markers.r_head_front = Markers.r_head_front(1:3,:,:);
                end
            end
            if nmarkers > 2
                % Head axes
                Segment(8).Z = Vnorm_array3(Markers.r_head_front-Markers.l_head_front);
                Segment(8).Y = Vnorm_array3(cross(Segment(8).Z,...
                    (((Markers.r_head_front+Markers.l_head_front)/2) - ((Markers.r_head_back+Markers.l_head_back)/2))));
                Segment(8).X = Vnorm_array3(cross(Segment(8).Y, Segment(8).Z));
                Segment(8).SCSC = (Markers.r_head_front+Markers.l_head_front+Markers.r_head_back+Markers.l_head_back)/4;
                % Head parameters
                rP8 = (Markers.r_head_back+Markers.l_head_back)/2;
                rD8 = (Markers.r_head_front+Markers.l_head_front)/2;
                w8 = Segment(8).Z;
                u8 = Segment(8).X;
                Segment(8).Q = [u8;rP8;rD8;w8];
                % Head markers
                Segment(8).rM = [Markers.r_head_front,Markers.l_head_front,Markers.r_head_back];
            end
        end

        % Thigh parameters
        % -----------------------------------------------------------------     
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

    % =====================================================================
    % Segment parameters using Qualisys system (Leardini markersset)
    % =====================================================================
    % Leardini A, Sawacha Z, Paolini G, Ingrosso S, Nativo R, Benedetti MG.
    % A new anatomically based protocol for gait analysis in children
    % Gait Posture. 2007 Oct;26(4):560-71
    % =====================================================================
    elseif strcmp(system,'Qualisys')

        % Pelvis parameters
        % -----------------------------------------------------------------
        % Pelvis axes
        if isfield(Markers,'R_IPS') && isfield(Markers,'L_IPS') && isfield(Markers,'R_IAS') && isfield(Markers,'L_IAS')
            Markers.sacrum = (Markers.R_IPS+Markers.L_IPS)/2;
            Segment(5).Z = Vnorm_array3(Markers.R_IAS - Markers.L_IAS);
            Segment(5).Y = Vnorm_array3(cross(Segment(5).Z,...
                   ((Markers.R_IAS + Markers.L_IAS)/2 - Markers.sacrum)));
            Segment(5).X = Vnorm_array3(cross(Segment(5).Y, Segment(5).Z)); 
            Segment(5).SCSC = (Markers.R_IAS + Markers.L_IAS)/2;
        end

        % Rachis (axe occipital) parameters
        % -----------------------------------------------------------------
        if isfield(Markers,'R_IPS') && isfield(Markers,'L_IPS')
            Markers.sacrum = (Markers.R_IPS+Markers.L_IPS)/2;
        end
        if isfield(Markers,'sacrum')&& isfield(Markers,'CV7') && isfield(Markers,'R_SAE') && isfield(Markers,'L_SAE')  
            % Rachis axes
            Segment(6).Y = Vnorm_array3(Markers.CV7 - Markers.sacrum);
            Segment(6).X = Vnorm_array3(cross(Segment(6).Y,Markers.R_SAE - Markers.L_SAE)); 
            Segment(6).Z = Vnorm_array3(cross(Segment(6).X,Segment(6).Y));
            Segment(6).SCSC = Markers.sacrum;
            % Rachis markers
            Segment(6).rM = [Markers.R_SAE,Markers.CV7,Markers.R_IPS];
            % Rachis parameters
            rD6 = Markers.sacrum;
            rP6 = Markers.CV7;
            w6 = Segment(6).Z;
            u6 = Segment(6).X;
            Segment(6).Q = [u6;rP6;rD6;w6]; % échanger P et D?
        end

        % Scapular belt parameters
        % -----------------------------------------------------------------
        if isfield(Markers,'CV7') && isfield(Markers,'R_SAE') && isfield(Markers,'L_SAE') 
            % Scapular belt axes
            Segment(7).Z = Vnorm_array3(Markers.R_SAE-Markers.L_SAE);    
            Segment(7).Y = Vnorm_array3(cross(Segment(7).Z,((Markers.R_SAE+Markers.L_SAE)/2 - Markers.CV7)));
            Segment(7).X = Vnorm_array3(cross(Segment(7).Y,Segment(7).Z)); 
            Segment(7).SCSC = (Markers.R_SAE+Markers.L_SAE)/4 + (Markers.CV7)/2;
            % Scapular belt markers
            Segment(7).rM = [Markers.R_SAE,Markers.L_SAE,Markers.CV7];
            % Scapular belt parameters
            rP7 = Markers.CV7;
            rD7 = Segment(7).SCSC;
            w7 = Segment(7).Z;
            u7 = Segment(7).X;
            Segment(7).Q = [u7;rP7;rD7;w7];
        end

        % Head parameters
        % -----------------------------------------------------------------  
        nmarkers = isfield(Markers,'R_HDF')+isfield(Markers,'R_HDB')+isfield(Markers,'L_HDF')+isfield(Markers,'L_HDB'); 
        if nmarkers == 3
            if isfield(Markers,'R_HDF') && isfield(Markers,'L_HDF') && isfield(Markers,'R_HDB') % no L_HDB
                Segment(8).rM = [Markers.R_HDF,Markers.L_HDF,Markers.R_HDB]; 
                n = size(Markers.R_HDF,3);
                Rotation = [];
                Translation = [];
                RMS = [];
                for i = 1:n
                    [Rotation(:,:,i),Translation(:,:,i),RMS(:,:,i)] ...
                            = soder(Static(8).rM_LHDB',Segment(8).rM(:,:,i)');
                end
                Markers.L_HDB = ...
                    Mprod_array3(Rotation , repmat(Pvmarkers.L_HDB,[1 1 n])) ...
                    + Translation;
                Markers.L_HDB = Markers.L_HDB(1:3,:,:);
                nmarkers = 4;
            elseif isfield(Markers,'R_HDF') && isfield(Markers,'L_HDF') && isfield(Markers,'L_HDB') % no R_HDB
                Segment(8).rM = [Markers.R_HDF,Markers.L_HDF,Markers.L_HDB];
                n = size(Markers.R_HDF,3);
                Rotation = [];
                Translation = [];
                RMS = [];
                for i = 1:n
                    [Rotation(:,:,i),Translation(:,:,i),RMS(:,:,i)] ...
                            = soder(Static(8).rM_RHDB',Segment(8).rM(:,:,i)');
                end
                Markers.R_HDB = ...
                    Mprod_array3(Rotation , repmat(Pvmarkers.R_HDB,[1 1 n])) ...
                    + Translation;
                Markers.R_HDB = Markers.R_HDB(1:3,:,:);
                nmarkers = 4;
            elseif isfield(Markers,'R_HDF') && isfield(Markers,'L_HDB') && isfield(Markers,'R_HDB') % no L_HDF
                Segment(8).rM = [Markers.R_HDF,Markers.L_HDB,Markers.R_HDB];
                n = size(Markers.R_HDF,3);
                Rotation = [];
                Translation = [];
                RMS = [];
                for i = 1:n
                    [Rotation(:,:,i),Translation(:,:,i),RMS(:,:,i)] ...
                            = soder(Static(8).rM_LHDF',Segment(8).rM(:,:,i)');
                end
                Markers.L_HDF = ...
                    Mprod_array3(Rotation , repmat(Pvmarkers.L_HDF,[1 1 n])) ...
                    + Translation;
                Markers.L_HDF = Markers.L_HDF(1:3,:,:);
                nmarkers = 4;
            elseif isfield(Markers,'L_HDF') && isfield(Markers,'L_HDB') && isfield(Markers,'R_HDB') % no R_HDF
                Segment(8).rM = [Markers.L_HDF,Markers.L_HDB,Markers.R_HDB];
                n = size(Markers.L_HDF,3);
                Rotation = [];
                Translation = [];
                RMS = [];
                for i = 1:n
                    [Rotation(:,:,i),Translation(:,:,i),RMS(:,:,i)] ...
                            = soder(Static(8).rM_RHDF',Segment(8).rM(:,:,i)');
                end
                Markers.R_HDF = ...
                    Mprod_array3(Rotation , repmat(Pvmarkers.R_HDF,[1 1 n])) ...
                    + Translation;
                Markers.R_HDF = Markers.R_HDF(1:3,:,:);
                nmarkers = 4;
            end
        end
        if nmarkers == 4 
            % Head axes
            Segment(8).Z = Vnorm_array3((Markers.R_HDF+Markers.R_HDB)/2 - (Markers.L_HDF+Markers.L_HDB)/2);
            Segment(8).Y = Vnorm_array3(cross(Segment(8).Z,...
                   ((Markers.R_HDF+Markers.L_HDF)/2 - (Markers.R_HDB+Markers.L_HDB)/2)));
            Segment(8).X = Vnorm_array3(cross(Segment(8).Y, Segment(8).Z)); 
            Segment(8).SCSC = (Markers.R_HDF+Markers.L_HDF+Markers.R_HDB+Markers.L_HDB)/4;
            % Head parameters
            rP8 = (Markers.R_HDB+Markers.L_HDB)/2;
            rD8 = (Markers.R_HDF+Markers.L_HDF)/2;
            w8 = Segment(8).Z;
            u8 = Segment(8).X;
            Segment(8).Q = [u8;rP8;rD8;w8];
            % Head markers
            Segment(8).rM = [Markers.R_HDF,Markers.L_HDF,Markers.R_HDB];
        end
    end

        % Thigh parameters
        % ----------------------------------------------------------------- 
    %     if side == 'Left'
    %         if isfield(Markers,'L_FLE')
    %             Segment(4).Z = Vnorm_array3(Markers.L_FLE-Vmarkers.l_kjc);
    %             Segment(4).Y = Vnorm_array3(Vmarkers.l_hjc-Vmarkers.l_kjc);
    %             Segment(4).X = Vnorm_array3(cross(Segment(4).Y,Segment(4).Z));
    %             Segment(4).SCSC = Vmarkers.l_kjc;
    %         end
    %     elseif side == 'Right'
    %         if isfield(Markers,'R_FLE')
    %             Segment(4).Z = Vnorm_array3(Markers.R_FLE-Vmarkers.r_kjc);
    %             Segment(4).Y = Vnorm_array3(Vmarkers.r_hjc-Vmarkers.r_kjc);
    %             Segment(4).X = Vnorm_array3(cross(Segment(4).Y,Segment(4).Z));
    %             Segment(4).SCSC = Vmarkers.r_kjc;
    %         end
    %     end

end