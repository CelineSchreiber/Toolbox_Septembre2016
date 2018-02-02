function graph_EMG(x,y,y1,igraph,Graph,emg_name,emg_raw,colorL)
    pageWidth = 21; % cm
    pageHeight = 29.7; % cm
    graphWidth = 4.5; % cm
    graphHeight = 3.2; % cm
    isize = size(find(~isnan(emg_raw)),1);

    axesGraph = axes;
    set(axesGraph,'Position',[0 0 1 1]);
    set(axesGraph,'Visible','Off');
    Graph(igraph) = axes('position',[x(1)/pageWidth y/pageHeight ...
        graphWidth/pageWidth graphHeight/pageHeight]);
    set(Graph(igraph),'FontSize',8,'YGrid','on','XTick',[],'YTick',-50e-4:1e-4:50e-4);
    hold on;
    title(regexprep(regexprep(emg_name,'left_',''),'_',' '),'FontWeight','Bold');
    ylabel('Amplitude (uV)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
    plot(1:isize,zeros(isize,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    plot(emg_raw(1:isize),'Linestyle','-','Linewidth',0.5,'Color',colorL(1,:));
    axis tight;
end