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

function [Session,Static,Markers,Vmarkers] = prepareStaticSegmentParameters(Patient,Session,Markers,side,system)

% =========================================================================
% Transform left limb data into right limb data
% =========================================================================
if strcmp(side,'Left')
    names = fieldnames(Markers);
    for i = 1:size(names,1)
        Markers.(names{i})(2,:,:) = -Markers.(names{i})(2,:,:);
    end
end

% =========================================================================
% Compute leg length (thigh length + shank length)
% =========================================================================
if strcmp(system,'BTS')
    x1 = Markers.r_thigh(1,1);
    y1 = Markers.r_thigh(2,1);
    z1 = Markers.r_thigh(3,1);
    x2 = Markers.r_knee_1(1,1);
    y2 = Markers.r_knee_1(2,1);
    z2 = Markers.r_knee_1(3,1);
    x3 = Markers.r_mall(1,1);
    y3 = Markers.r_mall(2,1);
    z3 = Markers.r_mall(3,1);
    Session.right_leg_length = sqrt((x1-x2)^2 + (y1-y2)^2 + (z1-z2)^2) + ...
        sqrt((x2-x3)^2 + (y2-y3)^2 + (z2-z3)^2);
    x1 = Markers.l_thigh(1,1);
    y1 = Markers.l_thigh(2,1);
    z1 = Markers.l_thigh(3,1);
    x2 = Markers.l_knee_1(1,1);
    y2 = Markers.l_knee_1(2,1);
    z2 = Markers.l_knee_1(3,1);
    x3 = Markers.l_mall(1,1);
    y3 = Markers.l_mall(2,1);
    z3 = Markers.l_mall(3,1);
    Session.left_leg_length = sqrt((x1-x2)^2 + (y1-y2)^2 + (z1-z2)^2) + ...
        sqrt((x2-x3)^2 + (y2-y3)^2 + (z2-z3)^2);
elseif strcmp(system,'Qualisys') 
    x1 = Markers.R_FTC(1,1);
    y1 = Markers.R_FTC(2,1);
    z1 = Markers.R_FTC(3,1);
    x2 = Markers.R_FLE(1,1);
    y2 = Markers.R_FLE(2,1);
    z2 = Markers.R_FLE(3,1);
    x3 = Markers.R_FAL(1,1);
    y3 = Markers.R_FAL(2,1);
    z3 = Markers.R_FAL(3,1);
    Session.right_leg_length = sqrt((x1-x2)^2 + (y1-y2)^2 + (z1-z2)^2) + ...
        sqrt((x2-x3)^2 + (y2-y3)^2 + (z2-z3)^2);
    x1 = Markers.L_FTC(1,1);
    y1 = Markers.L_FTC(2,1);
    z1 = Markers.L_FTC(3,1);
    x2 = Markers.L_FLE(1,1);
    y2 = Markers.L_FLE(2,1);
    z2 = Markers.L_FLE(3,1);
    x3 = Markers.L_FAL(1,1);
    y3 = Markers.L_FAL(2,1);
    z3 = Markers.L_FAL(3,1);
    Session.left_leg_length = sqrt((x1-x2)^2 + (y1-y2)^2 + (z1-z2)^2) + ...
        sqrt((x2-x3)^2 + (y2-y3)^2 + (z2-z3)^2);
end

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
    if strcmp(side,'Right')
        Z5 = Vnorm_array3(Markers.r_asis-Markers.l_asis);
    elseif strcmp(side,'Left')
        Z5 = Vnorm_array3(Markers.l_asis-Markers.r_asis);
    end
    Y5 = Vnorm_array3(cross(Z5,(Markers.r_asis+Markers.l_asis)/2-Markers.sacrum));
    X5 = Vnorm_array3(cross(Y5,Z5));
    % Pelvis markers
    Static(5).rM = [Markers.r_asis,Markers.l_asis,Markers.sacrum];
    % Regressions
    if strcmp(Patient.gender,'Homme')
        R_Asis_Dumas = [78;7;112]; %mm
        L_Asis_Dumas = [78;7;-112]; %mm
        R_HJC_Dumas = [56;-75;81]; %mm
        L_HJC_Dumas = [56;-75;-81]; %mm
        LJC_Dumas = [0;0;0]; %mm
        M_Psis_Dumas = [-102;7;0]; %mm
    elseif strcmp(Patient.gender,'Femme')
        R_Asis_Dumas = [87;-13;119]; %mm
        L_Asis_Dumas = [87;-13;-119]; %mm
        R_HJC_Dumas = [54;-93;88]; %mm
        L_HJC_Dumas = [54;-93;-88]; %mm
        LJC_Dumas = [0;0;0]; %mm
        M_Psis_Dumas = [-108;-13;0]; %mm
    end
    w_pelvis = sqrt(sum((Markers.r_asis-Markers.l_asis).^2));
    w_pelvis_Dumas = sqrt(sum((R_Asis_Dumas-L_Asis_Dumas).^2));
    % Lumbar joint center
    LJC = (LJC_Dumas - (R_Asis_Dumas+L_Asis_Dumas)/2)/w_pelvis_Dumas;
    Vmarkers.ljc_static = (Markers.r_asis+Markers.l_asis)/2 + ...
        LJC(1)*w_pelvis*X5 + ...
        LJC(2)*w_pelvis*Y5 + ...
        LJC(3)*w_pelvis*Z5;
    % Hip joint centers
    R_HJC = (R_HJC_Dumas - (R_Asis_Dumas+L_Asis_Dumas)/2)/w_pelvis_Dumas;
    if strcmp(side,'Right')
        Vmarkers.r_hjc_static = (Markers.r_asis+Markers.l_asis)/2 + ...
            R_HJC(1)*w_pelvis*X5 + ...
            R_HJC(2)*w_pelvis*Y5 + ...
            R_HJC(3)*w_pelvis*Z5;
        L_HJC = (L_HJC_Dumas - (R_Asis_Dumas+L_Asis_Dumas)/2)/w_pelvis_Dumas;
        Vmarkers.l_hjc_static = (Markers.r_asis+Markers.l_asis)/2 + ...
            L_HJC(1)*w_pelvis*X5 + ...
            L_HJC(2)*w_pelvis*Y5 + ...
            L_HJC(3)*w_pelvis*Z5;
    elseif strcmp(side,'Left')
        Vmarkers.l_hjc_static = (Markers.r_asis+Markers.l_asis)/2 + ...
            R_HJC(1)*w_pelvis*X5 + ...
            R_HJC(2)*w_pelvis*Y5 + ...
            R_HJC(3)*w_pelvis*Z5;
        L_HJC = (L_HJC_Dumas - (R_Asis_Dumas+L_Asis_Dumas)/2)/w_pelvis_Dumas;
        Vmarkers.r_hjc_static = (Markers.r_asis+Markers.l_asis)/2 + ...
            L_HJC(1)*w_pelvis*X5 + ...
            L_HJC(2)*w_pelvis*Y5 + ...
            L_HJC(3)*w_pelvis*Z5;
    end
    % Pelvis parameters
    rP5 = Vmarkers.ljc_static;
    rD5 = (Vmarkers.r_hjc_static+Vmarkers.l_hjc_static)/2;
    w5 = Z5;
    u5 = X5;
    Static(5).Q = [u5;rP5;rD5;w5];

    if strcmp(side,'Right')

        % Thigh parameters
        % -----------------------------------------------------------------
        % Thigh markers
        Static(4).rM = [Markers.r_thigh,Markers.r_bar_1,Markers.r_knee_1];
        % Optimized solution boundaries: define the points on the technical sphere
        % (x-a)^2+(y-b)^2+(z-c)^2 - r^2 = 0
        TC = permute(Markers.r_knee_1,[3,1,2]);
        aS = TC(1);
        bS = TC(2);
        cS = TC(3);
        rS = Session.right_knee_width/2 + Session.marker_height;
        % Optimization problem constraint: anatomical hypothesis [hjc kjc]
        % perpendicular to [knee_1 kjc]
        X1 = permute(Vmarkers.r_hjc_static,[3,1,2]);
        X2 = permute(Markers.r_knee_1,[3,1,2]);
        % Optimization problem criterion: set the technical plan
        % ax + by + cz + d = 0
        vec1 = permute(Markers.r_bar_1 - Markers.r_knee_1,[3,1,2]);
        vec2 = permute(Markers.r_thigh - Markers.r_knee_1,[3,1,2]);
        orig = permute(Markers.r_knee_1,[3,1,2]);
        temp = cross(vec1,vec2);
        aP = temp(1);
        bP = temp(2);
        cP = temp(3);
        dP = -(aP*orig(1) + bP*orig(2) + cP*orig(3));
        % Solve the optimization problem
        options = optimset('Display','off');
        X0 = [permute(Markers.r_knee_1(1,:,:),[3,1,2]); permute(Markers.r_knee_1(2,:,:),[3,1,2])+rS; permute(Markers.r_knee_1(3,:,:),[3,1,2])];
        f = @(X)([(aP*X(1,:) + bP*X(2,:) + cP*X(3,:) + dP); ...
            dot(X1'-X, X2'-X); ...
            ((X(1,:)-aS)^2+(X(2,:)-bS)^2+(X(3,:)-cS)^2-rS^2)]);
        X = fsolve(f,X0,options);
        % Knee joint center
        Vmarkers.r_kjc_static = X;
        % Thigh axes
        Z4 = Vnorm_array3(Markers.r_knee_1-Vmarkers.r_kjc_static);
        Y4 = Vnorm_array3(Vmarkers.r_hjc_static-Vmarkers.r_kjc_static);
        X4 = Vnorm_array3(cross(Y4,Z4));
        % Thigh parameters
        rP4 = Vmarkers.r_hjc_static;
        rD4 = Vmarkers.r_kjc_static;
        w4 = Z4;
        u4 = X4;
        Static(4).Q = [u4;rP4;rD4;w4];

        % Shank parameters
        % -----------------------------------------------------------------
        % Shank markers
        Static(3).rM = [Markers.r_knee_2,Markers.r_bar_2,Markers.r_mall];
        % Optimized solution boundaries: define the points on the technical sphere
        % (x-a)^2+(y-b)^2+(z-c)^2 - r^2 = 0
        TC = permute(Markers.r_mall,[3,1,2]);
        aS = TC(1);
        bS = TC(2);
        cS = TC(3);
        rS = Session.right_ankle_width/2 + Session.marker_height;
        % Optimization problem constraint: anatomical hypothesis [kjc ajc]
        % perpendicular to [mall ajc]
        X1 = permute(Vmarkers.r_kjc_static,[3,1,2]);
        X2 = permute(Markers.r_mall,[3,1,2]);
        % Optimization problem criterion: set the technical plan
        % ax + by + cz + d = 0
        vec1 = permute(Markers.r_bar_2 - Markers.r_mall,[3,1,2]);
        vec2 = permute(Markers.r_knee_2 - Markers.r_mall,[3,1,2]);
        orig = permute(Markers.r_mall,[3,1,2]);
        temp = cross(vec1,vec2);
        aP = temp(1);
        bP = temp(2);
        cP = temp(3);
        dP = -(aP*orig(1) + bP*orig(2) + cP*orig(3));
        % Solve the optimization problem
        options = optimset('Display','off');
        X0 = [permute(Markers.r_mall(1,:,:),[3,1,2]); permute(Markers.r_mall(2,:,:),[3,1,2])+rS; permute(Markers.r_mall(3,:,:),[3,1,2])];
        f = @(X)([(aP*X(1,:) + bP*X(2,:) + cP*X(3,:) + dP); ...
            dot(X1'-X, X2'-X); ...
            ((X(1,:)-aS)^2+(X(2,:)-bS)^2+(X(3,:)-cS)^2-rS^2)]);
        X = fsolve(f,X0,options);
        % Ankle joint center
        Vmarkers.r_ajc_static = X;
        % Shank axes
        Z3 = Vnorm_array3(Markers.r_mall-Vmarkers.r_ajc_static);
        Y3 = Vnorm_array3(Vmarkers.r_kjc_static-Vmarkers.r_ajc_static);
        X3 = Vnorm_array3(cross(Y3,Z3));
        % Shank parameters
        rP3 = Vmarkers.r_kjc_static;
        rD3 = Vmarkers.r_ajc_static;
        w3 = Z3;
        u3 = X3;
        Static(3).Q = [u3;rP3;rD3;w3];

        % Foot parameters
        % -----------------------------------------------------------------
        % Foot markers
        Static(2).rM = [Markers.r_met];
        % Foot axes
        Z2 = Z3;
        Y2 = Vnorm_array3(Markers.r_mall-Markers.r_met);
        X2 = Vnorm_array3(cross(Y2,Z2));
        % Foot parameters
        rP2 = Markers.r_mall;
        rD2 = Markers.r_met;
        w2 = Z2;
        u2 = X2;
        Static(2).Q = [u2;rP2;rD2;w2];

    elseif strcmp(side,'Left')

        % Thigh parameters
        % -----------------------------------------------------------------
        % Thigh markers
        Static(4).rM = [Markers.l_thigh,Markers.l_bar_1,Markers.l_knee_1];
        % Optimized solution boundaries: define the points on the technical sphere
        % (x-a)^2+(y-b)^2+(z-c)^2 - r^2 = 0
        TC = permute(Markers.l_knee_1,[3,1,2]);
        aS = TC(1);
        bS = TC(2);
        cS = TC(3);
        rS = Session.left_knee_width/2 + Session.marker_height;
        % Optimization problem constraint: anatomical hypothesis [hjc kjc]
        % perpendicular to [knee_1 kjc]
        X1 = permute(Vmarkers.l_hjc_static,[3,1,2]);
        X2 = permute(Markers.l_knee_1,[3,1,2]);
        % Optimization problem criterion: set the technical plan
        % ax + by + cz + d = 0
        vec1 = permute(Markers.l_bar_1 - Markers.l_knee_1,[3,1,2]);
        vec2 = permute(Markers.l_thigh - Markers.l_knee_1,[3,1,2]);
        orig = permute(Markers.l_knee_1,[3,1,2]);
        temp = cross(vec1,vec2);
        aP = temp(1);
        bP = temp(2);
        cP = temp(3);
        dP = -(aP*orig(1) + bP*orig(2) + cP*orig(3));
        clear vec1 vec2 orig temp
        % Solve the optimization problem
        options = optimset('Display','off');
        X0 = [permute(Markers.l_knee_1(1,:,:),[3,1,2]); permute(Markers.l_knee_1(2,:,:),[3,1,2])+rS; permute(Markers.l_knee_1(3,:,:),[3,1,2])];
        f = @(X)([(aP*X(1,:) + bP*X(2,:) + cP*X(3,:) + dP); ...
            dot(X1'-X, X2'-X); ...
            ((X(1,:)-aS)^2+(X(2,:)-bS)^2+(X(3,:)-cS)^2-rS^2)]);
        X = fsolve(f,X0,options);
        % Knee joint center
        Vmarkers.l_kjc_static = X;
        % Thigh axes
        Z4 = Vnorm_array3(Markers.l_knee_1-Vmarkers.l_kjc_static);
        Y4 = Vnorm_array3(Vmarkers.l_hjc_static-Vmarkers.l_kjc_static);
        X4 = Vnorm_array3(cross(Y4,Z4));
        % Thigh parameters
        rP4 = Vmarkers.l_hjc_static;
        rD4 = Vmarkers.l_kjc_static;
        w4 = Z4;
        u4 = X4;
        Static(4).Q = [u4;rP4;rD4;w4];

        % Shank parameters
        % -----------------------------------------------------------------
        % Shank markers
        Static(3).rM = [Markers.l_knee_2,Markers.l_bar_2,Markers.l_mall];
        % Optimized solution boundaries: define the points on the technical sphere
        % (x-a)^2+(y-b)^2+(z-c)^2 - r^2 = 0
        TC = permute(Markers.l_mall,[3,1,2]);
        aS = TC(1);
        bS = TC(2);
        cS = TC(3);
        rS = Session.left_ankle_width/2 + Session.marker_height;
        % Optimization problem constraint: anatomical hypothesis [kjc ajc]
        % perpendicular to [mall ajc]
        X1 = permute(Vmarkers.l_kjc_static,[3,1,2]);
        X2 = permute(Markers.l_mall,[3,1,2]);
        % Optimization problem criterion: set the technical plan
        % ax + by + cz + d = 0
        vec1 = permute(Markers.l_bar_2 - Markers.l_mall,[3,1,2]);
        vec2 = permute(Markers.l_knee_2 - Markers.l_mall,[3,1,2]);
        orig = permute(Markers.l_mall,[3,1,2]);
        temp = cross(vec1,vec2);
        aP = temp(1);
        bP = temp(2);
        cP = temp(3);
        dP = -(aP*orig(1) + bP*orig(2) + cP*orig(3));
        % Solve the optimization problem
        options = optimset('Display','off');
        X0 = [permute(Markers.l_mall(1,:,:),[3,1,2]); permute(Markers.l_mall(2,:,:),[3,1,2])+rS; permute(Markers.l_mall(3,:,:),[3,1,2])];
        f = @(X)([(aP*X(1,:) + bP*X(2,:) + cP*X(3,:) + dP); ...
            dot(X1'-X, X2'-X); ...
            ((X(1,:)-aS)^2+(X(2,:)-bS)^2+(X(3,:)-cS)^2-rS^2)]);
        X = fsolve(f,X0,options);
        % Ankle joint center
        Vmarkers.l_ajc_static = X;
        % Shank axes
        Z3 = Vnorm_array3(Markers.l_mall-Vmarkers.l_ajc_static);
        Y3 = Vnorm_array3(Vmarkers.l_kjc_static-Vmarkers.l_ajc_static);
        X3 = Vnorm_array3(cross(Y3,Z3));
        % Shank parameters
        rP3 = Vmarkers.l_kjc_static;
        rD3 = Vmarkers.l_ajc_static;
        w3 = Z3;
        u3 = X3;
        Static(3).Q = [u3;rP3;rD3;w3];

        % Foot parameters
        % -----------------------------------------------------------------
        % Foot markers
        Static(2).rM = [Markers.l_met];
        % Foot axes
        Z2 = Z3;
        Y2 = Vnorm_array3(Markers.l_mall-Markers.l_met);
        X2 = Vnorm_array3(cross(Y2,Z2));
        % Foot parameters
        rP2 = Markers.l_mall;
        rD2 = Markers.l_met;
        w2 = Z2;
        u2 = X2;
        Static(2).Q = [u2;rP2;rD2;w2];

    end

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
        if strcmp(side,'Right')
            Z5 = Vnorm_array3(Markers.R_IAS-Markers.L_IAS);
        elseif strcmp(side,'Left')
            Z5 = Vnorm_array3(Markers.L_IAS-Markers.R_IAS);
        end
        Y5 = Vnorm_array3(cross(Z5,(Markers.R_IAS+Markers.L_IAS)/2-(Markers.R_IPS+Markers.L_IPS)/2));
        X5 = Vnorm_array3(cross(Y5,Z5));
        % Pelvis markers
        Static(5).rM = [Markers.R_IAS,Markers.L_IAS,Markers.R_IPS,Markers.L_IPS];
        % Regressions
        if strcmp(Patient.gender,'Homme')
            R_Asis_Dumas = [78;7;112]; %mm
            L_Asis_Dumas = [78;7;-112]; %mm
            R_HJC_Dumas = [56;-75;81]; %mm
            L_HJC_Dumas = [56;-75;-81]; %mm
            LJC_Dumas = [0;0;0]; %mm
            M_Psis_Dumas = [-102;7;0]; %mm
        elseif strcmp(Patient.gender,'Femme')
            R_Asis_Dumas = [87;-13;119]; %mm
            L_Asis_Dumas = [87;-13;-119]; %mm
            R_HJC_Dumas = [54;-93;88]; %mm
            L_HJC_Dumas = [54;-93;-88]; %mm
            LJC_Dumas = [0;0;0]; %mm
            M_Psis_Dumas = [-108;-13;0]; %mm
        end
        w_pelvis = sqrt(sum((Markers.R_IAS-Markers.L_IAS).^2));
        w_pelvis_Dumas = sqrt(sum((R_Asis_Dumas-L_Asis_Dumas).^2));
        % Lumbar joint center
        LJC = (LJC_Dumas - (R_Asis_Dumas+L_Asis_Dumas)/2)/w_pelvis_Dumas;
        Vmarkers.ljc_static = (Markers.R_IAS+Markers.L_IAS)/2 + ...
            LJC(1)*w_pelvis*X5 + ...
            LJC(2)*w_pelvis*Y5 + ...
            LJC(3)*w_pelvis*Z5;
        % Hip joint centers
        R_HJC = (R_HJC_Dumas - (R_Asis_Dumas+L_Asis_Dumas)/2)/w_pelvis_Dumas;
        L_HJC = (L_HJC_Dumas - (R_Asis_Dumas+L_Asis_Dumas)/2)/w_pelvis_Dumas;
        if strcmp(side,'Right')
            Vmarkers.r_hjc_static = (Markers.R_IAS+Markers.L_IAS)/2 + ...
                R_HJC(1)*w_pelvis*X5 + ...
                R_HJC(2)*w_pelvis*Y5 + ...
                R_HJC(3)*w_pelvis*Z5;
            Vmarkers.l_hjc_static = (Markers.R_IAS+Markers.L_IAS)/2 + ...
                L_HJC(1)*w_pelvis*X5 + ...
                L_HJC(2)*w_pelvis*Y5 + ...
                L_HJC(3)*w_pelvis*Z5;
        elseif strcmp(side,'Left')
            Vmarkers.l_hjc_static = (Markers.R_IAS+Markers.L_IAS)/2 + ...
                R_HJC(1)*w_pelvis*X5 + ...
                R_HJC(2)*w_pelvis*Y5 + ...
                R_HJC(3)*w_pelvis*Z5;
            Vmarkers.r_hjc_static = (Markers.R_IAS+Markers.L_IAS)/2 + ...
                L_HJC(1)*w_pelvis*X5 + ...
                L_HJC(2)*w_pelvis*Y5 + ...
                L_HJC(3)*w_pelvis*Z5;
        end
        % HARA joint center
        if strcmp(side,'Right')
            Vmarkers.r_hjc_static = (Markers.R_IAS+Markers.L_IAS)/2 + ...
                11/1000 - 0.063 *Session.right_leg_length*X5 + ...
                8/1000  + 0.086 *Session.right_leg_length*Z5 + ...
                -9/1000 - 0.078 *Session.right_leg_length*Y5;
            Vmarkers.l_hjc_static = (Markers.R_IAS+Markers.L_IAS)/2 + ...
                11/1000 - 0.063 *Session.right_leg_length*X5 + ...
                -8/1000 - 0.086 *Session.right_leg_length*Z5 + ...
                -9/1000 - 0.078 *Session.right_leg_length*Y5;
        elseif strcmp(side,'Left')
            Vmarkers.l_hjc_static = (Markers.R_IAS+Markers.L_IAS)/2 + ...
                11/1000 - 0.063 *Session.right_leg_length*X5 + ...
                8/1000  + 0.086 *Session.right_leg_length*Z5 + ...
                -9/1000 - 0.078 *Session.right_leg_length*Y5;
            Vmarkers.r_hjc_static = (Markers.R_IAS+Markers.L_IAS)/2 + ...
                11/1000 - 0.063 *Session.right_leg_length*X5 + ...
                -8/1000 - 0.086 *Session.right_leg_length*Z5 + ...
                -9/1000 - 0.078 *Session.right_leg_length*Y5;
        end
        % Pelvis parameters
        rP5 = Vmarkers.ljc_static;
        rD5 = (Vmarkers.r_hjc_static+Vmarkers.l_hjc_static)/2;
        w5 = Z5;
        u5 = X5;
        Static(5).Q = [u5;rP5;rD5;w5];

        if strcmp(side,'Right')

            % Thigh parameters
            % -----------------------------------------------------------------
            % Thigh markers
            Static(4).rM = [Markers.R_FTC,Markers.R_FLE,Vmarkers.r_hjc_static];
            % Knee joint center
            Vmarkers.r_kjc_static = (Markers.R_FLE+Markers.R_FME)/2;
            % Thigh axes
            Z4 = Vnorm_array3(Markers.R_FLE-Vmarkers.r_kjc_static);
            Y4 = Vnorm_array3(Vmarkers.r_hjc_static-Vmarkers.r_kjc_static);
            X4 = Vnorm_array3(cross(Y4,Z4));
            % Thigh parameters
            rP4 = Vmarkers.r_hjc_static;
            rD4 = Vmarkers.r_kjc_static;
            w4 = Z4;
            u4 = X4;
            Static(4).Q = [u4;rP4;rD4;w4];
            
        elseif strcmp(side,'Left')

            % Thigh parameters
            % -----------------------------------------------------------------
            % Thigh markers
            Static(4).rM = [Markers.L_FTC,Markers.L_FLE,Vmarkers.l_hjc_static];
            % Knee joint center
            Vmarkers.l_kjc_static = (Markers.L_FLE+Markers.L_FME)/2;
            % Thigh axes
            Z4 = Vnorm_array3(Markers.L_FLE-Vmarkers.l_kjc_static);
            Y4 = Vnorm_array3(Vmarkers.l_hjc_static-Vmarkers.l_kjc_static);
            X4 = Vnorm_array3(cross(Y4,Z4));
            % Thigh parameters
            rP4 = Vmarkers.l_hjc_static;
            rD4 = Vmarkers.l_kjc_static;
            w4 = Z4;
            u4 = X4;
            Static(4).Q = [u4;rP4;rD4;w4];
        end

    if strcmp(side,'Right')
        % Shank parameters
        % -----------------------------------------------------------------
        % Shank markers
        Static(3).rM = [Markers.R_FAX,Markers.R_TTC,Markers.R_FAL];
        % Ankle joint center
        Vmarkers.r_ajc_static = (Markers.R_FAL+Markers.R_TAM)/2;
        % Shank axes
        Z3 = Vnorm_array3(Markers.R_FAL-Vmarkers.r_ajc_static);
        Y3 = Vnorm_array3(Vmarkers.r_kjc_static-Vmarkers.r_ajc_static);
        X3 = Vnorm_array3(cross(Y3,Z3));
        % Shank parameters
        rP3 = Vmarkers.r_kjc_static;
        rD3 = Vmarkers.r_ajc_static;
        w3 = Z3;
        u3 = X3;
        Static(3).Q = [u3;rP3;rD3;w3];

        % Foot parameters
        % -----------------------------------------------------------------
        % Foot markers
        Static(2).rM = [Markers.R_FCC,Markers.R_FM1,Markers.R_FM5];
        % Foot axes
        Z2 = Vnorm_array3(Markers.R_FM5-Markers.R_FM1);
        Y2 = Vnorm_array3(Markers.R_FCC-(Markers.R_FM5+Markers.R_FM1)/2);
        X2 = Vnorm_array3(cross(Y2,Z2));
        % Foot parameters
        rP2 = Vmarkers.r_ajc_static;
        rD2 = (Markers.R_FM5+Markers.R_FM1)/2;
        w2 = Z2;
        u2 = X2;
        Static(2).Q = [u2;rP2;rD2;w2];

    elseif strcmp(side,'Left')

        % Shank parameters
        % -----------------------------------------------------------------
        % Shank markers
        Static(3).rM = [Markers.L_FAX,Markers.L_TTC,Markers.L_FAL];
        % Ankle joint center
        Vmarkers.l_ajc_static = (Markers.L_FAL+Markers.L_TAM)/2;
        % Shank axes
        Z3 = Vnorm_array3(Markers.L_FAL-Vmarkers.l_ajc_static);
        Y3 = Vnorm_array3(Vmarkers.l_kjc_static-Vmarkers.l_ajc_static);
        X3 = Vnorm_array3(cross(Y3,Z3));
        % Shank parameters
        rP3 = Vmarkers.l_kjc_static;
        rD3 = Vmarkers.l_ajc_static;
        w3 = Z3;
        u3 = X3;
        Static(3).Q = [u3;rP3;rD3;w3];

        % Foot parameters
        % -----------------------------------------------------------------
        % Foot markers
        Static(2).rM = [Markers.L_FCC,Markers.L_FM1,Markers.L_FM5];
        % Foot axes
        Z2 = Vnorm_array3(Markers.L_FM5-Markers.L_FM1);
        Y2 = Vnorm_array3(Markers.L_FCC-(Markers.L_FM5+Markers.L_FM1)/2);
        X2 = Vnorm_array3(cross(Y2,Z2));
        % Foot parameters
        rP2 = Vmarkers.l_ajc_static;
        rD2 = (Markers.L_FM5+Markers.L_FM1)/2;
        w2 = Z2;
        u2 = X2;
        Static(2).Q = [u2;rP2;rD2;w2];

    end
    
    for i = 2:5
        Static(i).T = Q2Tuv_array3(Static(i).Q);
    end
    
end