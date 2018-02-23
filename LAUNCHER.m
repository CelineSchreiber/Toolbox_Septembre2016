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
c3dFolder = 'W:\Bdd_Baropodo2\Data\Debue_Pierre_1961081237914\2018-02-23_2';
database = 0; % 0: don't store in database | 1: store in database
matFolder = c3dFolder(1:(end-13));
MainRehazenterToolbox(c3dFolder,database);

% Compute statistics (to be launch for each condition)
filenameNormatives='Normes spontanee.mat';
MainStatistics();

% Launch clinical report plugin
database = 0; % 0: don't store in database | 1: store in database
reportFolder='X:\Reports';
MainPluginClinicalReport();