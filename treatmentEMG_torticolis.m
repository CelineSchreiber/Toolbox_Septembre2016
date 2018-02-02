% =========================================================================
% REHAZENTER TOOLBOX
% =========================================================================
% File name:    computeBiomechanicalParameters
% -------------------------------------------------------------------------
% Subject:      Compute a set of biomechanical parameters
% -------------------------------------------------------------------------
% Inputs:       - Patient (structure)
%               - Session (structure)
%               - Condition (structure)
% Outputs:      - Session (structure)
%               - Condition (structure)
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber, A. Naaim
% Date of creation: 26/03/2014
% Version: 1
% -------------------------------------------------------------------------
% Updates: - 16/09/2014: Outputs have 101 rows (frames 0 to 100)
%          - 26/09/2014: Auto selection the static file corresponding to 
%            the current condition OR ' TOUTES CONDITIONS' !!!!
% =========================================================================

function [Session,Condition] = treatmentEMG(Session,Condition)

disp('Traitement des EMG');
% % % =========================================================================
% % % Static
% % % =========================================================================
% % disp('    - Static');
% % % Load static files for each kind of data (kinematics, EMG and posture)
% % staticE = [];
% % if isfield(Session,'Static')
% %     for i = 1:length(Session.Static)
% %         if strcmp(Session.Static(i).condition,Condition.name) || strcmp(Session.Static(i).condition,'toutes conditions')
% %             if  strcmp(Session.Static(i).emgtrial,'yes')
% %                 staticE = Session.Static(i).file;
% %             end
% %         end
% %     end
% %     % EMG static trial
% %     % -------------------------------------------------------------------------
% %     % To be done
% % 
% % end

% =========================================================================
% Gait cycles
% =========================================================================
j = 1;
for i = 1:length(Session.Gait)
    
    if strcmp(Session.Gait(i).condition,Condition.name) && strcmp(Session.Gait(i).emgtrial,'yes')

        disp(['    - EMG',num2str(i),' = ',char(Session.Gait(i).filename)]);        
        gait = Session.Gait(i).file;

       % Prepare gait cycle data
        % ----------------------------------------------------------------- 
        % Initialise variables
        n0 = btkGetFirstFrame(gait);
        [Emg,Info.emg] = btkGetAnalogs(gait);
        
        % Right gait cycle
        % -----------------------------------------------------------------
        % Initialise variables
        disp('        Right gait cycle');        
        clear n1;
        
        % EMG signal treatment
        Remg = prepareCycleEmgData(Session,Emg,Info.emg.units,Session.fanalog,'Right',Session.system);
        names = fieldnames(Remg);
        for k = 1:length(names)
            Condition.Gait(j).Remg.(names{k}) = permute(Remg.(names{k}),[3,2,1]);
        end
        
        % Left gait cycle
        % -----------------------------------------------------------------
        % Initialise variables
        disp('        Left gait cycle');        
        clear n1;
        
        % EMG signal treatment
        Lemg = prepareCycleEmgData(Session,Emg,Info.emg.units,Session.fanalog,'Left',Session.system);
        names = fieldnames(Lemg);
        for k = 1:length(names)
            Condition.Gait(j).Lemg.(names{k}) = permute(Lemg.(names{k}),[3,2,1]);
        end               
        j = j+1;
        Condition.Gait(j).e = Session.Gait(i).e;
        
    elseif strcmp(Session.Gait(i).condition,Condition.name) && strcmp(Session.Gait(i).emgtrial,'no')
        Condition.Gait(j).Remg = [];
        Condition.Gait(j).Lemg = [];
%         Condition.Gait(j).e = [];
        j=j+1;
    end
    
end