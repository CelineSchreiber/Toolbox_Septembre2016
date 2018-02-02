% =========================================================================
% REHAZENTER TOOLBOX - PLUGIN CLINICAL REPORT
% =========================================================================
% File name:    reportAI
% -------------------------------------------------------------------------
% Subject:      Generate the report page for rachis Kinematicsematics
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

function f=reportIA(Patient,Session,Condition,pluginFolder,normFolder,norm)

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
colorB = [0 0 0.8;0.2 0.2 0.8;0.5 0.5 0.8;0.7 0.7 0.8;0.9 0.9 0.8;0.9 0.9 0.6];
cd(normFolder);
temp = load(cell2mat(norm));
Norme = temp.Normatives.Rposturalindex.Aindex;
cd(pluginFolder);
for i = 1:size(Condition,2)
    Kinematicsematics(i) = Condition(i).All.Rposturalindex.Aindex;
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
    '  Indices d''ancrage',...
    'Color','k','FontWeight','Bold','FontSize',18,...
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
    for j = 1:length(Condition(i).Gait);
        if ~isempty(Condition(i).Gait(j).RKinematicsematics.Pobli)
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

%--------------------------------------------------------------------------
%   GRAPHIQUES
%--------------------------------------------------------------------------
                
% Index Head frontal
%--------------------------------------------------------------------------
y = y - yincr*6.5;
axesGraph = axes;

for i=1:nc
    if ~isempty(Kinematics(i).H_obli.mean)
        text(x(1)/pageWidth,(y+(HauteurGraphe-0.6)/(nc+1)*i)/Hauteur,...
        [num2str(Kinematics(i).H_obli.mean,'%2.2f'),'  +/-',num2str(Kinematics(i).H_obli.std,'%2.2f')]);
    end
    if i==nc
        text(x(1)/pageWidth,(y+(HauteurGraphe-0.6)/(nc+1)*(i+1))/Hauteur,...
        [num2str(Norme.H_obli.mean,'%2.2f'),'  +/-',num2str(Norme.H_obli.std,'%2.2f')]);
    end
end

set(axesGraph,'Position',[0 0 1 1]);
set(axesGraph,'Visible','Off');
Graph(igraph) = axes('position',[x(1)/pageWidth y/pageHeight ...
    graphWidth/pageWidth graphHeight/pageHeight]);
set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
hold on;
title('IA Head obli','FontWeight','Bold');

for i = 1:size(Condition,2)
    if ~isempty(Kinematics(i).H_obli.mean)
        barh(i,Kinematics(i).H_obli.mean,'facecolor',colorB(i,:));
        barh(i,Kinematics(i).H_obli.mean+Kinematics(i).H_obli.std,...
            'facecolor','none','LineStyle','-');
        barh(i,Kinematics(i).H_obli.mean-Kinematics(i).H_obli.std,...
            'facecolor','none','LineStyle','-');
    end
    if i==size(Condition,2)
        barh(i+1,Norme.H_obli.mean,'facecolor',[0.5 0.5 0.5]);
        barh(i+1,Norme.H_obli.mean+Norme.H_obli.std,...
            'facecolor','none','LineStyle','-');
        barh(i+1,Norme.H_obli.mean-Norme.H_obli.std,...
            'facecolor','none','LineStyle','-');
    end
end
xlim([-1 1]);

                %---------------------
                %% Index Head sagittal
                %---------------------
axes(AxesTextes);
for i=1:nc
    if ~isempty(Kinematics(i).H_tilt.mean)
        text(x(3)/pageWidth,(y+(HauteurGraphe-0.6)/(nc+1)*i)/Hauteur,...
            [num2str(Kinematics(i).H_tilt.mean,'%2.2f'),'  +/-',num2str(Kinematics(i).H_tilt.std,'%2.2f')]);
    end
    if i==nc
        text(x(3)/pageWidth,(y+(HauteurGraphe-0.6)/(nc+1)*(i+1))/Hauteur,...
        [num2str(Norme.H_tilt.mean,'%2.2f'),'  +/-',num2str(Norme.H_tilt.std,'%2.2f')]);
    end
end
Graph(11) = axes('position',[x(4)/pageWidth y/Hauteur pageWidthGraphe/pageWidth HauteurGraphe/Hauteur]);
set(Graph(11),'FontSize',8,'XGrid','on','YTick',[ ],'XTick',0:10:100);
hold on;
title('IA Head tilt','FontWeight','Bold');

for i = 1:nc
    if ~isempty(Kinematics(i).H_tilt.mean)
        barh(i,Kinematics(i).H_tilt.mean,'facecolor',colorB(i,:));
        barh(i,Kinematics(i).H_tilt.mean+Kinematics(i).H_tilt.std,...
            'facecolor','none','LineStyle','-');
        barh(i,Kinematics(i).H_tilt.mean-Kinematics(i).H_tilt.std,...
            'facecolor','none','LineStyle','-');
    end
    if i==nc
        barh(i+1,Norme.H_tilt.mean,'facecolor',[0.5 0.5 0.5]);
        barh(i+1,Norme.H_tilt.mean+Norme.H_tilt.std,...
            'facecolor','none','LineStyle','-');
        barh(i+1,Norme.H_tilt.mean-Norme.H_tilt.std,...
            'facecolor','none','LineStyle','-');
    end
end
xlim([-1 1]);

                %--------------------------
                %% Index Head transversal
                %--------------------------
axes(AxesTextes);
for i=1:nc
    if ~isempty(Kinematics(i).H_rota.mean)
        text(x(5)/pageWidth,(y+(HauteurGraphe-0.6)/(nc+1)*i)/Hauteur,...
            [num2str(Kinematics(i).H_rota.mean,'%2.2f'),'  +/-',num2str(Kinematics(i).H_rota.std,'%2.2f')]);
    end
    if i==nc
        text(x(5)/pageWidth,(y+(HauteurGraphe-0.6)/(nc+1)*(i+1))/Hauteur,...
        [num2str(Norme.H_rota.mean,'%2.2f'),'  +/-',num2str(Norme.H_rota.std,'%2.2f')]);
    end
end
Graph(12) = axes('position',[x(6)/pageWidth y/Hauteur pageWidthGraphe/pageWidth HauteurGraphe/Hauteur]);
set(Graph(12),'FontSize',8,'XGrid','on','YTick',[ ],'XTick',0:10:100);
hold on;
title('IA Head rota','FontWeight','Bold');

for i = 1:nc
    if ~isempty(Kinematics(i).H_rota.mean)
        barh(i,Kinematics(i).H_rota.mean,'facecolor',colorB(i,:));
        barh(i,Kinematics(i).H_rota.mean+Kinematics(i).H_rota.std,...
            'facecolor','none','LineStyle','-');
        barh(i,Kinematics(i).H_rota.mean-Kinematics(i).H_rota.std,...
            'facecolor','none','LineStyle','-');
    end
    if i==nc
        barh(i+1,Norme.H_rota.mean,'facecolor',[0.5 0.5 0.5]);
        barh(i+1,Norme.H_rota.mean+Norme.H_rota.std,...
            'facecolor','none','LineStyle','-');
        barh(i+1,Norme.H_rota.mean-Norme.H_rota.std,...
            'facecolor','none','LineStyle','-');
    end
end
xlim([-1 1]);

                %--------------------------
                %% Index Shoulders frontal
                %--------------------------
y=y-5;

axes(AxesTextes);
for i=1:nc
    if ~isempty(Kinematics(i).S_obli.mean)
        text(x(1)/pageWidth,(y+(HauteurGraphe-0.6)/(nc+1)*i)/Hauteur,...
            [num2str(Kinematics(i).S_obli.mean,'%2.2f'),'  +/-',num2str(Kinematics(i).S_obli.std,'%2.2f')]);
    end
    if i==nc
        text(x(1)/pageWidth,(y+(HauteurGraphe-0.6)/(nc+1)*(i+1))/Hauteur,...
        [num2str(Norme.S_obli.mean,'%2.2f'),'  +/-',num2str(Norme.S_obli.std,'%2.2f')]);
    end
end
Graph(13) = axes('position',[x(2)/pageWidth y/Hauteur pageWidthGraphe/pageWidth HauteurGraphe/Hauteur]);
set(Graph(13),'FontSize',8,'XGrid','on','YTick',[ ],'XTick',0:10:100);
hold on;
title('IA Shoulders obli','FontWeight','Bold');

for i = 1:nc
    if ~isempty(Kinematics(i).S_obli.mean)
        barh(i,Kinematics(i).S_obli.mean,'facecolor',colorB(i,:));
        barh(i,Kinematics(i).S_obli.mean+Kinematics(i).S_obli.std,...
            'facecolor','none','LineStyle','-');
        barh(i,Kinematics(i).S_obli.mean-Kinematics(i).S_obli.std,...
            'facecolor','none','LineStyle','-');
    end
    if i==nc
        barh(i+1,Norme.S_obli.mean,'facecolor',[0.5 0.5 0.5]);
        barh(i+1,Norme.S_obli.mean+Norme.S_obli.std,...
            'facecolor','none','LineStyle','-');
        barh(i+1,Norme.S_obli.mean-Norme.S_obli.std,...
            'facecolor','none','LineStyle','-');
    end
end
xlim([-1 1]);

                %--------------------------
                %% Index Shoulders sagittal
                %--------------------------
axes(AxesTextes);
for i=1:nc
    if ~isempty(Kinematics(i).S_tilt.mean)
        text(x(3)/pageWidth,(y+(HauteurGraphe-0.6)/(nc+1)*i)/Hauteur,...
        [num2str(Kinematics(i).S_tilt.mean,'%2.2f'),'  +/-',num2str(Kinematics(i).S_tilt.std,'%2.2f')]);
    end
    if i==nc
        text(x(3)/pageWidth,(y+(HauteurGraphe-0.6)/(nc+1)*(i+1))/Hauteur,...
        [num2str(Norme.S_tilt.mean,'%2.2f'),'  +/-',num2str(Norme.S_tilt.std,'%2.2f')]);
    end
end
Graph(14) = axes('position',[x(4)/pageWidth y/Hauteur pageWidthGraphe/pageWidth HauteurGraphe/Hauteur]);
set(Graph(14),'FontSize',8,'XGrid','on','YTick',[ ],'XTick',0:10:100);
hold on;
title('IA Shoulders tilt','FontWeight','Bold');

for i = 1:nc
    if ~isempty(Kinematics(i).S_tilt.mean)
        barh(i,Kinematics(i).S_tilt.mean,'facecolor',colorB(i,:));
        barh(i,Kinematics(i).S_tilt.mean+Kinematics(i).S_tilt.std,...
            'facecolor','none','LineStyle','-');
        barh(i,Kinematics(i).S_tilt.mean-Kinematics(i).S_tilt.std,...
            'facecolor','none','LineStyle','-');
    end
    if i==nc
        barh(i+1,Norme.S_tilt.mean,'facecolor',[0.5 0.5 0.5]);
        barh(i+1,Norme.S_tilt.mean+Norme.S_tilt.std,...
            'facecolor','none','LineStyle','-');
        barh(i+1,Norme.S_tilt.mean-Norme.S_tilt.std,...
            'facecolor','none','LineStyle','-');
    end
end
xlim([-1 1]);

                %-----------------------------
                %% Index Shoulders transversal
                %-----------------------------
axes(AxesTextes);
for i=1:nc
    if ~isempty(Kinematics(i).S_rota.mean)
        text(x(5)/pageWidth,(y+(HauteurGraphe-0.6)/(nc+1)*i)/Hauteur,...
        [num2str(Kinematics(i).S_rota.mean,'%2.2f'),'  +/-',num2str(Kinematics(i).S_rota.std,'%2.2f')]);
    end
    if i==nc
        text(x(5)/pageWidth,(y+(HauteurGraphe-0.6)/(nc+1)*(i+1))/Hauteur,...
        [num2str(Norme.S_rota.mean,'%2.2f'),'  +/-',num2str(Norme.S_rota.std,'%2.2f')]);
    end
end
Graph(15) = axes('position',[x(6)/pageWidth y/Hauteur pageWidthGraphe/pageWidth HauteurGraphe/Hauteur]);
set(Graph(15),'FontSize',8,'XGrid','on','YTick',[ ],'XTick',0:10:100);
hold on;
title('IA Shoulders rota','FontWeight','Bold');

for i = 1:nc
    if ~isempty(Kinematics(i).S_rota.mean)    
        barh(i,Kinematics(i).S_rota.mean,'facecolor',colorB(i,:));
        barh(i,Kinematics(i).S_rota.mean+Kinematics(i).S_rota.std,...
            'facecolor','none','LineStyle','-');
        barh(i,Kinematics(i).S_rota.mean-Kinematics(i).S_rota.std,...
            'facecolor','none','LineStyle','-');
    end
    if i==nc
        barh(i+1,Norme.S_rota.mean,'facecolor',[0.5 0.5 0.5]);
        barh(i+1,Norme.S_rota.mean+Norme.S_rota.std,...
            'facecolor','none','LineStyle','-');
        barh(i+1,Norme.S_rota.mean-Norme.S_rota.std,...
            'facecolor','none','LineStyle','-');
    end
end
xlim([-1 1]);