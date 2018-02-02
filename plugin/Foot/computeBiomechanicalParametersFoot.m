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

function [Session,Condition] = computeBiomechanicalParametersFoot(Session,Condition)

% =========================================================================
% Static
% =========================================================================
% % % disp('    - Static');
% % % % Load static files for each kind of data (kinematics)
% % % static = [];
% % % for i = 1:length(Session.Static)
% % %     if strcmp(Session.Static(i).condition,Condition.name) || strcmp(Session.Static(i).condition,'toutes conditions')
% % %         if strcmp(Session.Static(i).gaittrial,'yes')
% % %             static = Session.Static(i).file;
% % %         end
% % %     end

% % %     % Kinematics static trial    Plus tard pour avoir les offsets!!!!
% % %     % -------------------------------------------------------------------------
% % %     % Import markers trajectories and number of frames
% % %     Markers = btkGetMarkers(static);
% % %     n = btkGetLastFrame(static)-btkGetFirstFrame(static)+1;
% % %     % Set kinematic data in the correct format
% % %     Markers = prepareStaticKinematicData(Markers,static,n,Session.system);
% % %     % Define segments parameters
% % %     [RstaticF,Rmarkers,Rvmarkers] = prepareSegmentParametersFoot(Session,Markers,'Right');
% % %     for i = 1:size(RstaticF,2)
% % %         RstaticF(i).T = Q2Tuv_array3(RstaticF(i).Q);
% % %     end
% % %     %     [Session,LstaticF,Lmarkers,Lvmarkers] = prepareStaticSegmentParametersFoot(Patient,Session,Markers,'Left',Session.system);
% % %     % Compute angle offset and ankle joint
% % % %     RstaticF.offset = 90;  
% % % %     LstaticF.offset = 90;
% % %     % Plot static
% % % %     plotStaticFoot(Rmarkers,Rvmarkers,RStaticF);
% % % %     plotStatic(Lmarkers,Lvmarkers,Session.system);

% % % end

% =========================================================================
% Gait cycles
% =========================================================================
j = 1;
for i = 1:length(Session.Gait)
    
    if strcmp(Session.Gait(i).condition,Condition.name)

        disp(['    - Foot',num2str(i),' = ',char(Session.Gait(i).filename)]);        
        gait = Session.Gait(i).file;

        % Prepare gait cycle data
        % ----------------------------------------------------------------- 
        % Initialise variables
        clear Markers n n1 n2 f1 f2 e;      
        Markers = btkGetMarkers(gait);
        Grf = btkGetGroundReactionWrenches(gait);
        n0 = btkGetFirstFrame(gait);
        n1 = btkGetLastFrame(gait)-btkGetFirstFrame(gait)+1;
        
        % Detect foot strike and foot off events
        Events.e = btkGetEvents(gait);

        % Set kinematic data in the correct format
        [Markers,~] = prepareCycleKinematicData(Markers,Session.Gait(i),n1,Session.fpoint,Session.system);
             
        % Right gait cycle
        % -----------------------------------------------------------------
        % Initialise variables
        disp('        Right gait cycle');        
        clear n1;
        % Keep only data between two consecutive "foot strikes"
        [Rmarkers,~,~,n1,~] = cutCycleData(Markers,Grf,[],Session.Gait(i),n0,Session.fpoint,Session.fanalog,Events.e,Session.Gait(i).s(1),'Right');
        % Define segments parameters
        [Segment,Rmarkers,Rvmarkers] = prepareSegmentParametersFoot(Session,Rmarkers,Session.Gait(i),'Right');
        Condition.Foot(j).Rkinematics = inverseKinematicsFoot(...
            Segment,Rmarkers,Session.Gait(i),n1,'Right');
        % Store limb Segment and Joint structures
        Condition.Foot(j).Rsegment = Segment; 
 
        % Left gait cycle
        % -----------------------------------------------------------------
        % Initialise variables
        disp('        Left gait cycle');        
        clear Segment n1;
        % Keep only data between two consecutive "foot strikes"
        [Lmarkers,~,~,n1,~] = cutCycleData(Markers,Grf,[],Session.Gait(i),n0,Session.fpoint,Session.fanalog,Events.e,Session.Gait(i).s(2),'Left');
        % Define segments parameters
        [Segment,Lmarkers,Lvmarkers] = prepareSegmentParametersFoot(Session,Lmarkers,Session.Gait(i),'Left');
        % Compute inverse kinematics
        Condition.Foot(j).Lkinematics = inverseKinematics(...
             Segment,Lmarkers,Session.Gait(i),n1,'Left');
        % Store limb Segment and Joint structures
        Condition.Foot(j).Lsegment = Segment;
        
        % Gait parameters
        % -----------------------------------------------------------------
        if ~isfield(Condition.Gait(j),'Gaitparameters')
            Condition.Gait(j).Gaitparameters = gaitParameters(Rmarkers,...
                Lmarkers,Rvmarkers,Lvmarkers,Session.Gait(i),Events.e,Session);
        end            
        j = j+1;
        
    end

end