function Sensitivity = computeSensitivity(side,system,Markers,Vmarkers,kinematics)


% =========================================================================
% Initialisation
% =========================================================================
names=[];names=fieldnames(kinematics);
for i=1:length(names)
    Diff_kin.(names{i}) = diff(kinematics.(names{i}));
    Diff_kin.(names{i}) = interp1((1:100)',Diff_kin.(names{i}),linspace(1,100,101)','spline');
end

if strcmp(system,'BTS')
    if strcmp(side,'Right')
        Yo = permute(Markers.l_met,[3,1,2]);
        Yt = permute(Markers.r_met,[3,1,2]);
        Ya = permute(Vmarkers.r_ajc,[3,1,2]);
        Yk = permute(Vmarkers.r_kjc,[3,1,2]);
        Yh = permute(Vmarkers.r_hjc,[3,1,2]);
        Yp = permute(Vmarkers.ljc,[3,1,2]);
    else
        Yo = permute(Markers.r_met,[3,1,2]);
        Yt = permute(Markers.l_met,[3,1,2]);
        Ya = permute(Vmarkers.l_ajc,[3,1,2]);
        Yk = permute(Vmarkers.l_kjc,[3,1,2]);
        Yh = permute(Vmarkers.l_hjc,[3,1,2]);
        Yp = permute(Vmarkers.ljc,[3,1,2]);
    end
else
    if strcmp(side,'Right')
        Yo = permute(Markers.L_FM5,[3,1,2]);
        Yt = permute(Markers.R_FM5,[3,1,2]);
        Ya = permute(Vmarkers.r_ajc,[3,1,2]);
        Yk = permute(Vmarkers.r_kjc,[3,1,2]);
        Yh = permute(Vmarkers.r_hjc,[3,1,2]);
        Yp = permute(Vmarkers.ljc,[3,1,2]);
    else
        Yo = permute(Markers.R_FM5,[3,1,2]);
        Yt = permute(Markers.L_FM5,[3,1,2]);
        Ya = permute(Vmarkers.l_ajc,[3,1,2]);
        Yk = permute(Vmarkers.l_kjc,[3,1,2]);
        Yh = permute(Vmarkers.l_hjc,[3,1,2]);
        Yp = permute(Vmarkers.ljc,[3,1,2]);
    end
end 
Sensitivity=[];
Sensitivity.function.Ptilt= Yp(:,1)-Yt(:,1);
Sensitivity.function.FE4  = Yt(:,1)-Yh(:,1);
Sensitivity.function.FE3  = Yk(:,1)-Yt(:,1);
Sensitivity.function.FE2  = Yt(:,1)-Ya(:,1);
Sensitivity.function.Pobli= Yt(:,3)-Yp(:,3);
Sensitivity.function.AA4  = Yh(:,3)-Yt(:,3);
Sensitivity.function.AA3  = Yk(:,3)-Yt(:,3);
Sensitivity.function.AA2  = Yt(:,3)-Ya(:,3);

names=fieldnames(Sensitivity.function);
n=length(Sensitivity.function.(names{1}));
k = (1:n)';
ko = (linspace(1,n,101))';
for i=1:length(names)
    Sensitivity.function.(names{i})    = interp1(k,Sensitivity.function.(names{i}),ko,'spline');
    Sensitivity.contribution.(names{i})= Sensitivity.function.(names{i}) .* Diff_kin.(names{i}) * (pi/180);
end

Sensitivity.contribution.FE3 = -Sensitivity.contribution.FE3;
Sensitivity.contribution.Ptilt = -Sensitivity.contribution.Ptilt;
Sensitivity.contribution.Pobli = -Sensitivity.contribution.Pobli;
 
Sensitivity.Tot_sag_contribution = Sensitivity.contribution.Ptilt +...
    Sensitivity.contribution.FE4 + Sensitivity.contribution.FE3 + Sensitivity.contribution.FE2;
Sensitivity.Tot_front_contribution = Sensitivity.contribution.Pobli +...
    Sensitivity.contribution.AA4 + Sensitivity.contribution.AA2; %+Sensitivity.contribution.AA3
Sensitivity.Vaulting = diff(Yp(:,2));
Sensitivity.Vaulting = interp1((1:(n-1))',Sensitivity.Vaulting,linspace(1,n-1,101)','spline');
Sensitivity.Total_contribution = Sensitivity.Tot_sag_contribution + ...
    Sensitivity.Tot_front_contribution;

Sensitivity.Clearance = kinematics.Clearance;
Sensitivity.Diff_Clearance = diff(kinematics.Clearance);
Sensitivity.Diff_Clearance = interp1((1:100)',Sensitivity.Diff_Clearance,linspace(1,100,101)','spline');

Dist=abs(Yo(:,1)-Yt(:,1));
Dist=interp1(k,Dist,ko,'spline');
[M,T]=min(Dist(50:end));
Sensitivity.Time = T+49;


