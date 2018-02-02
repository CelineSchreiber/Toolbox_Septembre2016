function [Segment,Joint] = Inverse_Dynamics_HM(Segment,Joint,f,n)

k = 1:n;
ko = linspace(1,n,100);

% Extend segment fields
Segment = Extend_Segment_Fields(Segment);

for i = 2:4  % From i = 2 foot (or hand) to i = 4 thigh (or arm)

    % Homogenous matrix of pseudo-inertia expressed in SCS (Js)
    Segment(i).Js = ...
        [(Segment(i).Is(1,1) + ...
        Segment(i).Is(2,2) + ...
        Segment(i).Is(3,3))/2 * ...
        eye(3) - Segment(i).Is,Segment(i).m * Segment(i).rCs;
        Segment(i).m * (Segment(i).rCs)',Segment(i).m];

end

% Transformation form origin of ICS to COP in ICS
T(1:3,4,:) = Segment(1).T(1:3,4,:);
T(1,1,:) = 1; % in ICS
T(2,2,:) = 1; % in ICS
T(3,3,:) = 1; % in ICS
T(4,4,:) = 1;
% Homogenous matrix of GR force and moment at origin of ICS (phi)
% with transpose = permute( ,[2,1,3])
Joint(1).phi = Mprod_array3(T,Mprod_array3(...
    [Vskew_array3(Joint(1).M),Joint(1).F;...
    - permute(Joint(1).F,[2,1,3]),zeros(1,1,n)],...
    permute(T,[2,1,3])));

% Kinematics
Segment = Kinematics_HM(Segment,f,n);

% Dynamics
[Joint,Segment] = Dynamics_HM(Joint,Segment,n);

% 100% of gait cycle (or of propulsive cycle)
% Ankle (or wrist)
LM2_HM = interp1(k,permute(Joint(2).F(1,1,:),[3,1,2]),ko,'spline')';  % in JCS
PD2_HM = interp1(k,permute(Joint(2).F(2,1,:),[3,1,2]), ko,'spline')'; % in JCS
AP2_HM = interp1(k,permute(Joint(2).F(3,1,:),[3,1,2]),ko,'spline')'; % in JCS
FE2_HM = interp1(k,permute(Joint(2).M(1,1,:),[3,1,2]),ko,'spline')'; % in JCS
IER2_HM = interp1(k,permute(Joint(2).M(2,1,:),[3,1,2]),ko,'spline')'; % in JCS
AA2_HM = interp1(k,permute(Joint(2).M(3,1,:),[3,1,2]),ko,'spline')'; % in JCS
OmegaX2_HM = interp1(k,permute(Segment(2).Omega(1,1,:),[3,1,2]),ko,'spline')'; % in ICS
OmegaY2_HM = interp1(k,permute(Segment(2).Omega(2,1,:),[3,1,2]),ko,'spline')'; % in ICS
OmegaZ2_HM = interp1(k,permute(Segment(2).Omega(3,1,:),[3,1,2]),ko,'spline')'; % in ICS
AlphaX2_HM = interp1(k,permute(Segment(2).Alpha(1,1,:),[3,1,2]),ko,'spline')'; % in ICS
AlphaY2_HM = interp1(k,permute(Segment(2).Alpha(2,1,:),[3,1,2]),ko,'spline')'; % in ICS
AlphaZ2_HM = interp1(k,permute(Segment(2).Alpha(3,1,:),[3,1,2]),ko,'spline')'; % in ICS
VX2_HM = interp1(k,permute(Segment(2).V(1,1,:),[3,1,2]),ko,'spline')'; % in ICS
VY2_HM = interp1(k,permute(Segment(2).V(2,1,:),[3,1,2]),ko,'spline')'; % in ICS
VZ2_HM = interp1(k,permute(Segment(2).V(3,1,:),[3,1,2]),ko,'spline')'; % in ICS
AX2_HM = interp1(k,permute(Segment(2).A(1,1,:),[3,1,2]),ko,'spline')'; % in ICS
AY2_HM = interp1(k,permute(Segment(2).A(2,1,:),[3,1,2]),ko,'spline')'; % in ICS
AZ2_HM = interp1(k,permute(Segment(2).A(3,1,:),[3,1,2]),ko,'spline')'; % in ICS
% Knee (or elbow)
LM3_HM = interp1(k,permute(Joint(3).F(1,1,:),[3,1,2]),ko,'spline')'; % in JCS
AP3_HM = interp1(k,permute(Joint(3).F(2,1,:),[3,1,2]),ko,'spline')'; % in JCS
PD3_HM = interp1(k,permute(Joint(3).F(3,1,:),[3,1,2]),ko,'spline')'; % in JCS
FE3_HM = interp1(k,permute(Joint(3).M(1,1,:),[3,1,2]),ko,'spline')'; % in JCS
AA3_HM = interp1(k,permute(Joint(3).M(2,1,:),[3,1,2]),ko,'spline')'; % in JCS
IER3_HM = interp1(k,permute(Joint(3).M(3,1,:),[3,1,2]),ko,'spline')'; % in JCS
OmegaX3_HM = interp1(k,permute(Segment(3).Omega(1,1,:),[3,1,2]),ko,'spline')'; % in ICS
OmegaY3_HM = interp1(k,permute(Segment(3).Omega(2,1,:),[3,1,2]),ko,'spline')'; % in ICS
OmegaZ3_HM = interp1(k,permute(Segment(3).Omega(3,1,:),[3,1,2]),ko,'spline')'; % in ICS
AlphaX3_HM = interp1(k,permute(Segment(3).Alpha(1,1,:),[3,1,2]),ko,'spline')'; % in ICS
AlphaY3_HM = interp1(k,permute(Segment(3).Alpha(2,1,:),[3,1,2]),ko,'spline')'; % in ICS
AlphaZ3_HM = interp1(k,permute(Segment(3).Alpha(3,1,:),[3,1,2]),ko,'spline')'; % in ICS
VX3_HM = interp1(k,permute(Segment(3).V(1,1,:),[3,1,2]),ko,'spline')'; % in ICS
VY3_HM = interp1(k,permute(Segment(3).V(2,1,:),[3,1,2]),ko,'spline')'; % in ICS
VZ3_HM = interp1(k,permute(Segment(3).V(3,1,:),[3,1,2]),ko,'spline')'; % in ICS
AX3_HM = interp1(k,permute(Segment(3).A(1,1,:),[3,1,2]),ko,'spline')'; % in ICS
AY3_HM = interp1(k,permute(Segment(3).A(2,1,:),[3,1,2]),ko,'spline')'; % in ICS
AZ3_HM = interp1(k,permute(Segment(3).A(3,1,:),[3,1,2]),ko,'spline')'; % in ICS
% Hip (or shoulder)
LM4_HM = interp1(k,permute(Joint(4).F(1,1,:),[3,1,2]),ko,'spline')';
AP4_HM = interp1(k,permute(Joint(4).F(2,1,:),[3,1,2]),ko,'spline')';
PD4_HM = interp1(k,permute(Joint(4).F(3,1,:),[3,1,2]),ko,'spline')';
FE4_HM = interp1(k,permute(Joint(4).M(1,1,:),[3,1,2]),ko,'spline')';
AA4_HM = interp1(k,permute(Joint(4).M(2,1,:),[3,1,2]),ko,'spline')';
IER4_HM = interp1(k,permute(Joint(4).M(3,1,:),[3,1,2]),ko,'spline')';
OmegaX4_HM = interp1(k,permute(Segment(4).Omega(1,1,:),[3,1,2]),ko,'spline')'; % in ICS
OmegaY4_HM = interp1(k,permute(Segment(4).Omega(2,1,:),[3,1,2]),ko,'spline')'; % in ICS
OmegaZ4_HM = interp1(k,permute(Segment(4).Omega(3,1,:),[3,1,2]),ko,'spline')'; % in ICS
AlphaX4_HM = interp1(k,permute(Segment(4).Alpha(1,1,:),[3,1,2]),ko,'spline')'; % in ICS
AlphaY4_HM = interp1(k,permute(Segment(4).Alpha(2,1,:),[3,1,2]),ko,'spline')'; % in ICS
AlphaZ4_HM = interp1(k,permute(Segment(4).Alpha(3,1,:),[3,1,2]),ko,'spline')'; % in ICS
VX4_HM = interp1(k,permute(Segment(4).V(1,1,:),[3,1,2]),ko,'spline')'; % in ICS
VY4_HM = interp1(k,permute(Segment(4).V(2,1,:),[3,1,2]),ko,'spline')'; % in ICS
VZ4_HM = interp1(k,permute(Segment(4).V(3,1,:),[3,1,2]),ko,'spline')'; % in ICS
AX4_HM = interp1(k,permute(Segment(4).A(1,1,:),[3,1,2]),ko,'spline')'; % in ICS
AY4_HM = interp1(k,permute(Segment(4).A(2,1,:),[3,1,2]),ko,'spline')'; % in ICS
AZ4_HM = interp1(k,permute(Segment(4).A(3,1,:),[3,1,2]),ko,'spline')'; % in ICS

% Figure for ankle (or wrist) joint force and moment
figure;
hold on;
% Lateral Medial
subplot(2,3,1);
hold on;
plot(LM2_HM,'Color','black','LineStyle','-');
title ('Right Ankle (or Wrist) Lateral (+) /  Medial (-)');
xlabel('% of Gait (or Proplusion) Cycle');
ylabel('Force (in N)');
% Anterior Posterior
subplot(2,3,2);
hold on;
plot(AP2_HM,'Color','black','LineStyle','-');
title ('Right Ankle (or Wrist) Anterior (+) / Posterior (-)');
xlabel('% of Gait (or Proplusion) Cycle');
ylabel('Force (in N)');
% Proximal Distal
subplot(2,3,3);
hold on;
plot(PD2_HM,'Color','black','LineStyle','-');
title ('Right Ankle (or Wrist)  Proximal (+) / Distal (-)');
xlabel('% of Gait (or Proplusion) Cycle');
ylabel('Force (in N)');
% Flexion Extension
subplot(2,3,4);
hold on;
plot(FE2_HM,'Color','black','LineStyle','-');
title ('Right Ankle (or Wrist) Flexion (+) / Extension(-)');
xlabel('% of Gait (or Proplusion) Cycle');
ylabel('Moment (in N.m)');
% Adduction Abduction
subplot(2,3,5);
hold on;
plot(AA2_HM,'Color','black','LineStyle','-');
title ('Right Ankle (or Wrist) Adduction (+) / Abduction (-)');
xlabel('% of Gait (or Proplusion) Cycle');
ylabel('Moment (in N.m)');
% Internal External Rotation
subplot(2,3,6);
hold on;
plot(IER2_HM,'Color','black','LineStyle','-');
title ('Right Ankle (or Wrist) Internal (+) / External (-) Rotation');
xlabel('% of Gait (or Proplusion) Cycle');
ylabel('Moment (in N.m)');

% Figure for knee (or elbow) joint force and moment
figure;
hold on;
% Lateral Medial
subplot(2,3,1);
hold on;
plot(LM3_HM,'Color','black','LineStyle','-');
title ('Right Knee (or Elbow) Lateral (+) /  Medial (-)');
xlabel('% of Gait (or Proplusion) Cycle');
ylabel('Force (in N)');
% Anterior Posterior
subplot(2,3,2);
hold on;
plot(AP3_HM,'Color','black','LineStyle','-');
title ('Right Knee (or Elbow) Anterior (+) / Posterior (-)');
xlabel('% of Gait (or Proplusion) Cycle');
ylabel('Force (in N)');
% Proximal Distal
subplot(2,3,3);
hold on;
plot(PD3_HM,'Color','black','LineStyle','-');
title ('Right Knee (or Elbow) Proximal (+) / Distal (-)');
xlabel('% of Gait (or Proplusion) Cycle');
ylabel('Force (in N)');
% Flexion Extension
subplot(2,3,4);
hold on;
plot(FE3_HM,'Color','black','LineStyle','-');
title (['  Right Knee Extension (+) / Flexion (-)   '; ...
    '(or Right Elbow Flexion (+) / Extension(-))']);
xlabel('% of Gait (or Proplusion) Cycle');
ylabel('Moment (in N.m)');
% Adduction Abduction
subplot(2,3,5);
hold on;
plot(AA3_HM,'Color','black','LineStyle','-');
title ('Right Knee (or Elbow) Adduction (+) / Abduction (-)');
xlabel('% of Gait (or Proplusion) Cycle');
ylabel('Moment (in N.m)');
% Internal External Rotation
subplot(2,3,6);
hold on;
plot(IER3_HM,'Color','black','LineStyle','-');
title ('Right Knee (or Elbow) Internal (+) / External (-) Rotation');
xlabel('% of Gait (or Proplusion) Cycle');
ylabel('Moment (in N.m)');

% Figure for hip (or shoulder) joint force and moment
figure;
hold on;
% Lateral Medial
subplot(2,3,1);
hold on;
plot(LM4_HM,'Color','black','LineStyle','-');
title ('Right Hip (or Shoulder) Lateral (+) /  Medial (-)');
xlabel('% of Gait (or Proplusion) Cycle');
ylabel('Force (in N)');
% Anterior Posterior
subplot(2,3,2);
hold on;
plot(AP4_HM,'Color','black','LineStyle','-');
title ('Right Hip (or Shoulder) Anterior (+) / Posterior (-)');
xlabel('% of Gait (or Proplusion) Cycle');
ylabel('Force (in N)');
% Proximal Distal
subplot(2,3,3);
hold on;
plot(PD4_HM,'Color','black','LineStyle','-');
title ('Right Hip (or Shoulder) Proximal (+) / Distal (-)');
xlabel('% of Gait (or Proplusion) Cycle');
ylabel('Force (in N)');
% Flexion Extension
subplot(2,3,4);
hold on;
plot(FE4_HM,'Color','black','LineStyle','-');
title ('Right Hip (or Shoulder) Flexion (+) / Extension(-)');
xlabel('% of Gait (or Proplusion) Cycle');
ylabel('Moment (in N.m)');
% Adduction Abduction
subplot(2,3,5);
hold on;
plot(AA4_HM,'Color','black','LineStyle','-');
title ('Right Hip (or Shoulder) Adduction (+) / Abduction (-)');
xlabel('% of Gait (or Proplusion) Cycle');
ylabel('Moment (in N.m)');
% Internal External Rotation
subplot(2,3,6);
hold on;
plot(IER4_HM,'Color','black','LineStyle','-');
title ('Right Hip (or Shoulder) Internal (+) / External (-) Rotation');
xlabel('% of Gait (or Proplusion) Cycle');
ylabel('Moment (in N.m)');
