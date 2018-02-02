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

function f = reportEMG(Patient,Session,Condition,pluginFolder,normFolder,norm)

% =========================================================================
% Initialisation
% =========================================================================
pageWidth = 21; % cm
pageHeight = 29.7; % cm
graphWidth = 4.5; % cm
graphHeight = 3.2; % cm
yinit = 29.0; % cm
yincr = 0.5; % cm
x = [1.50 7.00 12.00 17.50]; % cm
igraph = 1; % graph number
colorR = [0 0.8 0;0 0.8 0.8;0 0.4 0;0 0.4 0.4;0 0.2 0;0 0.2 0.2];
colorL = [0.8 0 0;0.8 0 0.8;0.4 0 0;0.4 0 0.4;0.2 0 0;0.2 0 0.2];
colorB = [0 0 0.8;0.2 0.2 0.8;0.5 0.5 0.8;0.7 0.7 0.8;0.9 0.9 0.8;0.9 0.9 0.6];
cd(normFolder);
temp = load(cell2mat(norm));
Norm.EMG = temp.Normatives.Remg;
Norm.Event = temp.Normatives.Rphases;
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
% t=0;
% for i=1:length(Session(icondition).Gait)
%     if strcmp(Session(icondition).Gait(i).condition,Condition(icondition).name) && strcmp(Session(icondition).Gait(i).emgtrial,'yes')
%         t=t+1;
%         if t==itrial
%             itrial=i;
%             break;
%         end
%     end
% end

number_frame_cycle = Condition(icondition).Gait(itrial).Revents.e.LHS(2)*Session(icondition).fanalog...
                - Condition(icondition).Gait(itrial).Revents.e.LHS(1)*Session(icondition).fanalog;
X_down = Condition(icondition).Gait(itrial).Revents.e.LHS(1)*Session(icondition).fanalog-2*number_frame_cycle;
X_up = Condition(icondition).Gait(itrial).Revents.e.LHS(2)*Session(icondition).fanalog+2*number_frame_cycle;
            
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
        if strfind(cell2mat(names(j)),'_filt')
            Remg_filt.mean(1:size(eval(['Condition(icondition).All.Remg.',cell2mat(names(j)),'.mean;']),1),k2) = ...
                eval(['Condition(icondition).All.Remg.',cell2mat(names(j)),'.mean;']);
            Remg_filt.std(1:size(eval(['Condition(icondition).All.Remg.',cell2mat(names(j)),'.mean;']),1),k2) = ...
                eval(['Condition(icondition).All.Remg.',cell2mat(names(j)),'.std;']);
            k2 = k2+1;
        end
    end
    
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
        '  EMG',...
        'Color','k','FontWeight','Bold','FontSize',18,...
        'HorizontalAlignment','Center');
    y = y - yincr*2;
    text(0.02,y/pageHeight,...
        '  C�t� droit',...
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

    % EMG 1 / raw
    % ---------------------------------------------------------------------
    if length(Remg_name) >= 1
        % Real size of the data vector
        isize = size(find(~isnan(Remg_raw(:,1))),1);
        % Plot EMG
        y = y - yincr*8.5;
        y1 = y;
        axesGraph = axes;
        set(axesGraph,'Position',[0 0 1 1]);
        set(axesGraph,'Visible','Off');
        Graph(igraph) = axes('position',[x(1)/pageWidth y/pageHeight ...
            graphWidth/pageWidth graphHeight/pageHeight]);
        set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[],'YTick',-50e-4:1e-4:50e-4);
        hold on;
        title(regexprep(regexprep(Remg_name{1},'right_',''),'_',' '),'FontWeight','Bold');
        ylabel('Amplitude (uV)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
        plot(1:isize,zeros(isize,1),'Linestyle','-','Linewidth',0.5,'Color','black');
        plot(Remg_raw(1:isize,1),'Linestyle','-','Linewidth',0.5,'Color',colorR(1,:));
        axis tight;
%         YL = [-2e-4,2e-4];
%         XL = xlim;
%         number_frame_cycle = Condition(icondition).Gait(itrial).Revents.e.RHS(2)*Session(icondition).fanalog...
%             - Condition(icondition).Gait(itrial).Revents.e.RHS(1)*Session(icondition).fanalog;
%         X_down = Condition(icondition).Gait(itrial).Revents.e.RHS(1)*Session(icondition).fanalog-2*number_frame_cycle;
%         X_up = Condition(icondition).Gait(itrial).Revents.e.RHS(2)*Session(icondition).fanalog+2*number_frame_cycle;
%         XL(1) = max(XL(1),X_down);
%         XL(2) = min(XL(2),X_up);
%         axis([XL(1) XL(2) YL(1) YL(2)]);
%         plot([Condition(icondition).Gait(itrial).Revents.e.RHS(1)*Session(icondition).fanalog ...
%             Condition(icondition).Gait(itrial).Revents.e.RHS(1)*Session(icondition).fanalog],...
%             [YL(1) YL(2)],'Linestyle','-','Linewidth',1,'Color','black');
%         plot([Condition(icondition).Gait(itrial).Revents.e.RTO(end)*Session(icondition).fanalog ...
%             Condition(icondition).Gait(itrial).Revents.e.RTO(end)*Session(icondition).fanalog],...
%             [YL(1) YL(2)],'Linestyle','--','Linewidth',1,'Color','black');
%         plot([Condition(icondition).Gait(itrial).Revents.e.RHS(2)*Session(icondition).fanalog ...
%             Condition(icondition).Gait(itrial).Revents.e.RHS(2)*Session(icondition).fanalog],...
%             [YL(1) YL(2)],'Linestyle','-','Linewidth',1,'Color','black');
%         box on;
        igraph = igraph+1;
    end

    % EMG 1 / filt
    % ---------------------------------------------------------------------
    if length(Remg_name) >= 1
        axesGraph = axes;
        set(axesGraph,'Position',[0 0 1 1]);
        set(axesGraph,'Visible','Off');
        Graph(igraph) = axes('position',[x(2)/pageWidth y/pageHeight ...
            graphWidth/2/pageWidth graphHeight/pageHeight]);
        xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
        ylabel('Amplitude (%max)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
        hold on;
        % Find norm
        inorm = [];
        names = fieldnames(Norm.EMG);
        for i = 1:length(names)
            if strfind(regexprep(names{i},'right_',''),regexprep(Remg_name{1},'right_',''))
                inorm = eval(['Norm.EMG.',names{i},';']);
            end
        end
        % Plot
        if ~isempty(inorm)
            plot(inorm.mean(1:101,1)/max(inorm.mean(1:101,1)),'Linestyle','-','Linewidth',2,'Color',[0.5 0.5 0.5]);
        end
        plot(Remg_filt.mean(1:101,1)/max(Remg_filt.mean(1:101,1)),'Linestyle','-','Linewidth',2,'Color',colorR(1,:));
        set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0:50:100],'YTick',0:0.25:1,'YTickLabel',{'0' '25' '50' '75' '100'});
        axis tight;
        axis([0 100 0 1]);
        plot([Condition(icondition).Gait(itrial).Rphases.p5 ...
            Condition(icondition).Gait(itrial).Rphases.p5],...
            [0 1],'Linestyle','--','Linewidth',1,'Color','black');
        box on;
        igraph = igraph+1;
    end

    % EMG 2 / raw
    % ---------------------------------------------------------------------
    if length(Remg_name) >= 2
        % Real size of the data vector
        isize = size(find(~isnan(Remg_raw(:,2))),1);
        % Plot EMG
        y = y - yincr*8.5;
        axesGraph = axes;
        set(axesGraph,'Position',[0 0 1 1]);
        set(axesGraph,'Visible','Off');
        Graph(igraph) = axes('position',[x(1)/pageWidth y/pageHeight ...
            graphWidth/pageWidth graphHeight/pageHeight]);
        set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[],'YTick',-50e-4:1e-4:50e-4);
        hold on;
        title(regexprep(regexprep(Remg_name{2},'right_',''),'_',' '),'FontWeight','Bold');
        ylabel('Amplitude (uV)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
        plot(1:isize,zeros(isize,1),'Linestyle','-','Linewidth',0.5,'Color','black');
        plot(Remg_raw(1:isize,2),'Linestyle','-','Linewidth',0.5,'Color',colorR(1,:));
        axis tight;
%         YL = [-2e-4,2e-4];
%         XL = xlim;
%         number_frame_cycle = Condition(icondition).Gait(itrial).Revents.e.RHS(2)*Session(icondition).fanalog...
%             - Condition(icondition).Gait(itrial).Revents.e.RHS(1)*Session(icondition).fanalog;
%         X_down = Condition(icondition).Gait(itrial).Revents.e.RHS(1)*Session(icondition).fanalog-2*number_frame_cycle;
%         X_up = Condition(icondition).Gait(itrial).Revents.e.RHS(2)*Session(icondition).fanalog+2*number_frame_cycle;
%         XL(1) = max(XL(1),X_down);
%         XL(2) = min(XL(2),X_up);
%         axis([XL(1) XL(2) YL(1) YL(2)]);
%         plot([Condition(icondition).Gait(itrial).Revents.e.RHS(1)*Session(icondition).fanalog ...
%             Condition(icondition).Gait(itrial).Revents.e.RHS(1)*Session(icondition).fanalog],...
%             [YL(1) YL(2)],'Linestyle','-','Linewidth',1,'Color','black');
%         plot([Condition(icondition).Gait(itrial).Revents.e.RTO(end)*Session(icondition).fanalog ...
%             Condition(icondition).Gait(itrial).Revents.e.RTO(end)*Session(icondition).fanalog],...
%             [YL(1) YL(2)],'Linestyle','--','Linewidth',1,'Color','black');
%         plot([Condition(icondition).Gait(itrial).Revents.e.RHS(2)*Session(icondition).fanalog ...
%             Condition(icondition).Gait(itrial).Revents.e.RHS(2)*Session(icondition).fanalog],...
%             [YL(1) YL(2)],'Linestyle','-','Linewidth',1,'Color','black');
%         box on;
        igraph = igraph+1;
    end

    % EMG 2 / filt
    % ---------------------------------------------------------------------
    if length(Remg_name) >= 2
        axesGraph = axes;
        set(axesGraph,'Position',[0 0 1 1]);
        set(axesGraph,'Visible','Off');
        Graph(igraph) = axes('position',[x(2)/pageWidth y/pageHeight ...
            graphWidth/2/pageWidth graphHeight/pageHeight]);
        xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
        ylabel('Amplitude (%max)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
        hold on;
        % Find norm
        inorm = [];
        names = fieldnames(Norm.EMG);
        for i = 1:length(names)
            if strfind(regexprep(names{i},'right_',''),regexprep(Remg_name{2},'right_',''))
                inorm = eval(['Norm.EMG.',names{i},';']);
            end
        end
        % Plot
        if ~isempty(inorm)
            plot(inorm.mean(1:101,1)/max(inorm.mean(1:101,1)),'Linestyle','-','Linewidth',2,'Color',[0.5 0.5 0.5]);
        end
        plot(Remg_filt.mean(1:101,2)/max(Remg_filt.mean(1:101,2)),'Linestyle','-','Linewidth',2,'Color',colorR(1,:));
        set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0:50:100],'YTick',0:0.25:1,'YTickLabel',{'0' '25' '50' '75' '100'});
        ylim([0 1]);
        axis tight;
        axis([0 100 0 1]);
        plot([Condition(icondition).Gait(itrial).Rphases.p5 ...
            Condition(icondition).Gait(itrial).Rphases.p5],...
            [0 1],'Linestyle','--','Linewidth',1,'Color','black');
        box on;
        igraph = igraph+1;
    end

    % EMG 3 / raw
    % ---------------------------------------------------------------------
    if length(Remg_name) >= 3
        % Real size of the data vector
        isize = size(find(~isnan(Remg_raw(:,3))),1);
        % Plot EMG
        y = y - yincr*8.5;
        axesGraph = axes;
        set(axesGraph,'Position',[0 0 1 1]);
        set(axesGraph,'Visible','Off');
        Graph(igraph) = axes('position',[x(1)/pageWidth y/pageHeight ...
            graphWidth/pageWidth graphHeight/pageHeight]);
        set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[],'YTick',-50e-4:1e-4:50e-4);
        hold on;
        title(regexprep(regexprep(Remg_name{3},'right_',''),'_',' '),'FontWeight','Bold');
        ylabel('Amplitude (uV)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
        plot(1:isize,zeros(isize,1),'Linestyle','-','Linewidth',0.5,'Color','black');
        plot(Remg_raw(1:isize,3),'Linestyle','-','Linewidth',0.5,'Color',colorR(1,:));
        axis tight;
        YL = [-2e-4,2e-4];
        XL = xlim;
        number_frame_cycle = Condition(icondition).Gait(itrial).Revents.e.RHS(2)*Session(icondition).fanalog...
            - Condition(icondition).Gait(itrial).Revents.e.RHS(1)*Session(icondition).fanalog;
        X_down = Condition(icondition).Gait(itrial).Revents.e.RHS(1)*Session(icondition).fanalog-2*number_frame_cycle;
        X_up = Condition(icondition).Gait(itrial).Revents.e.RHS(2)*Session(icondition).fanalog+2*number_frame_cycle;
        XL(1) = max(XL(1),X_down);
        XL(2) = min(XL(2),X_up);
        axis([XL(1) XL(2) YL(1) YL(2)]);
        plot([Condition(icondition).Gait(itrial).Revents.e.RHS(1)*Session(icondition).fanalog ...
            Condition(icondition).Gait(itrial).Revents.e.RHS(1)*Session(icondition).fanalog],...
            [YL(1) YL(2)],'Linestyle','-','Linewidth',1,'Color','black');
        plot([Condition(icondition).Gait(itrial).Revents.e.RTO(end)*Session(icondition).fanalog ...
            Condition(icondition).Gait(itrial).Revents.e.RTO(end)*Session(icondition).fanalog],...
            [YL(1) YL(2)],'Linestyle','--','Linewidth',1,'Color','black');
        plot([Condition(icondition).Gait(itrial).Revents.e.RHS(2)*Session(icondition).fanalog ...
            Condition(icondition).Gait(itrial).Revents.e.RHS(2)*Session(icondition).fanalog],...
            [YL(1) YL(2)],'Linestyle','-','Linewidth',1,'Color','black');
        box on;
        igraph = igraph+1;
    end

    % EMG 3 / filt
    % ---------------------------------------------------------------------
    if length(Remg_name) >= 3
        axesGraph = axes;
        set(axesGraph,'Position',[0 0 1 1]);
        set(axesGraph,'Visible','Off');
        Graph(igraph) = axes('position',[x(2)/pageWidth y/pageHeight ...
            graphWidth/2/pageWidth graphHeight/pageHeight]);
        xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
        ylabel('Amplitude (%max)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
        hold on;
        % Find norm
        inorm = [];
        names = fieldnames(Norm.EMG);
        for i = 1:length(names)
            if strfind(regexprep(names{i},'right_',''),regexprep(Remg_name{3},'right_',''))
                inorm = eval(['Norm.EMG.',names{i},';']);
            end
        end
        % Plot
        if ~isempty(inorm)
            plot(inorm.mean(1:101,1)/max(inorm.mean(1:101,1)),'Linestyle','-','Linewidth',2,'Color',[0.5 0.5 0.5]);
        end
        plot(Remg_filt.mean(1:101,3)/max(Remg_filt.mean(1:101,3)),'Linestyle','-','Linewidth',2,'Color',colorR(1,:));
        set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0:50:100],'YTick',0:0.25:1,'YTickLabel',{'0' '25' '50' '75' '100'});
        ylim([0 1]);
        axis tight;
        axis([0 100 0 1]);
        plot([Condition(icondition).Gait(itrial).Rphases.p5 ...
            Condition(icondition).Gait(itrial).Rphases.p5],...
            [0 1],'Linestyle','--','Linewidth',1,'Color','black');
        box on;
        igraph = igraph+1;
    end

    % EMG 4 / raw
    % ---------------------------------------------------------------------
    if length(Remg_name) >= 4
        % Real size of the data vector
        isize = size(find(~isnan(Remg_raw(:,4))),1);
        % Plot EMG
        y = y - yincr*8.5;
        axesGraph = axes;
        set(axesGraph,'Position',[0 0 1 1]);
        set(axesGraph,'Visible','Off');
        Graph(igraph) = axes('position',[x(1)/pageWidth y/pageHeight ...
            graphWidth/pageWidth graphHeight/pageHeight]);
        set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[],'YTick',-50e-4:4e-4:50e-4);
        hold on;
        title(regexprep(regexprep(Remg_name{4},'right_',''),'_',' '),'FontWeight','Bold');
        ylabel('Amplitude (uV)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
        plot(1:isize,zeros(isize,1),'Linestyle','-','Linewidth',0.5,'Color','black');
        plot(Remg_raw(1:isize,4),'Linestyle','-','Linewidth',0.5,'Color',colorR(1,:));
        axis tight;
        YL = [-2e-4,2e-4];
        XL = xlim;
        number_frame_cycle = Condition(icondition).Gait(itrial).Revents.e.RHS(2)*Session(icondition).fanalog...
            - Condition(icondition).Gait(itrial).Revents.e.RHS(1)*Session(icondition).fanalog;
        X_down = Condition(icondition).Gait(itrial).Revents.e.RHS(1)*Session(icondition).fanalog-2*number_frame_cycle;
        X_up = Condition(icondition).Gait(itrial).Revents.e.RHS(2)*Session(icondition).fanalog+2*number_frame_cycle;
        XL(1) = max(XL(1),X_down);
        XL(2) = min(XL(2),X_up);
        axis([XL(1) XL(2) YL(1) YL(2)]);
        plot([Condition(icondition).Gait(itrial).Revents.e.RHS(1)*Session(icondition).fanalog ...
            Condition(icondition).Gait(itrial).Revents.e.RHS(1)*Session(icondition).fanalog],...
            [YL(1) YL(2)],'Linestyle','-','Linewidth',1,'Color','black');
        plot([Condition(icondition).Gait(itrial).Revents.e.RTO(end)*Session(icondition).fanalog ...
            Condition(icondition).Gait(itrial).Revents.e.RTO(end)*Session(icondition).fanalog],...
            [YL(1) YL(2)],'Linestyle','--','Linewidth',1,'Color','black');
        plot([Condition(icondition).Gait(itrial).Revents.e.RHS(2)*Session(icondition).fanalog ...
            Condition(icondition).Gait(itrial).Revents.e.RHS(2)*Session(icondition).fanalog],...
            [YL(1) YL(2)],'Linestyle','-','Linewidth',1,'Color','black');
        box on;
        igraph = igraph+1;
    end

    % EMG 4 / filt
    % ---------------------------------------------------------------------
    if length(Remg_name) >= 4
        axesGraph = axes;
        set(axesGraph,'Position',[0 0 1 1]);
        set(axesGraph,'Visible','Off');
        Graph(igraph) = axes('position',[x(2)/pageWidth y/pageHeight ...
            graphWidth/2/pageWidth graphHeight/pageHeight]);
        xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
        ylabel('Amplitude (%max)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
        hold on;
        % Find norm
        inorm = [];
        names = fieldnames(Norm.EMG);
        for i = 1:length(names)
            if strfind(regexprep(names{i},'right_',''),regexprep(Remg_name{4},'right_',''))
                inorm = eval(['Norm.EMG.',names{i},';']);
            end
        end
        % Plot
        if ~isempty(inorm)
            plot(inorm.mean(1:101,1)/max(inorm.mean(1:101,1)),'Linestyle','-','Linewidth',2,'Color',[0.5 0.5 0.5]);
        end
        plot(Remg_filt.mean(1:101,4)/max(Remg_filt.mean(1:101,4)),'Linestyle','-','Linewidth',2,'Color',colorR(1,:));
        set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0:50:100],'YTick',0:0.25:1,'YTickLabel',{'0' '25' '50' '75' '100'});
        ylim([0 1]);
        axis tight;
        axis([0 100 0 1]);
        plot([Condition(icondition).Gait(itrial).Rphases.p5 ...
            Condition(icondition).Gait(itrial).Rphases.p5],...
            [0 1],'Linestyle','--','Linewidth',1,'Color','black');
        box on;
        igraph = igraph+1;
    end

    % EMG 5 / raw
    % ---------------------------------------------------------------------
    if length(Remg_name) >= 5
        % Real size of the data vector
        isize = size(find(~isnan(Remg_raw(:,5))),1);
        % Plot EMG
        y = y1;
        axesGraph = axes;
        set(axesGraph,'Position',[0 0 1 1]);
        set(axesGraph,'Visible','Off');
        Graph(igraph) = axes('position',[x(3)/pageWidth y/pageHeight ...
            graphWidth/pageWidth graphHeight/pageHeight]);
        set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[],'YTick',-50e-4:1e-4:50e-4);
        hold on;
        title(regexprep(regexprep(Remg_name{5},'right_',''),'_',' '),'FontWeight','Bold');
        ylabel('Amplitude (uV)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
        plot(1:isize,zeros(isize,1),'Linestyle','-','Linewidth',0.5,'Color','black');
        plot(Remg_raw(1:isize,5),'Linestyle','-','Linewidth',0.5,'Color',colorR(1,:));
        axis tight;
        YL = [-2e-4,2e-4];
        XL = xlim;
        number_frame_cycle = Condition(icondition).Gait(itrial).Revents.e.RHS(2)*Session(icondition).fanalog...
            - Condition(icondition).Gait(itrial).Revents.e.RHS(1)*Session(icondition).fanalog;
        X_down = Condition(icondition).Gait(itrial).Revents.e.RHS(1)*Session(icondition).fanalog-2*number_frame_cycle;
        X_up = Condition(icondition).Gait(itrial).Revents.e.RHS(2)*Session(icondition).fanalog+2*number_frame_cycle;
        XL(1) = max(XL(1),X_down);
        XL(2) = min(XL(2),X_up);
        axis([XL(1) XL(2) YL(1) YL(2)]);
        plot([Condition(icondition).Gait(itrial).Revents.e.RHS(1)*Session(icondition).fanalog ...
            Condition(icondition).Gait(itrial).Revents.e.RHS(1)*Session(icondition).fanalog],...
            [YL(1) YL(2)],'Linestyle','-','Linewidth',1,'Color','black');
        plot([Condition(icondition).Gait(itrial).Revents.e.RTO(end)*Session(icondition).fanalog ...
            Condition(icondition).Gait(itrial).Revents.e.RTO(end)*Session(icondition).fanalog],...
            [YL(1) YL(2)],'Linestyle','--','Linewidth',1,'Color','black');
        plot([Condition(icondition).Gait(itrial).Revents.e.RHS(2)*Session(icondition).fanalog ...
            Condition(icondition).Gait(itrial).Revents.e.RHS(2)*Session(icondition).fanalog],...
            [YL(1) YL(2)],'Linestyle','-','Linewidth',1,'Color','black');
        box on;
        igraph = igraph+1;
    end

    % EMG 5 / filt
    % ---------------------------------------------------------------------
    if length(Remg_name) >= 5
        axesGraph = axes;
        set(axesGraph,'Position',[0 0 1 1]);
        set(axesGraph,'Visible','Off');
        Graph(igraph) = axes('position',[x(4)/pageWidth y/pageHeight ...
            graphWidth/2/pageWidth graphHeight/pageHeight]);
        xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
        ylabel('Amplitude (%max)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
        hold on;
        % Find norm
        inorm = [];
        names = fieldnames(Norm.EMG);
        for i = 1:length(names)
            if strfind(regexprep(names{i},'right_',''),regexprep(Remg_name{5},'right_',''))
                inorm = eval(['Norm.EMG.',names{i},';']);
            end
        end
        % Plot
        if ~isempty(inorm)
            plot(inorm.mean(1:101,1)/max(inorm.mean(1:101,1)),'Linestyle','-','Linewidth',2,'Color',[0.5 0.5 0.5]);
        end
        plot(Remg_filt.mean(1:101,5)/max(Remg_filt.mean(1:101,5)),'Linestyle','-','Linewidth',2,'Color',colorR(1,:));
        set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0:50:100],'YTick',0:0.25:1,'YTickLabel',{'0' '25' '50' '75' '100'});
        axis tight;
        axis([0 100 0 1]);
        plot([Condition(icondition).Gait(itrial).Rphases.p5 ...
            Condition(icondition).Gait(itrial).Rphases.p5],...
            [0 1],'Linestyle','--','Linewidth',1,'Color','black');
        box on;
        igraph = igraph+1;
    end

    % EMG 6 / raw
    % ---------------------------------------------------------------------
    if length(Remg_name) >= 6
        % Real size of the data vector
        isize = size(find(~isnan(Remg_raw(:,6))),1);
        % Plot EMG
        y = y - yincr*8.5;
        axesGraph = axes;
        set(axesGraph,'Position',[0 0 1 1]);
        set(axesGraph,'Visible','Off');
        Graph(igraph) = axes('position',[x(3)/pageWidth y/pageHeight ...
            graphWidth/pageWidth graphHeight/pageHeight]);
        set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[],'YTick',-50e-4:1e-4:50e-4);
        hold on;
        title(regexprep(regexprep(Remg_name{6},'right_',''),'_',' '),'FontWeight','Bold');
        ylabel('Amplitude (uV)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
        plot(1:isize,zeros(isize,1),'Linestyle','-','Linewidth',0.5,'Color','black');
        plot(Remg_raw(1:isize,6),'Linestyle','-','Linewidth',0.5,'Color',colorR(1,:));
        axis tight;
        YL = [-2e-4,2e-4];
        XL = xlim;
        number_frame_cycle = Condition(icondition).Gait(itrial).Revents.e.RHS(2)*Session(icondition).fanalog...
            - Condition(icondition).Gait(itrial).Revents.e.RHS(1)*Session(icondition).fanalog;
        X_down = Condition(icondition).Gait(itrial).Revents.e.RHS(1)*Session(icondition).fanalog-2*number_frame_cycle;
        X_up = Condition(icondition).Gait(itrial).Revents.e.RHS(2)*Session(icondition).fanalog+2*number_frame_cycle;
        XL(1) = max(XL(1),X_down);
        XL(2) = min(XL(2),X_up);
        axis([XL(1) XL(2) YL(1) YL(2)]);
        plot([Condition(icondition).Gait(itrial).Revents.e.RHS(1)*Session(icondition).fanalog ...
            Condition(icondition).Gait(itrial).Revents.e.RHS(1)*Session(icondition).fanalog],...
            [YL(1) YL(2)],'Linestyle','-','Linewidth',1,'Color','black');
        plot([Condition(icondition).Gait(itrial).Revents.e.RTO(end)*Session(icondition).fanalog ...
            Condition(icondition).Gait(itrial).Revents.e.RTO(end)*Session(icondition).fanalog],...
            [YL(1) YL(2)],'Linestyle','--','Linewidth',1,'Color','black');
        plot([Condition(icondition).Gait(itrial).Revents.e.RHS(2)*Session(icondition).fanalog ...
            Condition(icondition).Gait(itrial).Revents.e.RHS(2)*Session(icondition).fanalog],...
            [YL(1) YL(2)],'Linestyle','-','Linewidth',1,'Color','black');
        box on;
        igraph = igraph+1;
    end

    % EMG 6 / filt
    % ---------------------------------------------------------------------
    if length(Remg_name) >= 6
        axesGraph = axes;
        set(axesGraph,'Position',[0 0 1 1]);
        set(axesGraph,'Visible','Off');
        Graph(igraph) = axes('position',[x(4)/pageWidth y/pageHeight ...
            graphWidth/2/pageWidth graphHeight/pageHeight]);
        xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
        ylabel('Amplitude (%max)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
        hold on;
        % Find norm
        inorm = [];
        names = fieldnames(Norm.EMG);
        for i = 1:length(names)
            if strfind(regexprep(names{i},'right_',''),regexprep(Remg_name{6},'right_',''))
                inorm = eval(['Norm.EMG.',names{i},';']);
            end
        end
        % Plot
        if ~isempty(inorm)
            plot(inorm.mean(1:101,1)/max(inorm.mean(1:101,1)),'Linestyle','-','Linewidth',2,'Color',[0.5 0.5 0.5]);
        end
        plot(Remg_filt.mean(1:101,6)/max(Remg_filt.mean(1:101,6)),'Linestyle','-','Linewidth',2,'Color',colorR(1,:));
        set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0:50:100],'YTick',0:0.25:1,'YTickLabel',{'0' '25' '50' '75' '100'});
        axis tight;
        axis([0 100 0 1]);
        plot([Condition(icondition).Gait(itrial).Rphases.p5 ...
            Condition(icondition).Gait(itrial).Rphases.p5],...
            [0 1],'Linestyle','--','Linewidth',1,'Color','black');
        box on;
        igraph = igraph+1;
    end

    % EMG 7 / raw
    % ---------------------------------------------------------------------
    if length(Remg_name) >= 7
        % Real size of the data vector
        isize = size(find(~isnan(Remg_raw(:,7))),1);
        % Plot EMG
        y = y - yincr*8.5;
        axesGraph = axes;
        set(axesGraph,'Position',[0 0 1 1]);
        set(axesGraph,'Visible','Off');
        Graph(igraph) = axes('position',[x(3)/pageWidth y/pageHeight ...
            graphWidth/pageWidth graphHeight/pageHeight]);
        set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[],'YTick',-50e-4:1e-4:50e-4);
        hold on;
        title(regexprep(regexprep(Remg_name{7},'right_',''),'_',' '),'FontWeight','Bold');
        ylabel('Amplitude (uV)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
        plot(1:isize,zeros(isize,1),'Linestyle','-','Linewidth',0.5,'Color','black');
        plot(Remg_raw(1:isize,7),'Linestyle','-','Linewidth',0.5,'Color',colorR(1,:));
        axis tight;
        YL = [-2e-4,2e-4];
        XL = xlim;
        number_frame_cycle = Condition(icondition).Gait(itrial).Revents.e.RHS(2)*Session(icondition).fanalog...
            - Condition(icondition).Gait(itrial).Revents.e.RHS(1)*Session(icondition).fanalog;
        X_down = Condition(icondition).Gait(itrial).Revents.e.RHS(1)*Session(icondition).fanalog-2*number_frame_cycle;
        X_up = Condition(icondition).Gait(itrial).Revents.e.RHS(2)*Session(icondition).fanalog+2*number_frame_cycle;
        XL(1) = max(XL(1),X_down);
        XL(2) = min(XL(2),X_up);
        axis([XL(1) XL(2) YL(1) YL(2)]);
        plot([Condition(icondition).Gait(itrial).Revents.e.RHS(1)*Session(icondition).fanalog ...
            Condition(icondition).Gait(itrial).Revents.e.RHS(1)*Session(icondition).fanalog],...
            [YL(1) YL(2)],'Linestyle','-','Linewidth',1,'Color','black');
        plot([Condition(icondition).Gait(itrial).Revents.e.RTO(end)*Session(icondition).fanalog ...
            Condition(icondition).Gait(itrial).Revents.e.RTO(end)*Session(icondition).fanalog],...
            [YL(1) YL(2)],'Linestyle','--','Linewidth',1,'Color','black');
        plot([Condition(icondition).Gait(itrial).Revents.e.RHS(2)*Session(icondition).fanalog ...
            Condition(icondition).Gait(itrial).Revents.e.RHS(2)*Session(icondition).fanalog],...
            [YL(1) YL(2)],'Linestyle','-','Linewidth',1,'Color','black');
        box on;
        igraph = igraph+1;
    end

    % EMG 7 / filt
    % ---------------------------------------------------------------------
    if length(Remg_name) >= 7
        axesGraph = axes;
        set(axesGraph,'Position',[0 0 1 1]);
        set(axesGraph,'Visible','Off');
        Graph(igraph) = axes('position',[x(4)/pageWidth y/pageHeight ...
            graphWidth/2/pageWidth graphHeight/pageHeight]);
        xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
        ylabel('Amplitude (%max)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
        hold on;
        % Find norm
        inorm = [];
        names = fieldnames(Norm.EMG);
        for i = 1:length(names)
            if strfind(regexprep(names{i},'right_',''),regexprep(Remg_name{7},'right_',''))
                inorm = eval(['Norm.EMG.',names{i},';']);
            end
        end
        % Plot
        if ~isempty(inorm)
            plot(inorm.mean(1:101,1)/max(inorm.mean(1:101,1)),'Linestyle','-','Linewidth',2,'Color',[0.5 0.5 0.5]);
        end
        plot(Remg_filt.mean(1:101,7)/max(Remg_filt.mean(1:101,7)),'Linestyle','-','Linewidth',2,'Color',colorR(1,:));
        set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0:50:100],'YTick',0:0.25:1,'YTickLabel',{'0' '25' '50' '75' '100'});
        axis tight;
        axis([0 100 0 1]);
        plot([Condition(icondition).Gait(itrial).Rphases.p5 ...
            Condition(icondition).Gait(itrial).Rphases.p5],...
            [0 1],'Linestyle','--','Linewidth',1,'Color','black');
        box on;
        igraph = igraph+1;
    end

    % EMG 8 / raw
    % ---------------------------------------------------------------------
    if length(Remg_name) >= 8
        % Real size of the data vector
        isize = size(find(~isnan(Remg_raw(:,8))),1);
        % Plot EMG
        y = y - yincr*8.5;
        axesGraph = axes;
        set(axesGraph,'Position',[0 0 1 1]);
        set(axesGraph,'Visible','Off');
        Graph(igraph) = axes('position',[x(3)/pageWidth y/pageHeight ...
            graphWidth/pageWidth graphHeight/pageHeight]);
        set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[],'YTick',-50e-4:1e-4:50e-4);
        hold on;
        title(regexprep(regexprep(Remg_name{8},'right_',''),'_',' '),'FontWeight','Bold');
        ylabel('Amplitude (uV)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
        plot(1:isize,zeros(isize,1),'Linestyle','-','Linewidth',0.5,'Color','black');
        plot(Remg_raw(1:isize,8),'Linestyle','-','Linewidth',0.5,'Color',colorR(1,:));
        axis tight;
        YL = [-2e-4,2e-4];
        XL = xlim;
        number_frame_cycle = Condition(icondition).Gait(itrial).Revents.e.RHS(2)*Session(icondition).fanalog...
            - Condition(icondition).Gait(itrial).Revents.e.RHS(1)*Session(icondition).fanalog;
        X_down = Condition(icondition).Gait(itrial).Revents.e.RHS(1)*Session(icondition).fanalog-2*number_frame_cycle;
        X_up = Condition(icondition).Gait(itrial).Revents.e.RHS(2)*Session(icondition).fanalog+2*number_frame_cycle;
        XL(1) = max(XL(1),X_down);
        XL(2) = min(XL(2),X_up);
        axis([XL(1) XL(2) YL(1) YL(2)]);
        plot([Condition(icondition).Gait(itrial).Revents.e.RHS(1)*Session(icondition).fanalog ...
            Condition(icondition).Gait(itrial).Revents.e.RHS(1)*Session(icondition).fanalog],...
            [YL(1) YL(2)],'Linestyle','-','Linewidth',1,'Color','black');
        plot([Condition(icondition).Gait(itrial).Revents.e.RTO(end)*Session(icondition).fanalog ...
            Condition(icondition).Gait(itrial).Revents.e.RTO(end)*Session(icondition).fanalog],...
            [YL(1) YL(2)],'Linestyle','--','Linewidth',1,'Color','black');
        plot([Condition(icondition).Gait(itrial).Revents.e.RHS(2)*Session(icondition).fanalog ...
            Condition(icondition).Gait(itrial).Revents.e.RHS(2)*Session(icondition).fanalog],...
            [YL(1) YL(2)],'Linestyle','-','Linewidth',1,'Color','black');
        box on;
        igraph = igraph+1;
    end

    % EMG 8 / filt
    % ---------------------------------------------------------------------
    if length(Remg_name) >= 8
        axesGraph = axes;
        set(axesGraph,'Position',[0 0 1 1]);
        set(axesGraph,'Visible','Off');
        Graph(igraph) = axes('position',[x(4)/pageWidth y/pageHeight ...
            graphWidth/2/pageWidth graphHeight/pageHeight]);
        xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
        ylabel('Amplitude (%max)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
        hold on;
        % Find norm
        inorm = [];
        names = fieldnames(Norm.EMG);
        for i = 1:length(names)
            if strfind(regexprep(names{i},'right_',''),regexprep(Remg_name{8},'right_',''))
                inorm = eval(['Norm.EMG.',names{i},';']);
            end
        end
        % Plot
        if ~isempty(inorm)
            plot(inorm.mean(1:101,1)/max(inorm.mean(1:101,1)),'Linestyle','-','Linewidth',2,'Color',[0.5 0.5 0.5]);
        end
        plot(Remg_filt.mean(1:101,8)/max(Remg_filt.mean(1:101,8)),'Linestyle','-','Linewidth',2,'Color',colorR(1,:));
        set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0:50:100],'YTick',0:0.25:1,'YTickLabel',{'0' '25' '50' '75' '100'});
        axis tight;
        axis([0 100 0 1]);
        plot([Condition(icondition).Gait(itrial).Rphases.p5 ...
            Condition(icondition).Gait(itrial).Rphases.p5],...
            [0 1],'Linestyle','--','Linewidth',1,'Color','black');
        box on;
        igraph = igraph+1;
    end

end

if ~isempty(Condition(icondition).Gait(itrial).Lemg)
    
    % =====================================================================
    % Generate the page 2 (left side)
    % =====================================================================

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
        if strfind(cell2mat(names(j)),'_filt')
            Lemg_filt(1:size(eval(['Condition(icondition).Gait(itrial).Lemg.',cell2mat(names(j)),';']),1),k2) = ...
                eval(['Condition(icondition).Gait(itrial).Lemg.',cell2mat(names(j)),';']);
            k2 = k2+1;
        end
    end

    % Set the page
    % ---------------------------------------------------------------------
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
    yinit = 29.0; %cm
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
        '  EMG',...
        'Color','k','FontWeight','Bold','FontSize',18,...
        'HorizontalAlignment','Center');
    y = y - yincr*2;
    text(0.02,y/pageHeight,...
        '  C�t� gauche',...
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
    % Count the number of trials
    nbtrials = 0;
    for j = 1:length(Condition(icondition).Gait);
        if ~isempty(Condition(icondition).Gait(j).Lemg)
            nbtrials = nbtrials+1;
        end
    end
    % Write the legend
    text(0.05,y/pageHeight,[char(files(itrial,:))]);
    text(0.25,y/pageHeight,'Norm','Color',[0.5 0.5 0.5]);
    text(0.33,y/pageHeight,[char(Session(icondition).date),...
        '     Nb essais : ',num2str(nbtrials),...
        '     Condition : ',char(regexprep(Condition(icondition).name,'_','-')),' (cf page 1)'],'color','k');
    y = y - yincr*1.0;

    % EMG 1 / raw
    % ---------------------------------------------------------------------
    if length(Lemg_name) >= 1
        % Real size of the data vector
        isize = size(find(~isnan(Lemg_raw(:,1))),1);
        % Plot EMG
        y = y - yincr*8.5;
        y1 = y;
        axesGraph = axes;
        set(axesGraph,'Position',[0 0 1 1]);
        set(axesGraph,'Visible','Off');
        Graph(igraph) = axes('position',[x(1)/pageWidth y/pageHeight ...
            graphWidth/pageWidth graphHeight/pageHeight]);
        set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[],'YTick',-50e-4:1e-4:50e-4);
        hold on;
        title(regexprep(regexprep(Lemg_name{1},'left_',''),'_',' '),'FontWeight','Bold');
        ylabel('Amplitude (uV)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
        plot(1:isize,zeros(isize,1),'Linestyle','-','Linewidth',0.5,'Color','black');
        plot(Lemg_raw(1:isize,1),'Linestyle','-','Linewidth',0.5,'Color',colorL(1,:));
        axis tight;
        YL = [-2e-4,2e-4];
        XL = xlim;
        number_frame_cycle = Condition(icondition).Gait(itrial).Revents.e.LHS(2)*Session(icondition).fanalog...
            - Condition(icondition).Gait(itrial).Revents.e.LHS(1)*Session(icondition).fanalog;
        X_down = Condition(icondition).Gait(itrial).Revents.e.LHS(1)*Session(icondition).fanalog-2*number_frame_cycle;
        X_up = Condition(icondition).Gait(itrial).Revents.e.LHS(2)*Session(icondition).fanalog+2*number_frame_cycle;
        XL(1) = max(XL(1),X_down);
        XL(2) = min(XL(2),X_up);
        axis([XL(1) XL(2) YL(1) YL(2)]);
        plot([Condition(icondition).Gait(itrial).Revents.e.LHS(1)*Session(icondition).fanalog ...
            Condition(icondition).Gait(itrial).Revents.e.LHS(1)*Session(icondition).fanalog],...
            [YL(1) YL(2)],'Linestyle','-','Linewidth',1,'Color','black');
        plot([Condition(icondition).Gait(itrial).Revents.e.LTO(end)*Session(icondition).fanalog ...
            Condition(icondition).Gait(itrial).Revents.e.LTO(end)*Session(icondition).fanalog],...
            [YL(1) YL(2)],'Linestyle','--','Linewidth',1,'Color','black');
        plot([Condition(icondition).Gait(itrial).Revents.e.LHS(2)*Session(icondition).fanalog ...
            Condition(icondition).Gait(itrial).Revents.e.LHS(2)*Session(icondition).fanalog],...
            [YL(1) YL(2)],'Linestyle','-','Linewidth',1,'Color','black');
        box on;
        igraph = igraph+1;
    end

    % EMG 1 / filt
    % ---------------------------------------------------------------------
    if length(Lemg_name) >= 1
        axesGraph = axes;
        set(axesGraph,'Position',[0 0 1 1]);
        set(axesGraph,'Visible','Off');
        Graph(igraph) = axes('position',[x(2)/pageWidth y/pageHeight ...
            graphWidth/2/pageWidth graphHeight/pageHeight]);
        xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
        ylabel('Amplitude (%max)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
        hold on;
        % Find norm
        inorm = [];
        names = fieldnames(Norm.EMG);
        for i = 1:length(names)
            if strfind(regexprep(names{i},'right_',''),regexprep(Lemg_name{1},'left_',''))
                inorm = eval(['Norm.EMG.',names{i},';']);
            end
        end
        % Plot
        if ~isempty(inorm)
            plot(inorm.mean(1:101,1)/max(inorm.mean(1:101,1)),'Linestyle','-','Linewidth',2,'Color',[0.5 0.5 0.5]);
        end
        plot(Lemg_filt(1:101,1)/max(Lemg_filt(1:101,1)),'Linestyle','-','Linewidth',2,'Color',colorL(1,:));
        set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0:50:100],'YTick',0:0.25:1,'YTickLabel',{'0' '25' '50' '75' '100'});
        axis tight;
        axis([0 100 0 1]);
        plot([Condition(icondition).Gait(itrial).Lphases.p5 ...
            Condition(icondition).Gait(itrial).Lphases.p5],...
            [0 1],'Linestyle','--','Linewidth',1,'Color','black');
        box on;
        igraph = igraph+1;
    end

    % EMG 2 / raw
    % ---------------------------------------------------------------------
    if length(Lemg_name) >= 2
        % Real size of the data vector
        isize = size(find(~isnan(Lemg_raw(:,2))),1);
        % Plot EMG
        y = y - yincr*8.5;
        axesGraph = axes;
        set(axesGraph,'Position',[0 0 1 1]);
        set(axesGraph,'Visible','Off');
        Graph(igraph) = axes('position',[x(1)/pageWidth y/pageHeight ...
            graphWidth/pageWidth graphHeight/pageHeight]);
        set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[],'YTick',-50e-4:1e-4:50e-4);
        hold on;
        title(regexprep(regexprep(Lemg_name{2},'left_',''),'_',' '),'FontWeight','Bold');
        ylabel('Amplitude (uV)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
        plot(1:isize,zeros(isize,1),'Linestyle','-','Linewidth',0.5,'Color','black');
        plot(Lemg_raw(1:isize,2),'Linestyle','-','Linewidth',0.5,'Color',colorL(1,:));
        axis tight;
        YL = [-2e-4,2e-4];
        XL = xlim;
        number_frame_cycle = Condition(icondition).Gait(itrial).Revents.e.LHS(2)*Session(icondition).fanalog...
            - Condition(icondition).Gait(itrial).Revents.e.LHS(1)*Session(icondition).fanalog;
        X_down = Condition(icondition).Gait(itrial).Revents.e.LHS(1)*Session(icondition).fanalog-2*number_frame_cycle;
        X_up = Condition(icondition).Gait(itrial).Revents.e.LHS(2)*Session(icondition).fanalog+2*number_frame_cycle;
        XL(1) = max(XL(1),X_down);
        XL(2) = min(XL(2),X_up);
        axis([XL(1) XL(2) YL(1) YL(2)]);
        plot([Condition(icondition).Gait(itrial).Revents.e.LHS(1)*Session(icondition).fanalog ...
            Condition(icondition).Gait(itrial).Revents.e.LHS(1)*Session(icondition).fanalog],...
            [YL(1) YL(2)],'Linestyle','-','Linewidth',1,'Color','black');
        plot([Condition(icondition).Gait(itrial).Revents.e.LTO(end)*Session(icondition).fanalog ...
            Condition(icondition).Gait(itrial).Revents.e.LTO(end)*Session(icondition).fanalog],...
            [YL(1) YL(2)],'Linestyle','--','Linewidth',1,'Color','black');
        plot([Condition(icondition).Gait(itrial).Revents.e.LHS(2)*Session(icondition).fanalog ...
            Condition(icondition).Gait(itrial).Revents.e.LHS(2)*Session(icondition).fanalog],...
            [YL(1) YL(2)],'Linestyle','-','Linewidth',1,'Color','black');
        box on;
        igraph = igraph+1;
    end

    % EMG 2 / filt
    % ---------------------------------------------------------------------
    if length(Lemg_name) >= 2
        axesGraph = axes;
        set(axesGraph,'Position',[0 0 1 1]);
        set(axesGraph,'Visible','Off');
        Graph(igraph) = axes('position',[x(2)/pageWidth y/pageHeight ...
            graphWidth/2/pageWidth graphHeight/pageHeight]);
        xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
        ylabel('Amplitude (%max)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
        hold on;
        % Find norm
        inorm = [];
        names = fieldnames(Norm.EMG);
        for i = 1:length(names)
            if strfind(regexprep(names{i},'right_',''),regexprep(Lemg_name{2},'left_',''))
                inorm = eval(['Norm.EMG.',names{i},';']);
            end
        end
        % Plot
        if ~isempty(inorm)
            plot(inorm.mean(1:101,1)/max(inorm.mean(1:101,1)),'Linestyle','-','Linewidth',2,'Color',[0.5 0.5 0.5]);
        end
        plot(Lemg_filt(1:101,2)/max(Lemg_filt(1:101,2)),'Linestyle','-','Linewidth',2,'Color',colorL(1,:));
        set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0:50:100],'YTick',0:0.25:1,'YTickLabel',{'0' '25' '50' '75' '100'});
        ylim([0 1]);
        axis tight;
        axis([0 100 0 1]);
        plot([Condition(icondition).Gait(itrial).Lphases.p5 ...
            Condition(icondition).Gait(itrial).Lphases.p5],...
            [0 1],'Linestyle','--','Linewidth',1,'Color','black');
        box on;
        igraph = igraph+1;
    end

    % EMG 3 / raw
    % ---------------------------------------------------------------------
    if length(Lemg_name) >= 3
        % Real size of the data vector
        isize = size(find(~isnan(Lemg_raw(:,3))),1);
        % Plot EMG
        y = y - yincr*8.5;
        axesGraph = axes;
        set(axesGraph,'Position',[0 0 1 1]);
        set(axesGraph,'Visible','Off');
        Graph(igraph) = axes('position',[x(1)/pageWidth y/pageHeight ...
            graphWidth/pageWidth graphHeight/pageHeight]);
        set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[],'YTick',-50e-4:1e-4:50e-4);
        hold on;
        title(regexprep(regexprep(Lemg_name{3},'left_',''),'_',' '),'FontWeight','Bold');
        ylabel('Amplitude (uV)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
        plot(1:isize,zeros(isize,1),'Linestyle','-','Linewidth',0.5,'Color','black');
        plot(Lemg_raw(1:isize,3),'Linestyle','-','Linewidth',0.5,'Color',colorL(1,:));
        axis tight;
        YL = [-2e-4,2e-4];
        XL = xlim;
        number_frame_cycle = Condition(icondition).Gait(itrial).Revents.e.LHS(2)*Session(icondition).fanalog...
            - Condition(icondition).Gait(itrial).Revents.e.LHS(1)*Session(icondition).fanalog;
        X_down = Condition(icondition).Gait(itrial).Revents.e.LHS(1)*Session(icondition).fanalog-2*number_frame_cycle;
        X_up = Condition(icondition).Gait(itrial).Revents.e.LHS(2)*Session(icondition).fanalog+2*number_frame_cycle;
        XL(1) = max(XL(1),X_down);
        XL(2) = min(XL(2),X_up);
        axis([XL(1) XL(2) YL(1) YL(2)]);
        plot([Condition(icondition).Gait(itrial).Revents.e.LHS(1)*Session(icondition).fanalog ...
            Condition(icondition).Gait(itrial).Revents.e.LHS(1)*Session(icondition).fanalog],...
            [YL(1) YL(2)],'Linestyle','-','Linewidth',1,'Color','black');
        plot([Condition(icondition).Gait(itrial).Revents.e.LTO(end)*Session(icondition).fanalog ...
            Condition(icondition).Gait(itrial).Revents.e.LTO(end)*Session(icondition).fanalog],...
            [YL(1) YL(2)],'Linestyle','--','Linewidth',1,'Color','black');
        plot([Condition(icondition).Gait(itrial).Revents.e.LHS(2)*Session(icondition).fanalog ...
            Condition(icondition).Gait(itrial).Revents.e.LHS(2)*Session(icondition).fanalog],...
            [YL(1) YL(2)],'Linestyle','-','Linewidth',1,'Color','black');
        box on;
        igraph = igraph+1;
    end

    % EMG 3 / filt
    % ---------------------------------------------------------------------
    if length(Lemg_name) >= 3
        axesGraph = axes;
        set(axesGraph,'Position',[0 0 1 1]);
        set(axesGraph,'Visible','Off');
        Graph(igraph) = axes('position',[x(2)/pageWidth y/pageHeight ...
            graphWidth/2/pageWidth graphHeight/pageHeight]);
        xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
        ylabel('Amplitude (%max)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
        hold on;
        % Find norm
        inorm = [];
        names = fieldnames(Norm.EMG);
        for i = 1:length(names)
            if strfind(regexprep(names{i},'right_',''),regexprep(Lemg_name{3},'left_',''))
                inorm = eval(['Norm.EMG.',names{i},';']);
            end
        end
        % Plot
        if ~isempty(inorm)
            plot(inorm.mean(1:101,1)/max(inorm.mean(1:101,1)),'Linestyle','-','Linewidth',2,'Color',[0.5 0.5 0.5]);
        end
        plot(Lemg_filt(1:101,3)/max(Lemg_filt(1:101,3)),'Linestyle','-','Linewidth',2,'Color',colorL(1,:));
        set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0:50:100],'YTick',0:0.25:1,'YTickLabel',{'0' '25' '50' '75' '100'});
        ylim([0 1]);
        axis tight;
        axis([0 100 0 1]);
        plot([Condition(icondition).Gait(itrial).Lphases.p5 ...
            Condition(icondition).Gait(itrial).Lphases.p5],...
            [0 1],'Linestyle','--','Linewidth',1,'Color','black');
        box on;
        igraph = igraph+1;
    end

    % EMG 4 / raw
    % ---------------------------------------------------------------------
    if length(Lemg_name) >= 4
        % Real size of the data vector
        isize = size(find(~isnan(Lemg_raw(:,4))),1);
        % Plot EMG
        y = y - yincr*8.5;
        axesGraph = axes;
        set(axesGraph,'Position',[0 0 1 1]);
        set(axesGraph,'Visible','Off');
        Graph(igraph) = axes('position',[x(1)/pageWidth y/pageHeight ...
            graphWidth/pageWidth graphHeight/pageHeight]);
        set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[],'YTick',-50e-4:1e-4:50e-4);
        hold on;
        title(regexprep(regexprep(Lemg_name{4},'left_',''),'_',' '),'FontWeight','Bold');
        ylabel('Amplitude (uV)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
        plot(1:isize,zeros(isize,1),'Linestyle','-','Linewidth',0.5,'Color','black');
        plot(Lemg_raw(1:isize,4),'Linestyle','-','Linewidth',0.5,'Color',colorL(1,:));
        axis tight;
        YL = [-2e-4,2e-4];
        XL = xlim;
        number_frame_cycle = Condition(icondition).Gait(itrial).Revents.e.LHS(2)*Session(icondition).fanalog...
            - Condition(icondition).Gait(itrial).Revents.e.LHS(1)*Session(icondition).fanalog;
        X_down = Condition(icondition).Gait(itrial).Revents.e.LHS(1)*Session(icondition).fanalog-2*number_frame_cycle;
        X_up = Condition(icondition).Gait(itrial).Revents.e.LHS(2)*Session(icondition).fanalog+2*number_frame_cycle;
        XL(1) = max(XL(1),X_down);
        XL(2) = min(XL(2),X_up);
        axis([XL(1) XL(2) YL(1) YL(2)]);
        plot([Condition(icondition).Gait(itrial).Revents.e.LHS(1)*Session(icondition).fanalog ...
            Condition(icondition).Gait(itrial).Revents.e.LHS(1)*Session(icondition).fanalog],...
            [YL(1) YL(2)],'Linestyle','-','Linewidth',1,'Color','black');
        plot([Condition(icondition).Gait(itrial).Revents.e.LTO(end)*Session(icondition).fanalog ...
            Condition(icondition).Gait(itrial).Revents.e.LTO(end)*Session(icondition).fanalog],...
            [YL(1) YL(2)],'Linestyle','--','Linewidth',1,'Color','black');
        plot([Condition(icondition).Gait(itrial).Revents.e.LHS(2)*Session(icondition).fanalog ...
            Condition(icondition).Gait(itrial).Revents.e.LHS(2)*Session(icondition).fanalog],...
            [YL(1) YL(2)],'Linestyle','-','Linewidth',1,'Color','black');
        box on;
        igraph = igraph+1;
    end

    % EMG 4 / filt
    % ---------------------------------------------------------------------
    if length(Lemg_name) >= 4
        axesGraph = axes;
        set(axesGraph,'Position',[0 0 1 1]);
        set(axesGraph,'Visible','Off');
        Graph(igraph) = axes('position',[x(2)/pageWidth y/pageHeight ...
            graphWidth/2/pageWidth graphHeight/pageHeight]);
        xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
        ylabel('Amplitude (%max)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
        hold on;
        % Find norm
        inorm = [];
        names = fieldnames(Norm.EMG);
        for i = 1:length(names)
            if strfind(regexprep(names{i},'right_',''),regexprep(Lemg_name{4},'left_',''))
                inorm = eval(['Norm.EMG.',names{i},';']);
            end
        end
        % Plot
        if ~isempty(inorm)
            plot(inorm.mean(1:101,1)/max(inorm.mean(1:101,1)),'Linestyle','-','Linewidth',2,'Color',[0.5 0.5 0.5]);
        end
        plot(Lemg_filt(1:101,4)/max(Lemg_filt(1:101,4)),'Linestyle','-','Linewidth',2,'Color',colorL(1,:));
        set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0:50:100],'YTick',0:0.25:1,'YTickLabel',{'0' '25' '50' '75' '100'});
        ylim([0 1]);
        axis tight;
        axis([0 100 0 1]);
        plot([Condition(icondition).Gait(itrial).Lphases.p5 ...
            Condition(icondition).Gait(itrial).Lphases.p5],...
            [0 1],'Linestyle','--','Linewidth',1,'Color','black');
        box on;
        igraph = igraph+1;
    end

    % EMG 5 / raw
    % ---------------------------------------------------------------------
    if length(Lemg_name) >= 5
        % Real size of the data vector
        isize = size(find(~isnan(Lemg_raw(:,5))),1);
        % Plot EMG
        y = y1;
        axesGraph = axes;
        set(axesGraph,'Position',[0 0 1 1]);
        set(axesGraph,'Visible','Off');
        Graph(igraph) = axes('position',[x(3)/pageWidth y/pageHeight ...
            graphWidth/pageWidth graphHeight/pageHeight]);
        set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[],'YTick',-50e-4:1e-4:50e-4);
        hold on;
        title(regexprep(regexprep(Lemg_name{5},'left_',''),'_',' '),'FontWeight','Bold');
        ylabel('Amplitude (uV)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
        plot(1:isize,zeros(isize,1),'Linestyle','-','Linewidth',0.5,'Color','black');
        plot(Lemg_raw(1:isize,5),'Linestyle','-','Linewidth',0.5,'Color',colorL(1,:));
        axis tight;
        YL = [-2e-4,2e-4];
        XL = xlim;
        number_frame_cycle = Condition(icondition).Gait(itrial).Revents.e.LHS(2)*Session(icondition).fanalog...
            - Condition(icondition).Gait(itrial).Revents.e.LHS(1)*Session(icondition).fanalog;
        X_down = Condition(icondition).Gait(itrial).Revents.e.LHS(1)*Session(icondition).fanalog-2*number_frame_cycle;
        X_up = Condition(icondition).Gait(itrial).Revents.e.LHS(2)*Session(icondition).fanalog+2*number_frame_cycle;
        XL(1) = max(XL(1),X_down);
        XL(2) = min(XL(2),X_up);
        axis([XL(1) XL(2) YL(1) YL(2)]);
        plot([Condition(icondition).Gait(itrial).Revents.e.LHS(1)*Session(icondition).fanalog ...
            Condition(icondition).Gait(itrial).Revents.e.LHS(1)*Session(icondition).fanalog],...
            [YL(1) YL(2)],'Linestyle','-','Linewidth',1,'Color','black');
        plot([Condition(icondition).Gait(itrial).Revents.e.LTO(end)*Session(icondition).fanalog ...
            Condition(icondition).Gait(itrial).Revents.e.LTO(end)*Session(icondition).fanalog],...
            [YL(1) YL(2)],'Linestyle','--','Linewidth',1,'Color','black');
        plot([Condition(icondition).Gait(itrial).Revents.e.LHS(2)*Session(icondition).fanalog ...
            Condition(icondition).Gait(itrial).Revents.e.LHS(2)*Session(icondition).fanalog],...
            [YL(1) YL(2)],'Linestyle','-','Linewidth',1,'Color','black');
        box on;
        igraph = igraph+1;
    end

    % EMG 5 / filt
    % ---------------------------------------------------------------------
    if length(Lemg_name) >= 5
        axesGraph = axes;
        set(axesGraph,'Position',[0 0 1 1]);
        set(axesGraph,'Visible','Off');
        Graph(igraph) = axes('position',[x(4)/pageWidth y/pageHeight ...
            graphWidth/2/pageWidth graphHeight/pageHeight]);
        xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
        ylabel('Amplitude (%max)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
        hold on;
        % Find norm
        inorm = [];
        names = fieldnames(Norm.EMG);
        for i = 1:length(names)
            if strfind(regexprep(names{i},'right_',''),regexprep(Lemg_name{5},'left_',''))
                inorm = eval(['Norm.EMG.',names{i},';']);
            end
        end
        % Plot
        if ~isempty(inorm)
            plot(inorm.mean(1:101,1)/max(inorm.mean(1:101,1)),'Linestyle','-','Linewidth',2,'Color',[0.5 0.5 0.5]);
        end
        plot(Lemg_filt(1:101,5)/max(Lemg_filt(1:101,5)),'Linestyle','-','Linewidth',2,'Color',colorL(1,:));
        set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0:50:100],'YTick',0:0.25:1,'YTickLabel',{'0' '25' '50' '75' '100'});
        axis tight;
        axis([0 100 0 1]);
        plot([Condition(icondition).Gait(itrial).Lphases.p5 ...
            Condition(icondition).Gait(itrial).Lphases.p5],...
            [0 1],'Linestyle','--','Linewidth',1,'Color','black');
        box on;
        igraph = igraph+1;
    end

    % EMG 6 / raw
    % ---------------------------------------------------------------------
    if length(Lemg_name) >= 6
        % Real size of the data vector
        isize = size(find(~isnan(Lemg_raw(:,6))),1);
        % Plot EMG
        y = y - yincr*8.5;
        axesGraph = axes;
        set(axesGraph,'Position',[0 0 1 1]);
        set(axesGraph,'Visible','Off');
        Graph(igraph) = axes('position',[x(3)/pageWidth y/pageHeight ...
            graphWidth/pageWidth graphHeight/pageHeight]);
        set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[],'YTick',-50e-4:1e-4:50e-4);
        hold on;
        title(regexprep(regexprep(Lemg_name{6},'left_',''),'_',' '),'FontWeight','Bold');
        ylabel('Amplitude (uV)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
        plot(1:isize,zeros(isize,1),'Linestyle','-','Linewidth',0.5,'Color','black');
        plot(Lemg_raw(1:isize,6),'Linestyle','-','Linewidth',0.5,'Color',colorL(1,:));
        axis tight;
        YL = [-2e-4,2e-4];
        XL = xlim;
        number_frame_cycle = Condition(icondition).Gait(itrial).Revents.e.LHS(2)*Session(icondition).fanalog...
            - Condition(icondition).Gait(itrial).Revents.e.LHS(1)*Session(icondition).fanalog;
        X_down = Condition(icondition).Gait(itrial).Revents.e.LHS(1)*Session(icondition).fanalog-2*number_frame_cycle;
        X_up = Condition(icondition).Gait(itrial).Revents.e.LHS(2)*Session(icondition).fanalog+2*number_frame_cycle;
        XL(1) = max(XL(1),X_down);
        XL(2) = min(XL(2),X_up);
        axis([XL(1) XL(2) YL(1) YL(2)]);
        plot([Condition(icondition).Gait(itrial).Revents.e.LHS(1)*Session(icondition).fanalog ...
            Condition(icondition).Gait(itrial).Revents.e.LHS(1)*Session(icondition).fanalog],...
            [YL(1) YL(2)],'Linestyle','-','Linewidth',1,'Color','black');
        plot([Condition(icondition).Gait(itrial).Revents.e.LTO(end)*Session(icondition).fanalog ...
            Condition(icondition).Gait(itrial).Revents.e.LTO(end)*Session(icondition).fanalog],...
            [YL(1) YL(2)],'Linestyle','--','Linewidth',1,'Color','black');
        plot([Condition(icondition).Gait(itrial).Revents.e.LHS(2)*Session(icondition).fanalog ...
            Condition(icondition).Gait(itrial).Revents.e.LHS(2)*Session(icondition).fanalog],...
            [YL(1) YL(2)],'Linestyle','-','Linewidth',1,'Color','black');
        box on;
        igraph = igraph+1;
    end

    % EMG 6 / filt
    % ---------------------------------------------------------------------
    if length(Lemg_name) >= 6
        axesGraph = axes;
        set(axesGraph,'Position',[0 0 1 1]);
        set(axesGraph,'Visible','Off');
        Graph(igraph) = axes('position',[x(4)/pageWidth y/pageHeight ...
            graphWidth/2/pageWidth graphHeight/pageHeight]);
        xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
        ylabel('Amplitude (%max)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
        hold on;
        % Find norm
        inorm = [];
        names = fieldnames(Norm.EMG);
        for i = 1:length(names)
            if strfind(regexprep(names{i},'right_',''),regexprep(Lemg_name{6},'left_',''))
                inorm = eval(['Norm.EMG.',names{i},';']);
            end
        end
        % Plot
        if ~isempty(inorm)
            plot(inorm.mean(1:101,1)/max(inorm.mean(1:101,1)),'Linestyle','-','Linewidth',2,'Color',[0.5 0.5 0.5]);
        end
        plot(Lemg_filt(1:101,6)/max(Lemg_filt(1:101,6)),'Linestyle','-','Linewidth',2,'Color',colorL(1,:));
        set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0:50:100],'YTick',0:0.25:1,'YTickLabel',{'0' '25' '50' '75' '100'});
        axis tight;
        axis([0 100 0 1]);
        plot([Condition(icondition).Gait(itrial).Lphases.p5 ...
            Condition(icondition).Gait(itrial).Lphases.p5],...
            [0 1],'Linestyle','--','Linewidth',1,'Color','black');
        box on;
        igraph = igraph+1;
    end

    % EMG 7 / raw
    % ---------------------------------------------------------------------
    if length(Lemg_name) >= 7
        % Real size of the data vector
        isize = size(find(~isnan(Lemg_raw(:,7))),1);
        % Plot EMG
        y = y - yincr*8.5;
        axesGraph = axes;
        set(axesGraph,'Position',[0 0 1 1]);
        set(axesGraph,'Visible','Off');
        Graph(igraph) = axes('position',[x(3)/pageWidth y/pageHeight ...
            graphWidth/pageWidth graphHeight/pageHeight]);
        set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[],'YTick',-50e-4:1e-4:50e-4);
        hold on;
        title(regexprep(regexprep(Lemg_name{7},'left_',''),'_',' '),'FontWeight','Bold');
        ylabel('Amplitude (uV)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
        plot(1:isize,zeros(isize,1),'Linestyle','-','Linewidth',0.5,'Color','black');
        plot(Lemg_raw(1:isize,7),'Linestyle','-','Linewidth',0.5,'Color',colorL(1,:));
        axis tight;
        YL = [-2e-4,2e-4];
        XL = xlim;
        number_frame_cycle = Condition(icondition).Gait(itrial).Revents.e.LHS(2)*Session(icondition).fanalog...
            - Condition(icondition).Gait(itrial).Revents.e.LHS(1)*Session(icondition).fanalog;
        X_down = Condition(icondition).Gait(itrial).Revents.e.LHS(1)*Session(icondition).fanalog-2*number_frame_cycle;
        X_up = Condition(icondition).Gait(itrial).Revents.e.LHS(2)*Session(icondition).fanalog+2*number_frame_cycle;
        XL(1) = max(XL(1),X_down);
        XL(2) = min(XL(2),X_up);
        axis([XL(1) XL(2) YL(1) YL(2)]);
        plot([Condition(icondition).Gait(itrial).Revents.e.LHS(1)*Session(icondition).fanalog ...
            Condition(icondition).Gait(itrial).Revents.e.LHS(1)*Session(icondition).fanalog],...
            [YL(1) YL(2)],'Linestyle','-','Linewidth',1,'Color','black');
        plot([Condition(icondition).Gait(itrial).Revents.e.LTO(end)*Session(icondition).fanalog ...
            Condition(icondition).Gait(itrial).Revents.e.LTO(end)*Session(icondition).fanalog],...
            [YL(1) YL(2)],'Linestyle','--','Linewidth',1,'Color','black');
        plot([Condition(icondition).Gait(itrial).Revents.e.LHS(2)*Session(icondition).fanalog ...
            Condition(icondition).Gait(itrial).Revents.e.LHS(2)*Session(icondition).fanalog],...
            [YL(1) YL(2)],'Linestyle','-','Linewidth',1,'Color','black');
        box on;
        igraph = igraph+1;
    end

    % EMG 7 / filt
    % ---------------------------------------------------------------------
    if length(Lemg_name) >= 7
        axesGraph = axes;
        set(axesGraph,'Position',[0 0 1 1]);
        set(axesGraph,'Visible','Off');
        Graph(igraph) = axes('position',[x(4)/pageWidth y/pageHeight ...
            graphWidth/2/pageWidth graphHeight/pageHeight]);
        xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
        ylabel('Amplitude (%max)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
        hold on;
        % Find norm
        inorm = [];
        names = fieldnames(Norm.EMG);
        for i = 1:length(names)
            if strfind(regexprep(names{i},'right_',''),regexprep(Lemg_name{7},'left_',''))
                inorm = eval(['Norm.EMG.',names{i},';']);
            end
        end
        % Plot
        if ~isempty(inorm)
            plot(inorm.mean(1:101,1)/max(inorm.mean(1:101,1)),'Linestyle','-','Linewidth',2,'Color',[0.5 0.5 0.5]);
        end
        plot(Lemg_filt(1:101,7)/max(Lemg_filt(1:101,7)),'Linestyle','-','Linewidth',2,'Color',colorL(1,:));
        set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0:50:100],'YTick',0:0.25:1,'YTickLabel',{'0' '25' '50' '75' '100'});
        axis tight;
        axis([0 100 0 1]);
        plot([Condition(icondition).Gait(itrial).Lphases.p5 ...
            Condition(icondition).Gait(itrial).Lphases.p5],...
            [0 1],'Linestyle','--','Linewidth',1,'Color','black');
        box on;
        igraph = igraph+1;
    end

    % EMG 8 / raw
    % ---------------------------------------------------------------------
    if length(Lemg_name) >= 8
        % Real size of the data vector
        isize = size(find(~isnan(Lemg_raw(:,8))),1);
        % Plot EMG
        y = y - yincr*8.5;
        axesGraph = axes;
        set(axesGraph,'Position',[0 0 1 1]);
        set(axesGraph,'Visible','Off');
        Graph(igraph) = axes('position',[x(3)/pageWidth y/pageHeight ...
            graphWidth/pageWidth graphHeight/pageHeight]);
        set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[],'YTick',-50e-4:1e-4:50e-4);
        hold on;
        title(regexprep(regexprep(Lemg_name{8},'left_',''),'_',' '),'FontWeight','Bold');
        ylabel('Amplitude (uV)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
        plot(1:isize,zeros(isize,1),'Linestyle','-','Linewidth',0.5,'Color','black');
        plot(Lemg_raw(1:isize,8),'Linestyle','-','Linewidth',0.5,'Color',colorL(1,:));
        axis tight;
        YL = [-2e-4,2e-4];
        XL = xlim;
        number_frame_cycle = Condition(icondition).Gait(itrial).Revents.e.LHS(2)*Session(icondition).fanalog...
            - Condition(icondition).Gait(itrial).Revents.e.LHS(1)*Session(icondition).fanalog;
        X_down = Condition(icondition).Gait(itrial).Revents.e.LHS(1)*Session(icondition).fanalog-2*number_frame_cycle;
        X_up = Condition(icondition).Gait(itrial).Revents.e.LHS(2)*Session(icondition).fanalog+2*number_frame_cycle;
        XL(1) = max(XL(1),X_down);
        XL(2) = min(XL(2),X_up);
        axis([XL(1) XL(2) YL(1) YL(2)]);
        plot([Condition(icondition).Gait(itrial).Revents.e.LHS(1)*Session(icondition).fanalog ...
            Condition(icondition).Gait(itrial).Revents.e.LHS(1)*Session(icondition).fanalog],...
            [YL(1) YL(2)],'Linestyle','-','Linewidth',1,'Color','black');
        plot([Condition(icondition).Gait(itrial).Revents.e.LTO(end)*Session(icondition).fanalog ...
            Condition(icondition).Gait(itrial).Revents.e.LTO(end)*Session(icondition).fanalog],...
            [YL(1) YL(2)],'Linestyle','--','Linewidth',1,'Color','black');
        plot([Condition(icondition).Gait(itrial).Revents.e.LHS(2)*Session(icondition).fanalog ...
            Condition(icondition).Gait(itrial).Revents.e.LHS(2)*Session(icondition).fanalog],...
            [YL(1) YL(2)],'Linestyle','-','Linewidth',1,'Color','black');
        box on;
        igraph = igraph+1;
    end

    % EMG 8 / filt
    % ---------------------------------------------------------------------
    if length(Lemg_name) >= 8
        axesGraph = axes;
        set(axesGraph,'Position',[0 0 1 1]);
        set(axesGraph,'Visible','Off');
        Graph(igraph) = axes('position',[x(4)/pageWidth y/pageHeight ...
            graphWidth/2/pageWidth graphHeight/pageHeight]);
        xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
        ylabel('Amplitude (%max)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
        hold on;
        % Find norm
        inorm = [];
        names = fieldnames(Norm.EMG);
        for i = 1:length(names)
            if strfind(regexprep(names{i},'right_',''),regexprep(Lemg_name{8},'left_',''))
                inorm = eval(['Norm.EMG.',names{i},';']);
            end
        end
        % Plot
        if ~isempty(inorm)
            plot(inorm.mean(1:101,1)/max(inorm.mean(1:101,1)),'Linestyle','-','Linewidth',2,'Color',[0.5 0.5 0.5]);
        end
        plot(Lemg_filt(1:101,8)/max(Lemg_filt(1:101,8)),'Linestyle','-','Linewidth',2,'Color',colorL(1,:));
        set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0:50:100],'YTick',0:0.25:1,'YTickLabel',{'0' '25' '50' '75' '100'});
        axis tight;
        axis([0 100 0 1]);
        plot([Condition(icondition).Gait(itrial).Lphases.p5 ...
            Condition(icondition).Gait(itrial).Lphases.p5],...
            [0 1],'Linestyle','--','Linewidth',1,'Color','black');
        box on;
        igraph = igraph+1;
    end
    

%     if length(Lemg_name)>8
%         
%         % Set the page
%         % ---------------------------------------------------------------------
%         f(3) = figure('PaperOrientation','portrait','papertype','A4',...
%             'Units','centimeters','Position',[0 0 pageWidth pageHeight],...
%             'Color','white','PaperUnits','centimeters',...
%             'PaperPosition',[0 0 pageWidth pageHeight],...
%             'Name',['parameters',num2str(1)]);
%         hold on;
%         axis off;
% 
%         % Rehazenter banner
%         % ---------------------------------------------------------------------
%         cd(pluginFolder);
%         banner = imread('banner','jpeg');
%         axesImage = axes('position',...
%             [0 0.89 1 0.12]);
%         image(banner);
%         set(axesImage,'Visible','Off');
% 
%         % Header
%         % ---------------------------------------------------------------------
%         axesText = axes;
%         set(axesText,'Position',[0.47 0 1 1]);
%         set(axesText,'Visible','Off');
%         yinit = 29.0; %cm
%         y = yinit;
%         y = y - 0.8;
%         text(0.5/pageWidth,y/pageHeight,...
%             'CNRFR - Rehazenter',...
%             'Color','w','FontSize',12);
%         y = y - yincr;
%         text(0.5/pageWidth,y/pageHeight,...
%             'Laboratoire d''Analyse du Mouvement et de la Posture',...
%             'Color','w','FontSize',12);
% 
%         % Title
%         % ---------------------------------------------------------------------
%         y = y - yincr*5;
%         text(0.02,y/pageHeight,...
%             '  EMG',...
%             'Color','k','FontWeight','Bold','FontSize',18,...
%             'HorizontalAlignment','Center');
%         y = y - yincr*2;
%         text(0.02,y/pageHeight,...
%             '  C�t� gauche',...
%             'Color','k','FontSize',16,...
%             'HorizontalAlignment','Center');
%         yinit = y;
% 
%         % Patient
%         % ---------------------------------------------------------------------
%         y = y - yincr*3;
%         axesLegend = axes;
%         set(axesLegend,'Position',[0 0 1 1]);
%         set(axesLegend,'Visible','Off');
%         text(0.05,y/pageHeight,'Patient : ','FontWeight','Bold','Color','black');
%         text(0.25,y/pageHeight,[Patient(1).lastname,' ',Patient(1).firstname],'Color','black');
%         y = y - yincr;
%         text(0.05,y/pageHeight,'Date de naissance : ','FontWeight','Bold','Color','black');
%         text(0.25,y/pageHeight,[Patient(1).birthdate],'Color','black');
% 
%         % Legend
%         % ---------------------------------------------------------------------
%         y = y - yincr;
%         axesLegend = axes;
%         set(axesLegend,'Position',[0 0 1 1]);
%         set(axesLegend,'Visible','Off');
%         % Count the number of trials
%         nbtrials = 0;
%         for j = 1:length(Condition(icondition).Gait);
%             if ~isempty(Condition(icondition).Gait(j).Lemg)
%                 nbtrials = nbtrials+1;
%             end
%         end
%         % Write the legend
%         text(0.05,y/pageHeight,[char(files(itrial,:))]);
%         text(0.25,y/pageHeight,'Norm','Color',[0.5 0.5 0.5]);
%         text(0.33,y/pageHeight,[char(Session(icondition).date),...
%             '     Nb essais : ',num2str(nbtrials),...
%             '     Condition : ',char(regexprep(Condition(icondition).name,'_','-')),' (cf page 1)'],'color','k');
%         y = y - yincr*1.0;
% 
%         % EMG 9 / raw
%         % ---------------------------------------------------------------------
%         if length(Lemg_name) >= 9
%             % Real size of the data vector
%             isize = size(find(~isnan(Lemg_raw(:,9))),1);
%             % Plot EMG
%             y = y - yincr*8.5;
%             axesGraph = axes;
%             set(axesGraph,'Position',[0 0 1 1]);
%             set(axesGraph,'Visible','Off');
%             Graph(igraph) = axes('position',[x(1)/pageWidth y/pageHeight ...
%                 graphWidth/pageWidth graphHeight/pageHeight]);
%             set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[],'YTick',-50e-4:1e-4:50e-4);
%             hold on;
%             title(regexprep(regexprep(Lemg_name{9},'left_',''),'_',' '),'FontWeight','Bold');
%             ylabel('Amplitude (uV)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
%             plot(1:isize,zeros(isize,1),'Linestyle','-','Linewidth',0.5,'Color','black');
%             plot(Lemg_raw(1:isize,9),'Linestyle','-','Linewidth',0.5,'Color',colorL(1,:));
%             axis tight;
%             igraph = igraph+1;
%         end
% 
%         % EMG 9 / filt
%         % ---------------------------------------------------------------------
%         if length(Lemg_name) >= 9
%             axesGraph = axes;
%             set(axesGraph,'Position',[0 0 1 1]);
%             set(axesGraph,'Visible','Off');
%             Graph(igraph) = axes('position',[x(2)/pageWidth y/pageHeight ...
%                 graphWidth/2/pageWidth graphHeight/pageHeight]);
%             xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
%             ylabel('Amplitude (%max)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
%             hold on;
%             % Find norm
%             inorm = [];
%             names = fieldnames(Norm.EMG);
%             for i = 1:length(names)
%                 if strfind(regexprep(names{i},'right_',''),regexprep(Lemg_name{9},'left_',''))
%                     inorm = eval(['Norm.EMG.',names{i},';']);
%                 end
%             end
%             % Plot
%             if ~isempty(inorm)
%                 plot(inorm.mean(1:101,1)/max(inorm.mean(1:101,1)),'Linestyle','-','Linewidth',2,'Color',[0.5 0.5 0.5]);
%             end
%             plot(Lemg_filt(1:101,9)/max(Lemg_filt(1:101,9)),'Linestyle','-','Linewidth',2,'Color',colorL(1,:));
%             set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0:50:100],'YTick',0:0.25:1,'YTickLabel',{'0' '25' '50' '75' '100'});
%             axis tight;
%             axis([0 100 0 1]);
%             plot([Condition(icondition).Gait(itrial).Lphases.p5 ...
%                 Condition(icondition).Gait(itrial).Lphases.p5],...
%                 [0 1],'Linestyle','--','Linewidth',1,'Color','black');
%             box on;
%             igraph = igraph+1;
%         end
%         
%         % EMG 10 / raw
%         % ---------------------------------------------------------------------
%         if length(Lemg_name) >= 10
%             % Real size of the data vector
%             isize = size(find(~isnan(Lemg_raw(:,10))),1);
%             % Plot EMG
%             y = y - yincr*8.5;
%             axesGraph = axes;
%             set(axesGraph,'Position',[0 0 1 1]);
%             set(axesGraph,'Visible','Off');
%             Graph(igraph) = axes('position',[x(3)/pageWidth y/pageHeight ...
%                 graphWidth/pageWidth graphHeight/pageHeight]);
%             set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[],'YTick',-50e-4:1e-4:50e-4);
%             hold on;
%             title(regexprep(regexprep(Lemg_name{10},'left_',''),'_',' '),'FontWeight','Bold');
%             ylabel('Amplitude (uV)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
%             plot(1:isize,zeros(isize,1),'Linestyle','-','Linewidth',0.5,'Color','black');
%             plot(Lemg_raw(1:isize,10),'Linestyle','-','Linewidth',0.5,'Color',colorL(1,:));
%             axis tight;
%             igraph = igraph+1;
%         end
% 
%         % EMG 10 / filt
%         % ---------------------------------------------------------------------
%         if length(Lemg_name) >= 10
%             axesGraph = axes;
%             set(axesGraph,'Position',[0 0 1 1]);
%             set(axesGraph,'Visible','Off');
%             Graph(igraph) = axes('position',[x(2)/pageWidth y/pageHeight ...
%                 graphWidth/2/pageWidth graphHeight/pageHeight]);
%             xlabel('Gait cycle (%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
%             ylabel('Amplitude (%max)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
%             hold on;
%             % Find norm
%             inorm = [];
%             names = fieldnames(Norm.EMG);
%             for i = 1:length(names)
%                 if strfind(regexprep(names{i},'right_',''),regexprep(Lemg_name{10},'left_',''))
%                     inorm = eval(['Norm.EMG.',names{i},';']);
%                 end
%             end
%             % Plot
%             if ~isempty(inorm)
%                 plot(inorm.mean(1:101,1)/max(inorm.mean(1:101,1)),'Linestyle','-','Linewidth',2,'Color',[0.5 0.5 0.5]);
%             end
%             plot(Lemg_filt(1:101,10)/max(Lemg_filt(1:101,10)),'Linestyle','-','Linewidth',2,'Color',colorL(1,:));
%             set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[0:50:100],'YTick',0:0.25:1,'YTickLabel',{'0' '25' '50' '75' '100'});
%             axis tight;
%             axis([0 100 0 1]);
%             plot([Condition(icondition).Gait(itrial).Lphases.p5 ...
%                 Condition(icondition).Gait(itrial).Lphases.p5],...
%                 [0 1],'Linestyle','--','Linewidth',1,'Color','black');
%             box on;
%             igraph = igraph+1;
%         end
%         
%         % EMG 11 / raw
%         % ---------------------------------------------------------------------
%         if length(Lemg_name) >= 11
%             % Real size of the data vector
%             isize = size(find(~isnan(Lemg_raw(:,10))),1);
%             % Plot EMG
%             y = y - yincr*8.5;
%             y1 = y;
%             graph_EMG(x,y,y1,igraph,Lemg_name{11},Lemg_raw(:,11),colorL);
%             igraph = igraph+1;
%         end
%         
%         % EMG 12 / raw
%         % ---------------------------------------------------------------------
%         if length(Lemg_name) >= 12
%             % Real size of the data vector
%             isize = size(find(~isnan(Lemg_raw(:,10))),1);
%             % Plot EMG
%             y = y - yincr*8.5;
%             y1 = y;
%             graph_EMG(x,y,y1,igraph,Lemg_name{12},Lemg_raw(:,12),colorL);
%             igraph = igraph+1;
%         end
%         
%         % EMG 13 / raw
%         % ---------------------------------------------------------------------
%         if length(Lemg_name) >= 13
%             % Real size of the data vector
%             isize = size(find(~isnan(Lemg_raw(:,10))),1);
%             % Plot EMG
%             y = y - yincr*8.5;
%             y1 = y;
%             graph_EMG(x,y,y1,igraph,Lemg_name{13},Lemg_raw(:,13),colorL);
%             igraph = igraph+1;
%         end
%         
%         % EMG 14 / raw
%         % ---------------------------------------------------------------------
%         if length(Lemg_name) >= 14
%             % Real size of the data vector
%             isize = size(find(~isnan(Lemg_raw(:,10))),1);
%             % Plot EMG
%             y = y - yincr*8.5;
%             y1 = y;
%             graph_EMG(x,y,y1,igraph,Lemg_name{14},Lemg_raw(:,14),colorL);
%             igraph = igraph+1;
%         end
%         
%         % EMG 15 / raw
%         % ---------------------------------------------------------------------
%         if length(Lemg_name) >= 15
%             % Real size of the data vector
%             isize = size(find(~isnan(Lemg_raw(:,10))),1);
%             % Plot EMG
%             y = y - yincr*8.5;
%             y1 = y;
%             graph_EMG(x,y,y1,igraph,Lemg_name{15},Lemg_raw(:,15),colorL);
%             igraph = igraph+1;
%         end
%         
%         % EMG 16 / raw
%         % ---------------------------------------------------------------------
%         if length(Lemg_name) >= 16
%             % Real size of the data vector
%             isize = size(find(~isnan(Lemg_raw(:,10))),1);
%             % Plot EMG
%             y = y - yincr*8.5;
%             y1 = y;
%             graph_EMG(x,y,y1,igraph,Lemg_name{16},Lemg_raw(:,16),colorL);
%             igraph = igraph+1;
%         end
        
        for g=1:2:(igraph-1)
            
            axes(Graph(g));
            YL = [-2e-4,2e-4];
            XL = xlim;
            XL(1) = max(XL(1),X_down);
            XL(2) = min(XL(2),X_up);
            axis([XL(1) XL(2) YL(1) YL(2)]);
            plot([Condition(icondition).Gait(itrial).Revents.e.LHS(1)*Session(icondition).fanalog ...
                Condition(icondition).Gait(itrial).Revents.e.LHS(1)*Session(icondition).fanalog],...
                [YL(1) YL(2)],'Linestyle','-','Linewidth',1,'Color','black');
            plot([Condition(icondition).Gait(itrial).Revents.e.LTO(end)*Session(icondition).fanalog ...
                Condition(icondition).Gait(itrial).Revents.e.LTO(end)*Session(icondition).fanalog],...
                [YL(1) YL(2)],'Linestyle','--','Linewidth',1,'Color','black');
            plot([Condition(icondition).Gait(itrial).Revents.e.LHS(2)*Session(icondition).fanalog ...
                Condition(icondition).Gait(itrial).Revents.e.LHS(2)*Session(icondition).fanalog],...
                [YL(1) YL(2)],'Linestyle','-','Linewidth',1,'Color','black');
            box on;
        end
        
    end

end