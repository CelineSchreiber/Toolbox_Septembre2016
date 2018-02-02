% =========================================================================
% REHAZENTER TOOLBOX - PLUGIN CLINICAL REPORT
% =========================================================================
% File name:    reportRachis
% -------------------------------------------------------------------------
% Subject:      Generate the report page for rachis kinematics
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
% Date of creation: 13/03/2015
% Version: 1
% -------------------------------------------------------------------------
% Updates: -
% =========================================================================

function f=reportRachis(Patient,Session,Condition,pluginFolder,normFolder,norm)

% =========================================================================
% Initialisation
% =========================================================================
pageWidth = 21; % cm
pageHeight = 29.7; % cm
graphWidth = 5.0; % cm
graphHeight = 2.3; % cm
yinit = 29.0; % cm
yincr = 0.5; % cm
x=[1.50 8.00 14.50];
igraph = 1; % graph number
colorR = [0 0.8 0;0 0.8 0.8;0 0.4 0;0 0.4 0.4;0 0.2 0;0 0.2 0.2];
colorL = [0.8 0 0;0.8 0 0.8;0.4 0 0;0.4 0 0.4;0.2 0 0;0.2 0 0.2];
colorB = [0 0 0.8;0.2 0.2 0.8;0.5 0.5 0.8;0.7 0.7 0.8;0.9 0.9 0.8;0.9 0.9 0.6];
cd(normFolder);
temp = load(cell2mat(norm));
Norm.Kinematics = temp.Normatives.Rposturalangle;
Norm.Event = temp.Normatives.Rphases;
cd(pluginFolder);
for i = 1:size(Condition,2)
    Kinematics(i) = Condition(i).All.Rangle;
    Event(i) = Condition(i).All.Rphases;
end



% =========================================================================
% Generate the page
% =========================================================================
    
% Set the page
% ---------------------------------------------------------------------
f(1) = figure('PaperOrientation','portrait','papertype','A4',...
    'Units','centimeters','Position',[0 0 pageWidth pageHeight],...
    'Color','white','PaperUnits','centimeters',...
    'PaperPosition',[0 0 pageWidth pageHeight],...
    'Name',['Rachis']);
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
    '  Cinématique du Rachis',...
    'Color','k','FontWeight','Bold','FontSize',18,...
    'HorizontalAlignment','Center');
% y = y - yincr*2;
% text(0.02,y/pageHeight,...
%     '  ',...
%     'Color','k','FontSize',16,...
%     'HorizontalAlignment','Center');
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
for i = 1:size(Condition,2)
    axesLegend = axes;
    set(axesLegend,'Position',[0 0 1 1]);
    set(axesLegend,'Visible','Off');
    % Count the number of trials
    nbtrials = 0;
    for j = 1:length(Condition(i).Posturo);
        if ~isempty(Condition(i).Posturo(j).Rangle.Hgr_tilt)
            nbtrials = nbtrials+1;
        end
    end
    % Write the legend
    text(0.05,y/pageHeight,['Condition ',num2str(i)],'Color',colorB(i,:),'FontWeight','Bold');
    text(0.25,y/pageHeight,'Norm','Color',[0.5 0.5 0.5]);
    text(0.32,y/pageHeight,[char(Session(i).date),...
        '     Nb essais : ',num2str(nbtrials),...
        '     Condition : ',char(regexprep(Condition(i).name,'_','-')),' (cf page 1)'],'color','k');
    y = y - yincr*1.0;
end

% Head Tilt
%--------------------------------------------------------------------------
y = y - yincr*6.5;
axesGraph = axes;
set(axesGraph,'Position',[0 0 1 1]);
set(axesGraph,'Visible','Off');
Graph(igraph) = axes('position',[x(1)/pageWidth y/pageHeight ...
    graphWidth/pageWidth graphHeight/pageHeight]);
set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
hold on;
title('Head tilt (Ant+)','FontWeight','Bold');%'BackGroundColor',[245/256 243/256 89/256],
xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); 
ylabel('Angle (deg)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
corridor(-Norm.Kinematics.Hgr_tilt.mean,Norm.Kinematics.Hgr_tilt.std,[0.5 0.5 0.5]);
for i = 1:size(Condition,2)
   if ~isempty(Kinematics(i).Hgr_tilt.mean)
        corridor(Kinematics(i).Hgr_tilt.mean,Kinematics(i).Hgr_tilt.std,colorB(i,:));
        plot(Kinematics(i).Hgr_tilt.mean,'Linestyle','-','Linewidth',2,'Color',colorB(i,:));
   end
end
axis tight; 
YL=ylim;
YL=setAxisLim(YL,-10,10);
axis([0 100 YL(1) YL(2)]);
box on;
igraph = igraph+1;

% Head Obliquity     
%--------------------------------------------------------------------------
axesGraph = axes;
set(axesGraph,'Position',[0 0 1 1]);
set(axesGraph,'Visible','Off');
Graph(igraph) = axes('position',[x(2)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
hold on;
title('Head obliquity','FontWeight','Bold');
xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); 
ylabel('Angle (deg)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');  
plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
corridor(-Norm.Kinematics.Hgr_obli.mean,Norm.Kinematics.Hgr_obli.std,[0.5 0.5 0.5]);
for i = 1:size(Condition,2)
    if ~isempty(Kinematics(i).Hgr_obli.mean)
        corridor(Kinematics(i).Hgr_obli.mean,Kinematics(i).Hgr_obli.std,colorB(i,:));
        plot(Kinematics(i).Hgr_obli.mean,'Linestyle','-','Linewidth',2,'Color',colorB(i,:));
    end
end
axis tight; YL=ylim;
YL=setAxisLim(YL,-10,10);
axis([0 100 YL(1) YL(2)]);
box on;
igraph = igraph+1;
   
%    Head Rotation        
%--------------------------------------------------------------------------
axesGraph = axes;
set(axesGraph,'Position',[0 0 1 1]);
set(axesGraph,'Visible','Off');
Graph(igraph) = axes('position',[x(3)/pageWidth y/pageHeight ...
    graphWidth/pageWidth graphHeight/pageHeight]);
set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
hold on;
title('Head rotation (right+)','FontWeight','Bold');
xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); 
ylabel('Angle (deg)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
corridor(Norm.Kinematics.Hgr_rota.mean,Norm.Kinematics.Hgr_rota.std,[0.5 0.5 0.5]);
for i = 1:size(Condition,2)
    if ~isempty(Kinematics(i).Hgr_rota.mean)
        corridor(Kinematics(i).Hgr_rota.mean,Kinematics(i).Hgr_rota.std,colorB(i,:));
        plot(Kinematics(i).Hgr_rota.mean,'Linestyle','-','Linewidth',2,'Color',colorB(i,:));
    end
end
axis tight; YL=ylim;
YL=setAxisLim(YL,-10,10);
axis([0 100 YL(1) YL(2)]);
box on;
igraph = igraph+1;

% Shoulders Flex/Ext
%--------------------------------------------------------------------------
y = y - yincr*7.5;
axesGraph = axes;
set(axesGraph,'Position',[0 0 1 1]);
set(axesGraph,'Visible','Off');
Graph(igraph) = axes('position',[x(1)/pageWidth y/pageHeight ...
    graphWidth/pageWidth graphHeight/pageHeight]);
set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
hold on;
title('Shoulders flex/ext','FontWeight','Bold');
xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Angle (deg)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
corridor(Norm.Kinematics.Sgr_tilt.mean,Norm.Kinematics.Sgr_tilt.std,[0.5 0.5 0.5]);
for i = 1:size(Condition,2)
   if ~isempty(Kinematics(i).Sgr_tilt.mean)
        corridor(Kinematics(i).Sgr_tilt.mean,Kinematics(i).Sgr_tilt.std,colorB(i,:));
        plot(Kinematics(i).Sgr_tilt.mean,'Linestyle','-','Linewidth',2,'Color',colorB(i,:));
    end
end
axis tight; YL=ylim;
YL=setAxisLim(YL,-10,10);
axis([0 100 YL(1) YL(2)]);
box on;
igraph = igraph+1;

%     Shoulders Obliquity
%--------------------------------------------------------------------------
axesGraph = axes;
set(axesGraph,'Position',[0 0 1 1]);
set(axesGraph,'Visible','Off');
Graph(igraph) = axes('position',[x(2)/pageWidth y/pageHeight ...
    graphWidth/pageWidth graphHeight/pageHeight]);
set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
hold on;
title('Shoulders obliquity','FontWeight','Bold');
xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Angle (deg)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
corridor(Norm.Kinematics.Sgr_obli.mean,Norm.Kinematics.Sgr_obli.std,[0.5 0.5 0.5]);
for i = 1:size(Condition,2)
    if ~isempty(Kinematics(i).Sgr_obli.mean)
        corridor(Kinematics(i).Sgr_obli.mean,Kinematics(i).Sgr_obli.std,colorB(i,:));
        plot(Kinematics(i).Sgr_obli.mean,'Linestyle','-','Linewidth',2,'Color',colorB(i,:));
    end
end
axis tight; YL=ylim;
YL=setAxisLim(YL,-10,10);
axis([0 100 YL(1) YL(2)]);
box on;
igraph = igraph+1;
    
%     Shoulders Rotation
%--------------------------------------------------------------------------
axesGraph = axes;
set(axesGraph,'Position',[0 0 1 1]);
set(axesGraph,'Visible','Off');
Graph(igraph) = axes('position',[x(3)/pageWidth y/pageHeight ...
    graphWidth/pageWidth graphHeight/pageHeight]);
set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
hold on;
title('Shoulders rotation','FontWeight','Bold');%'BackGroundColor',[89/256 157/256 233/256],
xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); 
ylabel('Angle (deg)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');    
plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
corridor(Norm.Kinematics.Sgr_rota.mean,Norm.Kinematics.Sgr_rota.std,[0.5 0.5 0.5]);
for i = 1:size(Condition,2)
    if ~isempty(Kinematics(i).Sgr_rota.mean)
        corridor(Kinematics(i).Sgr_rota.mean,Kinematics(i).Sgr_rota.std,colorB(i,:));
        plot(Kinematics(i).Sgr_rota.mean,'Linestyle','-','Linewidth',2,'Color',colorB(i,:));
    end
end
axis tight; YL=ylim;
YL=setAxisLim(YL,-10,10);
axis([0 100 YL(1) YL(2)]);
box on;
igraph = igraph+1;

%     Rachis Flex/Ext      
%--------------------------------------------------------------------------
y = y - yincr*7.5;
axesGraph = axes;
set(axesGraph,'Position',[0 0 1 1]);
set(axesGraph,'Visible','Off');
Graph(igraph) = axes('position',[x(1)/pageWidth y/pageHeight ...
    graphWidth/pageWidth graphHeight/pageHeight]);
set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
hold on;
title('Rachis flex/ext','FontWeight','Bold');
xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); 
ylabel('Angle (deg)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
corridor(Norm.Kinematics.Rgr_tilt.mean,Norm.Kinematics.Rgr_tilt.std,[0.5 0.5 0.5]);
for i = 1:size(Condition,2)
    if ~isempty(Kinematics(i).Rgr_tilt.mean)
        corridor(Kinematics(i).Rgr_tilt.mean,Kinematics(i).Rgr_tilt.std,colorB(i,:));
        plot(Kinematics(i).Rgr_tilt.mean,'Linestyle','-','Linewidth',2,'Color',colorB(i,:));
    end
end
axis tight; YL=ylim;
YL=setAxisLim(YL,-10,10);
axis([0 100 YL(1) YL(2)]);
box on;
igraph = igraph+1;
                
%     Rachis Obliquity       
%--------------------------------------------------------------------------
axesGraph = axes;
set(axesGraph,'Position',[0 0 1 1]);
set(axesGraph,'Visible','Off');
Graph(igraph) = axes('position',[x(2)/pageWidth y/pageHeight ...
    graphWidth/pageWidth graphHeight/pageHeight]);
set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
hold on;
title('Rachis obliquity','FontWeight','Bold');
xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); 
ylabel('Angle (deg)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
corridor(Norm.Kinematics.Rgr_obli.mean,Norm.Kinematics.Rgr_obli.std,[0.5 0.5 0.5]);
for i = 1:size(Condition,2)
   if ~isempty(Kinematics(i).Rgr_obli.mean)
        corridor(Kinematics(i).Rgr_obli.mean,Kinematics(i).Rgr_obli.std,colorB(i,:));
        plot(Kinematics(i).Rgr_obli.mean,'Linestyle','-','Linewidth',2,'Color',colorB(i,:));
   end
end
axis tight; YL=ylim;
YL=setAxisLim(YL,-10,10);
axis([0 100 YL(1) YL(2)]);
box on;
igraph = igraph+1;

%     Rachis Rotation       
%--------------------------------------------------------------------------
axesGraph = axes;
set(axesGraph,'Position',[0 0 1 1]);
set(axesGraph,'Visible','Off');
Graph(igraph) = axes('position',[x(3)/pageWidth y/pageHeight ...
    graphWidth/pageWidth graphHeight/pageHeight]);
set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
hold on;
title('Rachis rotation','FontWeight','Bold');%'BackGroundColor',[89/256 157/256 233/256],
xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); 
ylabel('Angle (deg)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
corridor(Norm.Kinematics.Rgr_rota.mean,Norm.Kinematics.Rgr_rota.std,[0.5 0.5 0.5]);
for i = 1:size(Condition,2)
    if ~isempty(Kinematics(i).Rgr_rota.mean)
        corridor(Kinematics(i).Rgr_rota.mean,Kinematics(i).Rgr_rota.std,colorB(i,:));
        plot(Kinematics(i).Rgr_rota.mean,'Linestyle','-','Linewidth',2,'Color',colorB(i,:));
    end
end
axis tight; YL=ylim;
YL=setAxisLim(YL,-10,10);
axis([0 100 YL(1) YL(2)]);
box on;
igraph = igraph+1;
          
%     Pelvis Flex/Ext       
%--------------------------------------------------------------------------
y = y - yincr*7.5;
axesGraph = axes;
set(axesGraph,'Position',[0 0 1 1]);
set(axesGraph,'Visible','Off');
Graph(igraph) = axes('position',[x(1)/pageWidth y/pageHeight ...
    graphWidth/pageWidth graphHeight/pageHeight]);
set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
hold on;
title('Pelvis tilt','FontWeight','Bold');%'BackGroundColor',[242/256 156/256 34/256],
xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); 
ylabel('Angle (deg)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');   
plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
corridor(Norm.Kinematics.Pgr_tilt.mean,Norm.Kinematics.Pgr_tilt.std,[0.5 0.5 0.5]);
for i = 1:size(Condition,2)
    if ~isempty(Kinematics(i).Pgr_tilt.mean)
        corridor(Kinematics(i).Pgr_tilt.mean,Kinematics(i).Pgr_tilt.std,colorB(i,:));
        plot(Kinematics(i).Pgr_tilt.mean,'Linestyle','-','Linewidth',2,'Color',colorB(i,:));
    end
end
axis tight; YL=ylim;
YL=setAxisLim(YL,-10,10);
axis([0 100 YL(1) YL(2)]);
box on;
igraph = igraph+1;

%     Rachis Obliquity        
%--------------------------------------------------------------------------
axesGraph = axes;
set(axesGraph,'Position',[0 0 1 1]);
set(axesGraph,'Visible','Off');
Graph(igraph) = axes('position',[x(2)/pageWidth y/pageHeight ...
    graphWidth/pageWidth graphHeight/pageHeight]);
set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
hold on;
title('Pelvis obliquity','FontWeight','Bold');%'BackGroundColor',[89/256 157/256 233/256],
xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); 
ylabel('Angle (deg)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
corridor(Norm.Kinematics.Pgr_obli.mean,Norm.Kinematics.Pgr_obli.std,[0.5 0.5 0.5]);
for i = 1:size(Condition,2)
    if ~isempty(Kinematics(i).Pgr_obli.mean)
        corridor(Kinematics(i).Pgr_obli.mean,Kinematics(i).Pgr_obli.std,colorB(i,:));
        plot(Kinematics(i).Pgr_obli.mean,'Linestyle','-','Linewidth',2,'Color',colorB(i,:));
    end
end
axis tight; YL=ylim;
YL=setAxisLim(YL,-10,10);
axis([0 100 YL(1) YL(2)]);
box on;
igraph = igraph+1;

%     Pelvis Rotation      
%--------------------------------------------------------------------------
axesGraph = axes;
set(axesGraph,'Position',[0 0 1 1]);
set(axesGraph,'Visible','Off');
Graph(igraph) = axes('position',[x(3)/pageWidth y/pageHeight ...
    graphWidth/pageWidth graphHeight/pageHeight]);
set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
hold on;
title('Pelvis rotation','FontWeight','Bold');%'BackGroundColor',[89/256 157/256 233/256],
xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); 
ylabel('Angle (deg)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
corridor(Norm.Kinematics.Pgr_rota.mean,Norm.Kinematics.Pgr_rota.std,[0.5 0.5 0.5]);
for i = 1:size(Condition,2)
    if ~isempty(Kinematics(i).Pgr_rota.mean)
        corridor(Kinematics(i).Pgr_rota.mean,Kinematics(i).Rgr_rota.std,colorB(i,:));
        plot(Kinematics(i).Pgr_rota.mean,'Linestyle','-','Linewidth',2,'Color',colorB(i,:));
    end
end
axis tight; YL=ylim;
YL=setAxisLim(YL,-10,10);
axis([0 100 YL(1) YL(2)]);
box on;
igraph = igraph+1;
    
%**************************************************************************
%% Events
    for g=1:length(Graph)
        axes(Graph(g));
        YL=ylim;
        corridor(Norm.Event.p5.mean,Norm.Event.p5.std,[0.5 0.5 0.5]);
        for i = 1:size(Condition,2)
            corridor(Event(i).p5.mean,Event(i).p5.std,colorB(i,:));         
            plot([Event(i).p5.mean Event(i).p5.mean],[-180 180],'Linestyle','-','Linewidth',2,'Color',colorB(i,:)); %IHS
            plot([Event(i).p2.mean Event(i).p2.mean],[YL(1)-20 YL(1)+(YL(2)-YL(1))/10],'Linewidth',1.5,'Color',colorB(i,:)); %CTO
            plot([Event(i).p4.mean Event(i).p4.mean],[YL(1)-20 YL(1)+(YL(2)-YL(1))/10],'Linewidth',1.5,'Color',colorB(i,:)); %CHS
        end
    end
    g
    
  