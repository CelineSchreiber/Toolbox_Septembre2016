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

function f = reportIndexes(Patient,Session,Condition,pluginFolder,normFolder,norm)

% % Calcul des index si nécessaire %%NON TESTE!!!%%
% %--------------------------------------------------------------------------
cd(normFolder);
temp = load(cell2mat(norm));
Norme = temp.Normatives; 
cd(pluginFolder);
% if ~strcmp(Session.markersset,'Paramètres')  && ~strcmp(Session.markersset,'EMG')
%     for i = 1:length(Session.Gait)
%         Condition.Gait(i).Index = computeIndexes(Session.Gait(i),Condition.Gait(i),Norme);
%     end
% end


% Quelques parametres de mise en page...
%--------------------------------------------------------------------------
pageWidth = 21; % cm
pageHeight = 29.7; % cm
graphWidth = 7.0; % cm
graphHeight = 2; % cm
yinit = 29.0; % cm
yincr = 0.5; % cm
x=[1.05 7.00 10.75 16.45]; % cm
colorR = [0 0.8 0;0 0.8 0.8;0 0.4 0;0 0.4 0.4;0 0.2 0;0 0.2 0.2];
colorL = [0.8 0 0;0.8 0 0.8;0.4 0 0;0.4 0 0.4;0.2 0 0;0.2 0 0.2];
colorB = [0 0 0.8;0.3 0.3 0.8;0.5 0.5 0.8;0.7 0.7 0.8;0.9 0.9 0.8;0.9 0.9 0.6];

for i = 1:size(Condition,2)
    Index(i) = Condition(i).All.Index;
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
        'Indices de marche',...
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
    text(0.05,y/pageHeight,'Norme','Color',[0.5 0.5 0.5],'FontWeight','Bold');
    y = y - yincr*1.5;
    axesLegend = axes;
    set(axesLegend,'Position',[0 0 1 1]);
    set(axesLegend,'Visible','Off');
    % Count the number of trials
    nbtrials = 0;
    for j = 1:length(Condition.Gait);
        if ~isempty(Condition.Gait(j).Index.NI)
            nbtrials = nbtrials+1;
        end
    end
    % Write the legend
    text(0.05,y/pageHeight,'Global','Color',colorB(1,:));
    text(0.10,y/pageHeight,'Droite','Color',colorR(1,:));
    text(0.15,y/pageHeight,'Gauche','Color',colorL(1,:));
    text(0.23,y/pageHeight,['Cond: ',char(regexprep(Condition(i).name,'_','-'))],...
        'Color','k');
    text(0.50,y/pageHeight,[char(Session(i).date),...
        '     Nb essais : ',num2str(nbtrials)],'color','k');
    y = y - yincr*1.0;
    
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
    Labels{4} = [num2str(Norme.Index.NI.O.mean,'%2.2f'),'.+/- ',...
        num2str(Norme.Index.NI.O.std,'%2.2f')];
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
    barh(4,Norme.Index.NI.O.mean,'facecolor',[0.5 0.5 0.5]);
    barh(4,Norme.Index.NI.O.mean+Norme.Index.NI.O.std,...
        'facecolor','none','LineStyle','-');
    barh(4,Norme.Index.NI.O.mean-Norme.Index.NI.O.std,...
        'facecolor','none','LineStyle','-');
    
    set(gca, 'YTick', 1:length(Labels), 'YTickLabel', Labels,...
        'YAxisLocation','right');
    xlim([0 200]);
    box on;
    
     
    %% NI: NORMES selon ROMEI2004
    %------------------------
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    clear Labels;
    Labels={'Able-bodied','Idiopathic toe-walkers','Hemiplegics','Diplegics'};%'Quadriplegics'
    Graph(2) = axes('position',[x(3)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(2),'FontSize',8,'XGrid','on','YTick',[ ],'XTick',0:100:500);
    hold on;
    title('NI: Romei 2004','FontWeight','Bold');
    
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
    
    set(gca, 'YTick', 1:4, 'YTickLabel', Labels,'YAxisLocation','right');    
    xlim([0 500]);
                   
    %%     GDI Index      %%
    %----------------------------------------------------------------------
    y = y - yincr*6.5;
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
    Labels{4} = [num2str(Norme.Index.GDI.O.mean,'%2.2f'),'.+/- ',...
        num2str(Norme.Index.GDI.O.std,'%2.2f')];
    Graph(3) = axes('position',[x(1)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(3),'FontSize',8,'XGrid','on','YTick',[ ],'XTick',0:10:110);
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
    barh(4,Norme.Index.GDI.O.mean,'facecolor',[0.5 0.5 0.5]);
    barh(4,Norme.Index.GDI.O.mean+Norme.Index.GDI.O.std,...
        'facecolor','none','LineStyle','-');
    barh(4,Norme.Index.GDI.O.mean-Norme.Index.GDI.O.std,...
        'facecolor','none','LineStyle','-');
        
    set(gca, 'YTick', 1:length(Labels), 'YTickLabel', Labels,...
        'YAxisLocation','right');
    xlim([0 110]);
    
%     %---------------------%
%    %%     Symmetrie NI    %%
%     %---------------------%
%     axesGraph = axes;
%     set(axesGraph,'Position',[0 0 1 1]);
%     set(axesGraph,'Visible','Off');
%     clear Labels;
%     Labels{1} = [num2str(Index(1).SR.NI.mean,'%2.2f'),' +/- ',...
%         num2str(Index(1).SR.NI.std,'%2.2f')];
%     Labels{2} = [num2str(Norme.SR.NI.mean,'%2.2f'),' +/- ',...
%         num2str(Norme.SR.NI.std,'%2.2f')];
%     Graph(4) = axes('position',[x(3)/pageWidth y/pageHeight ...
%         graphWidth/pageWidth graphHeight/pageHeight]);
%     set(Graph(4),'FontSize',8,'XGrid','on','YTick',[ ],'XTick',0:10:110);
%     hold on;
%     title('Symmetry Index (NI)','FontWeight','Bold');
%     
%     barh(1,Index(1).SR.NI.mean,'facecolor',colorB(1,:));
%     barh(1,Index(1).SR.NI.mean+Index(1).SR.NI.std,...
%         'facecolor','none','LineStyle','-');
%     barh(1,Index(1).SR.NI.mean-Index(1).SR.NI.std,...
%         'facecolor','none','LineStyle','-');
%     
%     barh(2,Norme.SR.NI.mean,'facecolor',[0.5 0.5 0.5]);
%     barh(2,Norme.SR.NI.mean+Norme.SR.NI.std,...
%         'facecolor','none','LineStyle','-');
%     barh(2,Norme.SR.NI.mean-Norme.SR.NI.std,...
%         'facecolor','none','LineStyle','-');
%         
%     set(gca, 'YTick', 1:length(Labels), 'YTickLabel', Labels,...
%         'YAxisLocation','right');
%     xlim([0 2]);
    
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
    Labels{4}=[num2str(Norme.Index.GPS.O.mean,'%2.2f'),'  +/-  ',...
        num2str(Norme.Index.GPS.O.std,'%2.2f')];    
    Graph(5) = axes('position',[x(1)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(5),'FontSize',8,'XGrid','on','YTick',[ ],'XTick',0:2:20);
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

    barh(4,Norme.Index.GPS.O.mean,'facecolor',[0.5 0.5 0.5]);
    barh(4,Norme.Index.GPS.O.mean+Norme.Index.GPS.O.std,...
        'facecolor','none','LineStyle','-');
    barh(4,Norme.Index.GPS.O.mean-Norme.Index.GPS.O.std,...
        'facecolor','none','LineStyle','-');
                
    set(gca, 'YTick', 1:length(Labels), 'YTickLabel', Labels,...
        'YAxisLocation','right');
    xlim([0 20]);
    
%     %----------------------%
%    %%     Symmetrie GDI    %%
%     %----------------------%
%     axesGraph = axes;
%     set(axesGraph,'Position',[0 0 1 1]);
%     set(axesGraph,'Visible','Off');
%     clear Labels;
%     Labels{1} = [num2str(Index(1).SR.GDI.mean,'%2.2f'),' +/- ',...
%         num2str(Index(1).SR.GDI.std,'%2.2f')];
%     Labels{2} = [num2str(Norme.SR.GDI.mean,'%2.2f'),' +/- ',...
%         num2str(Norme.SR.GDI.std,'%2.2f')];
%     Graph(7) = axes('position',[x(3)/pageWidth y/pageHeight ...
%         graphWidth/pageWidth graphHeight/pageHeight]);
%     set(Graph(7),'FontSize',8,'XGrid','on','YTick',[ ],'XTick',0:10:110);
%     hold on;
%     title('Symmetry Index (GDI)','FontWeight','Bold');
%     
%     barh(1,Index(1).SR.GDI.mean,'facecolor',colorB(1,:));
%     barh(1,Index(1).SR.GDI.mean+Index(1).SR.GDI.std,...
%         'facecolor','none','LineStyle','-');
%     barh(1,Index(1).SR.GDI.mean-Index(1).SR.GDI.std,...
%         'facecolor','none','LineStyle','-');
%     
%     barh(2,Norme.SR.GDI.mean,'facecolor',[0.5 0.5 0.5]);
%     barh(2,Norme.SR.GDI.mean+Norme.SR.GDI.std,...
%         'facecolor','none','LineStyle','-');
%     barh(2,Norme.SR.GDI.mean-Norme.SR.GDI.std,...
%         'facecolor','none','LineStyle','-');
%         
%     set(gca, 'YTick', 1:length(Labels), 'YTickLabel', Labels,...
%         'YAxisLocation','right');
%     xlim([0 2]);
%     
                    %-------------------%
                   %%     GVS Index      %%
                    %-------------------%
    y = y - yincr*19.5;
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    clear Labels;
    L={'Pelvic Tilt','Pelvic Obliquity','Pelvic Rotation','Hip Flexion',...
        'Hip abduction','Hip Rotation','Knee Flexion','Ankle Plantarflexion',...
        'Foot Progression'};
    Graph(6) = axes('position',[x(1)/pageWidth y/pageHeight ...
        graphWidth/pageWidth 4*graphHeight/pageHeight]);
    set(Graph(6),'FontSize',8,'XGrid','on','YTick',[ ],'XTick',[]);
    hold on;
    title('Gait Visual Score (GVS)','FontWeight','Bold');
    
    for j=1:3
        barh(3*j-2,Index(1).GVS.O.mean(j),'facecolor',colorB(1,:));
        barh(3*j-2,Index(1).GVS.O.mean(j)+Index(1).GVS.O.std(j),...
            'facecolor','none','LineStyle','-');
        barh(3*j-2,Index(1).GVS.O.mean(j)-Index(1).GVS.O.std(j),...
            'facecolor','none','LineStyle','-');
        Labels{3*j-2}=L{j};
        barh(3*j-1,Norme.Index.GVS.O.mean(j),'facecolor',[0.5 0.5 0.5]);
        barh(3*j-1,Norme.Index.GVS.O.mean(j)+Norme.Index.GVS.O.std(j),...
            'facecolor','none','LineStyle','-');
        barh(3*j-1,Norme.Index.GVS.O.mean(j)-Norme.Index.GVS.O.std(j),...
            'facecolor','none','LineStyle','-');
    end
    for j=4:9
        barh(4*j-6,Index(1).GVS.O.mean(j),'facecolor',colorR(1,:));
        barh(4*j-6,Index(1).GVS.O.mean(j)+Index(1).GVS.O.std(j),...
            'facecolor','none','LineStyle','-');
        barh(4*j-6,Index(1).GVS.O.mean(j)-Index(1).GVS.O.std(j),...
            'facecolor','none','LineStyle','-');
        Labels{4*j-5}=L{j};
        barh(4*j-4,Norme.Index.GVS.O.mean(j),'facecolor',[0.5 0.5 0.5]);
        barh(4*j-4,Norme.Index.GVS.O.mean(j)+Norme.Index.GVS.O.std(j),...
            'facecolor','none','LineStyle','-');
        barh(4*j-4,Norme.Index.GVS.O.mean(j)-Norme.Index.GVS.O.std(j),...
            'facecolor','none','LineStyle','-');
    end
    for j=10:15
        barh(4*(j-6)-5,Index(1).GVS.O.mean(j),'facecolor',colorL(1,:));
        barh(4*(j-6)-5,Index(1).GVS.O.mean(j)+Index(1).GVS.O.std(j),...
            'facecolor','none','LineStyle','-');
        barh(4*(j-6)-5,Index(1).GVS.O.mean(j)-Index(1).GVS.O.std(j),...
            'facecolor','none','LineStyle','-');
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
        'Indices de marche',...
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
    text(0.05,y/pageHeight,'Norme','Color',[0.5 0.5 0.5],'FontWeight','Bold');
    y = y - yincr*1.5;
    for i = 1:size(Condition,2)
        axesLegend = axes;
        set(axesLegend,'Position',[0 0 1 1]);
        set(axesLegend,'Visible','Off');
        % Count the number of trials
        nbtrials = 0;
        for j = 1:length(Condition(i).Gait);
            if ~isempty(Condition(i).Gait(j).Index.NI)
                nbtrials = nbtrials+1;
            end
        end
        % Write the legend
        text(0.055,y/pageHeight,'     ','BackgroundColor',colorB(i,:));
        text(0.10,y/pageHeight,[char(regexprep(Condition(i).name,'_','-'))],...
            'Color','k');
        text(0.40,y/pageHeight,[char(Session(i).date),...
            '     Nb essais : ',num2str(nbtrials)],'color','k');
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
    hold on;
    title('Normalcy Index (NI)','FontWeight','Bold');
    for i = size(Condition,2):-1:1
        Labels{size(Condition,2)-i+1}=[num2str(Index(i).NI.O.mean,'%2.2f'),...
            '  +/-  ',num2str(Index(i).NI.O.std,'%2.2f')];
        barh(size(Condition,2)-i+1,Index(i).NI.O.mean,'facecolor',colorB(i,:));
        barh(size(Condition,2)-i+1,Index(i).NI.O.mean+Index(i).NI.O.std,...
            'facecolor','none','LineStyle','-');
        barh(size(Condition,2)-i+1,Index(i).NI.O.mean-Index(i).NI.O.std,...
            'facecolor','none','LineStyle','-');
    end
    barh(size(Condition,2)+1,Norme.Index.NI.R.mean,'facecolor',[0.5 0.5 0.5]);
    barh(size(Condition,2)+1,Norme.Index.NI.R.mean+Norme.Index.NI.R.std,...
        'facecolor','none','LineStyle','-');
    barh(size(Condition,2)+1,Norme.Index.NI.R.mean-Norme.Index.NI.R.std,...
        'facecolor','none','LineStyle','-');
    Labels{size(Condition,2)+1}=[num2str(Norme.Index.NI.R.mean,'%2.2f'),...
        '  +/-  ',num2str(Norme.Index.NI.R.std,'%2.2f')];
    set(gca,'YTick',1:length(Labels),'YTickLabel',Labels,'YAxisLocation','right');
  
    %% NI: NORMES selon ROMEI2004
    %------------------------
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    clear Labels;
    Labels={'Able-bodied','Idiopathic toe-walkers','Hemiplegics','Diplegics'};
    Graph(3) = axes('position',[x(3)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(3),'FontSize',8,'XGrid','on','YTick',[ ],'XTick',0:100:500);
    hold on;
    title('NI: Romei 2004','FontWeight','Bold');
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
    set(gca, 'YTick', 1:4, 'YTickLabel', Labels,'YAxisLocation','right');    
    xlim([0 500]);
    
    % GDI
    %----------------------------------------------------------------------
    y = y - yincr*6.5;
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    clear Labels;
    Graph(2) = axes('position',[x(1)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(2),'FontSize',8,'XGrid','on','YTick',[ ],'XTick',0:100:500);
    hold on;
    title('Gait Deviationnal Index (GDI)','FontWeight','Bold');
    for i = size(Condition,2):-1:1
        Labels{size(Condition,2)-i+1}=[num2str(Index(i).GDI.O.mean,'%2.2f'),...
            '  +/-  ',num2str(Index(i).GDI.O.std,'%2.2f')];
        barh(size(Condition,2)-i+1,Index(i).GDI.O.mean,'facecolor',colorB(i,:));
        barh(size(Condition,2)-i+1,Index(i).GDI.O.mean+Index(i).GDI.O.std,...
            'facecolor','none','LineStyle','-');
        barh(size(Condition,2)-i+1,Index(i).GDI.O.mean-Index(i).GDI.O.std,...
            'facecolor','none','LineStyle','-');
    end
    barh(size(Condition,2)+1,Norme.Index.GDI.O.mean,'facecolor',[0.5 0.5 0.5]);
    barh(size(Condition,2)+1,Norme.Index.GDI.O.mean+Norme.Index.GDI.O.std,...
        'facecolor','none','LineStyle','-');
    barh(size(Condition,2)+1,Norme.Index.GDI.O.mean-Norme.Index.GDI.O.std,...
        'facecolor','none','LineStyle','-');
    Labels{size(Condition,2)+1}=[num2str(Norme.Index.GDI.O.mean,'%2.2f'),...
        '  +/-  ',num2str(Norme.Index.GDI.R.std,'%2.2f')];
    set(gca,'YTick',1:length(Labels),'YTickLabel',Labels,'YAxisLocation','right');
    
    
    % GPS
    %----------------------------------------------------------------------
    y = y - yincr*6.5;
    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    clear Labels;
    Graph(4) = axes('position',[x(1)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(4),'FontSize',8,'XGrid','on','YTick',[ ],'XTick',0:2:20);
    hold on;
    title('Gait Profile Score (GPS)','FontWeight','Bold');
    for i = size(Condition,2):-1:1
        Labels{size(Condition,2)-i+1}=[num2str(Index(i).GPS.O.mean,'%2.2f'),'  +/-  ',...
            num2str(Index(i).GPS.O.std,'%2.2f')];
        barh(size(Condition,2)-i+1,Index(i).GPS.O.mean,'facecolor',colorB(i,:));
        barh(size(Condition,2)-i+1,Index(i).GPS.O.mean+Index(i).GPS.O.std,...
                'facecolor','none','LineStyle','-');
        barh(size(Condition,2)-i+1,Index(i).GPS.O.mean-Index(i).GPS.O.std,...
                'facecolor','none','LineStyle','-');
    end
    barh(size(Condition,2)+1,Norme.Index.GPS.O.mean,'facecolor',[0.5 0.5 0.5]);
    barh(size(Condition,2)+1,Norme.Index.GPS.O.mean+Norme.Index.GPS.O.std,...
        'facecolor','none','LineStyle','-');
    barh(size(Condition,2)+1,Norme.Index.GPS.O.mean-Norme.Index.GPS.O.std,...
        'facecolor','none','LineStyle','-'); 
    Labels{size(Condition,2)+1}=[num2str(Norme.Index.GPS.O.mean,'%2.2f'),'  +/-  ',...
        num2str(Norme.Index.GPS.O.std,'%2.2f')];      
    set(gca,'YTick',1:length(Labels),'YTickLabel',Labels,'YAxisLocation','right');

end        