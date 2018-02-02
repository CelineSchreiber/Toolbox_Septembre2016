% =========================================================================
% REHAZENTER TOOLBOX - PLUGIN STATISTICAL ANALYSIS
% =========================================================================
% File name:    MainPluginFoot
% -------------------------------------------------------------------------
% Subject:      Leardini's model
% -------------------------------------------------------------------------
% Inputs:       - 
% Outputs:      - Foot angles
% -------------------------------------------------------------------------
% Author: C. Schreiber
% Date of creation: 26/05/2016
% Version: 1
% -------------------------------------------------------------------------
% Updates: - 
% =========================================================================

% =========================================================================
% Initialisation
% =========================================================================
disp(' Foot');
pluginFolder = [toolboxFolder,'\plugin\Foot'];
cd(matFolder);
filename = uigetfile({'*.mat','MAT-files (*.mat)'}, ...
    'Select a session files', ...
    'MultiSelect','on');
if ~iscell(filename)
    filename = mat2cell(filename);
end
for i = 1:size(filename,2)
    cd(matFolder);
    load(filename{i});
    for j=1:length(Condition.Gait)
        cd(toolboxFolder);
        if ~strcmp(Session.footmarkersset,'Aucun')
            [Session,Condition] = computeBiomechanicalParametersFoot(Patient,Session,Condition);
        end
    end
    
    cd(matFolder);
    save([regexprep(Session.date,'/','-'),'_',...
       regexprep(Patient.lastname,' ','_'),'_',...
       regexprep(Patient.firstname,' ','_'),'_',...
       regexprep(Patient.birthdate,'/','-'),'_',...
       regexprep(Condition.name,' ','_'),'.mat'],...
       'Patient','Pathology','Treatment','Examination','Session','Condition');
end

disp('  > Foot angles saved');
disp(' ');