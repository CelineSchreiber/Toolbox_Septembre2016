function [Kinematics] = prepareCycleSegmentParametersFootOnly(Markers,Gait,n,side)

if strcmp(Gait.gaittrial,'yes')
    
    % =====================================================================
    % Transform left limb data into right limb data
    % =====================================================================
    names = fieldnames(Markers);
    if strcmp(side,'Left')
        for i = 1:size(names,1)
            Markers.(names{i})(3,:,:) = -Markers.(names{i})(3,:,:);
        end
    end
    
    % Foot parameters
    % -------------------------------------------------------------
    if strcmp(side,'Right')
        % Foot Markers 
        Segment(2).rM = [Markers.R_FCC,Markers.R_FM1,Markers.R_FM5];
        % Foot axes
        Z2 = Vnorm_array3(Markers.R_FM5-Markers.R_FM1);
        Y2 = Vnorm_array3(Markers.R_FCC-(Markers.R_FM5+Markers.R_FM1)/2);
        X2 = Vnorm_array3(cross(Y2,Z2));
        % Foot parameters
        rP2 = (Markers.R_FAL+Markers.R_TAM)/2;
        rD2 = (Markers.R_FM5+Markers.R_FM1)/2;
        w2 = Z2;
        u2 = X2;
        Segment(2).Q = [u2;rP2;rD2;w2];
    elseif strcmp(side,'Left')
        % Foot Markers 
        Segment(2).rM = [Markers.L_FCC,Markers.L_FM1,Markers.L_FM5];
        % Foot axes
        Z2 = Vnorm_array3(Markers.L_FM5-Markers.L_FM1);
        Y2 = Vnorm_array3(Markers.L_FCC-(Markers.L_FM5+Markers.L_FM1)/2);
        X2 = Vnorm_array3(cross(Y2,Z2));
        % Foot parameters
        rP2 = (Markers.L_FAL+Markers.L_TAM)/2;
        rD2 = (Markers.L_FM5+Markers.L_FM1)/2;
        w2 = Z2;
        u2 = X2;
        Segment(2).Q = [u2;rP2;rD2;w2];
    end
    
    Kinematics.Ftilt = [];Kinematics.Frota=[];Kinematics.Fobli=[];
    % Tilt        
    Foot.T = Q2Tw_array3(Segment(2).Q);
    Foot.Euler = R2fixedZYX_array3(Foot.T(1:3,1:3,:));
    Foot.tilt = permute(Foot.Euler(:,1,:),[3,2,1])*180/pi-90;
    % Obliquity        
    Foot.obli = -permute(Foot.Euler(:,3,:),[3,2,1])*180/pi;
    % Progression angle (rotation)
    if strcmp(side,'Right')
        M1 = Markers.R_FCC;
        M2 = Markers.R_FM1;
        M3 = Markers.R_FM5;
    elseif strcmp(side,'Left')
        M1 = Markers.L_FCC;
        M2 = Markers.L_FM1;
        M3 = Markers.L_FM5;
    end
    beta = -20; % technical offset to avoid gimble lock
    V1 = Vnorm_array3(cross(M3-M2,M1-M2));
    V2 = repmat([0;0;1],[1,1,n]);
    V3 = cross(V1,V2);
    V4 = Vnorm_array3((M2+M3)/2-M1);
    V5 = cross(V4,V1);
    V6 = -sind(beta)*V4 + cosd(beta)*V5;
    for i = 1:n
        Foot.rota(i) = -(rad2deg(atan2(norm(cross(V6(:,:,i),V3(:,:,i))),...
            dot(V6(:,:,i),V3(:,:,i))))-90+beta);
    end
    
    k = (1:n)';
    ko = (linspace(1,n,101))';
    Kinematics.Ftilt = interp1(k,Foot.tilt,ko,'spline');
    Kinematics.Frota = interp1(k,Foot.rota,ko,'spline');
    Kinematics.Fobli = interp1(k,Foot.obli,ko,'spline');
    
end