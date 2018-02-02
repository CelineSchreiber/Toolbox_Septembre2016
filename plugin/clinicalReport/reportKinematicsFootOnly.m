% =========================================================================
% REHAZENTER TOOLBOX - PLUGIN CLINICAL REPORT
% =========================================================================
% File name:    reportKinematics
% -------------------------------------------------------------------------
% Subject:      Generate the report page for kinematics
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

function f = reportKinematicsFootOnly(Patient,Session,Condition,pluginFolder,normFolder,norm)

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
Norm.Event = temp.Normatives.Rphases;
cd(pluginFolder);
Rkinematics = Condition.All.Rkinematics;
Lkinematics = Condition.All.Lkinematics;
% %     Revent(i) = Condition(i).All.Rphases;
% %     Levent(i) = Condition(i).All.Lphases;

% =========================================================================
% Generate the page
% =========================================================================
% Case 1: Only 1 condition: page 1 = right and left parameters
% =========================================================================
  
    % Set the page
    % ---------------------------------------------------------------------
    f = figure('PaperOrientation','portrait','papertype','A4',...
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
    for i = 1:size(Condition,2)
        axesLegend = axes;
        set(axesLegend,'Position',[0 0 1 1]);
        set(axesLegend,'Visible','Off');
        
        % Write the legend
        text(0.05,y/pageHeight,['Condition ',num2str(i)],'Color',colorB(i,:),'FontWeight','Bold');
        text(0.25,y/pageHeight,'Droite','Color',colorR(i,:));
        text(0.30,y/pageHeight,'Gauche','Color',colorL(i,:));
        text(0.37,y/pageHeight,'Norm','Color',[0.5 0.5 0.5]);
        text(0.44,y/pageHeight,[char(Session.date),...
           '     Condition : ',char(regexprep(Condition.name,'_','-')),' (cf page 1)'],'color','k');
        y = y - yincr*1.0;
    end
    
        
    % Right/Left foot tilt
    % ---------------------------------------------------------------------
    y = y - yincr*7.5;
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    Graph(igraph) = axes('position',[x(1)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
    hold on;
    title('Foot tilt (plan sagittal)','FontWeight','Bold');
    xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Angle (deg)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
        corridor(Norm.Kinematics.Ftilt.mean,Norm.Kinematics.Ftilt.std,[0.5 0.5 0.5]);
    if ~isempty(Rkinematics.Ftilt.mean)
        corridor(Rkinematics.Ftilt.mean,Rkinematics.Ftilt.std,colorR(i,:));
        plot(Rkinematics.Ftilt.mean,'Linestyle','-','Linewidth',2,'Color',colorR(i,:));
    end
    if ~isempty(Lkinematics(i).Ftilt.mean)
        corridor(Lkinematics(i).Ftilt.mean,Lkinematics(i).Ftilt.std,colorL(i,:));
        plot(Lkinematics(i).Ftilt.mean,'Linestyle','-','Linewidth',2,'Color',colorL(i,:));
    end
    axis tight;
    YL = ylim;
    YL = setAxisLim(YL,-40,40);
    axis([0 100 YL(1) YL(2)]);
    box on;
    igraph = igraph+1;
    
    % Right/Left foot obliquity
    % ---------------------------------------------------------------------
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    Graph(igraph) = axes('position',[x(2)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
    hold on;
    title('Foot obliquity (plan frontal)','FontWeight','Bold');
    xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Angle (deg)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
        corridor(Norm.Kinematics.Fobli.mean,Norm.Kinematics.Fobli.std,[0.5 0.5 0.5]);
    if ~isempty(Rkinematics.Fobli.mean)
        corridor(Rkinematics.Fobli.mean,Rkinematics.Fobli.std,colorR(i,:));
        plot(Rkinematics.Fobli.mean,'Linestyle','-','Linewidth',2,'Color',colorR(i,:));
    end
    if ~isempty(Lkinematics(i).Fobli.mean)
        corridor(Lkinematics(i).Fobli.mean,Lkinematics(i).Fobli.std,colorL(i,:));
        plot(Lkinematics(i).Fobli.mean,'Linestyle','-','Linewidth',2,'Color',colorL(i,:));
    end
    axis tight;
    YL = ylim;
    YL = setAxisLim(YL,-40,40);
    axis([0 100 YL(1) YL(2)]);
    box on;
    igraph = igraph+1;
    
    % Right/Left foot rotation
    % ---------------------------------------------------------------------
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    Graph(igraph) = axes('position',[x(3)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
    hold on;
    title('Foot progression angle (plan transversal)','FontWeight','Bold');
    xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Angle (deg)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
        corridor(Norm.Kinematics.Frota.mean,Norm.Kinematics.Frota.std,[0.5 0.5 0.5]);
    if ~isempty(Rkinematics.Frota.mean)
        corridor(Rkinematics.Frota.mean,Rkinematics.Frota.std,colorR(i,:));
        plot(Rkinematics.Frota.mean,'Linestyle','-','Linewidth',2,'Color',colorR(i,:));
    end
    if ~isempty(Lkinematics(i).Frota.mean)
        corridor(Lkinematics(i).Frota.mean,Lkinematics(i).Frota.std,colorL(i,:));
        plot(Lkinematics(i).Frota.mean,'Linestyle','-','Linewidth',2,'Color',colorL(i,:));
    end
    axis tight;
    YL = ylim;
    YL = setAxisLim(YL,-40,40);
    axis([0 100 YL(1) YL(2)]);
    box on;
    igraph = igraph+1;
    
    y = y - yincr*7.5;
    if isfield(Rkinematics(i),'FE2')
        % Right/Left ankle flexion/extension
        % ---------------------------------------------------------------------
        axesGraph = axes;
        set(axesGraph,'Position',[0 0 1 1]);
        set(axesGraph,'Visible','Off');
        Graph(igraph) = axes('position',[x(1)/pageWidth y/pageHeight ...
            graphWidth/pageWidth graphHeight/pageHeight]);
        set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
        hold on;
        title('Ankle flexion/extension (Dorsi+)','FontWeight','Bold');
        xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Angle (deg)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
        plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
        corridor(Norm.Kinematics.FE2.mean,Norm.Kinematics.FE2.std,[0.5 0.5 0.5]);
        if ~isempty(Rkinematics(i).FE2.mean)
            corridor(Rkinematics(i).FE2.mean,Rkinematics(i).FE2.std,colorR(i,:));
            plot(Rkinematics(i).FE2.mean,'Linestyle','-','Linewidth',2,'Color',colorR(i,:));
        end
        if ~isempty(Lkinematics(i).FE2.mean)
            corridor(Lkinematics(i).FE2.mean,Lkinematics(i).FE2.std,colorL(i,:));
            plot(Lkinematics(i).FE2.mean,'Linestyle','-','Linewidth',2,'Color',colorL(i,:));
        end
        axis tight;
        YL = ylim;
        YL = setAxisLim(YL,-40,40);
        axis([0 100 YL(1) YL(2)]);
        box on;
        igraph = igraph+1;
    end
    
    if isfield(Rkinematics(i),'IER2')
        % Right/Left ankle internal/external rotation
        % ---------------------------------------------------------------------
        axesGraph = axes;
        set(axesGraph,'Position',[0 0 1 1]);
        set(axesGraph,'Visible','Off');
        Graph(igraph) = axes('position',[x(3)/pageWidth y/pageHeight ...
            graphWidth/pageWidth graphHeight/pageHeight]);
        set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
        hold on;
        title('Ankle internal/external rotation (Int+)','FontWeight','Bold');
        xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle'); ylabel('Angle (deg)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
        plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
        corridor(Norm.Kinematics.IER2.mean,Norm.Kinematics.IER2.std,[0.5 0.5 0.5]);
        if ~isempty(Rkinematics(i).IER2.mean)
            corridor(Rkinematics(i).IER2.mean,Rkinematics(i).IER2.std,colorR(i,:));
            plot(Rkinematics(i).IER2.mean,'Linestyle','-','Linewidth',2,'Color',colorR(i,:));
        end
        if ~isempty(Lkinematics(i).IER2.mean)
            corridor(Lkinematics(i).IER2.mean,Lkinematics(i).IER2.std,colorL(i,:));
            plot(Lkinematics(i).IER2.mean,'Linestyle','-','Linewidth',2,'Color',colorL(i,:));
        end
        axis tight;
        YL = ylim;
        YL = setAxisLim(YL,-40,40);
        axis([0 100 YL(1) YL(2)]);
        box on;
        igraph = igraph+1;
    end
    
    % Events
    % ---------------------------------------------------------------------
    Revent.p5.mean = Condition.All.Gaitparameters.right_stance_phase.mean;
    Revent.p5.std = Condition.All.Gaitparameters.right_stance_phase.std;
    Levent.p5.mean = Condition.All.Gaitparameters.left_stance_phase.mean;
    Levent.p5.std = Condition.All.Gaitparameters.left_stance_phase.std;
    
    for g = 1:length(Graph)
        axes(Graph(g));
        YL = ylim;
        corridor(Norm.Event.p5.mean,Norm.Event.p5.std,[0.5 0.5 0.5]);
        corridor(Revent.p5.mean,Revent.p5.std,colorR(1,:));
        plot([Revent.p5.mean Revent.p5.mean],[-180 180],'Linestyle','-','Linewidth',2,'Color',colorR(1,:)); %IHS
        corridor(Levent.p5.mean,Levent.p5.std,colorL(1,:));
        plot([Levent.p5.mean Levent.p5.mean],[-180 180],'Linestyle','-','Linewidth',2,'Color',colorL(1,:)); %IHS
    end