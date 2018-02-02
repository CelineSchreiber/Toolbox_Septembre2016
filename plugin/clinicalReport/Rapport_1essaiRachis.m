function f=Rapport_1essaiRachis(Condition,Session,Patient)

%% Quelques parametres de mise en page...
Largeur = 21;
Hauteur = 29.7;
yinit = 29.0;
yincr = 0.5;
x=[1.5 8 14.5];

condNames=cell(1,length(Session));
for i=1:length(Session)
    condNames{i}=[char(Patient(i).lastname),' - ',char(Session(i).date),' - ',char(Condition(i).name)];
end
[cond,ok]=listdlg('ListString',condNames,'ListSize',[300 300]);
files=[];
for i=1:length(Session(cond).Gait)
    if strcmp(Session(cond).Gait(i).condition,Condition(cond).name)
        files=[files;Session(cond).Gait(i).filename];
    end
end
[trial,ok]=listdlg('ListString',files);  
    
Kin=Condition(cond).Gait(trial).Rposturalangle;
Event=Condition(cond).Gait(trial).Rphases;

%////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
%% GENERATION DE LA PAGE 1 : Posturo 
%////////////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    
f = figure('PaperOrientation','portrait','papertype','A4','Units',...
'centimeters','Position',[0 0 Largeur Hauteur],'Color','white',...
'PaperUnits','centimeters','PaperPosition',[0 0 Largeur Hauteur],'Name','1 essai angles_posturo');

%% ------------Affichage Logo REHAZENTER-----------------------------------
%--------------------------------------------------------------------------
logo=imread('logo','png');
AxesImages = axes('position',[14.5/Largeur 27.7/Hauteur 6/Largeur 2/Hauteur]);
image(logo);
set(AxesImages,'Visible','Off');

%% ------------Affichage Entête
%--------------------------------------------------------------------------
AxesTextes = axes;
hold on;
set(AxesTextes,'Position',[0 0 1 1]);
axis manual;
set(AxesTextes,'Visible','Off');

y = yinit;
text(0.5/Largeur,y/Hauteur,'Rehazenter','color','k');
y = y - yincr;
text(0.5/Largeur,y/Hauteur,'Centre de Rééducation et de Réadaptation Fonctionnelle','color','k');
y = y - yincr;
text(0.5/Largeur,y/Hauteur,'Laboratoire d''Analyse du Mouvement','color','k');
y = y - yincr;
% text(0.5/Largeur,y/Hauteur,'Dr. Paul Filipetti','color','k');


%% ------------TITRE
%--------------------------------------------------------------------------
y = y - yincr;
text(10.5/Largeur,y/Hauteur,'CINEMATIQUE DU RACHIS','color','k','FontWeight','Bold','HorizontalAlignment','Center')
y = y - yincr;

%% ------------Affichage Informations Patient
%--------------------------------------------------------------------------
y = y - yincr;  % reprise de l'ancien y pour etre a la suite de Clinicien
texte = ['Patient: ' char(Patient(cond).firstname) ' ' char(Patient(cond).lastname)];
text(0.5/Largeur,y/Hauteur,texte);
y = y - yincr;
text(0.5/Largeur,y/Hauteur,['Date de naissance: ' char(Patient(cond).dob)]);
y = y - yincr;
% text(0.5/Largeur,y/Hauteur,['Pathologie: ' char(Session(1).diagnosis)]);
% y = y - yincr;

%% ------------Affichage Legende
%--------------------------------------------------------------------------
    y = y - yincr;  
    text(0.5/Largeur,y/Hauteur,['Date d''examen: ',char(Session(cond).date),...
        '    nbre essais: ',num2str(length(Condition(cond).Gait)),'    Condition: ',char(Condition(cond).name)],'color','k');
    text(17.5/Largeur,y/Hauteur,['Essai: ',char(files(trial,:))],...
    'color','k');
%-------------------------------
%   GRAPHIQUES
%-------------------------------
g=0;
                %--------------------%
               %%    Head Tilt       %%
                %--------------------%
y = y - 6;
if ~isempty(Kin.Hgr_tilt)
    g=g+1;
    Graph(g) = axes('position',[x(2)/Largeur y/Hauteur 5.5/Largeur 4/Hauteur]);
    set(Graph(g),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
    hold on;
    title('Head tilt (ant+)','FontWeight','Bold');%'BackGroundColor',[245/256 243/256 89/256],
    ylabel('Degree','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');

    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    plot(Kin.Hgr_tilt,'Linestyle','-','Linewidth',2,'Color','b');

    axis tight; YL=ylim;
    YL=setaxislim(YL,-10,10);
    axis([0 100 YL(1) YL(2)]);
end
                %--------------------------%
               %%    Head Obliquity        %%
                %--------------------------%
if ~isempty(Kin.Hgr_obli)
    g=g+1;
    Graph(g) = axes('position',[x(1)/Largeur y/Hauteur 5.5/Largeur 4/Hauteur]);
    set(Graph(g),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
    hold on;
    title('Head obliquity','FontWeight','Bold');%'BackGroundColor',[245/256 243/256 89/256],
    ylabel('Degree','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');

    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    plot(Kin.Hgr_obli,'Linestyle','-','Linewidth',2,'Color','b');

    axis tight; YL=ylim;
    YL=setaxislim(YL,-10,10);
    axis([0 100 YL(1) YL(2)]);
end
                %--------------------------%
               %%    Head Rotation         %%
                %--------------------------%
if ~isempty(Kin.Hgr_rota)
    g=g+1;
    Graph(g) = axes('position',[x(3)/Largeur y/Hauteur 5.5/Largeur 4/Hauteur]);
    set(Graph(g),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
    hold on;
    title('Head rotation (right+)','FontWeight','Bold');%'BackGroundColor',[245/256 243/256 89/256],
    ylabel('Degree','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');

    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    plot(Kin.Hgr_rota,'Linestyle','-','Linewidth',2,'Color','b');

    axis tight; YL=ylim;
    YL=setaxislim(YL,-10,10);
    axis([0 100 YL(1) YL(2)]);
end
% *************************************************************************
                %-------------------------------%
               %%     Shoulders Flex/Ext        %%
                %-------------------------------%
y = y - 5;
if ~isempty(Kin.Sgr_tilt)
    g=g+1;
    Graph(g) = axes('position',[x(2)/Largeur y/Hauteur 5.5/Largeur 4/Hauteur]);
    set(Graph(g),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
    hold on;
    title('Shoulders flex/ext','FontWeight','Bold');%'BackGroundColor',[89/256 157/256 233/256],
    ylabel('Degree','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');

    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    plot(Kin.Sgr_tilt,'Linestyle','-','Linewidth',2,'Color','b');

    axis tight; YL=ylim;
    YL=setaxislim(YL,-10,10);
    axis([0 100 YL(1) YL(2)]);
end
                %--------------------------------%
               %%     Shoulders Obliquity        %%
                %--------------------------------%
if ~isempty(Kin.Sgr_obli)
    g=g+1;
    Graph(g) = axes('position',[x(1)/Largeur y/Hauteur 5.5/Largeur 4/Hauteur]);
    set(Graph(g),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
    hold on;
    title('Shoulders obliquity','FontWeight','Bold');%'BackGroundColor',[89/256 157/256 233/256],
    ylabel('Degree','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');

    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    plot(Kin.Sgr_obli,'Linestyle','-','Linewidth',2,'Color','b');

    axis tight; YL=ylim;
    YL=setaxislim(YL,-10,10);
    axis([0 100 YL(1) YL(2)]);
end
                %-------------------------------%
               %%     Shoulders Rotation        %%
                %-------------------------------%
if ~isempty(Kin.Sgr_rota)
    g=g+1;
    Graph(g) = axes('position',[x(3)/Largeur y/Hauteur 5.5/Largeur 4/Hauteur]);
    set(Graph(g),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
    hold on;
    title('Shoulders rotation','FontWeight','Bold');%'BackGroundColor',[89/256 157/256 233/256],
    ylabel('Degree','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');

    plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
    plot(Kin.Sgr_rota,'Linestyle','-','Linewidth',2,'Color','b');

    axis tight; YL=ylim;
    YL=setaxislim(YL,-10,10);
    axis([0 100 YL(1) YL(2)]);
end

% *************************************************************************
                %----------------------------%
               %%     Rachis Flex/Ext        %%
                %----------------------------%
y = y - 5;
g=g+1;
Graph(g) = axes('position',[x(2)/Largeur y/Hauteur 5.5/Largeur 4/Hauteur]);
set(Graph(g),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
hold on;
title('Rachis flex/ext','FontWeight','Bold');%'BackGroundColor',[242/256 156/256 34/256],
ylabel('Degree','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');

plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
if ~isempty(Kin.Rgr_tilt)
    plot(Kin.Rgr_tilt,'Linestyle','-','Linewidth',2,'Color','b');
end
axis tight; YL=ylim;
YL=setaxislim(YL,-10,10);
axis([0 100 YL(1) YL(2)]);

                %--------------------------------%
               %%     Rachis Obliquity        %%
                %--------------------------------%
g=g+1;
Graph(g) = axes('position',[x(1)/Largeur y/Hauteur 5.5/Largeur 4/Hauteur]);
set(Graph(g),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
hold on;
title('Rachis obliquity','FontWeight','Bold');%'BackGroundColor',[89/256 157/256 233/256],
ylabel('Degree','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');

plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
if ~isempty(Kin.Rgr_obli)
    plot(Kin.Rgr_obli,'Linestyle','-','Linewidth',2,'Color','b');
end
axis tight; YL=ylim;
YL=setaxislim(YL,-10,10);
axis([0 100 YL(1) YL(2)]);

                %-------------------------------%
               %%     Rachis Rotation        %%
                %-------------------------------%
g=g+1;
Graph(g) = axes('position',[x(3)/Largeur y/Hauteur 5.5/Largeur 4/Hauteur]);
set(Graph(g),'FontSize',8,'YGrid','on','XTick',[0 25 50 75 100],'YTick',-100:10:100);
hold on;
title('Rachis rotation','FontWeight','Bold');%'BackGroundColor',[89/256 157/256 233/256],
ylabel('Degree','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');

plot(1:100,zeros(100,1),'Linestyle','-','Linewidth',0.5,'Color','black');
if ~isempty(Kin.Rgr_rota)
    plot(Kin.Rgr_rota,'Linestyle','-','Linewidth',2,'Color','b');
end
axis tight; YL=ylim;
YL=setaxislim(YL,-10,10);
axis([0 100 YL(1) YL(2)]);



%**************************************************************************
%% Events
for g=1:length(Graph)
    axes(Graph(g));YL=ylim;
    plot([Event.p5 Event.p5],[-180 180],'Linestyle','-','Linewidth',2,'Color','b'); %IHS
    plot([Event.p2 Event.p2],[YL(1)-20 YL(1)+(YL(2)-YL(1))/10],'Linewidth',1.5,'Color','b'); %CTO
    plot([Event.p4 Event.p4],[YL(1)-20 YL(1)+(YL(2)-YL(1))/10],'Linewidth',1.5,'Color','b'); %CHS
end
   
%**************************************************************************


function YL=setaxislim(YL,a,b)
    
if YL(1)<0
    YL(1)=-ceil(abs(YL(1))/10)*10;
else
    YL(1)=round(YL(1)/10)*10;
end
if YL(2)<0
    YL(2)=-ceil(abs(YL(2))/10)*10;
else
    YL(2)=ceil(YL(2)/10)*10;
end
if YL(1)>=a && YL(2)<=b
    YL(1)=a;YL(2)=b;
elseif YL(2)>b && YL(1)>=-a
    if YL(1)>YL(2)-(b-a)
        YL(1)=YL(2)-(b-a);
    end
elseif YL(1)<a && YL(2)<=b
    if YL(2)<YL(1)+(b-a)
        YL(2)=YL(1)+(b-a);
    end
end
