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

dataFolder    =  ['C:\Users\celine.schreiber\Box\Rehazenter\RF-VI\data SKG\'];
cd(dataFolder);
patients = importdata('Listing patients SKG.xlsx',',');

nfiles = size(patients.textdata.Sheet1,1)-1;
for i =99:102%nfiles
    i
     filename = [patients.textdata.Sheet1{i+1,7},'.mat'];
    matFolder   = ['V:\1 - Donnees protocoles\Protocole AQM\Data\',...
        patients.textdata.Sheet1{i+1,1},'_',patients.textdata.Sheet1{i+1,2},'_',num2str(patients.data.Sheet1(i,1))];
    c3dFolder   = ['V:\1 - Donnees protocoles\Protocole AQM\Data\',...
        patients.textdata.Sheet1{i+1,1},'_',patients.textdata.Sheet1{i+1,2},'_',num2str(patients.data.Sheet1(i,1)),...
        '\',patients.textdata.Sheet1{i+1,7}(1:10)];
    
    database = 0; % 0: don't store in database | 1: store in database
%     matFolder = c3dFolder(1:(end-11));
    MainRehazenterToolbox(c3dFolder,database);

    % Compute statistics (to be launch for each condition)
    filenameNormatives='Normes spontanee.mat';
    toc %32.9s pour Maraga, 30.1 pour Lambert Motox1
    MainStatistics();
end