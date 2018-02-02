% MAIN PROGRAM
% Main_Segment_Kinematics.m
%__________________________________________________________________________
%
% PURPOSE
% Computation and plotting of 3D Segment angles and displacements
%
% SYNOPSIS
% N/A (i.e., main program)
%
% DESCRIPTION
% Data loading, call of functions and plotting of Segment coordinate system 
% angles and displacements
%__________________________________________________________________________
%
% CALLED FUNCTIONS (FROM 3D INVERSE DYNAMICS TOOLBOX)
% Mprod_array3.m
% Tinv_array3.m
% Q2Tw_array3.m
% Q2Tu_array3.m
% R2mobileZXY_array3.m
% R2mobileZYX_array3
% Vnop_array3
% 
% MATLAB VERSION
% Matlab R2007b
%__________________________________________________________________________
%
% CHANGELOG
% Created by Rapha�l Dumas
% March 2010
%
% Modified by Rapha�l Dumas
% October 2010
% Sequence ZYX for both ankle and wrist Segments
% Figure captions
%__________________________________________________________________________

% % *.mat
% uiload; % Segment data

% Number of frames
n = size(Segment(2).Q,3);
% Interpolation parameters
k = (1:n)';
ko = (linspace(1,n,100))';

% Segment angles and displacements
for i = 2:4 % From i = 2 ankle (or wrist) to i = 4 hip (or shoulder)
    
    % Transformation from the proximal segment axes
    % (with origin at endpoint D and with Z = w)
    % to the distal segment axes
    % (with origin at point P and with X = u)
    Segment(i).T = Mprod_array3(Tinv_array3(Q2Tw_array3(Segment(i+1).Q)),...
        Q2Tu_array3(Segment(i).Q));
    
    if i == 4 % Special case for i = 4 thigh (or arm)
        
        % Origin of proximal segment at mean position of Pi
        % in proximal segment (rather than endpoint Di+1)
        Segment(4).T(1:3,4,:) = Segment(4).T(1:3,4,:) - ...
            repmat(mean(Segment(4).T(1:3,4,:),3),[1 1 n]);
            
    end
    
    if i == 2 % ZYX sequence of mobile axis
        % Segment coordinate system for ankle (or wrist):
        % Internal/extenal rotation on floating axis

        % Euler angles
        Segment(i).Euler = R2mobileZYX_array3(Segment(i).T(1:3,1:3,:));

        % Segment displacement about the Euler angle axes
        Segment(i).dj = Vnop_array3(...
            Segment(i).T(1:3,4,:),... Di+1 to Pi in SCS of segment i+1
            repmat([0;0;1],[1 1 n]),... % Zi+1 in SCS of segment i+1
            cross(Segment(i).T(1:3,1,:),repmat([0;0;1],[1 1 n])),...
            Segment(i).T(1:3,1,:)); % % Xi in SCS of segment i+1

    else % ZXY sequence of mobile axis

        % Euler angles
        Segment(i).Euler = R2mobileZXY_array3(Segment(i).T(1:3,1:3,:));

        % Segment displacement about the Euler angle axes
        Segment(i).dj = Vnop_array3(...
            Segment(i).T(1:3,4,:),... Di+1 to Pi in SCS of segment i+1
            repmat([0;0;1],[1 1 n]),... % Zi+1 in SCS of segment i+1
            cross(Segment(i).T(1:3,2,:),repmat([0;0;1],[1 1 n])),...
            Segment(i).T(1:3,2,:)); % % Yi in SCS of segment i+1

    end

end

% 100% of gait cycle (or of propulsive cycle)
% Ankle (or wrist) Segment angles and displacements
FE2 = interp1(k,permute(Segment(2).Euler(1,1,:),[3,2,1])*180/pi,ko,'spline');
IER2 = interp1(k,permute(Segment(2).Euler(1,2,:),[3,2,1])*180/pi,ko,'spline');
AA2 = interp1(k,permute(Segment(2).Euler(1,3,:),[3,2,1])*180/pi,ko,'spline');
LM2 = interp1(k,permute(Segment(2).dj(1,1,:),[3,2,1]),ko,'spline');
PD2 = interp1(k,permute(Segment(2).dj(2,1,:),[3,2,1]),ko,'spline');
AP2 = interp1(k,permute(Segment(2).dj(3,1,:),[3,2,1]),ko,'spline');
% Knee (or elbow) Segment angles and displacements
FE3 = interp1(k,permute(Segment(3).Euler(1,1,:),[3,2,1])*180/pi,ko,'spline');
AA3 = interp1(k,permute(Segment(3).Euler(1,2,:),[3,2,1])*180/pi,ko,'spline');
IER3 = interp1(k,permute(Segment(3).Euler(1,3,:),[3,2,1])*180/pi,ko,'spline');
LM3 = interp1(k,permute(Segment(3).dj(1,1,:),[3,2,1]),ko,'spline');
AP3 = interp1(k,permute(Segment(3).dj(2,1,:),[3,2,1]),ko,'spline');
PD3 = interp1(k,permute(Segment(3).dj(3,1,:),[3,2,1]),ko,'spline');
% Hip (or shoulder) Segment angles and displacements
FE4 = interp1(k,permute(Segment(4).Euler(1,1,:),[3,2,1])*180/pi,ko,'spline');
AA4 = interp1(k,permute(Segment(4).Euler(1,2,:),[3,2,1])*180/pi,ko,'spline');
IER4 = interp1(k,permute(Segment(4).Euler(1,3,:),[3,2,1])*180/pi,ko,'spline');
LM4 = interp1(k,permute(Segment(4).dj(1,1,:),[3,2,1]),ko,'spline');
AP4 = interp1(k,permute(Segment(4).dj(2,1,:),[3,2,1]),ko,'spline');
PD4 = interp1(k,permute(Segment(4).dj(3,1,:),[3,2,1]),ko,'spline');

% % Figure for ankle (or wrist)
% figure(1);
% hold on;
% % Flexion Extension
% subplot(2,3,1);
% hold on;
% plot(FE2,'LineWidth',1,'Color','blue');
% title ('Right Ankle (or Wrist) Flexion (+) / Extension (-)');
% xlabel('% of Gait (or Proplusion) Cycle');
% ylabel('Angle (in degree)');
% % Adduction Abduction
% subplot(2,3,2);
% hold on;
% plot(AA2,'LineWidth',1,'Color','blue');
% title ('Right Ankle (or Wrist)  Adduction (+) / Abduction (-)');
% xlabel('% of Gait (or Proplusion) Cycle');
% ylabel('Angle (in degree)');
% % Internal External Rotation
% subplot(2,3,3);
% hold on;
% plot(IER2,'LineWidth',1,'Color','blue');
% title ('Right Ankle (or Wrist) Internal (+) / External (-) Rotation');
% xlabel('% of Gait (or Proplusion) Cycle');
% ylabel('Angle (in degree)');
% % Lateral Medial
% subplot(2,3,4);
% hold on;
% plot(LM2*1000,'LineWidth',1,'Color','blue'); % mm
% title ('Right Ankle (or Wrist) Lateral (+) /  Medial (-)');
% xlabel('% of Gait (or Proplusion) Cycle');
% ylabel('Displacement (in mm)');
% % Anterior Posterior
% subplot(2,3,5);
% hold on;
% plot(AP2*1000,'LineWidth',1,'Color','blue'); % mm
% title ('Right Ankle (or Wrist) Anterior (+) / Posterior (-)');
% xlabel('% of Gait (or Proplusion) Cycle');
% ylabel('Displacement (in mm)');
% % Proximal Distal
% subplot(2,3,6);
% hold on;
% plot(PD2*1000,'LineWidth',1,'Color','blue'); % mm
% title ('Right Ankle (or Wrist) Proximal (+) / Distal (-))');
% xlabel('% of Gait (or Proplusion) Cycle');
% ylabel('Displacement (in mm)');
% 
% 
% % Figures for knee (or elbow)
% figure(2);
% hold on;
% % Extension Flexion (or Flexion Extension)
% subplot(2,3,1);
% hold on;
% plot(FE3,'LineWidth',1,'Color','blue');
% title (['  Right Knee Extension (+) / Flexion (-)   '; ...
%     '(or Right Elbow Flexion (+) / Extension(-))']);
% xlabel('% of Gait (or Proplusion) Cycle');
% ylabel('Angle (in degree)');
% % Adduction Abduction
% subplot(2,3,2);
% hold on;
% plot(AA3,'LineWidth',1,'Color','blue');
% title ('Right Knee (or Elbow) Adduction (+) / Abduction (-)');
% xlabel('% of Gait (or Proplusion) Cycle');
% ylabel('Angle (in degree)');
% % Internal External Rotation
% subplot(2,3,3);
% hold on;
% plot(IER3,'LineWidth',1,'Color','blue');
% title (['Right Knee (or Elbow) Internal (+) / External (-) Rotation'; ...
%     '     (Neutral Pronation (+) / Supination (-) at +90�)     ']);
% xlabel('% of Gait (or Proplusion) Cycle');
% ylabel('Angle (in degree)');
% % Lateral Medial
% subplot(2,3,4);
% hold on;
% plot(LM3*1000,'LineWidth',1,'Color','blue'); % mm
% title ('Right Knee (or Elbow) Lateral (+) /  Medial (-)');
% xlabel('% of Gait (or Proplusion) Cycle');
% ylabel('Displacement (in mm)');
% % Anterior Posterior
% subplot(2,3,5);
% hold on;
% plot(AP3*1000,'LineWidth',1,'Color','blue'); % mm
% title ('Right Knee (or Elbow) Anterior (+) / Posterior (-)');
% xlabel('% of Gait (or Proplusion) Cycle');
% ylabel('Displacement (in mm)');
% % Proximal Distal
% subplot(2,3,6);
% hold on;
% plot(PD3*1000,'LineWidth',1,'Color','blue'); % mm
% title ('Right Knee (or Elbow) Proximal (+) / Distal (-)');
% xlabel('% of Gait (or Proplusion) Cycle');
% ylabel('Displacement (in mm)');
% 
% 
% % Figure for hip (or shoulder)
% figure(3);
% hold on;
% % Flexion Extension 
% subplot(2,3,1);
% hold on;
% plot(FE4,'LineWidth',1,'Color','blue');
% title ('Right Hip (or Shoulder) Flexion (+) / Extension (-)');
% xlabel('% of Gait (or Proplusion) Cycle');
% ylabel('Angle (in degree)');
% % Adduction Abduction
% subplot(2,3,2);
% hold on;
% plot(AA4,'LineWidth',1,'Color','blue');
% title ('Right Hip (or Shoulder) Adduction (+) / Abduction (-)');
% xlabel('% of Gait (or Proplusion) Cycle');
% ylabel('Angle (in degree)');
% % Internal External Rotation
% subplot(2,3,3);
% hold on;
% plot(IER4,'LineWidth',1,'Color','blue');
% title ('Right Hip (or Shoulder) Internal (+) / External (-) Rotation');
% xlabel('% of Gait (or Proplusion) Cycle');
% ylabel('Angle (in degree)');
% % Lateral Medial
% subplot(2,3,4);
% hold on;
% plot(LM4*1000,'LineWidth',1,'Color','blue'); % mm
% title ('Right Hip (or Shoulder) Lateral (+) /  Medial (-)');
% xlabel('% of Gait (or Proplusion) Cycle');
% ylabel('Displacement (in mm)');
% % Anterior Posterior
% subplot(2,3,5);
% hold on;
% plot(AP4*1000,'LineWidth',1,'Color','blue'); % mm
% title ('Right Hip (or Shoulder) Anterior (+) / Posterior (-)');
% xlabel('% of Gait (or Proplusion) Cycle');
% ylabel('Displacement (in mm)');
% % Proximal Distal
% subplot(2,3,6);
% hold on;
% plot(PD4*1000,'LineWidth',1,'Color','blue'); % mm
% title ('Right Hip (or Shoulder) Proximal (+) / Distal (-)');
% xlabel('% of Gait (or Proplusion) Cycle');
% ylabel('Displacement (in mm)');