% =========================================================================
% REHAZENTER TOOLBOX - PLUGIN STATISTICAL ANALYSIS
% =========================================================================
% File name:    MainPluginStatistics
% -------------------------------------------------------------------------
% Subject:      Statistical analysis referenced to normatives
% -------------------------------------------------------------------------
% Inputs:       - 
% Outputs:      - Statistics (RMSE, R2, Indexes)
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber, A. Naaim
% Date of creation: 26/05/2016
% Version: 1
% -------------------------------------------------------------------------
% Updates: - 
% =========================================================================

% =========================================================================
% Initialisation
% =========================================================================
disp(' Calculs statistiques');
pluginFolder = [toolboxFolder,'\plugin\statistics'];
normFolder = [toolboxFolder,'\norm\'];
cd(normFolder);
load(filenameNormatives);
cd(matFolder);
filename = uigetfile({'*.mat','MAT-files (*.mat)'}, ...
    'Select a session files', ...
    'MultiSelect','on');
if ~iscell(filename)
    filename = mat2cell(filename,1);
end
for i = 1:size(filename,2)
    cd(matFolder);
    load(filename{i});
    if isfield(Condition,'Gait')
        for j=1:length(Condition.Gait)
            cd(toolboxFolder);
            if ~strcmp(Session.markersset,'Paramètres') && ~strcmp(Session.markersset,'Aucun')
                if ~isempty(Condition.Gait(j).Rkinematics.FE3)
                    Condition.Gait(j).Index = computeIndexes(Session,Condition.Gait(j),Normatives);
                else
                Condition.Gait(j).Index.NI.R=[];
                Condition.Gait(j).Index.NI.L=[];
                Condition.Gait(j).Index.NI.O=[];
                Condition.Gait(j).Index.GDI.R=[];
                Condition.Gait(j).Index.GDI.L=[];
                Condition.Gait(j).Index.GDI.O=[];
                Condition.Gait(j).Index.GPS.R=[];
                Condition.Gait(j).Index.GPS.L=[];
                Condition.Gait(j).Index.GPS.O=[];
                Condition.Gait(j).Index.GVS.O=[];
                end
            end
        end
    end
    
    Condition.All = [];
    Condition = computeBiomechanicalStatistics(Session,Condition);    % Save the data

    cd(matFolder);
    save([regexprep(Session.date,'/','-'),'_',...
       regexprep(Patient.lastname,' ','_'),'_',...
       regexprep(Patient.firstname,' ','_'),'_',...
       regexprep(Patient.birthdate,'/','-'),'_',...
       regexprep(Condition.name,' ','_'),'.mat'],...
       'Patient','Pathology','Treatment','Examination','Session','Condition');
end

disp('  > Statistics saved');
disp(' ');