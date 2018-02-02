% =========================================================================
% REHAZENTER TOOLBOX - PLUGIN CLINICAL REPORT
% =========================================================================
% File name:    reportKineticsTrial
% -------------------------------------------------------------------------
% Subject:      Check one specific trial kinetics
% -------------------------------------------------------------------------
% Inpageuts:    - Patient (structure)
%               - Session (structure)
%               - Condition (structure)
%               - pluginFolder (char)
%               - normFolder (char)
%               - norm (char)
% Outputs:      - f (figure)
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber, A. Naaim
% Date of creation: 13/01/2015
% Version: 1
% -------------------------------------------------------------------------
% Updates: -
% =========================================================================

function f = reportKineticsTrial(Patient,Session,Condition,pluginFolder,normFolder,norm)

% =========================================================================
% Initialisation
% =========================================================================
pageWidth = 21; % cm
pageHeight = 29.7; % cm
graphWidth = 5.0; % cm
graphHeight = 2.3; % cm
yinit = 29.0; % cm
yincr = 0.5; % cm
x = [1.50 8.00 14.50]; % cm
igraph = 1; % graph number
colorR = [0 0.8 0;0 0.8 0.8;0 0.4 0;0 0.4 0.4;0 0.2 0;0 0.2 0.2];
colorL = [0.8 0 0;0.8 0 0.8;0.4 0 0;0.4 0 0.4;0.2 0 0;0.2 0 0.2];
colorB = [0 0 0.8;0.2 0.2 0.8;0.5 0.5 0.8;0.7 0.7 0.8;0.9 0.9 0.8;0.9 0.9 0.6];
cd(normFolder);
temp = load(cell2mat(norm));
Norm.Kinematics = temp.Normatives.Rkinematics;
Norm.Kinetics = temp.Normatives.Rdynamics;
Norm.Event = temp.Normatives.Rphases;
cd(pluginFolder);
% Choose condition
condNames = cell(1,length(Session));
for i = 1:length(Session)
    condNames{i} = [char(Patient(i).lastname),' - ',char(Session(i).date),' - ',char(Condition(i).name)];
end
[cond,ok] = listdlg('ListString',condNames,'ListSize',[300 300]);
% Choose trial
files = [];
for i = 1:length(Session(cond).Gait)
    if strcmp(Session(cond).Gait(i).condition,Condition(cond).name)
        files = [files; Session(cond).Gait(i).filename];
    end
end
[trial,ok] = listdlg('ListString',files);
% Store data
Rkinematics(1) = Condition(cond).Gait(trial).Rkinematics;
Lkinematics(1) = Condition(cond).Gait(trial).Lkinematics;    
Rkinetics(1) = Condition(cond).Gait(trial).Rdynamics;
Lkinetics(1) = Condition(cond).Gait(trial).Ldynamics;
Revent(1) = Condition(cond).Gait(trial).Rphases;
Levent(1) = Condition(cond).Gait(trial).Lphases;

% =========================================================================
% Generate the page
% =========================================================================
% Case 1: Only 1 condition: page 1 = right and left parameters
% Case 2: More than 1 condition: page 1 = right, page 2 = left
% =========================================================================

% Set the page
% ---------------------------------------------------------------------
f(1) = figure('PaperOrientation','portrait','papertype','A4',...
    'Units','centimeters','Position',[0 0 pageWidth pageHeight],...
    'Color','white','PaperUnits','centimeters',...
    'PaperPosition',[0 0 pageWidth pageHeight],...
    'Name',['parameters',num2str(1)]);
hold on;
axis off;

% Rehazenter banner
% ---------------------------------------------------------------------
cd(pluginFolder);
banner = imread('banner','jpeg');
axesImage = axes('position',...
    [0 0.89 1 0.12]);
image(banner);
set(axesImage,'Visible','Off');

% Header
% ---------------------------------------------------------------------
axesText = axes;
set(axesText,'Position',[0.47 0 1 1]);
set(axesText,'Visible','Off');
y = yinit;
y = y - 0.8;
text(0.5/pageWidth,y/pageHeight,...
    'CNRFR - Rehazenter',...
    'Color','w','FontSize',12);
y = y - yincr;
text(0.5/pageWidth,y/pageHeight,...
    'Laboratoire d''Analyse du Mouvement et de la Posture',...
    'Color','w','FontSize',12);

% Title
% ---------------------------------------------------------------------
y = y - yincr*5;
text(0.02,y/pageHeight,...
    '  Cinématique',...
    'Color','k','FontWeight','Bold','FontSize',18,...
    'HorizontalAlignment','Center');
y = y - yincr*2;
text(0.02,y/pageHeight,...
    '  Côté droit VS côté gauche',...
    'Color','k','FontSize',16,...
    'HorizontalAlignment','Center');
yinit = y;

% Patient
% ---------------------------------------------------------------------
y = y - yincr*3;
axesLegend = axes;
set(axesLegend,'Position',[0 0 1 1]);
set(axesLegend,'Visible','Off');
text(0.05,y/pageHeight,'Patient : ','FontWeight','Bold','Color','black');
text(0.25,y/pageHeight,[Patient(1).lastname,' ',Patient(1).firstname],'Color','black');
y = y - yincr;
text(0.05,y/pageHeight,'Date de naissance : ','FontWeight','Bold','Color','black');
text(0.25,y/pageHeight,[Patient(1).birthdate],'Color','black');

% Legend
% ---------------------------------------------------------------------
y = y - yincr;
axesLegend = axes;
set(axesLegend,'Position',[0 0 1 1]);
set(axesLegend,'Visible','Off');
% Write the legend
text(0.05,y/pageHeight,['Condition ',num2str(cond)],'Color',colorB(cond,:),'FontWeight','Bold');
text(0.25,y/pageHeight,'Droite','Color',colorR(cond,:));
text(0.30,y/pageHeight,'Gauche','Color',colorL(cond,:));
text(0.37,y/pageHeight,'Norm','Color',[0.5 0.5 0.5]);
text(0.44,y/pageHeight,[char(Session(cond).date),...
    '     Fichier : ',char(files(trial,:)),...
    '     Condition : ',char(regexprep(Condition(cond).name,'_','-')),' (cf page 1)'],'color','k');
y = y - yincr*1.0;

% Right/Left hip flexion/extension
% ---------------------------------------------------------------------
y = y - yincr*6.5;
axesGraph = axes;
set(axesGraph,'Position',[0 0 1 1]);
set(axesGraph,'Visible','Off');
Graph(igraph) = axes('position',[x(1)/pageWidth y/pageHeight ...
    graphWidth/pageWidth graphHeight/pageHeight]);
set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
hold on;
title('Hip flexion/extension (Flex+)','FontWeight','Bold');
xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Angle (deg)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
corridor(Norm.Kinematics.FE4.mean,Norm.Kinematics.FE4.std,[0.5 0.5 0.5]);
if ~isempty(Rkinematics(1).FE4)
    plot(Rkinematics(1).FE4,'Linestyle','-','Linewidth',2,'Color',colorR(cond,:));
end
if ~isempty(Lkinematics(1).FE4)
    plot(Lkinematics(1).FE4,'Linestyle','-','Linewidth',2,'Color',colorL(cond,:));
end
axis tight;
YL = ylim;
YL = setAxisLim(YL,-40,40);
axis([0 100 YL(1) YL(2)]);
box on;
igraph = igraph+1;

% Right/Left knee flexion/extension
% ---------------------------------------------------------------------
axesGraph = axes;
set(axesGraph,'Position',[0 0 1 1]);
set(axesGraph,'Visible','Off');
Graph(igraph) = axes('position',[x(2)/pageWidth y/pageHeight ...
    graphWidth/pageWidth graphHeight/pageHeight]);
set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
hold on;
title('Knee flexion/extension (Flex+)','FontWeight','Bold');
xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Angle (deg)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
corridor(-Norm.Kinematics.FE3.mean,Norm.Kinematics.FE3.std,[0.5 0.5 0.5]);
if ~isempty(Rkinematics(1).FE3)
    plot(-Rkinematics(1).FE3,'Linestyle','-','Linewidth',2,'Color',colorR(cond,:));
end
if ~isempty(Lkinematics(1).FE3)
    plot(-Lkinematics(1).FE3,'Linestyle','-','Linewidth',2,'Color',colorL(cond,:));
end
axis tight;
YL = ylim;
YL = setAxisLim(YL,-40,40);
axis([0 100 YL(1) YL(2)]);
box on;
igraph = igraph+1;

% Right/Left ankle flexion/extension
% ---------------------------------------------------------------------
axesGraph = axes;
set(axesGraph,'Position',[0 0 1 1]);
set(axesGraph,'Visible','Off');
Graph(igraph) = axes('position',[x(3)/pageWidth y/pageHeight ...
    graphWidth/pageWidth graphHeight/pageHeight]);
set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
hold on;
title('Ankle flexion/extension (Dorsi+)','FontWeight','Bold');
xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Angle (deg)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
corridor(Norm.Kinematics.FE2.mean,Norm.Kinematics.FE2.std,[0.5 0.5 0.5]);
if ~isempty(Rkinematics(1).FE2)
    plot(Rkinematics(1).FE2,'Linestyle','-','Linewidth',2,'Color',colorR(cond,:));
end
if ~isempty(Lkinematics(1).FE2)
    plot(Lkinematics(1).FE2,'Linestyle','-','Linewidth',2,'Color',colorL(cond,:));
end
axis tight;
YL = ylim;
YL = setAxisLim(YL,-40,40);
axis([0 100 YL(1) YL(2)]);
box on;
igraph = igraph+1;

% Right/Left hip flexion/extension moment
% ---------------------------------------------------------------------
y = y - yincr*7.5;
axesGraph = axes;
set(axesGraph,'Position',[0 0 1 1]);
set(axesGraph,'Visible','Off');
Graph(igraph) = axes('position',[x(1)/pageWidth y/pageHeight ...
    graphWidth/pageWidth graphHeight/pageHeight]);
set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-10:0.05:10);
hold on;
title('Hip flexion/extension moment (Flex+)','FontWeight','Bold');
xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Moment (adimensioned)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
corridor(Norm.Kinetics.FE4.mean,Norm.Kinetics.FE4.std,[0.5 0.5 0.5]);
if ~isempty(Rkinetics(1).FE4)
    plot(Rkinetics(1).FE4,'Linestyle','-','Linewidth',2,'Color',colorR(cond,:));
end
if ~isempty(Lkinetics(1).FE4)
    plot(Lkinetics(1).FE4,'Linestyle','-','Linewidth',2,'Color',colorL(cond,:));
end
axis tight;
YL = ylim;
YL = setAxisLim(YL,-10,10);
axis([0 100 -0.2 0.2]);%YL(1) YL(2)
box on;
igraph = igraph+1;

% Right/Left knee flexion/extension moment
% ---------------------------------------------------------------------
axesGraph = axes;
set(axesGraph,'Position',[0 0 1 1]);
set(axesGraph,'Visible','Off');
Graph(igraph) = axes('position',[x(2)/pageWidth y/pageHeight ...
    graphWidth/pageWidth graphHeight/pageHeight]);
set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-10:0.05:10);
hold on;
title('Knee flexion/extension moment (Flex+)','FontWeight','Bold');
xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Moment (adimensioned)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
corridor(-Norm.Kinetics.FE3.mean,Norm.Kinetics.FE3.std,[0.5 0.5 0.5]);
if ~isempty(-Rkinetics(1).FE3)
    plot(-Rkinetics(1).FE3,'Linestyle','-','Linewidth',2,'Color',colorR(cond,:));
end
if ~isempty(-Lkinetics(1).FE3)
    plot(-Lkinetics(1).FE3,'Linestyle','-','Linewidth',2,'Color',colorL(cond,:));
end
axis tight;
YL = ylim;
YL = setAxisLim(YL,-10,10);
axis([0 100 -0.1 0.1]);%YL(1) YL(2)
box on;
igraph = igraph+1;

% Right/Left ankle flexion/extension moment
% ---------------------------------------------------------------------
axesGraph = axes;
set(axesGraph,'Position',[0 0 1 1]);
set(axesGraph,'Visible','Off');
Graph(igraph) = axes('position',[x(3)/pageWidth y/pageHeight ...
    graphWidth/pageWidth graphHeight/pageHeight]);
set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-10:0.05:10);
hold on;
title('Ankle flexion/extension moment (Dorsi+)','FontWeight','Bold');
xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Moment (adimensioned)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
corridor(Norm.Kinetics.FE2.mean,Norm.Kinetics.FE2.std,[0.5 0.5 0.5]);
if ~isempty(Rkinetics(1).FE2)
    plot(Rkinetics(1).FE2,'Linestyle','-','Linewidth',2,'Color',colorR(cond,:));
end
if ~isempty(Lkinetics(1).FE2)
    plot(Lkinetics(1).FE2,'Linestyle','-','Linewidth',2,'Color',colorL(cond,:));
end
axis tight;
YL = ylim;
YL = setAxisLim(YL,-10,10);
axis([0 100 -0.25 0.1]);%YL(1) YL(2)
box on;
igraph = igraph+1;

% Right/Left hip flexion/extension power
% ---------------------------------------------------------------------
y = y - yincr*7.5;
axesGraph = axes;
set(axesGraph,'Position',[0 0 1 1]);
set(axesGraph,'Visible','Off');
Graph(igraph) = axes('position',[x(1)/pageWidth y/pageHeight ...
    graphWidth/pageWidth graphHeight/pageHeight]);
set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-10:0.1:10);
hold on;
title('Total hip power (Gen+)','FontWeight','Bold');
xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Power (adimensioned)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
corridor(Norm.Kinetics.Power4.mean,Norm.Kinetics.Power4.std,[0.5 0.5 0.5]);
if ~isempty(Rkinetics(1).Power4)
    plot(Rkinetics(1).Power4,'Linestyle','-','Linewidth',2,'Color',colorR(cond,:));
end
if ~isempty(Lkinetics(1).Power4)
    plot(Lkinetics(1).Power4,'Linestyle','-','Linewidth',2,'Color',colorL(cond,:));
end
axis tight;
YL = ylim;
YL = setAxisLim(YL,-10,10);
axis([0 100 -0.4 0.4]);%YL(1) YL(2)
box on;
igraph = igraph+1;

% Right/Left knee flexion/extension power
% ---------------------------------------------------------------------
axesGraph = axes;
set(axesGraph,'Position',[0 0 1 1]);
set(axesGraph,'Visible','Off');
Graph(igraph) = axes('position',[x(2)/pageWidth y/pageHeight ...
    graphWidth/pageWidth graphHeight/pageHeight]);
set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-10:0.1:10);
hold on;
title('Total knee power (Gen+)','FontWeight','Bold');
xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Power (adimensioned)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
corridor(Norm.Kinetics.Power3.mean,Norm.Kinetics.Power3.std,[0.5 0.5 0.5]);
if ~isempty(Rkinetics(1).Power3)
    plot(Rkinetics(1).Power3,'Linestyle','-','Linewidth',2,'Color',colorR(cond,:));
end
if ~isempty(Lkinetics(1).Power3)
    plot(Lkinetics(1).Power3,'Linestyle','-','Linewidth',2,'Color',colorL(cond,:));
end
axis tight;
YL = ylim;
YL = setAxisLim(YL,-10,10);
axis([0 100 -0.4 0.4]);%YL(1) YL(2)
box on;
igraph = igraph+1;

% Right/Left ankle flexion/extension power
% ---------------------------------------------------------------------
axesGraph = axes;
set(axesGraph,'Position',[0 0 1 1]);
set(axesGraph,'Visible','Off');
Graph(igraph) = axes('position',[x(3)/pageWidth y/pageHeight ...
    graphWidth/pageWidth graphHeight/pageHeight]);
set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-10:0.2:10);
hold on;
title('Total ankle power (Gen+)','FontWeight','Bold');
xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Power (adimensioned)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
corridor(Norm.Kinetics.Power2.mean,Norm.Kinetics.Power2.std,[0.5 0.5 0.5]);
if ~isempty(Rkinetics(1).Power2)
    plot(Rkinetics(1).Power2,'Linestyle','-','Linewidth',2,'Color',colorR(cond,:));
end
if ~isempty(Lkinetics(1).Power2)
    plot(Lkinetics(1).Power2,'Linestyle','-','Linewidth',2,'Color',colorL(cond,:));
end
axis tight;
YL = ylim;
YL = setAxisLim(YL,-10,10);
axis([0 100 -1 1]);%YL(1) YL(2)
box on;
igraph = igraph+1;

% Right/Left ground reaction force (vertical)
% ---------------------------------------------------------------------
y = y - yincr*7.5;
axesGraph = axes;
set(axesGraph,'Position',[0 0 1 1]);
set(axesGraph,'Visible','Off');
Graph(igraph) = axes('position',[x(1)/pageWidth y/pageHeight ...
    graphWidth/pageWidth graphHeight/pageHeight]);
set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-10:0.2:10);
hold on;
title('Vertical ground reaction force (Up+)','FontWeight','Bold');
xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Force (adimensioned)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
corridor(-Norm.Kinetics.PD1.mean,Norm.Kinetics.PD1.std,[0.5 0.5 0.5]);
if ~isempty(Rkinetics(1).PD1)
    plot(-Rkinetics(1).PD1,'Linestyle','-','Linewidth',2,'Color',colorR(cond,:));
end
if ~isempty(Lkinetics(1).PD1)
    plot(-Lkinetics(1).PD1,'Linestyle','-','Linewidth',2,'Color',colorL(cond,:));
end
axis tight;
YL = ylim;
YL = setAxisLim(YL,-10,10);
axis([0 100 -0.05 1.6]);%YL(1) YL(2)
box on;
igraph = igraph+1;

% Right/Left ground reaction force (anterior/posterior)
% ---------------------------------------------------------------------
axesGraph = axes;
set(axesGraph,'Position',[0 0 1 1]);
set(axesGraph,'Visible','Off');
Graph(igraph) = axes('position',[x(2)/pageWidth y/pageHeight ...
    graphWidth/pageWidth graphHeight/pageHeight]);
set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-10:0.1:10);
hold on;
title('Ant/post ground reaction force (Ant+)','FontWeight','Bold');
xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Force (adimensioned)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
corridor(-Norm.Kinetics.AP1.mean,Norm.Kinetics.AP1.std,[0.5 0.5 0.5]);
if ~isempty(-Rkinetics(1).AP1)
    plot(-Rkinetics(1).AP1,'Linestyle','-','Linewidth',2,'Color',colorR(cond,:));
end
if ~isempty(-Lkinetics(1).AP1)
    plot(-Lkinetics(1).AP1,'Linestyle','-','Linewidth',2,'Color',colorL(cond,:));
end
axis tight;
YL = ylim;
YL = setAxisLim(YL,-10,10);
axis([0 100 -0.3 0.3]);%YL(1) YL(2)
box on;
igraph = igraph+1;

% Right/Left ground reaction force (lateral/medial)
% ---------------------------------------------------------------------
axesGraph = axes;
set(axesGraph,'Position',[0 0 1 1]);
set(axesGraph,'Visible','Off');
Graph(igraph) = axes('position',[x(3)/pageWidth y/pageHeight ...
    graphWidth/pageWidth graphHeight/pageHeight]);
set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-10:0.1:10);
hold on;
title('Lat/med ground reaction force (Lat+)','FontWeight','Bold');
xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Force (adimensioned)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
corridor(-Norm.Kinetics.LM1.mean,Norm.Kinetics.LM1.std,[0.5 0.5 0.5]);
if ~isempty(-Rkinetics(1).LM1)
    plot(-Rkinetics(1).LM1,'Linestyle','-','Linewidth',2,'Color',colorR(cond,:));
end
if ~isempty(-Lkinetics(1).LM1)
    plot(-Lkinetics(1).LM1,'Linestyle','-','Linewidth',2,'Color',colorL(cond,:));
end
axis tight;
YL = ylim;
YL = setAxisLim(YL,-10,10);
axis([0 100 -0.2 0.2]);%YL(1) YL(2)
box on;
igraph = igraph+1;

% Events
% ---------------------------------------------------------------------    
for g = 1:length(Graph)
    axes(Graph(g));
    YL = ylim;
    corridor(Norm.Event.p5.mean,Norm.Event.p5.std,[0.5 0.5 0.5]);
    plot([Revent(1).p5 Revent(1).p5],[-180 180],'Linestyle','-','Linewidth',2,'Color',colorR(cond,:)); %IHS
    plot([Revent(1).p2 Revent(1).p2],[YL(1)-20 YL(1)+(YL(2)-YL(1))/10],'Linewidth',1.5,'Color',colorR(cond,:)); %CTO
    plot([Revent(1).p4 Revent(1).p4],[YL(1)-20 YL(1)+(YL(2)-YL(1))/10],'Linewidth',1.5,'Color',colorR(cond,:)); %CHS
    plot([Levent(1).p5 Levent(1).p5],[-180 180],'Linestyle','-','Linewidth',2,'Color',colorL(cond,:)); %IHS
    plot([Levent(1).p2 Levent(1).p2],[YL(1)-20 YL(1)+(YL(2)-YL(1))/10],'Linewidth',1.5,'Color',colorL(cond,:)); %CTO
    plot([Levent(1).p4 Levent(1).p4],[YL(1)-20 YL(1)+(YL(2)-YL(1))/10],'Linewidth',1.5,'Color',colorL(cond,:)); %CHS
end