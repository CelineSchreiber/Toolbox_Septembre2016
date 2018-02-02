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

function [Segment,Markers,Vmarkers] = prepareCycleSegmentParameters(Static,Markers,Vmarkers,Grf,n,side,system)

% =========================================================================
% Initialisation
% =========================================================================
Segment = [];

% =====================================================================
% Transform left limb data into right limb data
% =====================================================================
names = fieldnames(Markers);
if strcmp(side,'Left')
    for i = 1:size(names,1)
        Markers.(names{i})(3,:,:) = -Markers.(names{i})(3,:,:);
    end
    Grf.P(3,:,:) = -Grf.P(3,:,:);
end

% =====================================================================
% Segment parameters using BTS system (Davis markersset)
% =====================================================================
% Davis RB. Õunpuu S. Tyburski DT. and Gage JR. 
% A gait analysis data collection and reduction technique
% Hum Move Sci. 10:575-588, 1991.
% =====================================================================
if strcmp(system,'BTS')

    % Pelvis parameters
    % -----------------------------------------------------------------
    % Pelvis axes
    if strcmp(side,'Right')
        Z5 = Vnorm_array3(Markers.r_asis-Markers.l_asis);
    elseif strcmp(side,'Left')
        Z5 = Vnorm_array3(Markers.l_asis-Markers.r_asis);
    end
    Y5 = Vnorm_array3(cross(Z5,(Markers.r_asis+Markers.l_asis)/2-Markers.sacrum));
    X5 = Vnorm_array3(cross(Y5,Z5));
    % Pelvis Markers
    Segment(5).rM = [Markers.r_asis,Markers.l_asis,Markers.sacrum];
    % Lumbar joint center
    Rotation = [];
    Translation = [];
    RMS = [];
    for i = 1:n
        [Rotation(:,:,i),Translation(:,:,i),RMS(:,:,i)] ...
            = soder(Static(5).rM',Segment(5).rM(:,:,i)');
    end
    Vmarkers.ljc = ...
        Mprod_array3(Rotation , repmat(Vmarkers.ljc_static,[1 1 n])) ...
        + Translation;
    Vmarkers.ljc = Vmarkers.ljc(1:3,:,:);
    % Right hip joint center
    Rotation = [];
    Translation = [];
    RMS = [];
    for i = 1:n
        [Rotation(:,:,i),Translation(:,:,i),RMS(:,:,i)] ...
            = soder(Static(5).rM',Segment(5).rM(:,:,i)');
    end
    Vmarkers.r_hjc = ...
        Mprod_array3(Rotation , repmat(Vmarkers.r_hjc_static,[1 1 n])) ...
        + Translation;
    Vmarkers.r_hjc = Vmarkers.r_hjc(1:3,:,:);
    % Left hip joint center
    Rotation = [];
    Translation = [];
    RMS = [];
    for i = 1:n
        [Rotation(:,:,i),Translation(:,:,i),RMS(:,:,i)] ...
            = soder(Static(5).rM',Segment(5).rM(:,:,i)');
    end
    Vmarkers.l_hjc = ...
        Mprod_array3(Rotation , repmat(Vmarkers.l_hjc_static,[1 1 n])) ...
        + Translation;
    Vmarkers.l_hjc = Vmarkers.l_hjc(1:3,:,:);
    % Pelvis parameters
    rP5 = Vmarkers.ljc;
    rD5 = (Vmarkers.r_hjc+Vmarkers.l_hjc)/2;
    w5 = Z5;
    u5 = X5;
    Segment(5).Q = [u5;rP5;rD5;w5];

    if strcmp(side,'Right')

        % Thigh parameters
        % -------------------------------------------------------------
        % Thigh Markers
        Segment(4).rM = [Markers.r_thigh,Markers.r_bar_1,Markers.r_knee_1];
        % Knee joint center
        Rotation = [];
        Translation = [];
        RMS = [];
        for i = 1:n
            [Rotation(:,:,i),Translation(:,:,i),RMS(:,:,i)] ...
                = soder(Static(4).rM',Segment(4).rM(:,:,i)');
        end
        Vmarkers.r_kjc = ...
            Mprod_array3(Rotation , repmat(Vmarkers.r_kjc_static,[1 1 n])) ...
            + Translation;
        Vmarkers.r_kjc = Vmarkers.r_kjc(1:3,:,:);
        % Thigh axes
        Z4 = Vnorm_array3(Markers.r_knee_1-Vmarkers.r_kjc);
        Y4 = Vnorm_array3(Vmarkers.r_hjc-Vmarkers.r_kjc);
        X4 = Vnorm_array3(cross(Y4,Z4));
        % Thigh parameters
        rP4 = Vmarkers.r_hjc;
        rD4 = Vmarkers.r_kjc;
        w4 = Z4;
        u4 = X4;
        Segment(4).Q = [u4;rP4;rD4;w4];

        % Shank parameters
        % -------------------------------------------------------------
        % Shank Markers
        Segment(3).rM = [Markers.r_knee_2,Markers.r_bar_2,Markers.r_mall];
        % Ankle joint center
        Rotation = [];
        Translation = [];
        RMS = [];
        for i = 1:n
            [Rotation(:,:,i),Translation(:,:,i),RMS(:,:,i)] ...
                = soder(Static(3).rM',Segment(3).rM(:,:,i)');
        end
        Vmarkers.r_ajc = ...
            Mprod_array3(Rotation , repmat(Vmarkers.r_ajc_static,[1 1 n])) ...
            + Translation;
        Vmarkers.r_ajc = Vmarkers.r_ajc(1:3,:,:);
        % Shank axes
        Z3 = Vnorm_array3(Markers.r_mall-Vmarkers.r_ajc);
        Y3 = Vnorm_array3(Vmarkers.r_kjc-Vmarkers.r_ajc);
        X3 = Vnorm_array3(cross(Y3,Z3));
        % Shank parameters
        rP3 = Vmarkers.r_kjc;
        rD3 = Vmarkers.r_ajc;
        w3 = Z3;
        u3 = X3;
        Segment(3).Q = [u3;rP3;rD3;w3];

        % Foot parameters
        % -------------------------------------------------------------
        % Foot Markers 
        Segment(2).rM = [Markers.r_met];
        % Foot axes
        Z2 = Z3;
        Y2 = Vnorm_array3(Markers.r_mall-Markers.r_met);
        X2 = Vnorm_array3(cross(Y2,Z2));
        % Foot parameters
        rP2 = Vmarkers.r_ajc;
        rD2 = Markers.r_met + (Vmarkers.r_ajc-Markers.r_mall);
        w2 = Z2;
        u2 = X2;
        Segment(2).Q = [u2;rP2;rD2;w2];

        % Forceplace parameters
        % -------------------------------------------------------------
        rP1 = Grf.P;
        rD1 = zeros(3,1,n);
        u1 = repmat([1;0;0],[1,1,n]);
        w1 = repmat([1;0;0],[1,1,n]);
        Segment(1).Q = [u1;rP1;rD1;w1];

    elseif strcmp(side,'Left')

        % Thigh parameters
        % -------------------------------------------------------------
        % Thigh Markers
        Segment(4).rM = [Markers.l_thigh,Markers.l_bar_1,Markers.l_knee_1];
        % Knee joint center
        Rotation = [];
        Translation = [];
        RMS = [];
        for i = 1:n
            [Rotation(:,:,i),Translation(:,:,i),RMS(:,:,i)] ...
                = soder(Static(4).rM',Segment(4).rM(:,:,i)');
        end
        Vmarkers.l_kjc = ...
            Mprod_array3(Rotation , repmat(Vmarkers.l_kjc_static,[1 1 n])) ...
            + Translation;
        Vmarkers.l_kjc = Vmarkers.l_kjc(1:3,:,:);
        % Thigh axes
        Z4 = Vnorm_array3(Markers.l_knee_1-Vmarkers.l_kjc);
        Y4 = Vnorm_array3(Vmarkers.l_hjc-Vmarkers.l_kjc);
        X4 = Vnorm_array3(cross(Y4,Z4));
        % Thigh parameters
        rP4 = Vmarkers.l_hjc;
        rD4 = Vmarkers.l_kjc;
        w4 = Z4;
        u4 = X4;
        Segment(4).Q = [u4;rP4;rD4;w4];

        % Shank parameters
        % -------------------------------------------------------------
        % Shank Markers
        Segment(3).rM = [Markers.l_knee_2,Markers.l_bar_2,Markers.l_mall];
        % Ankle joint center
        Rotation = [];
        Translation = [];
        RMS = [];
        for i = 1:n
            [Rotation(:,:,i),Translation(:,:,i),RMS(:,:,i)] ...
                = soder(Static(3).rM',Segment(3).rM(:,:,i)');
        end
        Vmarkers.l_ajc = ...
            Mprod_array3(Rotation , repmat(Vmarkers.l_ajc_static,[1 1 n])) ...
            + Translation;
        Vmarkers.l_ajc = Vmarkers.l_ajc(1:3,:,:);
        % Shank axes
        Z3 = Vnorm_array3(Markers.l_mall-Vmarkers.l_ajc);
        Y3 = Vnorm_array3(Vmarkers.l_kjc-Vmarkers.l_ajc);
        X3 = Vnorm_array3(cross(Y3,Z3));
        % Shank parameters
        rP3 = Vmarkers.l_kjc;
        rD3 = Vmarkers.l_ajc;
        w3 = Z3;
        u3 = X3;
        Segment(3).Q = [u3;rP3;rD3;w3];

        % Foot parameters
        % -------------------------------------------------------------
        % Foot Markers 
        Segment(2).rM = [Markers.l_met];
        % Foot axes
        Z2 = Z3;
        Y2 = Vnorm_array3(Markers.l_mall-Markers.l_met);
        X2 = Vnorm_array3(cross(Y2,Z2));
        % Foot parameters
        rP2 = Vmarkers.l_ajc;
        rD2 = Markers.l_met + (Vmarkers.l_ajc-Markers.l_mall);
        w2 = Z2;
        u2 = X2;
        Segment(2).Q = [u2;rP2;rD2;w2];

        % Forceplace parameters
        % -------------------------------------------------------------
        rP1 = Grf.P;
        rD1 = zeros(3,1,n);
        u1 = repmat([1;0;0],[1,1,n]);
        w1 = repmat([1;0;0],[1,1,n]);
        Segment(1).Q = [u1;rP1;rD1;w1];

    end

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
    if strcmp(side,'Right')
        Z5 = Vnorm_array3(Markers.R_IAS-Markers.L_IAS);
    elseif strcmp(side,'Left')
        Z5 = Vnorm_array3(Markers.L_IAS-Markers.R_IAS);
    end
    Y5 = Vnorm_array3(cross(Z5,(Markers.R_IAS+Markers.L_IAS)/2-...
        (Markers.R_IPS+Markers.L_IPS)/2));
    X5 = Vnorm_array3(cross(Y5,Z5));
    % Pelvis Markers
    Segment(5).rM = [Markers.R_IAS,Markers.L_IAS,Markers.R_IPS,Markers.L_IPS];
    % Lumbar joint center
    Rotation = [];
    Translation = [];
    RMS = [];
    for i = 1:n
        [Rotation(:,:,i),Translation(:,:,i),RMS(:,:,i)] ...
            = soder(Static(5).rM',Segment(5).rM(:,:,i)');
    end
    Vmarkers.ljc = ...
        Mprod_array3(Rotation , repmat(Vmarkers.ljc_static,[1 1 n])) ...
        + Translation;
    Vmarkers.ljc = Vmarkers.ljc(1:3,:,:);
    % Right hip joint center
    Rotation = [];
    Translation = [];
    RMS = [];
    for i = 1:n
        [Rotation(:,:,i),Translation(:,:,i),RMS(:,:,i)] ...
            = soder(Static(5).rM',Segment(5).rM(:,:,i)');
    end
    Vmarkers.r_hjc = ...
        Mprod_array3(Rotation , repmat(Vmarkers.r_hjc_static,[1 1 n])) ...
        + Translation;
    Vmarkers.r_hjc = Vmarkers.r_hjc(1:3,:,:);
    % Left hip joint center
    Rotation = [];
    Translation = [];
    RMS = [];
    for i = 1:n
        [Rotation(:,:,i),Translation(:,:,i),RMS(:,:,i)] ...
            = soder(Static(5).rM',Segment(5).rM(:,:,i)');
    end
    Vmarkers.l_hjc = ...
        Mprod_array3(Rotation , repmat(Vmarkers.l_hjc_static,[1 1 n])) ...
        + Translation;
    Vmarkers.l_hjc = Vmarkers.l_hjc(1:3,:,:);
    % Pelvis parameters
    rP5 = Vmarkers.ljc;
    rD5 = (Vmarkers.r_hjc+Vmarkers.l_hjc)/2;
    w5 = Z5;
    u5 = X5;
    Segment(5).Q = [u5;rP5;rD5;w5];

    if strcmp(side,'Right')

        % Thigh parameters
        % -------------------------------------------------------------
        % Thigh Markers
        Segment(4).rM = [Markers.R_FTC,Markers.R_FLE,Vmarkers.r_hjc];
        % Knee joint center
        Rotation = [];
        Translation = [];
        RMS = [];
        for i = 1:n
            [Rotation(:,:,i),Translation(:,:,i),RMS(:,:,i)] ...
                = soder(Static(4).rM',Segment(4).rM(:,:,i)');
        end
        Vmarkers.r_kjc = ...
            Mprod_array3(Rotation , repmat(Vmarkers.r_kjc_static,[1 1 n])) ...
            + Translation;
        Vmarkers.r_kjc = Vmarkers.r_kjc(1:3,:,:);
        % Thigh axes
        Z4 = Vnorm_array3(Markers.R_FLE-Vmarkers.r_kjc);
        Y4 = Vnorm_array3(Vmarkers.r_hjc-Vmarkers.r_kjc);
        X4 = Vnorm_array3(cross(Y4,Z4));
        % Thigh parameters
        rP4 = Vmarkers.r_hjc;
        rD4 = Vmarkers.r_kjc;
        w4 = Z4;
        u4 = X4;
        Segment(4).Q = [u4;rP4;rD4;w4];

        % Shank parameters
        % -------------------------------------------------------------
        % Shank Markers
        Segment(3).rM = [Markers.R_FAX,Markers.R_TTC,Markers.R_FAL];
        % Ankle joint center
        Rotation = [];
        Translation = [];
        RMS = [];
        for i = 1:n
            [Rotation(:,:,i),Translation(:,:,i),RMS(:,:,i)] ...
                = soder(Static(3).rM',Segment(3).rM(:,:,i)');
        end
        Vmarkers.r_ajc = ...
            Mprod_array3(Rotation , repmat(Vmarkers.r_ajc_static,[1 1 n])) ...
            + Translation;
        Vmarkers.r_ajc = Vmarkers.r_ajc(1:3,:,:);
        % Shank axes
        Z3 = Vnorm_array3(Markers.R_FAL-Vmarkers.r_ajc);
        Y3 = Vnorm_array3(Vmarkers.r_kjc-Vmarkers.r_ajc);
        X3 = Vnorm_array3(cross(Y3,Z3));
        % Shank parameters
        rP3 = Vmarkers.r_kjc;
        rD3 = Vmarkers.r_ajc;
        w3 = Z3;
        u3 = X3;
        Segment(3).Q = [u3;rP3;rD3;w3];

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

        % Forceplace parameters
        % -------------------------------------------------------------
        rP1 = Grf.P;
        rD1 = zeros(3,1,n);
        u1 = repmat([1;0;0],[1,1,n]);
        w1 = repmat([1;0;0],[1,1,n]);
        Segment(1).Q = [u1;rP1;rD1;w1];

%             Segment(2).rM = [Markers.R_FCC,Markers.R_FM5,Markers.R_FM1];
%             Segment(3).rM = [Markers.R_FAX,Markers.R_TTC,Markers.R_FAL];
%             for j = 2:3
% 
%                 Rotation = [];
%                 Translation = [];
%                 RMS = [];
% 
%                 for i = 1:n
%                     [Rotation(:,:,i),Translation(:,:,i),RMS(:,:,i)] ...
%                         = soder(Static(j).rM',Segment(j).rM(:,:,i)');
%                 end
% 
%                 Segment(j).Q = ...
%                     [Mprod_array3(Rotation , repmat(Static(j).Q(1:3,1,:),[1 1 n])); ...
%                     Mprod_array3(Rotation , repmat(Static(j).Q(4:6,1,:),[1 1 n])) ...
%                     + Translation; ...
%                     Mprod_array3(Rotation , repmat(Static(j).Q(7:9,1,:),[1 1 n])) ...
%                     + Translation; ...
%                     Mprod_array3(Rotation , repmat(Static(j).Q(10:12,1,:),[1 1 n]))];
% 
%             end
%             Vmarkers.r_ajc = Segment(3).Q(7:9,:,:);

    elseif strcmp(side,'Left')

        % Thigh parameters
        % -------------------------------------------------------------
        % Thigh Markers
        Segment(4).rM = [Markers.L_FTC,Markers.L_FLE,Vmarkers.l_hjc];
        % Knee joint center
        Rotation = [];
        Translation = [];
        RMS = [];
        for i = 1:n
            [Rotation(:,:,i),Translation(:,:,i),RMS(:,:,i)] ...
                = soder(Static(4).rM',Segment(4).rM(:,:,i)');
        end
        Vmarkers.l_kjc = ...
            Mprod_array3(Rotation , repmat(Vmarkers.l_kjc_static,[1 1 n])) ...
            + Translation;
        Vmarkers.l_kjc = Vmarkers.l_kjc(1:3,:,:);
        % Thigh axes
        Z4 = Vnorm_array3(Markers.L_FLE-Vmarkers.l_kjc);
        Y4 = Vnorm_array3(Vmarkers.l_hjc-Vmarkers.l_kjc);
        X4 = Vnorm_array3(cross(Y4,Z4));
        % Thigh parameters
        rP4 = Vmarkers.l_hjc;
        rD4 = Vmarkers.l_kjc;
        w4 = Z4;
        u4 = X4;
        Segment(4).Q = [u4;rP4;rD4;w4];

        % Shank parameters
        % -------------------------------------------------------------
        % Shank Markers
        Segment(3).rM = [Markers.L_FAX,Markers.L_TTC,Markers.L_FAL];
        % Ankle joint center
        Rotation = [];
        Translation = [];
        RMS = [];
        for i = 1:n
            [Rotation(:,:,i),Translation(:,:,i),RMS(:,:,i)] ...
                = soder(Static(3).rM',Segment(3).rM(:,:,i)');
        end
        Vmarkers.l_ajc = ...
            Mprod_array3(Rotation , repmat(Vmarkers.l_ajc_static,[1 1 n])) ...
            + Translation;
        Vmarkers.l_ajc = Vmarkers.l_ajc(1:3,:,:);
        % Shank axes
        Z3 = Vnorm_array3(Markers.L_FAL-Vmarkers.l_ajc);
        Y3 = Vnorm_array3(Vmarkers.l_kjc-Vmarkers.l_ajc);
        X3 = Vnorm_array3(cross(Y3,Z3));
        % Shank parameters
        rP3 = Vmarkers.l_kjc;
        rD3 = Vmarkers.l_ajc;
        w3 = Z3;
        u3 = X3;
        Segment(3).Q = [u3;rP3;rD3;w3];

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

        % Forceplate parameters
        % -------------------------------------------------------------
        rP1 = Grf.P;
        rD1 = zeros(3,1,n);
        u1 = repmat([1;0;0],[1,1,n]);
        w1 = repmat([1;0;0],[1,1,n]);
        Segment(1).Q = [u1;rP1;rD1;w1];

    end

end