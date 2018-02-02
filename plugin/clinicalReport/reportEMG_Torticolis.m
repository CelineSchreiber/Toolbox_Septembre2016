% =========================================================================
% REHAZENTER TOOLBOX - PLUGIN CLINICAL REPORT
% =========================================================================
% File name:    reportEMG
% -------------------------------------------------------------------------
% Subject:      Generate the report page for EMG
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
% Date of creation: 19/01/2015
% Version: 1
% -------------------------------------------------------------------------
% Updates: -
% =========================================================================

function f = reportEMG_Torticolis(Patient,Session,Condition,pluginFolder,normFolder,norm)

% =========================================================================
% Initialisation
% =========================================================================
pageWidth = 21; % cm
pageHeight = 29.7; % cm
graphWidth = 7.0; % cm
graphHeight = 3.2; % cm
yinit = 29.0; % cm
yincr = 0.5; % cm
x = [1.50 7.00 12.00 17.50]; % cm
igraph = 1; % graph number
colorR = [0 0.8 0;0 0.8 0.8;0 0.4 0;0 0.4 0.4;0 0.2 0;0 0.2 0.2];
colorL = [0.8 0 0;0.8 0 0.8;0.4 0 0;0.4 0 0.4;0.2 0 0;0.2 0 0.2];
colorB = [0 0 0.8;0.2 0.2 0.8;0.5 0.5 0.8;0.7 0.7 0.8;0.9 0.9 0.8;0.9 0.9 0.6];
cd(pluginFolder);

% =========================================================================
% Get the EMG trial (only 1 trial per condition/session)
% =========================================================================
icondition = [];
itrial = [];

condNames=cell(1,length(Session));
for i=1:length(Session)
    condNames{i}=[char(Patient(i).lastname),' - ',char(Session(i).date),' - ',char(Condition(i).name)];
end
[icondition,ok]=listdlg('ListString',condNames,'ListSize',[300 300]);
files=[];
for i=1:length(Session(icondition).Gait)
    if strcmp(Session(icondition).Gait(i).condition,Condition(icondition).name) && strcmp(Session(icondition).Gait(i).emgtrial,'yes')
        files=[files;Session(icondition).Gait(i).filename];
    end
end
if ~isempty(files)
    [itrial,ok]=listdlg('ListString',files);
else
    f=0;
    return;
end

nf=1;            
if ~isempty(Condition(icondition).Gait(itrial).Remg)

    % =====================================================================
    % Generate the page 1 (right side)
    % =====================================================================

    % Get recorded EMG for right side
    % ---------------------------------------------------------------------
    Remg_raw = nan(90000,8); % 1min maximum as EMG recording (1500Hz * 60s)
    Remg_filt = nan(101,8); % normalized data
    Remg_name = [];
    names = fieldnames(Condition(icondition).Gait(itrial).Remg);
    k1 = 1;
    k2 = 1;
    for j = 1:length(names)
        if strfind(cell2mat(names(j)),'_raw')
            Remg_raw(1:size(eval(['Condition(icondition).Gait(itrial).Remg.',cell2mat(names(j)),';']),1),k1) = ...
                eval(['Condition(icondition).Gait(itrial).Remg.',cell2mat(names(j)),';']);
            Remg_name{k1} = regexprep(cell2mat(names(j)),'_raw','');
            k1 = k1+1;
        end
    end
    
   % Get recorded EMG for left side
    % ---------------------------------------------------------------------
    Lemg_raw = nan(90000,8); % 1min maximum as EMG recording (1500Hz * 60s)
    Lemg_filt = nan(101,8); % normalized data
    Lemg_name = [];
    names = fieldnames(Condition(icondition).Gait(itrial).Lemg);
    k1 = 1;
    k2 = 1;
    for j = 1:length(names)
        if strfind(cell2mat(names(j)),'_raw')
            Lemg_raw(1:size(eval(['Condition(icondition).Gait(itrial).Lemg.',cell2mat(names(j)),';']),1),k1) = ...
                eval(['Condition(icondition).Gait(itrial).Lemg.',cell2mat(names(j)),';']);
            Lemg_name{k1} = regexprep(cell2mat(names(j)),'_raw','');
            k1 = k1+1;
        end
    end
    
    Events = eval(['Session(icondition).Gait(itrial).e']);
    
    % Set the page
    % ---------------------------------------------------------------------
    f(nf) = figure('PaperOrientation','portrait','papertype','A4',...
        'Units','centimeters','Position',[0 0 pageWidth pageHeight],...
        'Color','white','PaperUnits','centimeters',...
        'PaperPosition',[0 0 pageWidth pageHeight],...
        'Name',['EMG',num2str(1)]);
    hold on;
    axis off;
    nf=nf+1;
    
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
    text(0.01,y/pageHeight,...
        ['EMG: ' Condition.details(itrial)],...
        'Color','k','FontWeight','Bold','FontSize',18,...
        'HorizontalAlignment','Center');
    y = y - yincr*2;
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
    % Count the number of trials
    nbtrials = 0;
    for j = 1:length(Condition(icondition).Gait);
        nbtrials=nbtrials+~isempty(Condition(icondition).Gait(j).Remg);
    end
    % Write the legend
    text(0.05,y/pageHeight,[char(files(itrial,:))]);
    text(0.25,y/pageHeight,'Norm','Color',[0.5 0.5 0.5]);
    text(0.33,y/pageHeight,[char(Session(icondition).date),...
        '     Nb essais : ',num2str(nbtrials),...
        '     Condition : ',char(regexprep(Condition(icondition).name,'_','-')),' (cf page 1)'],'color','k');
    y = y - yincr*1.0;
    y1= y;
    
    % Mise en page des graphes côte droit
    %-------------------------
    % RAW
    for igraph=1:length(Remg_name)
        % Real size of the data vector
        g=igraph;
        isize = size(find(~isnan(Remg_raw(:,g))),1);
        % Plot EMG
        y = y1 - yincr*g*8.5;
        x1=x(1);
        axesGraph = axes;
        set(axesGraph,'Position',[0 0 1 1]);
        set(axesGraph,'Visible','Off');
        Graph(igraph) = axes('position',[x1/pageWidth y/pageHeight ...
                graphWidth/pageWidth graphHeight/pageHeight]);
        set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[],'YTick',-50e-4:1e-4:50e-4);
        hold on;
        title(regexprep(regexprep(Remg_name{g},'left_',''),'_',' '),'FontWeight','Bold');
        ylabel('Amplitude (uV)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
        plot(1:isize,zeros(isize,1),'Linestyle','-','Linewidth',0.5,'Color','black');
        plot(Remg_raw(1:isize,g),'Linestyle','-','Linewidth',0.5,'Color',colorR(1,:));
        axis tight;
        XL=xlim;
        axis([XL(1) XL(2) -0.0001 0.0001]);
    end
    
    % Mise en page des graphes cote gauche
    %-------------------------
    % RAW
    for igraph=5:2*length(Lemg_name)
        % Real size of the data vector
        g=igraph-4; 
        isize = size(find(~isnan(Lemg_raw(:,g))),1);
        % Plot EMG
        y = y1 - yincr*g*8.5;
        x1=x(3);
        axesGraph = axes;
        set(axesGraph,'Position',[0 0 1 1]);
        set(axesGraph,'Visible','Off');
        Graph(igraph) = axes('position',[x1/pageWidth y/pageHeight ...
                graphWidth/pageWidth graphHeight/pageHeight]);
        set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[],'YTick',-50e-4:1e-4:50e-4);
        hold on;
        title(regexprep(regexprep(Lemg_name{g},'left_',''),'_',' '),'FontWeight','Bold');
        ylabel('Amplitude (uV)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
        plot(1:isize,zeros(isize,1),'Linestyle','-','Linewidth',0.5,'Color','black');
        plot(Lemg_raw(1:isize,g),'Linestyle','-','Linewidth',0.5,'Color',colorL(1,:));
        axis tight;
        XL=xlim;
        axis([XL(1) XL(2) -0.0001 0.0001]);
    end
      
    if ~isempty(Events)
        for g = 1:length(Graph)
            axes(Graph(g));
            YL = ylim;
            plot([Events.Start*Session.fanalog Events.Start*Session.fanalog],[YL(1)-20 YL(1)+(YL(2)-YL(1))/10],'Linewidth',1.5,'Color','k'); %IHS
            plot([Events.Stop*Session.fanalog Events.Stop*Session.fanalog],[YL(1)-20 YL(1)+(YL(2)-YL(1))/10],'Linewidth',1.5,'Color','k'); %CTO
        end
    end
end