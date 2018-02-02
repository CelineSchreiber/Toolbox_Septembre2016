function []=corridor(X,MEAN,STD,color)
% Trace le corridor moyenne +/- ecart type
% mean, std = column vector
% x column vector[0:end,end:-1:0]
% Pour le trace des corridors, permet de faire un aller retour sur le
% graphe
n=size(MEAN,1);
if n>1
    for i=1:length(X)
        XX(i)=X(end+1-i);
    end
    x=[X,XX]';  
    y=[MEAN+STD;MEAN(end:-1:1)-STD(end:-1:1)]; % [Aller;Retour]
    % set(get(get(A,'Annotation'),'LegendInformation'),'IconDisplayStyle','off'); % Retire surface de la legende
else
    x=[MEAN-STD MEAN-STD MEAN+STD MEAN+STD]';
    y=[-180;180;180;-180];
end
A=fill(x,y,color,'LineStyle','none','FaceAlpha',0.4); % Trace le corridor +/- 1 SD