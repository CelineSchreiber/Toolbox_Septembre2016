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

function f = reportUpperLimbsKinematics(Patient,Session,Condition,pluginFolder,normFolder,norm)

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
% Norm.KinematicsUL = temp.Normatives.RkinematicsUL;
% Norm.Event = temp.Normatives.Rphases;
cd(pluginFolder);
for i = 1:size(Condition,2)
%     RkinematicsUL(i) = Condition(i).All.RkinematicsUL;
%     LkinematicsUL(i) = Condition(i).All.LkinematicsUL;
%     Revent(i) = Condition(i).All.Rphases;
%     Levent(i) = Condition(i).All.Lphases;
end

% =========================================================================
% Generate the page
% =========================================================================
% Case 1: Only 1 condition: page 1 = right and left parameters
% Case 2: More than 1 condition: page 1 = right, page 2 = left
% =========================================================================
if size(Condition,2) == 1
    
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
        '  Cinématique du membre supérieur',...
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
        % Count the number of trials
        nbtrials = 0;
        for j = 1:length(Condition(i).UpperLimbs);
            if ~isempty(Condition(i).UpperLimbs(j).Rkinematics.ThoraxSag)
                nbtrials = nbtrials+1;
            end
        end
        % Write the legend
        text(0.05,y/pageHeight,['Condition ',num2str(i)],'Color',colorB(i,:),'FontWeight','Bold');
        text(0.25,y/pageHeight,'Droite','Color',colorR(i,:));
        text(0.30,y/pageHeight,'Gauche','Color',colorL(i,:));
        text(0.37,y/pageHeight,'Norm','Color',[0.5 0.5 0.5]);
        text(0.44,y/pageHeight,[char(Session(i).date),...
            '     Nb essais : ',num2str(nbtrials),...
            '     Condition : ',char(regexprep(Condition(i).name,'_','-')),' (cf page 1)'],'color','k');
        y = y - yincr*1.0;
    end
    y1=y;
    
    % Get recorded kinematics right side
    % ---------------------------------------------------------------------
    names = fieldnames(Condition.All.RkinematicsUL);
    
    % Mise en page des graphes
    %-------------------------
    for igraph=1:length(names)
        g=floor((igraph+2)/3);
        y = y1 - yincr*g*8.5;
        x1=x(mod(igraph-1,3)+1);
        axesGraph = axes;
        set(axesGraph,'Position',[0 0 1 1]);
        set(axesGraph,'Visible','Off');
        Graph(igraph) = axes('position',[x1/pageWidth y/pageHeight ...
                graphWidth/pageWidth graphHeight/pageHeight]);
        set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[],'YTick',-50e-4:1e-4:50e-4);
        hold on;
        title(names{igraph},'FontWeight','Bold');
        xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
        ylabel('Angle (deg)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
        plot(1:101,zeros(101,1),'Linestyle','-','Linewidth',0.5,'Color','black');
%         inorm = [];
%         inorm = eval(['Norm.KinematicsFoot.',names{igraph},';']);
%         corridor(inorm.mean,inorm.std,[0.5 0.5 0.5]);
        Rkinematics = Condition.All.RkinematicsUL.(names{igraph});
        if ~isempty(Rkinematics.mean)
            corridor(Rkinematics.mean,Rkinematics.std,colorR(i,:));
            plot(Rkinematics.mean,'Linestyle','-','Linewidth',2,'Color',colorR(i,:));
        end
        Lkinematics = Condition.All.LkinematicsUL.(names{igraph});
        if ~isempty(Lkinematics.mean)
            corridor(Lkinematics.mean,Lkinematics.std,colorL(i,:));
            plot(Lkinematics.mean,'Linestyle','-','Linewidth',2,'Color',colorL(i,:));
        end
        axis tight;
        if igraph<4
            YL = ylim;
            YL = setAxisLim(YL,-10,10);
            axis([0 100 YL(1) YL(2)]);
        elseif igraph>3 && igraph<7
            YL = ylim;
            YL = setAxisLim(YL,-20,20);
            axis([0 100 YL(1) YL(2)]);
        elseif igraph>6
            YL = ylim;
            YL = setAxisLim(YL,0,60);
            axis([0 100 YL(1) YL(2)]);
        elseif igraph==8
            axis([0 100 0 10]);
        end
        box on;
    end
    
%     % Events
%     % ---------------------------------------------------------------------
%     for g = 1:length(Graph)
%         axes(Graph(g));
%         YL = ylim;
% %         RTO=(Events.e.RTO(end)-Events.e.RHS(1))/(Events.e.RHS(2)-Events.e.RHS(1));
% %         corridor(Norm.Event.p5.mean,Norm.Event.p5.std,[0.5 0.5 0.5]);
%         corridor(Revent(i).p5.mean,Revent(i).p5.std,colorR(i,:));
%         plot([Revent(i).p5.mean Revent(i).p5.mean],[-180 180],'Linestyle','-','Linewidth',2,'Color',colorR(i,:)); %IHS
%         plot([Revent(i).p2.mean Revent(i).p2.mean],[YL(1)-20 YL(1)+(YL(2)-YL(1))/10],'Linewidth',1.5,'Color',colorR(i,:)); %CTO
%         plot([Revent(i).p4.mean Revent(i).p4.mean],[YL(1)-20 YL(1)+(YL(2)-YL(1))/10],'Linewidth',1.5,'Color',colorR(i,:)); %CHS
%         corridor(Levent(i).p5.mean,Levent(i).p5.std,colorL(i,:));
%         plot([Levent(i).p5.mean Levent(i).p5.mean],[-180 180],'Linestyle','-','Linewidth',2,'Color',colorL(i,:)); %IHS
%         plot([Levent(i).p2.mean Levent(i).p2.mean],[YL(1)-20 YL(1)+(YL(2)-YL(1))/10],'Linewidth',1.5,'Color',colorL(i,:)); %CTO
%         plot([Levent(i).p4.mean Levent(i).p4.mean],[YL(1)-20 YL(1)+(YL(2)-YL(1))/10],'Linewidth',1.5,'Color',colorL(i,:)); %CHS
%     end
    
else
    
    % Set the right side page
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
        '  Cinématique du membre supérieur',...
        'Color','k','FontWeight','Bold','FontSize',18,...
        'HorizontalAlignment','Center');
    y = y - yincr*2;
    text(0.02,y/pageHeight,...
        '  Côté droit',...
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
        % Count the number of trials
        nbtrials = 0;
        for j = 1:length(Condition(i).UpperLimbs);
            if ~isempty(Condition(i).UpperLimbs(j).Rkinematics)
                nbtrials = nbtrials+1;
            end
        end
        % Write the legend
        text(0.05,y/pageHeight,['Condition ',num2str(i)],'Color',colorB(i,:),'FontWeight','Bold');
        text(0.25,y/pageHeight,'Droite','Color',colorR(i,:));
        text(0.33,y/pageHeight,'Norme','Color',[0.5 0.5 0.5]);
        text(0.40,y/pageHeight,[char(Session(i).date),...
            '     Nb essais : ',num2str(nbtrials),...
            '     Condition : ',char(regexprep(Condition(i).name,'_','-')),' (cf page 1)'],'color','k');
        y = y - yincr;
    end
    y1=y;
    
    % Get recorded kinematics right side
    % ---------------------------------------------------------------------
    names = fieldnames(Condition(1).All.RkinematicsUL);
    
    % Mise en page des graphes
    %-------------------------
    for igraph=1:length(names)
        g=floor((igraph+2)/3);
        y = y1 - yincr*g*8.5;
        x1=x(mod(igraph-1,3)+1);
        axesGraph = axes;
        set(axesGraph,'Position',[0 0 1 1]);
        set(axesGraph,'Visible','Off');
        Graph(igraph) = axes('position',[x1/pageWidth y/pageHeight ...
                graphWidth/pageWidth graphHeight/pageHeight]);
        set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[],'YTick',-50e-4:1e-4:50e-4);
        hold on;
        title(names{igraph},'FontWeight','Bold');
        xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
        ylabel('Angle (deg)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
        plot(1:101,zeros(101,1),'Linestyle','-','Linewidth',0.5,'Color','black');
%         inorm = [];
%         inorm = eval(['Norm.KinematicsFoot.',names{igraph},';']);
%         corridor(inorm.mean,inorm.std,[0.5 0.5 0.5]);
        for i = 1:size(Condition,2)
            Rkinematics(i) = Condition(i).All.RkinematicsUL.(names{igraph});
            if ~isempty(Rkinematics(i).mean)
                corridor(Rkinematics(i).mean,Rkinematics(i).std,colorR(i,:));
                plot(Rkinematics(i).mean,'Linestyle','-','Linewidth',2,'Color',colorR(i,:));
            end
        end
        axis tight;
        if igraph<4
            YL = ylim;
            YL = setAxisLim(YL,-10,10);
            axis([0 100 YL(1) YL(2)]);
        elseif igraph>4 && igraph<7
            YL = ylim;
            YL = setAxisLim(YL,-20,20);
            axis([0 100 YL(1) YL(2)]);
        elseif igraph>7
            YL = ylim;
            YL = setAxisLim(YL,20,80);
            axis([0 100 YL(1) YL(2)]);
        elseif igraph==8
            axis([0 100 -1 1]);
        end
        box on;
    end
    
    % Events
    % ---------------------------------------------------------------------
%     for g = 1:length(Graph)
%         axes(Graph(g));
%         YL = ylim;
%         corridor(Norm.Event.p5.mean,Norm.Event.p5.std,[0.5 0.5 0.5]);
%         corridor(Revent(i).p5.mean,Revent(i).p5.std,colorR(i,:));
%         plot([Revent(i).p5.mean Revent(i).p5.mean],[-180 180],'Linestyle','-','Linewidth',2,'Color',colorR(i,:)); %IHS
%         plot([Revent(i).p2.mean Revent(i).p2.mean],[YL(1)-20 YL(1)+(YL(2)-YL(1))/10],'Linewidth',1.5,'Color',colorR(i,:)); %CTO
%         plot([Revent(i).p4.mean Revent(i).p4.mean],[YL(1)-20 YL(1)+(YL(2)-YL(1))/10],'Linewidth',1.5,'Color',colorR(i,:)); %CHS
%     end
    
    % Set the left side page
    % ---------------------------------------------------------------------
    igraph = 1;
    yinit = 29.0; % cm
    f(2) = figure('PaperOrientation','portrait','papertype','A4',...
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
        '  Côté gauche',...
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
        % Count the number of trials
        nbtrials = 0;
        for j = 1:length(Condition(i).UpperLimbs);
            if ~isempty(Condition(i).UpperLimbs(j).Lkinematics)
                nbtrials = nbtrials+1;
            end
        end
        % Write the legend
        text(0.05,y/pageHeight,['Condition ',num2str(i)],'Color',colorB(i,:),'FontWeight','Bold');
        text(0.25,y/pageHeight,'Gauche','Color',colorL(i,:));
        text(0.33,y/pageHeight,'Norme','Color',[0.5 0.5 0.5]);
        text(0.40,y/pageHeight,[char(Session(i).date),...
            '     Nb essais : ',num2str(nbtrials),...
            '     Condition : ',char(regexprep(Condition(i).name,'_','-')),' (cf page 1)'],'color','k');
        y = y - yincr;
    end
    y1=y;
    
    % Get recorded kinematics right side
    % ---------------------------------------------------------------------
    names = fieldnames(Condition(1).All.LkinematicsUL);
    
    % Mise en page des graphes
    %-------------------------
    for igraph=1:length(names)
        g=floor((igraph+2)/3);
        y = y1 - yincr*g*8.5;
        x1=x(mod(igraph-1,3)+1);
        axesGraph = axes;
        set(axesGraph,'Position',[0 0 1 1]);
        set(axesGraph,'Visible','Off');
        Graph(igraph) = axes('position',[x1/pageWidth y/pageHeight ...
                graphWidth/pageWidth graphHeight/pageHeight]);
        set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[],'YTick',-50e-4:1e-4:50e-4);
        hold on;
        title(names{igraph},'FontWeight','Bold');
        xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
        ylabel('Angle (deg)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
        plot(1:101,zeros(101,1),'Linestyle','-','Linewidth',0.5,'Color','black');
%         inorm = [];
%         inorm = eval(['Norm.KinematicsFoot.',names{igraph},';']);
%         corridor(inorm.mean,inorm.std,[0.5 0.5 0.5]);
        for i = 1:size(Condition,2)
            Lkinematics(i) = Condition(i).All.LkinematicsUL.(names{igraph});
            if ~isempty(Lkinematics(i).mean)
                corridor(Lkinematics(i).mean,Lkinematics(i).std,colorL(i,:));
                plot(Lkinematics(i).mean,'Linestyle','-','Linewidth',2,'Color',colorL(i,:));
            end
        end
        axis tight;
        if igraph<4
            YL = ylim;
            YL = setAxisLim(YL,-10,10);
            axis([0 100 YL(1) YL(2)]);
        elseif igraph>4 && igraph<7
            YL = ylim;
            YL = setAxisLim(YL,-20,20);
            axis([0 100 YL(1) YL(2)]);
        elseif igraph>7
            YL = ylim;
            YL = setAxisLim(YL,20,80);
            axis([0 100 YL(1) YL(2)]);
        elseif igraph==8
            axis([0 100 -1 1]);
        end
        box on;
    end
    
    % Events
    % ---------------------------------------------------------------------
%     for g = 1:length(Graph)
%         axes(Graph(g));
%         YL = ylim;
%         corridor(Norm.Event.p5.mean,Norm.Event.p5.std,[0.5 0.5 0.5]);
%         corridor(Levent(i).p5.mean,Levent(i).p5.std,colorL(i,:));
%         plot([Levent(i).p5.mean Levent(i).p5.mean],[-180 180],'Linestyle','-','Linewidth',2,'Color',colorL(i,:)); %IHS
%         plot([Levent(i).p2.mean Levent(i).p2.mean],[YL(1)-20 YL(1)+(YL(2)-YL(1))/10],'Linewidth',1.5,'Color',colorL(i,:)); %CTO
%         plot([Levent(i).p4.mean Levent(i).p4.mean],[YL(1)-20 YL(1)+(YL(2)-YL(1))/10],'Linewidth',1.5,'Color',colorL(i,:)); %CHS
%     end
%     
end