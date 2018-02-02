% =========================================================================
% REHAZENTER TOOLBOX - PLUGIN CLINICAL REPORT
% =========================================================================
% File name:    reportNCCF
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

function f=reportNCCF(Patient,Session,Condition,pluginFolder,normFolder,norm)

% =========================================================================
% Initialisation
% =========================================================================
pageWidth = 21; % cm
pageHeight = 29.7; % cm
graphWidth = 4.5; % cm
graphHeight = 3.5; % cm
yinit = 29.0; % cm
yincr = 0.5; % cm
x=[1.5 8 14.5];
igraph = 1; % graph number
colorB = [0 0 0.8;0.2 0.2 0.8;0.5 0.5 0.8;0.7 0.7 0.8;0.9 0.9 0.8;0.9 0.9 0.6];
cd(normFolder);
temp = load(cell2mat(norm));
Norme = temp.Normatives.Rposturalindex.Ifunction;
cd(pluginFolder);
for i=1:size(Condition,2)
    Kinematics(i) = Condition(i).All.Rposturalindex.Ifunction;
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
    '  Fonctions d''intercorrelation',...
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
        if ~isempty(Condition(i).Gait(j).Rposturalindex.Ifunction)
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

%-------------------------------
%   GRAPHIQUES
%-------------------------------
            %--------------%
            %%  Head obli  %
            %--------------%
y=y-6;
Graph(17) = axes('position',[x(1)/Largeur y/Hauteur LargeurGraphe/Largeur HauteurGraphe/Hauteur]);
set(Graph(17),'FontSize',8,'XGrid','on','YTick',[ ],'XTick',-100:20:100);
hold on;
title('Head obli','FontWeight','Bold');

plot((-100:1:100),zeros(201,1),'Linestyle','-','Linewidth',0.5,'Color','black');
plot([0 0],[-1 1],'Linestyle','-','Linewidth',0.5,'Color','black');
for i = 1:nc
    if ~isempty(Kin(i).HA_TA_OB.mean)
        corridorX((-100:1:100),Kin(i).HA_TA_OB.mean,Kin(i).HA_TA_OB.std,colorB(i,:));
        plot((-100:1:100),Kin(i).HA_TA_OB.mean,'Linestyle','-','Linewidth',2,'Color',colorB(i,:));
   end
end
axis tight; 
axis([-100 100 -1 1]);

            %--------------%
            %%  Head tilt  %
            %--------------%

Graph(16) = axes('position',[x(2)/Largeur y/Hauteur LargeurGraphe/Largeur HauteurGraphe/Hauteur]);
set(Graph(16),'FontSize',8,'XGrid','on','YTick',[ ],'XTick',-100:20:100);
hold on;
title('Head tilt','FontWeight','Bold');

plot((-100:1:100),zeros(201,1),'Linestyle','-','Linewidth',0.5,'Color','black');
plot([0 0],[-1 1],'Linestyle','-','Linewidth',0.5,'Color','black');
for i = 1:nc
    if ~isempty(Kin(i).HA_TA_TI.mean)
        corridorX((-100:1:100),Kin(i).HA_TA_TI.mean,Kin(i).HA_TA_TI.std,colorB(i,:));
        plot((-100:1:100),Kin(i).HA_TA_TI.mean,'Linestyle','-','Linewidth',2,'Color',colorB(i,:));
   end
end
axis tight;
axis([-100 100 -1 1]);



            %--------------%
            %%  Head rota  %
            %--------------%
Graph(18) = axes('position',[x(3)/Largeur y/Hauteur LargeurGraphe/Largeur HauteurGraphe/Hauteur]);
set(Graph(18),'FontSize',8,'XGrid','on','YTick',[ ],'XTick',-100:20:100);
hold on;
title('Head rota','FontWeight','Bold');

plot((-100:1:100),zeros(201,1),'Linestyle','-','Linewidth',0.5,'Color','black');
plot([0 0],[-1 1],'Linestyle','-','Linewidth',0.5,'Color','black');
for i = 1:nc
    if ~isempty(Kin(i).HA_TA_RO.mean)
        corridorX((-100:1:100),Kin(i).HA_TA_RO.mean,Kin(i).HA_TA_RO.std,colorB(i,:));
        plot((-100:1:100),Kin(i).HA_TA_RO.mean,'Linestyle','-','Linewidth',2,'Color',colorB(i,:));
   end
end
axis tight; 
axis([-100 100 -1 1]);

% ****************************************************************************
            %-------------------%
            %%  Shoulders obli  %
            %-------------------%
y=y-5;
Graph(20) = axes('position',[x(1)/Largeur y/Hauteur LargeurGraphe/Largeur HauteurGraphe/Hauteur]);
set(Graph(20),'FontSize',8,'XGrid','on','YTick',[ ],'XTick',-100:20:100);
hold on;
title('Shoulders obli','FontWeight','Bold');

plot((-100:1:100),zeros(201,1),'Linestyle','-','Linewidth',0.5,'Color','black');
plot([0 0],[-1 1],'Linestyle','-','Linewidth',0.5,'Color','black');
for i = 1:nc
    if ~isempty(Kin(i).TA_PA_OB.mean)
        corridorX((-100:1:100),Kin(i).TA_PA_OB.mean,Kin(i).TA_PA_OB.std,colorB(i,:));
        plot((-100:1:100),Kin(i).TA_PA_OB.mean,'Linestyle','-','Linewidth',2,'Color',colorB(i,:));
   end
end
axis tight; 
axis([-100 100 -1 1]);
            %-------------------%
            %%  Shoulders tilt  %
            %-------------------%
Graph(19) = axes('position',[x(2)/Largeur y/Hauteur LargeurGraphe/Largeur HauteurGraphe/Hauteur]);
set(Graph(19),'FontSize',8,'XGrid','on','YTick',[ ],'XTick',-100:20:100);
hold on;
title('Shoulders tilt','FontWeight','Bold');

plot((-100:1:100),zeros(201,1),'Linestyle','-','Linewidth',0.5,'Color','black');
plot([0 0],[-1 1],'Linestyle','-','Linewidth',0.5,'Color','black');
for i = 1:nc
    if ~isempty(Kin(i).TA_PA_TI.mean)
        corridorX((-100:1:100),Kin(i).TA_PA_TI.mean,Kin(i).TA_PA_TI.std,colorB(i,:));
        plot((-100:1:100),Kin(i).TA_PA_TI.mean,'Linestyle','-','Linewidth',2,'Color',colorB(i,:));
   end
end
axis tight;
axis([-100 100 -1 1]);
            %-------------------%
            %%  Shoulders rota  %
            %-------------------%
Graph(21) = axes('position',[x(3)/Largeur y/Hauteur LargeurGraphe/Largeur HauteurGraphe/Hauteur]);
set(Graph(21),'FontSize',8,'XGrid','on','YTick',[ ],'XTick',-100:20:100);
hold on;
title('Shoulders rota','FontWeight','Bold');

plot((-100:1:100),zeros(201,1),'Linestyle','-','Linewidth',0.5,'Color','black');
plot([0 0],[-1 1],'Linestyle','-','Linewidth',0.5,'Color','black');
for i = 1:nc
    if ~isempty(Kin(i).TA_PA_RO.mean)    
        corridorX((-100:1:100),Kin(i).TA_PA_RO.mean,Kin(i).TA_PA_RO.std,colorB(i,:));
        plot((-100:1:100),Kin(i).TA_PA_RO.mean,'Linestyle','-','Linewidth',2,'Color',colorB(i,:));
   end
end
axis tight; 
axis([-100 100 -1 1]);
