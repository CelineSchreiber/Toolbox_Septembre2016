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
% Version: 2
% -------------------------------------------------------------------------
% Updates: - 16/09/2014: Outputs have 101 rows (frames 0 to 100)
%          - 26/09/2014: Auto selection the static file corresponding to 
%            the current condition OR ' TOUTES CONDITIONS' !!!!
%          - 26/09/2016: Only Kinematics and Dynamics!
% =========================================================================

function [Session,Condition] = computeBiomechanicalParameters(Patient,Session,Condition)

% =========================================================================
% Static
% =========================================================================
disp('    - Static');
% Load static files 
staticK = [];
if isfield(Session,'Static')
    for i = 1:length(Session.Static)
        if strcmp(Session.Static(i).condition,Condition.name) || strcmp(Session.Static(i).condition,'toutes conditions')
            if strcmp(Session.Static(i).gaittrial,'yes')
                staticK = Session.Static(i).file;
            end
        end
    end

    if ~isempty(staticK)
        % Kinematics static trial
        % -------------------------------------------------------------------------
        % Import markers trajectories and number of frames
        Markers = btkGetMarkers(staticK);
        nK = btkGetLastFrame(staticK)-btkGetFirstFrame(staticK)+1;
        % Set kinematic data in the correct format
        Markers = prepareStaticKinematicData(Markers,staticK,nK,Session.system);
        if isfield(Markers,'R_Ankle')
           Markers = modifyMarkersNames(Markers); 
        end
        % Define segments parameters
        [Session,Rstatic,Rmarkers,Rvmarkers] = prepareStaticSegmentParameters(Patient,Session,Markers,'Right',Session.system);
        [Session,Lstatic,Lmarkers,Lvmarkers] = prepareStaticSegmentParameters(Patient,Session,Markers,'Left',Session.system);
        % Compute angle offset and ankle joint
        Rstatic = computeAnkleAngleOffset(Rstatic,Rmarkers,'Right',Session.system);
        Lstatic = computeAnkleAngleOffset(Lstatic,Lmarkers,'Left',Session.system);
%         Rstatic = computeKneeAngleOffset(Rstatic,Rmarkers,'Right',Session.system);
%         Lstatic = computeKneeAngleOffset(Lstatic,Lmarkers,'Left',Session.system);
        % % Plot static
    %     plotStatic(Rmarkers,Rvmarkers,Session.system);
    %     plotStatic(Lmarkers,Lvmarkers,Session.system);

    end
end

% =========================================================================
% Gait cycles
% =========================================================================
j = 1;
for i = 1:length(Session.Gait)
    
    if strcmp(Session.Gait(i).condition,Condition.name) && strcmp(Session.Gait(i).gaittrial,'yes')

        disp(['    - Gait',num2str(i),' = ',char(Session.Gait(i).filename)]);        
        gait = Session.Gait(i).file;

        % Prepare gait cycle data
        % ----------------------------------------------------------------- 
        % Initialise variables
        clear Markers n n1 n2 f1 f2 e;      
        Markers = btkGetMarkers(gait);
        if isfield(Markers,'R_Ankle')
           Markers = modifyMarkersNames(Markers); 
        end
        Grf = btkGetGroundReactionWrenches(gait);
        n0 = btkGetFirstFrame(gait);
        n1 = btkGetLastFrame(gait)-n0+1;
        n2 = btkGetAnalogFrameNumber(gait);
        % Set kinematic data in the correct format
        [Markers,minusX] = prepareCycleKinematicData(Markers,Session.Gait(i),n1,Session.fpoint,Session.system);
        % Set kinetic data in the correct format
        [Grf,Session.Gait(i)] = prepareCycleKineticData(Grf,Session.Gait(i),n1,n2,Session.fanalog,minusX,Session.system);        
%         [Tapis,Info.tapis] = btkGetAnalogs(gait);
%         Tapis = prepareCycleKineticDataTapis(Tapis,Info.tapis.units,Session.Gait(i),n1,n2,Session.fanalog,minusX,Session.system);        
        % Right gait cycle
        % -----------------------------------------------------------------
        % Initialise variables
        disp('        Right gait cycle');        
        clear Segment Joint Emg n1 s;
   
        s = Session.Gait(i).s(1);
        
        % Keep only data between two consecutive "foot strikes"
        [Rmarkers,Rgrf,Remg,n1,n2] = cutCycleData(Markers,Grf,[],n0,...
            Session.fpoint,Session.fanalog,Session.Gait(i).e,s,'Right');
        if strcmp(Session.markersset,'Paramètres')
            Condition.Gait(j).Rkinematics = prepareCycleSegmentParametersFootOnly(Rmarkers,Session.Gait(j),n1,'Right');
        else
            % Define the gait phases described by Perry
            [Revents,Rphases] = detectionGaitPhases(Rmarkers,n0,...
                Session.fpoint,Session.Gait(i).e,'Right',Session.system);
            % Define segments parameters
            [Segment,Rmarkers,Rvmarkers] = prepareCycleSegmentParameters(Rstatic,...
                Rmarkers,Rvmarkers,Rgrf,n1,'Right',Session.system);
            % Define segments inertial parameters
            Segment = prepareCycleInertialParameters(Patient,Session,Segment);
            Joint = prepareJoint(Rgrf,'Right');
%           % Plot cycle
%           plotCycle(Rmarkers,Rvmarkers,n1,'Right',Session.system);
            Segment = Extend_Segment_Fields(Segment);
            % Compute inverse kinematics
            Condition.Gait(j).Rkinematics = inverseKinematics(...
                Rstatic,Segment,Rmarkers,Rvmarkers,Revents,n1,'Right',Session.system);
            % Compute inverse dynamics
            [Condition.Gait(j).Rdynamics,Segment,Joint] = inverseDynamics(...
                Session,Segment,Joint,n1,Session.fpoint,s,'Right');
            
            % Export events
            [Condition.Gait(j).Revents,Condition.Gait(j).Rphases] = exportEvents(Revents,Rphases,n1);        
            % Store limb Segment and Joint structures
            Condition.Gait(j).Rmarkers = Rmarkers;
            Condition.Gait(j).Rsegment = Segment;
            Condition.Gait(j).Rjoint = Joint;  
            Condition.Gait(j).RSensitivity = computeSensitivity('Right',Session.system,Rmarkers,Rvmarkers,...
                Condition.Gait(j).Rkinematics);
        end
        
        % Left gait cycle
        % -----------------------------------------------------------------
        % Initialise variables
        disp('        Left gait cycle');        
        clear Segment Joint Emg n1 s;
        s = Session.Gait(i).s(2);

        % Keep only data between two consecutive "foot strikes"
        [Lmarkers,Lgrf,Lemg,n1,n2] = cutCycleData(Markers,Grf,[],n0,...
            Session.fpoint,Session.fanalog,Session.Gait(i).e,s,'Left');
        if strcmp(Session.markersset,'Paramètres')
            Condition.Gait(j).Lkinematics = prepareCycleSegmentParametersFootOnly(Lmarkers,Session.Gait(j),n1,'Left');
        else
            % Define the gait phases described by Perry
            [Levents,Lphases] = detectionGaitPhases(Lmarkers,n0,...
                Session.fpoint,Session.Gait(i).e,'Left',Session.system);
            % Define segments parameters
            [Segment,Lmarkers,Lvmarkers] = prepareCycleSegmentParameters(...
                Lstatic,Lmarkers,Lvmarkers,Lgrf,n1,'Left',Session.system);
            % Define segments inertial parameters
            Segment = prepareCycleInertialParameters(Patient,Session,Segment);
            Joint = prepareJoint(Lgrf,'Left');
    %         % Plot cycle
    %         plotCycle(Rmarkers,Rvmarkers,n1,'Right',Session.system);
            % Compute inverse kinematics
            Segment = Extend_Segment_Fields(Segment);
            Condition.Gait(j).Lkinematics = inverseKinematics(...
                Lstatic,Segment,Lmarkers,Lvmarkers,Levents,n1,'Left',Session.system);
            % Compute inverse dynamics
            [Condition.Gait(j).Ldynamics,Segment,Joint] = inverseDynamics(...
                Session,Segment,Joint,n1,Session.fpoint,s,'Left');    
            
            % Export events
            [Condition.Gait(j).Levents,Condition.Gait(j).Lphases] = exportEvents(Levents,Lphases,n1);        
            % Store limb Segment and Joint structures
            Condition.Gait(j).Lmarkers = Lmarkers;
            Condition.Gait(j).Lsegment = Segment;
            Condition.Gait(j).Ljoint = Joint;
            Condition.Gait(j).LSensitivity = computeSensitivity('Left',Session.system,Lmarkers,Lvmarkers,...
                Condition.Gait(j).Lkinematics);
        end
        
        % Gait parameters
        % -----------------------------------------------------------------
        if strcmp(Session.markersset,'Paramètres')
            Condition.Gait(j).Gaitparameters = gaitParametersSimplified(Rmarkers,...
                Lmarkers,Session.Gait(i),Session.Gait(i).e);
        else
            Condition.Gait(j).Gaitparameters = gaitParameters(Rmarkers,...
                Lmarkers,Rvmarkers,Lvmarkers,Session.Gait(i),Session.Gait(i).e,Session);
        end
        
        % Detect abnormalities
        % -----------------------------------------------------------------
%         if ~strcmp(Session.markersset,'Paramètres')
%             Condition.Gait(j).Abnormalities = detectionAbnormalities(...
%                 Rmarkers,Lmarkers,Revents,Levents,Session.Gait(i),Session.system);
%         end
        
        j = j+1;
        
    elseif strcmp(Session.Gait(i).condition,Condition.name) && strcmp(Session.Gait(i).gaittrial,'no')
        [Condition.Gait(j).Rkinematics,Condition.Gait(j).Rdynamics,...
            Condition.Gait(j).Revents,Condition.Gait(j).Rphases]    = initialisationKinematicsDynamics;
        Condition.Gait(j).Rsegment = [];
        Condition.Gait(j).Rjoint = [];
        
        [Condition.Gait(j).Lkinematics,Condition.Gait(j).Ldynamics,...
            Condition.Gait(j).Levents,Condition.Gait(j).Lphases]    = initialisationKinematicsDynamics;
        Condition.Gait(j).Lsegment = [];
        Condition.Gait(j).Ljoint = [];
        
        Condition.Gait(j).Gaitparameters                            = initialisationGaitParameters;
        
        j=j+1;
    end

end