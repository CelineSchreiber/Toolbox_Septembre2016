% =========================================================================
% REHAZENTER TOOLBOX - PLUGIN CLINICAL REPORT
% =========================================================================
% File name:    reportFirstPage
% -------------------------------------------------------------------------
% Subject:      Generate the report page with the patient information
% -------------------------------------------------------------------------
% Inputs:       - Patient (structure)
%               - Pathology (structure)
%               - Treatment (structure)
%               - Session (structure)
%               - Condition (structure)
%               - pluginFolder (char)
% Outputs:      - f (figure)
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber, A. Naaim
% Date of creation: 16/12/2014
% Version: 1
% -------------------------------------------------------------------------
% Updates: -
% =========================================================================

function f = reportFirstPage(Patient,Pathology,Treatment,Session,Condition,pluginFolder)

% =========================================================================
% Initialisation
% =========================================================================
pageWidth = 21; % cm
pageHeight = 29.7; % cm
graphWidth = 5.5; % cm
graphHeight = 2.5; % cm
yinit = 29.0; % cm
yincr = 0.5; % cm
x = [1.5 5 11.5 14.5]; % cm

% =========================================================================
% Generate the page
% =========================================================================
f(1) = figure('PaperOrientation','portrait','papertype','A4',...
    'Units','centimeters','Position',[0 0 pageWidth pageHeight],...
    'Color','white','PaperUnits','centimeters',...
    'PaperPosition',[0 0 pageWidth pageHeight],...
    'Name',['parameters',num2str(1)]);
hold on;
axis off;

% Rehazenter banner
% -------------------------------------------------------------------------
cd(pluginFolder);
banner = imread('banner','jpeg');
axesImage = axes('position',...
    [0 0.89 1 0.12]);
image(banner);
set(axesImage,'Visible','Off');

% Header
% -------------------------------------------------------------------------
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
% -------------------------------------------------------------------------
y = y - yincr*6;
text(0.02,y/pageHeight,...
    '  Rapport d''Analyse Quantifiée de la Marche',...
    'Color','k','FontWeight','Bold','FontSize',22,...
        'HorizontalAlignment','Center');
y = y - yincr*2;
temp=['  Résultats de l''AQM du ',Session(1).date];
text(0.02,y/pageHeight,temp,...
'Color','k','FontSize',16,...
    'HorizontalAlignment','Center');
yinit = y;

% Patient information
% -------------------------------------------------------------------------
axesText = axes;
set(axesText,'Position',[0 0 1 1]);
set(axesText,'Visible','Off');  
y = yinit;
y = y - yincr*3.5;
temp = 'Patient';
text(0.05,y/pageHeight,temp,...
    'Color','k','FontWeight','Bold','FontSize',14);
y = y - yincr;
temp = '______________________________________________';
text(0.05,y/pageHeight,temp,...
    'Color','k','FontWeight','Bold','FontSize',10);
y = y - yincr*2;
temp = 'Nom :    ';
text(0.05,y/pageHeight,temp,...
    'Color','k','FontWeight','Bold','FontSize',10);
temp = char(Patient(1).lastname);
text(0.25,y/pageHeight,temp,...
    'Color','k','FontSize',10);
y = y - yincr*1.5;
temp = 'Prénom :    ';
text(0.05,y/pageHeight,temp,...
    'Color','k','FontWeight','Bold','FontSize',10);
temp = char(Patient(1).firstname);
text(0.25,y/pageHeight,temp,...
    'Color','k','FontSize',10);
y = y - yincr*1.5;
temp = 'Genre :    ';
text(0.05,y/pageHeight,temp,...
    'Color','k','FontWeight','Bold','FontSize',10);
temp = char(Patient(1).gender);
text(0.25,y/pageHeight,temp,...
    'Color','k','FontSize',10);
y = y - yincr*1.5;
temp = 'Date de naissance :    ';
text(0.05,y/pageHeight,temp,...
    'Color','k','FontWeight','Bold','FontSize',10);
temp = char(Patient(1).birthdate);
text(0.25,y/pageHeight,temp,...
    'Color','k','FontSize',10);

% Exam information
% -------------------------------------------------------------------------
axesText = axes;
set(axesText,'Position',[0.48 0 1 1]);
set(axesText,'Visible','Off');  
y = yinit;
y = y - yincr*3.5;
temp = 'Examen';
text(0.05,y/pageHeight,temp,...
    'Color','k','FontWeight','Bold','FontSize',14);
y = y - yincr;
temp = '______________________________________________';
text(0.05,y/pageHeight,temp,...
    'Color','k','FontWeight','Bold','FontSize',10);
y = y - yincr*2;
temp = 'Médecin :';
text(0.05,y/pageHeight,temp,...
    'Color','k','FontWeight','Bold','FontSize',10);
temp = char(Session(1).clinician);
text(0.20,y/pageHeight,temp,...
    'Color','k','FontSize',10);
y = y - yincr*1.5;
temp = 'Date de l''AQM :';
text(0.05,y/pageHeight,temp,...
    'Color','k','FontWeight','Bold','FontSize',10);
temp = char(Session(1).date);
text(0.20,y/pageHeight,temp,...
    'Color','k','FontSize',10);
y = y - yincr*1.5;
temp = 'Motif de l''AQM :';
text(0.05,y/pageHeight,temp,...
    'Color','k','FontWeight','Bold','FontSize',10);
temp = char(Session(1).reason);
text(0.20,y/pageHeight,temp,...
    'Color','k','FontSize',10);
y = y - yincr*1.5;
temp = 'Commentaires :';
text(0.05,y/pageHeight,temp,...
    'Color','k','FontWeight','Bold','FontSize',10);
temp = char(Session(1).comments);
text(0.20,y/pageHeight,temp,...
    'Color','k','FontSize',10);
y = y - yincr*1.5;
yinit2 = y; 

% Pathology information
% -------------------------------------------------------------------------
axesText = axes;
set(axesText,'Position',[0 0 1 1]);
set(axesText,'Visible','Off');  
y = yinit2;
y = y - yincr*2;
temp = 'Pathologie';
text(0.05,y/pageHeight,temp,...
    'Color','k','FontWeight','Bold','FontSize',14);
y = y - yincr;
temp = '______________________________________________';
text(0.05,y/pageHeight,temp,...
    'Color','k','FontWeight','Bold','FontSize',10);
y = y - yincr*2;
temp = 'Nom :    ';
text(0.05,y/pageHeight,temp,...
    'Color','k','FontWeight','Bold','FontSize',10);
temp = char(Pathology(1).name);
text(0.25,y/pageHeight,temp,...
    'Color','k','FontSize',10);
y = y - yincr*1.5;
temp = 'Type :    ';
text(0.05,y/pageHeight,temp,...
    'Color','k','FontWeight','Bold','FontSize',10);
temp = char(Pathology(1).type);
text(0.25,y/pageHeight,temp,...
    'Color','k','FontSize',10);
y = y - yincr*1.5;
temp = 'Commentaires :    ';
text(0.05,y/pageHeight,temp,...
    'Color','k','FontWeight','Bold','FontSize',10);
temp = char(Pathology(1).comments);
text(0.25,y/pageHeight,temp,...
    'Color','k','FontSize',10);
y = y - yincr*1.5;
temp = 'Date de l''accident :    ';
text(0.05,y/pageHeight,temp,...
    'Color','k','FontWeight','Bold','FontSize',10);
temp = char(Pathology(1).accidentdate);
text(0.25,y/pageHeight,temp,...
    'Color','k','FontSize',10);
y = y - yincr*1.5;
temp = 'Type d''accident :    ';
text(0.05,y/pageHeight,temp,...
    'Color','k','FontWeight','Bold','FontSize',10);
temp = char(Pathology(1).accidenttype);
text(0.25,y/pageHeight,temp,...
    'Color','k','FontSize',10);
y = y - yincr*1.5;
temp = 'Côté(s) affecté(s) :    ';
text(0.05,y/pageHeight,temp,...
    'Color','k','FontWeight','Bold','FontSize',10);
temp = char(Pathology(1).affectedside);
text(0.25,y/pageHeight,temp,...
    'Color','k','FontSize',10);
y = y - yincr*1.5;
temp = 'Membre(s) affecté(s) :    ';
text(0.05,y/pageHeight,temp,...
    'Color','k','FontWeight','Bold','FontSize',10);
temp = char(Pathology(1).affectedlimb);
text(0.25,y/pageHeight,temp,...
    'Color','k','FontSize',10);
yinit = y;

% Condition information
% -------------------------------------------------------------------------
axesText = axes;
set(axesText,'Position',[0.48 0 1 1]);
set(axesText,'Visible','Off');  
y = yinit2;
y = y - yincr*2;
temp = 'Conditions ';
text(0.05,y/pageHeight,temp,...
    'Color','k','FontWeight','Bold','FontSize',14);
y = y - yincr;
temp = '______________________________________________';
text(0.05,y/pageHeight,temp,...
    'Color','k','FontWeight','Bold','FontSize',10);
y = y - yincr*2;
for i = 1:size(Condition,2)
    temp = ['Condition ',num2str(i),' (',Session(i).date,') :'];
    text(0.05,y/pageHeight,temp,...
        'Color','k','FontWeight','Bold','FontSize',10);
    y = y - yincr*1.5;
    if strfind(Condition(i).name,'-A')
        temp = [regexprep(Condition(i).name,'_','-'),' : ',char(Condition(i).details(1))];   
    else     
        temp = [regexprep(Condition(i).name,'_','-'),' : ',translateNomenclature(char(Condition(i).name))];
    end
    text(0.05,y/pageHeight,temp,...
        'Color','k','FontSize',10);
    y = y - yincr*1.5;
end

% Treatment information
% -------------------------------------------------------------------------
axesText = axes;
set(axesText,'Position',[0 0 1 1]);
set(axesText,'Visible','Off');  
y = yinit;
y = y - yincr*3.5;
temp = 'Traitement';
text(0.05,y/pageHeight,temp,...
    'Color','k','FontWeight','Bold','FontSize',14);
y = y - yincr;
temp = '______________________________________________';
text(0.05,y/pageHeight,temp,...
    'Color','k','FontWeight','Bold','FontSize',10);
y = y - yincr*2;
temp = 'Dernière injection de toxine botulinique';
text(0.05,y/pageHeight,temp,...
    'Color','k','FontWeight','Bold','FontSize',10);
y = y - yincr*1.5;
temp = '- Date :    ';
text(0.05,y/pageHeight,temp,...
    'Color','k','FontWeight','Bold','FontSize',10);
temp = char(Treatment(1).injectiondate);
text(0.25,y/pageHeight,temp,...
    'Color','k','FontSize',10);
y = y - yincr*1;
temp = '- Muscle(s) :    ';
text(0.05,y/pageHeight,temp,...
    'Color','k','FontWeight','Bold','FontSize',10);
temp = char(Treatment(1).injectedmuscle1);
text(0.25,y/pageHeight,temp,...
    'Color','k','FontSize',10);
y = y - yincr*1;
temp = char(Treatment(1).injectedmuscle2);
text(0.25,y/pageHeight,temp,...
    'Color','k','FontSize',10);
y = y - yincr*1;
temp = char(Treatment(1).injectedmuscle3);
text(0.25,y/pageHeight,temp,...
    'Color','k','FontSize',10);
y = y - yincr*1;
temp = char(Treatment(1).injectedmuscle4);
text(0.25,y/pageHeight,temp,...
    'Color','k','FontSize',10);
y = y - yincr*1;
temp = char(Treatment(1).injectedmuscle5);
text(0.25,y/pageHeight,temp,...
    'Color','k','FontSize',10);
y = y - yincr*1;
temp = 'Dernière opération chirurgicale';
text(0.05,y/pageHeight,temp,...
    'Color','k','FontWeight','Bold','FontSize',10);
y = y - yincr*1.5;
temp = '- Date :    ';
text(0.05,y/pageHeight,temp,...
    'Color','k','FontWeight','Bold','FontSize',10);
temp = char(Treatment(1).surgerydate);
text(0.25,y/pageHeight,temp,...
    'Color','k','FontSize',10);
y = y - yincr*1;
temp = '- Motif :    ';
text(0.05,y/pageHeight,temp,...
    'Color','k','FontWeight','Bold','FontSize',10);
temp = char(Treatment(1).surgerypurpose);
text(0.25,y/pageHeight,temp,...
    'Color','k','FontSize',10);
y = y - yincr*1.5;

% Logo
% -------------------------------------------------------------------------
y = yinit;
logo = imread('logo','png');
axesImage = axes('position',...
    [0.55 0.03 0.35 0.22]);
image(logo);
set(axesImage,'Visible','Off');