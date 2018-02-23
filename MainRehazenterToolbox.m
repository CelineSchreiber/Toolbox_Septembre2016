% =========================================================================
% REHAZENTER TOOLBOX
% =========================================================================
% This toolbox uses the Biomechanical ToolKit for .c3d importation
% (https://code.google.com/p/b-tk/) 
% and the kinematics/dynamics toolbox developed by Raphaël Dumas 
% (www.inrets.fr/linstitut/unites-de-recherche-unites-de-service/lbmc.html)
% =========================================================================
% File name:    MainRehazenterToolbox
% -------------------------------------------------------------------------
% Subject:      Import .c3d files (using the Biomechanical Toolkit - BTK) 
%               and compute biomechanical parameters of a clinical gait 
%               analysis session
% -------------------------------------------------------------------------
% Inputs:       - filesFolder (char)
%               - database (int)
% Outputs:      - Patient (structure)
%               - Pathology (structure)
%               - Treatment (structure)
%               - Session (structure)
%               - Condition (structure)
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber, A. Naaim
% Date of creation: 26/11/2014
% Version: 3
% -------------------------------------------------------------------------
% Updates: - 28/04/2015 - Condition "database" to create .pdf file and
%            complete database ... or not 
%          - 26/05/2016 - Toolbox not dependent of the choice of normative 
%            data, creation of a statistical plugin (RMSE, indexes,...)
% =========================================================================

function MainRehazenterToolbox(filesFolder,database)

% =========================================================================
% Initialisation
% =========================================================================
warning('off','All'); clc;
disp('==================================================================');
disp('                       REHAZENTER TOOLBOX                         ');
disp('                   for clinical gait analysis                     ');
disp('==================================================================');
disp('           Author: F. Moissenet, C. Schreiber, A. Naaim           ');
disp('                  Date of creation: 26/11/2014                    ');
disp('                          Version: 3                              ');
disp('==================================================================');
disp(' ');
addpath('C:\Program Files\MATLAB\R2011b\toolbox\btk');
addpath(pwd);
addpath([pwd,'\toolbox']);
addpath([pwd,'\toolbox\Toolbox_M_Inverse_Dynamics']);
addpath([pwd,'\toolbox\queryMySQL']);
addpath([pwd,'\toolbox\queryMySQL\src']);
addpath([pwd,'\toolbox\xlsread1']);
matFolder = filesFolder(1:(end-12));
toolboxFolder = pwd;
cd(toolboxFolder);
if nargin == 0
    filesFolder = uigetdir; % Set the work folder
end

% =========================================================================
% Set patient, pathology and session information
% =========================================================================
disp('>> Import session information ...');
if ~exist('Session','var')
    [Patient,Pathology,Treatment,Examination,Session] = sessionInformation_saved(filesFolder);
end
disp(['  > Patient: ',Patient.lastname,' ',Patient.firstname,' ',Patient.birthdate]);
disp(['  > Session: ',Session.date]);
% Set temp as a cell in any cases
temp1 = cell(0);
temp2 = cell(0);
for i = 1:length(Session.Gait)
    count1 = 0;
    if ~isempty(temp1)
        for j = 1:length(temp1)
            if ~strcmp(temp1{j},Session.Gait(i).condition)
                count1 = count1+1;
            end
        end
        if count1 == length(temp1)
            temp1{length(temp1)+1} = Session.Gait(i).condition;
            temp2{length(temp2)+1} = Session.Gait(i).details;
        end
    else
        temp1{length(temp1)+1} = Session.Gait(i).condition;
        temp2{length(temp2)+1} = Session.Gait(i).details;
    end
end
Session.conditions = temp1;
Session.details = temp2;
disp('>> Information importation achieved!');
disp(' ');

% =========================================================================
% Set session files
% =========================================================================
% The .c3d files names must be formatted to respect the names given by the
% .xlsx file (staticXX, gaitXX)
% =========================================================================
disp('>> Load files ...');
cd(filesFolder);
% Load static file (.c3d) - 1 static per condition SAUF si protocole
% paramètres!
if isfield(Session,'Static')
    for i = 1:length(Session.Static)
        if ~isempty(Session.Static(i).filename)
            Session.Static(i).file = btkReadAcquisition(Session.Static(i).filename);
        end
    end
end
% Load gait files (.c3d) - for all conditions
temp = 0;
for i = 1:length(Session.Gait)      
    if ~isempty(Session.Gait(i).filename)
        Session.Gait(i).file = btkReadAcquisition(Session.Gait(i).filename);
        if temp == 0
            temp = i;
        end
    end
end

% % FUNCTIONAL
% Session.Functional(1).file = btkReadAcquisition('functional02.c3d');

cd(toolboxFolder);
% Get frequencies from Gait(1)
Session.fpoint = btkGetPointFrequency(Session.Gait(1).file);
Session.fanalog = btkGetAnalogFrequency(Session.Gait(1).file);
disp('>> Files importation achieved!');
disp(' ');

% =========================================================================
% mainTreatment: Data treatment of each gait cycle
% =========================================================================
disp(['>> ',num2str(length(Session.conditions)),...
    ' condition(s) detected ...']); 
disp(' ');        
if exist('Session','var')
    [Session] = computeEvents(Session);
    for i = 1:length(Session.conditions)    
        disp(['  > ',Session.conditions{i}]);        
        Condition = [];   
        Condition.name = Session.conditions{i};
        k=1;
        for j=1:length(Session.Gait)
            if strcmp(Session.Gait(j).condition,Condition.name)
                Condition.details{k}=Session.Gait(j).details;
                k=k+1;
            end
        end
        
        cd(toolboxFolder);

        if ~strcmp(Session.markersset,'Aucun')
            [Session,Condition] = computeBiomechanicalParameters(Patient,Session,Condition);
            if ~strcmp(Session.markersset,'Paramètres')
                [Session,Condition] = computeBiomechanicalPosturo(Session,Condition);
            end
            [Session,Condition] = treatmentEMG(Session,Condition);
        end
        if strcmp(Session.markersset,'Aucun')
            [Session,Condition]=treatmentEMG_torticolis(Session,Condition);
        end
        if ~strcmp(Session.upperlimbsmarkersset,'Aucun')
            [Session,Condition] = computeBiomechanicalParametersUpperLimbs(Session,Condition);
        end
%         if ~strcmp(Session.footmarkersset,'Aucun')
%             [Session,Condition] = computeBiomechanicalParametersFoot(Session,Condition);
%         end             
        cd(matFolder);
        save([regexprep(Session.date,'/','-'),'_',...
            regexprep(Patient.lastname,' ','_'),'_',...
            regexprep(Patient.firstname,' ','_'),'_',...
            regexprep(Patient.birthdate,'/','-'),'_',...
            regexprep(Condition.name,' ','_'),'.mat'],...
            'Patient','Pathology','Treatment','Session','Condition','Examination');
        cd(toolboxFolder);
        disp('  > Condition saved');
        disp(' ');        
    end    
end

% =========================================================================
% Store all information in the MySQL database
% =========================================================================
if database == 1
    cd(toolboxFolder);
    % Connect to the correct database
    javaaddpath([pwd,'\toolbox\queryMySQL\lib\mysql-connector-java-5.1.6\mysql-connector-java-5.1.6-bin.jar']);
    db = MySQLDatabase('bddlabo.rehazenter.local', 'bddaqm_v1', 'labomarche', 'qualisys');
    % Store information
    sqlStorePatient(Patient,db);
    sqlStorePathology(Patient,Pathology,db);
    sqlStoreSession(Patient,Session,db);
    sqlStoreTreatment(Patient,Session,Treatment,db);
%     sqlStoreExamination(Patient,Session,Examination,db);
    sqlStoreCondition(Patient,Session,db);
    % Close database
    db.close();
    disp('>> Database updated!');
end
disp(' ');
disp('>> Process achieved!');