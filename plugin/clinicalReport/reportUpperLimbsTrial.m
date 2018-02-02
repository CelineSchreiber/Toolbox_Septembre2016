% =========================================================================
% REHAZENTER TOOLBOX - PLUGIN CLINICAL REPORT
% =========================================================================
% File name:    reportKinematicsTrial
% -------------------------------------------------------------------------
% Subject:      Check one specific trial kinematics
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

function f = reportUpperLimbsTrial(Patient,Session,Condition,pluginFolder,normFolder,norm)

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
% temp = load(cell2mat(norm));
% Norm.Kinematics = temp.Normatives.Rkinematics;
% Norm.Event = temp.Normatives.Rphases;
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
Rkinematics = Condition(cond).UpperLimbs(trial).Rkinematics;
Lkinematics = Condition(cond).UpperLimbs(trial).Lkinematics;
Revent = Condition(cond).Gait(trial).Rphases;
Levent = Condition(cond).Gait(trial).Lphases;

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
    '  Cinématique des membres supérieurs',...
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
y1=y;
% Get recorded kinematics right side
% ---------------------------------------------------------------------
names = fieldnames(Rkinematics);

% Mise en page des graphes
%-------------------------
for igraph=1:length(names)
    g=floor((igraph+2)/3);
    y = y1 - yincr*g*8.5;
    x1=x(mod(igraph-1,3)+1);
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    Graph(igraph) = axes('position',[x1(1)/pageWidth y/pageHeight ...
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
    if ~isempty(Rkinematics.(names{igraph}))
        plot(Rkinematics.(names{igraph}),'Linestyle','-','Linewidth',2,'Color',colorR(cond,:));
    end
    if ~isempty(Lkinematics.(names{igraph}))
       plot(Lkinematics.(names{igraph}),'Linestyle','-','Linewidth',2,'Color',colorL(cond,:));
    end
    axis tight;
    if igraph<4
            YL = ylim;
            YL = setAxisLim(YL,-10,10);
            axis([0 100 YL(1) YL(2)]);
        elseif igraph>3 && igraph<7
            YL = ylim;
            YL = setAxisLim(YL,-40,40);
            axis([0 100 YL(1) YL(2)]);
        elseif igraph>6
            YL = ylim;
            YL = setAxisLim(YL,0,60);
            axis([0 100 YL(1) YL(2)]);
        elseif igraph==8
            axis([0 100 0 10]);
        end
    box on;
    igraph = igraph+1;
end

% Events
% ---------------------------------------------------------------------    
% for g = 1:length(Graph)
%     axes(Graph(g));
%     YL = ylim;
%     corridor(Norm.Event.p5.mean,Norm.Event.p5.std,[0.5 0.5 0.5]);
%     plot([Revent(1).p5 Revent(1).p5],[-180 180],'Linestyle','-','Linewidth',2,'Color',colorR(cond,:)); %IHS
%     plot([Revent(1).p2 Revent(1).p2],[YL(1)-20 YL(1)+(YL(2)-YL(1))/10],'Linewidth',1.5,'Color',colorR(cond,:)); %CTO
%     plot([Revent(1).p4 Revent(1).p4],[YL(1)-20 YL(1)+(YL(2)-YL(1))/10],'Linewidth',1.5,'Color',colorR(cond,:)); %CHS
%     plot([Levent(1).p5 Levent(1).p5],[-180 180],'Linestyle','-','Linewidth',2,'Color',colorL(cond,:)); %IHS
%     plot([Levent(1).p2 Levent(1).p2],[YL(1)-20 YL(1)+(YL(2)-YL(1))/10],'Linewidth',1.5,'Color',colorL(cond,:)); %CTO
%     plot([Levent(1).p4 Levent(1).p4],[YL(1)-20 YL(1)+(YL(2)-YL(1))/10],'Linewidth',1.5,'Color',colorL(cond,:)); %CHS
% end