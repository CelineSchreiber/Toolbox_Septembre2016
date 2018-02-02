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

function [Session,Condition] = computeBiomechanicalParametersUpperLimbs(Session,Condition)


% =========================================================================
% Gait cycles
% =========================================================================
j=1;
for i = 1:length(Session.Gait)

    if strcmp(Session.Gait(i).condition,Condition.name)
        
        disp(['    - UpperLimbs',num2str(i),' = ',char(Session.Gait(i).filename)]);        
        gait = Session.Gait(i).file;

        % Prepare gait cycle data
        % ----------------------------------------------------------------- 
        % Initialise variables
        clear Markers n n1 n2 f1 f2 e;      
        Markers = btkGetMarkers(gait);
        n0 = btkGetFirstFrame(gait);
        n1 = btkGetLastFrame(gait)-n0+1;

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
        [Rmarkers,~,~,n1,~] = cutCycleData(Markers,[],[],Session.Gait(i),n0,Session.fpoint,Session.fanalog,Events.e,0,'Right');
        % Define segments parameters
        [Segment,Rmarkers,Rvmarkers] = prepareSegmentParametersUpperLimb(Rmarkers,Session.Gait(i),n1,'Right');
        Condition.UpperLimbs(j).Rkinematics = inverseKinematicsUpperLimb(...
            Segment,Rmarkers,Session.Gait(i),n1,'Right');
        % Store limb Segment and Joint structures
        Condition.UpperLimbs(j).Rsegment = Segment; 
        
        % Left gait cycle
        % -----------------------------------------------------------------
        % Initialise variables
        disp('        Left gait cycle');        
        clear n1 Segment;
        % Keep only data between two consecutive "foot strikes"
        [Lmarkers,~,~,n1,~] = cutCycleData(Markers,[],[],Session.Gait(i),n0,Session.fpoint,Session.fanalog,Events.e,0,'Left');
        % Define segments parameters
        [Segment,Lmarkers,Lvmarkers] = prepareSegmentParametersUpperLimb(Lmarkers,Session.Gait(i),n1,'Left');
        % Compute inverse kinematics
        Condition.UpperLimbs(j).Lkinematics = inverseKinematicsUpperLimb(...
            Segment,Lmarkers,Session.Gait(i),n1,'Left');
        % Store limb Segment and Joint structures
        Condition.UpperLimbs(j).Lsegment = Segment;
        
        j = j+1;
   end

end