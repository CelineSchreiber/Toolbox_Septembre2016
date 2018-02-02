% =========================================================================
% REHAZENTER TOOLBOX - PLUGIN CLINICAL REPORT
% =========================================================================
% File name:    MainPluginClinicalReport
% -------------------------------------------------------------------------
% Subject:      User interface to generate clinical gait analysis reports
% -------------------------------------------------------------------------
% Inputs:       - .mat file for each condition
% Outputs:      - plots
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber, A. Naaim
% Date of creation: 16/12/2014
% Version: 1
% -------------------------------------------------------------------------
% Updates: - 
% =========================================================================

% =========================================================================
% Initialisation
% =========================================================================
clearvars -except database matFolder toolboxFolder;
clc;
warning('off','All');
cd(toolboxFolder);
addpath([pwd,'\toolbox\gs']);
pluginFolder = [pwd,'\plugin\clinicalReport'];
normFolder = [pwd,'\norm\'];
cd(toolboxFolder);
javaaddpath([pwd,'\toolbox\queryMySQL\lib\mysql-connector-java-5.1.6\mysql-connector-java-5.1.6-bin.jar']);

% =========================================================================
% Set sessions
% =========================================================================
% if isvar(filesFolder)
%     cd(filesFolder);cd ..;
% end
cd(matFolder);
% Load multi session files (.mat)
filename = uigetfile({'*.mat','MAT-files (*.mat)'}, ...
    'Select a session files', ...
    'MultiSelect','on');
if ~iscell(filename)
    filename = mat2cell(filename);
end
for i = 1:size(filename,2)
    temp(i) = load(filename{i});
end
cd(pluginFolder);

% =========================================================================
% Load GUI
% =========================================================================
Report = figure('units','normalized','position',[.1 .1 .4 .6]);

% Select sessions for comparison or one session for diagnosis
% !! ALWAYS SET AS AQM 1 the MOST RECENT AQM !!
% -------------------------------------------------------------------------
axesText = axes;
set(axesText,'Position',[0 0 1 1]);
set(axesText,'Visible','Off');  
text(0.05, 0.95, 'Select conditions','Color','k','FontWeight','Bold','FontSize',12);
for i = 1:size(filename,2)
    uicontrol('Style','Text','Units','normalized','Position',...
        [.050 .900-((i-1)*0.05) .75 .03],'String',char(filename(:,i)));
    a(i) = uicontrol('Style','checkbox','Units','normalized','Position',...
        [.83 .900-((i-1)*0.05) .04 .03],'Callback','');
    b(i) = uicontrol('Style','popup','Units','normalized','Position',...
        [.88 .900-((i-1)*0.05) .06 .03],'String','1|2|3|4|5','Value',i);
end
cd(pluginFolder);

% Select norm
% -------------------------------------------------------------------------
axesText = axes;
set(axesText,'Position',[0 0 1 1]);
set(axesText,'Visible','Off');  
text(0.05, 0.63, 'Select normative data','Color','k','FontWeight','Bold','FontSize',12);
N = {'Normes spontanee','Normes Perry1.mat','Normes Perry2.mat','Normes Perry3.mat','Normes rapide.mat','Normes enfants 0-6ans.mat','Normes parametres.mat'};%Normes spontanee.mat
norm = N(1);
n = uicontrol('Style','popup','Units','normalized','Position',...
        [.050 .57 .90 .04],'String',...
        'spontaneous|<0.4m/s|[0.4m/s; 0.8m/s]|[0.8m/s; 1.2m/s]|fast|enfants<6ans|parametres',...
        'Value',1,'Callback','norm = N(get(n,''Value''));');
f = [];

% Select the report pages that need to be generated
% -------------------------------------------------------------------------
axesText = axes;
set(axesText,'Position',[0 0 1 1]);
set(axesText,'Visible','Off');  
text(0.05, 0.51, 'Generate report pages','Color','k','FontWeight','Bold','FontSize',12);
c(1) = uicontrol('Style','pushbutton','Units','normalized','Position',...
    [.050 .440 .25 .04],'String','First page','call',...
    '[Patient,Pathology,Treatment,Session,Condition] = mergeConditions(temp,a,b); f = reportFirstPage(Patient,Pathology,Treatment,Session,Condition,pluginFolder);filename = ''firstPage''; generatePdf(f,pluginFolder,matFolder,filename);');
c(2) = uicontrol('Style','pushbutton','Units','normalized','Position',...
    [.050 .390 .25 .04],'String','Gait Parameters','call',...
    '[Patient,Pathology,Treatment,Session,Condition] = mergeConditions(temp,a,b); f = reportGaitParameters(Patient,Session,Condition,pluginFolder,normFolder,norm);filename = ''gaitParameters''; generatePdf(f,pluginFolder,matFolder,filename);');
c(3) = uicontrol('Style','pushbutton','Units','normalized','Position',...
    [.050 .340 .25 .04],'String','Kinematics','call',...
    '[Patient,Pathology,Treatment,Session,Condition] = mergeConditions(temp,a,b); f = reportKinematics(Patient,Session,Condition,pluginFolder,normFolder,norm);filename = ''kinematics''; generatePdf(f,pluginFolder,matFolder,filename);');
e(1) = uicontrol('Style','pushbutton','Units','normalized','Position',...
    [.350 .340 .25 .04],'String','> Check 1 trial','call',...
    '[Patient,Pathology,Treatment,Session,Condition] = mergeConditions(temp,a,b); f = reportKinematicsTrial(Patient,Session,Condition,pluginFolder,normFolder,norm);');
c(4) = uicontrol('Style','pushbutton','Units','normalized','Position',...
    [.050 .290 .25 .04],'String','Kinetics','call',...
    '[Patient,Pathology,Treatment,Session,Condition] = mergeConditions(temp,a,b); f = reportKinetics(Patient,Session,Condition,pluginFolder,normFolder,norm);filename = ''kinetics''; generatePdf(f,pluginFolder,matFolder,filename);');
e(2) = uicontrol('Style','pushbutton','Units','normalized','Position',...
    [.350 .290 .25 .04],'String','> Check 1 trial','call',...
    '[Patient,Pathology,Treatment,Session,Condition] = mergeConditions(temp,a,b); f = reportKineticsTrial(Patient,Session,Condition,pluginFolder,normFolder,norm);');
c(5) = uicontrol('Style','pushbutton','Units','normalized','Position',...
    [.050 .240 .25 .04],'String','EMG','call',...
    '[Patient,Pathology,Treatment,Session,Condition] = mergeConditions(temp,a,b); f = reportEMG(Patient,Session,Condition,pluginFolder,normFolder,norm);filename = ''EMG''; generatePdf(f,pluginFolder,matFolder,filename);');
c(6) = uicontrol('Style','pushbutton','Units','normalized','Position',...
    [.050 .190 .25 .04],'String','Posturo','call',...
    '[Patient,Pathology,Treatment,Session,Condition] = mergeConditions(temp,a,b); f = reportRachis(Patient,Session,Condition,pluginFolder,normFolder,norm);filename = ''rachis_kinematics''; generatePdf(f,pluginFolder,matFolder,filename);f = reportAI(Patient,Session,Condition,pluginFolder,normFolder,norm);filename = ''AI''; generatePdf(f,pluginFolder,matFolder,filename);f=reportNCCF(Patient,Session,Condition,pluginFolder,normFolder,norm);filename = ''NCCF''; generatePdf(f,pluginFolder,matFolder,filename);');
e(3) = uicontrol('Style','pushbutton','Units','normalized','Position',...
    [.350 .190 .25 .04],'String','Check 1 trial','call',...
    '[Patient,Pathology,Treatment,Session,Condition] = mergeConditions(temp,a,b); f = reportRachisTrial(Patient,Session,Condition,pluginFolder,normFolder,norm);');
c(7) = uicontrol('Style','pushbutton','Units','normalized','Position',...
    [.050 .140 .25 .04],'String','Index','call',...
    '[Patient,Pathology,Treatment,Session,Condition] = mergeConditions(temp,a,b); f = reportIndexes(Patient,Session,Condition,pluginFolder,normFolder,norm);filename = ''indexes''; generatePdf(f,pluginFolder,matFolder,filename);');
c(8) = uicontrol('Style','pushbutton','Units','normalized','Position',...
    [.050 .040 .25 .04],'String','Foot Kinematics (Baropodo)','call',...
    '[Patient,Pathology,Treatment,Session,Condition] = mergeConditions(temp,a,b); f = reportKinematicsFootOnly(Patient,Session,Condition,pluginFolder,normFolder,norm);filename = ''kinematics''; generatePdf(f,pluginFolder,matFolder,filename);');

% Generate report and CD
% -------------------------------------------------------------------------
cd(pluginFolder);
d(1) = uicontrol('Style','pushbutton','Units','normalized','Position',...
    [.650 .390 .3 .09],'String','Generate report','Visible','on','call',...
    '[Patient,Pathology,Treatment,Session,Condition] = mergeConditions(temp,a,b); mergePdf(Patient,Session,toolboxFolder,pluginFolder,matFolder,database)');
d(2) = uicontrol('Style','pushbutton','Units','normalized','Position',...
    [.650 .290 .3 .09],'String','Generate CD files','Visible','on','call',...
    '[Patient,Pathology,Treatment,Session,Condition] = mergeConditions(temp,a,b);');
d(3) = uicontrol('Style','pushbutton','Units','normalized','Position',...
    [.650 .190 .3 .09],'String','View PDF report','Visible','on','call',...
    '[Patient,Pathology,Treatment,Session,Condition] = mergeConditions(temp,a,b); cd(matFolder); temp0 = regexprep(Session(1).date,''/'',''-''); temp = dir([temp0,''_*.pdf'']); cd(pluginFolder); viewPdf(temp,pluginFolder,matFolder);');