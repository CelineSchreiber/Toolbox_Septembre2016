% =========================================================================
% REHAZENTER TOOLBOX - PLUGIN CLINICAL REPORT
% =========================================================================
% File name:    reportGaitIndexes
% -------------------------------------------------------------------------
% Subject:      Generate the report page for gait indexes (NI,GDI,GVS,GPS)
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
% Date of creation: 21/01/2015
% Version: 1
% -------------------------------------------------------------------------
% Updates: -
% ========================================================================

function f=Rapport_GaitIndexes(Patient,Session,Condition,pluginFolder,normFolder,norm)


% Quelques parametres de mise en page...
%--------------------------------------------------------------------------
pageWidth = 21; % cm
pageHeight = 29.7; % cm
graphWidth = 7.0; % cm
graphHeight = 2; % cm
yinit = 29.0; % cm
yincr = 0.5; % cm
x=[1.05 7.00 11.00 16.45]; % cm
colorR = [0 0.8 0;0 0.8 0.8;0 0.4 0;0 0.4 0.4;0 0.2 0;0 0.2 0.2];
colorL = [0.8 0 0;0.8 0 0.8;0.4 0 0;0.4 0 0.4;0.2 0 0;0.2 0 0.2];
colorB = [0 0 0.8;0.2 0.2 0.8;0.5 0.5 0.8;0.7 0.7 0.8;0.9 0.9 0.8;0.9 0.9 0.6];

cd(normFolder);
temp = load(cell2mat(norm));
Norme = temp.Normatives.Index;
cd(pluginFolder);
for i = 1:size(Condition,2)
    Index(i)=Condition(i).All.Index;
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
    f(1) = figure('PaperOrientation','portrait','papertype','A4','Units',...
    'centimeters','Position',[0 0 pageWidth pageHeight],'Color','white',...
    'PaperUnits','centimeters','PaperPosition',[0 0 pageWidth pageHeight],...
    'Name',['indexes',num2str(1)]);
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
        '  Index ',...
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
        for j = 1:length(Condition(i).Gait);
            if ~isempty(Condition(i).Gait(j).Gaitparameters.cadence)
                nbtrials = nbtrials+1;
            end
        end
        % Write the legend
        text(0.05,y/pageHeight,['Condition ',num2str(i)],'Color',colorB(i,:),'FontWeight','Bold');
        text(0.25,y/pageHeight,'Droite','Color',colorR(i,:));
        text(0.30,y/pageHeight,'Gauche','Color',colorL(i,:));
        text(0.37,y/pageHeight,'Norme','Color',[0.5 0.5 0.5]);
        text(0.44,y/pageHeight,[char(Session(i).date),...
            '     Nb essais : ',num2str(nbtrials),...
            '     Condition : ',char(regexprep(Condition(i).name,'_','-'))],'color','k');
        y = y - yincr*1.0;
    end
    
    %-------------------------------
    %   GRAPHIQUES
    %-------------------------------                  
                    
    %% NI Index %%
    %----------------------------------------------------------------------
    y = y - yincr*6.5;
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    clear Labels;
    Labels{1} = [num2str(Index(1).NI.R.mean,'%2.2f'),' +/- ',...
        num2str(Index(1).NI.R.std,'%2.2f')];
    Labels{2} = [num2str(Index(1).NI.L.mean,'%2.2f'),' +/- ',...
        num2str(Index(1).NI.L.std,'%2.2f')];
    Labels{3} = [num2str(Index(1).NI.O.mean,'%2.2f'),' +/- ',...
        num2str(Index(1).NI.O.std,'%2.2f')];
    Labels{4} = [num2str(Norme.NI.O.mean,'%2.2f'),'.+/- ',...
        num2str(Norme.NI.O.std,'%2.2f')];
    Graph(1) = axes('position',[x(1)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(1),'FontSize',8,'XGrid','on','YTick',[ ],'XTick',0:100:500);
    hold on;
    title('Normalcy Index (NI)','FontWeight','Bold');
    
    
    barh(1,Index(1).NI.R.mean,'facecolor',colorR(1,:));
    barh(1,Index(1).NI.R.mean+Index(1).NI.R.std,...
    'facecolor','none','LineStyle','-');
    barh(1,Index(1).NI.R.mean-Index(1).NI.R.std,...
    'facecolor','none','LineStyle','-');
    barh(2,Index(1).NI.L.mean,'facecolor',colorL(1,:));
    barh(2,Index(1).NI.L.mean+Index(1).NI.L.std,...
        'facecolor','none','LineStyle','-');
    barh(2,Index(1).NI.L.mean-Index(1).NI.L.std,...
        'facecolor','none','LineStyle','-');
    barh(3,Index(1).NI.O.mean,'facecolor',colorB(1,:));
    barh(3,Index(1).NI.O.mean+Index(i).NI.O.std,...
        'facecolor','none','LineStyle','-');
    barh(3,Index(1).NI.O.mean-Index(i).NI.O.std,...
        'facecolor','none','LineStyle','-');
    barh(4,Norme.NI.O.mean,'facecolor',[0.5 0.5 0.5]);
    barh(4,Norme.NI.O.mean+Norme.NI.O.std,...
        'facecolor','none','LineStyle','-');
    barh(4,Norme.NI.O.mean-Norme.NI.O.std,...
        'facecolor','none','LineStyle','-');
    
    set(gca, 'YTick', 1:length(Labels), 'YTickLabel', Labels,...
        'YAxisLocation','right');
    xlim([0 500]);
    box on;
    
                   
    %%     GDI Index      %%
    %----------------------------------------------------------------------
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    clear Labels;
    Labels{1} = [num2str(Index(1).GDI.R.mean,'%2.2f'),' +/- ',...
        num2str(Index(1).GDI.R.std,'%2.2f')];
    Labels{2} = [num2str(Index(1).GDI.L.mean,'%2.2f'),' +/- ',...
        num2str(Index(1).GDI.L.std,'%2.2f')];
    Labels{3} = [num2str(Index(1).GDI.O.mean,'%2.2f'),' +/- ',...
        num2str(Index(1).GDI.O.std,'%2.2f')];
    Labels{4} = [num2str(Norme.GDI.O.mean,'%2.2f'),'.+/- ',...
        num2str(Norme.GDI.O.std,'%2.2f')];
    Graph(2) = axes('position',[x(3)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(2),'FontSize',8,'XGrid','on','YTick',[ ],'XTick',0:10:110);
    hold on;
    title('Gait Deviationnal Index (GDI)','FontWeight','Bold');
    
    barh(1,Index(1).GDI.R.mean,'facecolor',colorR(1,:));
    barh(1,Index(1).GDI.R.mean+Index(1).GDI.R.std,...
        'facecolor','none','LineStyle','-');
    barh(1,Index(1).GDI.R.mean-Index(1).GDI.R.std,...
        'facecolor','none','LineStyle','-');
    barh(2,Index(1).GDI.L.mean,'facecolor',colorL(1,:));
    barh(2,Index(1).GDI.L.mean+Index(1).GDI.L.std,...
        'facecolor','none','LineStyle','-');
    barh(2,Index(1).GDI.L.mean-Index(1).GDI.L.std,...
        'facecolor','none','LineStyle','-');
    barh(3,Index(1).GDI.O.mean,'facecolor',colorB(1,:));
    barh(3,Index(1).GDI.O.mean+Index(1).GDI.O.std,...
        'facecolor','none','LineStyle','-');
    barh(3,Index(1).GDI.O.mean-Index(1).GDI.O.std,...
        'facecolor','none','LineStyle','-');
    barh(4,Norme.GDI.O.mean,'facecolor',[0.5 0.5 0.5]);
    barh(4,Norme.GDI.O.mean+Norme.GDI.O.std,...
        'facecolor','none','LineStyle','-');
    barh(4,Norme.GDI.O.mean-Norme.GDI.O.std,...
        'facecolor','none','LineStyle','-');
        
    set(gca, 'YTick', 1:length(Labels), 'YTickLabel', Labels,...
        'YAxisLocation','right');
    xlim([0 110]);
    
    %% NI: NORMES selon ROMEI2004
    %------------------------
    y = y - yincr*6.5;
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    clear Labels;
    Labels={'Able-bodied','Idiopathic toe-walkers','Hemiplegics','Diplegics','Quadriplegics'};
    Graph(3) = axes('position',[x(1)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(3),'FontSize',8,'XGrid','on','YTick',[ ],'XTick',0:100:500);
    hold on;
    title('NI: Romei 2004','FontWeight','Bold');
    
%     barh(1,16.36,'facecolor',[0.5 0.5 0.5]);
%     barh(1,6.85,'facecolor','none','LineStyle','-');
%     barh(1,29.27,'facecolor','none','LineStyle','-');
    barh(1,28.47,'facecolor',[0.5 0.5 0.5]);
    barh(1,7.44,'facecolor','none','LineStyle','-');
    barh(1,46.32,'facecolor','none','LineStyle','-');
    barh(2,61.22,'facecolor',[0.5 0.5 0.5]);
    barh(2,44.7,'facecolor','none','LineStyle','-');
    barh(2,82.1,'facecolor','none','LineStyle','-');
    barh(3,189.28,'facecolor',[0.5 0.5 0.5]);
    barh(3,41.5,'facecolor','none','LineStyle','-');
    barh(3,435.5,'facecolor','none','LineStyle','-');
    barh(4,278.12,'facecolor',[0.5 0.5 0.5]);
    barh(4,59.6,'facecolor','none','LineStyle','-');
    barh(4,789.5,'facecolor','none','LineStyle','-');
    barh(5,283.71,'facecolor',[0.5 0.5 0.5]);
    barh(5,177.4,'facecolor','none','LineStyle','-');
    barh(5,626.5,'facecolor','none','LineStyle','-');
    
    set(gca, 'YTick', 1:5, 'YTickLabel', Labels,'YAxisLocation','right');    
    xlim([0 500]);
    
                    %-------------------%
                   %%     GPS Index      %%
                    %-------------------%
    y = y - yincr*6.5;
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    clear Labels;
    Labels{1}=[num2str(Index(1).GPS.R.mean,'%2.2f'),'  +/-  ',...
        num2str(Index(1).GPS.R.std,'%2.2f')];
    Labels{2}=[num2str(Index(1).GPS.L.mean,'%2.2f'),'  +/-  ',...
        num2str(Index(1).GPS.L.std,'%2.2f')];
    Labels{3}=[num2str(Index(1).GPS.O.mean,'%2.2f'),'  +/-  ',...
        num2str(Index(1).GPS.O.std,'%2.2f')];
    Labels{4}=[num2str(Norme.GPS.O.mean,'%2.2f'),'  +/-  ',...
        num2str(Norme.GPS.O.std,'%2.2f')];    
    Graph(4) = axes('position',[x(1)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(4),'FontSize',8,'XGrid','on','YTick',[ ],'XTick',0:2:20);
    hold on;
    title('Gait Profile Score (GPS)','FontWeight','Bold');
    
    barh(1,Index(1).GPS.R.mean,'facecolor',colorR(1,:));
    barh(1,Index(1).GPS.R.mean+Index(1).GPS.R.std,...
        'facecolor','none','LineStyle','-');
    barh(1,Index(1).GPS.R.mean-Index(1).GPS.R.std,...
        'facecolor','none','LineStyle','-');
    Labels{1}=[num2str(Index(1).GPS.R.mean,'%2.2f'),'  +/-  ',num2str(Index(1).GPS.R.std,'%2.2f')];
    barh(2,Index(1).GPS.L.mean,'facecolor',colorL(1,:));
    barh(2,Index(1).GPS.L.mean+Index(1).GPS.L.std,...
        'facecolor','none','LineStyle','-');
    barh(2,Index(1).GPS.L.mean-Index(1).GPS.L.std,...
        'facecolor','none','LineStyle','-');

    barh(3,Index(1).GPS.O.mean,'facecolor',colorB(1,:));
    barh(3,Index(1).GPS.O.mean+Index(1).GPS.O.std,...
        'facecolor','none','LineStyle','-');
    barh(3,Index(1).GPS.O.mean-Index(1).GPS.O.std,...
        'facecolor','none','LineStyle','-');

    barh(4,Norme.GPS.O.mean,'facecolor',[0.5 0.5 0.5]);
    barh(4,Norme.GPS.O.mean+Norme.GPS.O.std,...
        'facecolor','none','LineStyle','-');
    barh(4,Norme.GPS.O.mean-Norme.GPS.O.std,...
        'facecolor','none','LineStyle','-');
                
    set(gca, 'YTick', 1:length(Labels), 'YTickLabel', Labels,...
        'YAxisLocation','right');
    xlim([0 20]);
    
                    %-------------------%
                   %%     GVS Index      %%
                    %-------------------%
    y = y - yincr*6.5;
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    clear Labels;
    L={'Pelvic Tilt','Pelvic Obliquity','Pelvic Rotation','Hip Flexion',...
        'Hip abduction','Hip Rotation','Knee Flexion','Ankle Plantarflexion',...
        'Foot Progression'};
    Graph(5) = axes('position',[x(3)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(5),'FontSize',8,'XGrid','on','YTick',[ ],'XTick',[]);
    hold on;
    title('Gait Visual Score (GVS)','FontWeight','Bold');
    
    for j=1:3
        barh(3*j-2,Index(1).GVS.O.mean(j),'facecolor',colorB(1,:));
        barh(3*j-2,Index(1).GVS.O.mean(j)+Index(1).GVS.O.std(j),...
            'facecolor','none','LineStyle','-');
        barh(3*j-2,Index(1).GVS.O.mean(j)-Index(1).GVS.O.std(j),...
            'facecolor','none','LineStyle','-');
        Labels{3*j-2}=L{j};
        barh(3*j-1,Norme.GVS.O.mean(j),'facecolor',[0.5 0.5 0.5]);
        barh(3*j-1,Norme.GVS.O.mean(j)+Norme.GVS.O.std(j),...
            'facecolor','none','LineStyle','-');
        barh(3*j-1,Norme.GVS.O.mean(j)-Norme.GVS.O.std(j),...
            'facecolor','none','LineStyle','-');
    end
    for j=4:9
        barh(4*j-6,Index(1).GVS.O.mean(j),'facecolor',colorR(1,:));
        barh(4*j-6,Index(1).GVS.O.mean(j)+Index(1).GVS.O.std(j),...
            'facecolor','none','LineStyle','-');
        barh(4*j-6,Index(1).GVS.O.mean(j)-Index(1).GVS.O.std(j),...
            'facecolor','none','LineStyle','-');
        Labels{4*j-4}=L{j};
        barh(4*j-4,Norme.GVS.O.mean(j),'facecolor',[0.5 0.5 0.5]);
        barh(4*j-4,Norme.GVS.O.mean(j)+Norme.GVS.O.std(j),...
            'facecolor','none','LineStyle','-');
        barh(4*j-4,Norme.GVS.O.mean(j)-Norme.GVS.O.std(j),...
            'facecolor','none','LineStyle','-');
    end
    for j=10:15
        barh(4*(j-6)-5,Index(1).GVS.O.mean(j),'facecolor',colorL(1,:));
        barh(4*(j-6)-5,Index(1).GVS.O.mean(j)+Index(1).GVS.O.std(j),...
            'facecolor','none','LineStyle','-');
        barh(4*(j-6)-5,Index(1).GVS.O.mean(j)-Index(1).GVS.O.std(j),...
            'facecolor','none','LineStyle','-');
        Labels{4*(j-6)-5}=L{j-6};
    end
    set(gca, 'YTick', 1:length(Labels), 'YTickLabel', Labels,...
        'YAxisLocation','right');

elseif size(Condition,2) > 1
        
    % Set the page for right side parameters
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
        '  Index',...
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
        for j = 1:length(Condition(i).Gait);
            if ~isempty(Condition(i).Gait(j).Gaitparameters.cadence)
                nbtrials = nbtrials+1;
            end
        end
        % Write the legend
        text(0.05,y/pageHeight,['Condition ',num2str(i)],'Color',colorB(i,:),'FontWeight','Bold');
        text(0.25,y/pageHeight,'Droite','Color',colorR(i,:));
        text(0.33,y/pageHeight,'Norme','Color',[0.5 0.5 0.5]);
        text(0.40,y/pageHeight,[char(Session(i).date),...
            '     Nb essais : ',num2str(nbtrials),...
            '     Condition : ',char(regexprep(Condition(i).name,'_','-'))],'color','k');
        y = y - yincr;
    end
    
    % Right NI
    % ---------------------------------------------------------------------
    y = y - yincr*6.5;
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    clear Labels;
    Graph(1) = axes('position',[x(1)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(1),'FontSize',8,'XGrid','on','YTick',[ ],'XTick',0:100:500);
    for i = 1:size(Condition,2)
        Labels{i}=[num2str(Index(i).NI.R.mean,'%2.2f'),...
            '  +/-  ',num2str(Index(i).NI.R.std,'%2.2f')];
        barh(i,Index(i).NI.R.mean,'facecolor',colorB(i,:));
        barh(i,Index(i).NI.R.mean+Index(i).NI.R.std,...
            'facecolor','none','LineStyle','-');
        barh(i,Index(i).NI.R.mean-Index(i).NI.R.std,...
            'facecolor','none','LineStyle','-');
    end
    barh(size(Condition,2)+1,Norme.NI.R.mean,'facecolor',[0.5 0.5 0.5]);
    barh(size(Condition,2)+1,Norme.NI.R.mean+Norme.NI.R.std,...
        'facecolor','none','LineStyle','-');
    barh(size(Condition,2)+1,Norme.NI.R.mean-Norme.NI.R.std,...
        'facecolor','none','LineStyle','-');
    Labels{size(Condition,2)+1}=[num2str(Norme.NI.R.mean,'%2.2f'),...
        '  +/-  ',num2str(Norme.NI.R.std,'%2.2f')];
    set(gca,'YTick',1:length(Labels),'YTickLabel',Labels,'YAxisLocation','right');
  
    % Right GDI
    %----------------------------------------------------------------------
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    clear Labels;
    Graph(2) = axes('position',[x(3)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(2),'FontSize',8,'XGrid','on','YTick',[ ],'XTick',0:100:500);
    for i = 1:size(Condition,2)
        Labels{i}=[num2str(Index(i).GDI.R.mean,'%2.2f'),...
            '  +/-  ',num2str(Index(i).GDI.R.std,'%2.2f')];
        barh(i,Index(i).GDI.R.mean,'facecolor',colorB(i,:));
        barh(i,Index(i).GDI.R.mean+Index(i).GDI.R.std,...
            'facecolor','none','LineStyle','-');
        barh(i,Index(i).GDI.R.mean-Index(i).GDI.R.std,...
            'facecolor','none','LineStyle','-');
    end
    barh(size(Condition,2)+1,Norme.GDI.R.mean,'facecolor',[0.5 0.5 0.5]);
    barh(size(Condition,2)+1,Norme.GDI.R.mean+Norme.GDI.R.std,...
        'facecolor','none','LineStyle','-');
    barh(size(Condition,2)+1,Norme.GDI.R.mean-Norme.GDI.R.std,...
        'facecolor','none','LineStyle','-');
    Labels{size(Condition,2)+1}=[num2str(Norme.GDI.R.mean,'%2.2f'),...
        '  +/-  ',num2str(Norme.GDI.R.std,'%2.2f')];
    set(gca,'YTick',1:length(Labels),'YTickLabel',Labels,'YAxisLocation','right');
    
    % Right GPS
    %----------------------------------------------------------------------
    
    
            if nc==1
%                 bar(2*i,Index(i).GVS.L.mean,'facecolor',colorL(i,:));
%                 barh(i+1,Index(i).GPS.L.mean+Index(i).GPS.L.std,...
%                     'facecolor','none','LineStyle','-');
%                 barh(i+1,Index(i).GPS.L.mean-Index(i).GPS.L.std,...
%                     'facecolor','none','LineStyle','-');
%                 barh(i+2,100,'facecolor','none');
%                 barh(i+2,Norme.GPS.R.mean,'facecolor',[0.5 0.5 0.5]);
%                 barh(i+2,Norme.GPS.R.mean+Norme.GPS.R.std,...
%                     'facecolor','none','LineStyle','-');
%                 barh(i+2,Norme.GPS.R.mean-Norme.GPS.R.std,...
%                     'facecolor','none','LineStyle','-');
%             elseif i==nc
%                 barh(i+1,100,'facecolor',[0.7 0.7 0.7]);
%                 barh(i+1,Norme.GPS.R.mean,'facecolor',[0.5 0.5 0.5]);
%                 barh(i+1,Norme.GPS.R.mean+Norme.GPS.R.std,...
%                     'facecolor','none','LineStyle','-');
%                 barh(i+1,Norme.GPS.R.mean-Norme.GPS.R.std,...
%                     'facecolor','none','LineStyle','-');
            end
%         else
%             barh(i,100,'facecolor',colorL(i,:)+0.2);
%             barh(i,Index(i).GPS.L.mean,'facecolor',colorL(i,:));
%             barh(i,Index(i).GPS.L.mean+Index(i).GPS.L.std,...
%                 'facecolor','none','LineStyle','-');
%             barh(i,Index(i).GPS.L.mean-Index(i).GPS.L.std,...
%                 'facecolor','none','LineStyle','-');
%             if i==nc
%                 barh(i+1,100,'facecolor',[0.7 0.7 0.7]);
%                 barh(i+1,Norme.GPS.R.mean,'facecolor',[0.5 0.5 0.5]);
%                 barh(i+1,Norme.GPS.R.mean+Norme.GPS.R.std,...
%                     'facecolor','none','LineStyle','-');
%                 barh(i+1,Norme.GPS.R.mean-Norme.GPS.R.std,...
%                     'facecolor','none','LineStyle','-');
%             end
%         end
%     end
%     end
%     xlim([0 20]);
    
                    
% else
%     else
%         if p==1
%             for i=1:nc
%                 
%             end
%         else
%             for i=1:nc
%                 barh(i,Index(i).NI.L.mean,'facecolor',colorL(i,:));
%                 barh(i,Index(i).NI.L.mean+Index(i).NI.L.std,...
%                     'facecolor','none','LineStyle','-');
%                 barh(i,Index(i).NI.L.mean-Index(i).NI.L.std,...
%                     'facecolor','none','LineStyle','-');
%                 Labels{i}=[num2str(Index(i).NI.L.mean,'%2.4f'),'  +/-  ',num2str(Index(i).NI.L.std,'%2.2f')];
%                 if i==nc
%                     barh(i+1,Norme.NI.L.mean,'facecolor',[0.5 0.5 0.5]);
%                     barh(i+1,Norme.NI.L.mean+Norme.NI.L.std,...
%                         'facecolor','none','LineStyle','-');
%                     barh(i+1,Norme.NI.L.mean-Norme.NI.L.std,...
%                         'facecolor','none','LineStyle','-');
%                     Labels{i+1}=[num2str(Norme.NI.L.mean,'%2.2f'),'  +/-  ',num2str(Norme.NI.L.std,'%2.2f')];
%                 end
%             end
%         end
% end
%     else
%         if p==1
%             for i=1:nc
%                 barh(i,Index(i).GDI.O.mean,'facecolor',colorB(i,:));
%                 barh(i,Index(i).GDI.O.mean+Index(i).GDI.O.std,...
%                     'facecolor','none','LineStyle','-');
%                 barh(i,Index(i).GDI.O.mean-Index(i).GDI.O.std,...
%                     'facecolor','none','LineStyle','-');
%                 Labels{i}=[num2str(Index(i).GDI.O.mean,'%2.2f'),'  +/-  ',num2str(Index(i).GDI.O.std,'%2.2f')];
%                 if i==nc
%                     barh(i+1,Norme.GDI.O.mean,'facecolor',[0.5 0.5 0.5]);
%                     barh(i+1,Norme.GDI.O.mean+Norme.GDI.O.std,...
%                         'facecolor','none','LineStyle','-');
%                     barh(i+1,Norme.GDI.O.mean-Norme.GDI.O.std,...
%                         'facecolor','none','LineStyle','-');
%                     Labels{i+1}=[num2str(Norme.GDI.O.mean,'%2.2f'),'  +/-  ',num2str(Norme.GDI.O.std,'%2.2f')];
%                 end
%             end
%         else
%             for i=1:nc
%                 barh(i,Index(i).GDI.L.mean,'facecolor',colorL(i,:));
%                 barh(i,Index(i).GDI.L.mean+Index(i).GDI.L.std,...
%                     'facecolor','none','LineStyle','-');
%                 barh(i,Index(i).GDI.L.mean-Index(i).GDI.L.std,...
%                     'facecolor','none','LineStyle','-');
%                 Labels{i}=[num2str(Index(i).GDI.L.mean,'%2.4f'),'  +/-  ',num2str(Index(i).GDI.L.std,'%2.2f')];
%                 if i==nc
%                     barh(i+1,Norme.GDI.R.mean,'facecolor',[0.5 0.5 0.5]);
%                     barh(i+1,Norme.GDI.R.mean+Norme.GDI.R.std,...
%                         'facecolor','none','LineStyle','-');
%                     barh(i+1,Norme.GDI.R.mean-Norme.GDI.R.std,...
%                         'facecolor','none','LineStyle','-');
%                     Labels{i+1}=[num2str(Norme.GDI.L.mean,'%2.2f'),'  +/-  ',num2str(Norme.GDI.L.std,'%2.2f')];
%                 end
%             end
%         end
%         else
%         if p==1
%             for i=1:nc
%             	barh(i,Index(i).GPS.O.mean,'facecolor',colorB(i,:));
%                 barh(i,Index(i).GPS.O.mean+Index(i).GPS.O.std,...
%                     'facecolor','none','LineStyle','-');
%                 barh(i,Index(i).GPS.R.mean-Index(i).GPS.O.std,...
%                     'facecolor','none','LineStyle','-');
%                 Labels{i}=[num2str(Index(i).GPS.O.mean,'%2.2f'),'  +/-  ',num2str(Index(i).GPS.O.std,'%2.2f')];
%                 if i==nc
%                     barh(i+1,Norme.GPS.O.mean,'facecolor',[0.5 0.5 0.5]);
%                     barh(i+1,Norme.GPS.O.mean+Norme.GPS.O.std,...
%                         'facecolor','none','LineStyle','-');
%                     barh(i+1,Norme.GPS.O.mean-Norme.GPS.O.std,...
%                         'facecolor','none','LineStyle','-');
%                     Labels{i+1}=[num2str(Norme.GPS.O.mean,'%2.2f'),'  +/-  ',num2str(Norme.GPS.O.std,'%2.2f')];
%                 end
%             end
%         else
%             for i=1:nc
%                 barh(i,Index(i).GPS.L.mean,'facecolor',colorL(i,:));
%                 barh(i,Index(i).GPS.L.mean+Index(i).GPS.L.std,...
%                     'facecolor','none','LineStyle','-');
%                 barh(i,Index(i).GPS.L.mean-Index(i).GPS.L.std,...
%                     'facecolor','none','LineStyle','-');
%                 Labels{i}=[num2str(Index(i).GPS.L.mean,'%2.4f'),'  +/-  ',num2str(Index(i).GPS.L.std,'%2.2f')];
%                 if i==nc
%                     barh(i+1,Norme.GPS.L.mean,'facecolor',[0.5 0.5 0.5]);
%                     barh(i+1,Norme.GPS.L.mean+Norme.GPS.L.std,...
%                         'facecolor','none','LineStyle','-');
%                     barh(i+1,Norme.GPS.L.mean-Norme.GPS.L.std,...
%                         'facecolor','none','LineStyle','-');
%                     Labels{i+1}=[num2str(Norme.GPS.L.mean,'%2.2f'),'  +/-  ',num2str(Norme.GPS.L.std,'%2.2f')];
%                 end
%             end
%         end
    end
%         