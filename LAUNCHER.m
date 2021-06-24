% Keep these lines


clearvars 
toolboxFolder = 'C:\Users\celine.schreiber\Documents\MATLAB\Toolbox_Septembre2016';
cd(toolboxFolder);
addpath(pwd);
addpath([pwd,'\plugin\clinicalReport']);
addpath([pwd,'\plugin\statistics']);
addpath([pwd,'\plugin\Foot']);
addpath([pwd,'\plugin\Posturo']);
addpath([pwd,'\toolbox\btk']);
addpath([pwd,'\toolbox\Toolbox_M_Inverse_Dynamics']);


% Launch main toolbox

tic
c3dFolder = 'V:\1 - Donnees protocoles\Protocole AQM\Data\Lahire_Marc_19690120\2020-06-25';
database = 0; % 0: don't store in database | 1: store in database
matFolder = c3dFolder(1:(end-11));
MainRehazenterToolbox(c3dFolder,database);

% c3dFolder = 'V:\1 - Donnees protocoles\Protocole AQM\Data\Lahire_Marc_19690120\2020-07-30';
% database = 0; % 0: don't store in database | 1: store in database
% matFolder = c3dFolder(1:(end-11));
% MainRehazenterToolbox(c3dFolder,database);

% c3dFolder = 'V:\1 - Donnees protocoles\Protocole AQM\Data\Michaux_Kevin_19941206\2020-10-29';
% database = 0; % 0: don't store in database | 1: store in database
% matFolder = c3dFolder(1:(end-11));
% MainRehazenterToolbox(c3dFolder,database);

% Compute statistics (to be launch for each condition)
filenameNormatives='Normes spontanee.mat';
toc %32.9s pour Maraga, 30.1 pour Lambert Motox1
MainStatistics();

% Launch clinical report plugin
database = 0; % 0: don't store in database | 1: store in database
reportFolder='X:\Reports';
MainPluginClinicalReport();

% Protocole SEF
% writeReportSEF;
% writeReportMOTOX