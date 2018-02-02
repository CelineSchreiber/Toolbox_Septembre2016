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

function [Session,Condition] = computeBiomechanicalParameters(Patient,Session,Condition)

% =========================================================================
% Static
% =========================================================================
disp('    - Static');
% Load static files for each kind of data (kinematics, EMG and posture)
staticK = [];
staticE = [];
staticP = [];
if isfield(Session,'Static')
    for i = 1:length(Session.Static)
        if strcmp(Session.Static(i).condition,Condition.name) || strcmp(Session.Static(i).condition,'toutes conditions')
            if strcmp(Session.Static(i).gaittrial,'yes')
                staticK = Session.Static(i).file;
            end
            if strcmp(Session.Static(i).emgtrial,'yes')
                staticE = Session.Static(i).file;
            end
            if strcmp(Session.Static(i).posturetrial,'yes')
                staticP = Session.Static(i).file;
            end
        end
    end

    % Kinematics static trial
    % -------------------------------------------------------------------------
    % Import markers trajectories and number of frames
    Markers = btkGetMarkers(staticK);
    nK = btkGetLastFrame(staticK)-btkGetFirstFrame(staticK)+1;
    % Set kinematic data in the correct format
    Markers = prepareStaticKinematicData(Markers,staticK,nK,Session.system);
    % Define segments parameters
    [Session,Rstatic,Rmarkers,Rvmarkers] = prepareStaticSegmentParameters(Patient,Session,Markers,'Right',Session.system);
    [Session,Lstatic,Lmarkers,Lvmarkers] = prepareStaticSegmentParameters(Patient,Session,Markers,'Left',Session.system);
    % Compute angle offset and ankle joint
    Rstatic = computeAnkleAngleOffset(Rstatic,Rmarkers,'Right',Session.system);
    Lstatic = computeAnkleAngleOffset(Lstatic,Lmarkers,'Left',Session.system);
    % % Plot static
%     plotStatic(Rmarkers,Rvmarkers,Session.system);
%     plotStatic(Lmarkers,Lvmarkers,Session.system);

    % EMG static trial
    % -------------------------------------------------------------------------
    % To be done

    % Postural static trial
    % -------------------------------------------------------------------------
    % Define postural segments parameters
    if ~isempty(staticP) && ~isequal(staticP,staticK)
        Pmarkers = btkGetMarkers(staticP);
        nP = btkGetLastFrame(staticP)-btkGetFirstFrame(staticP)+1;
        Pmarkers = prepareStaticKinematicData(Pmarkers,staticP,nP,Session.system);
    else
        Pmarkers = Markers;
    end
    [Pstatic,Pvmarkers] = prepareStaticPosturoSegmentParameters(Pmarkers,Session.system);
end
% % % =========================================================================
% % % Functional method (for knee joint)
% % % =========================================================================
% % Rstatic(3).rM = [Markers.Shank_Proximal,Markers.Shank_Anterior,Markers.Shank_Posterior];
% % Rstatic(4).rM = [Markers.Thigh_Proximal,Markers.Thigh_Anterior,Markers.Thigh_Posterior];
% % 
% % clear Markers n n1 n2 f1 f2 e;
% % ffunctional = Session.Functional(1).file;
% % Markers = btkGetMarkers(ffunctional);
% % nf = btkGetLastFrame(ffunctional)-btkGetFirstFrame(ffunctional)+1;
% % f = 100;
% % 
% % names = fieldnames(Markers);
% % for i = 1:length(names)
% %     temp1 = Markers.(names{i})(:,1);
% %     temp2 = Markers.(names{i})(:,3);
% %     temp3 = -Markers.(names{i})(:,2);
% %     Markers.(names{i})(:,1) = temp1;
% %     Markers.(names{i})(:,2) = temp2;
% %     Markers.(names{i})(:,3) = temp3;        
% %     Markers.(names{i}) = Markers.(names{i})*10^(-3);        
% %     for j = 1:nf
% %         if Markers.(names{i})(j,:) == [0 0 0]
% %             Markers.(names{i})(j,:) = nan(1,3);
% %         end
% %     end        
% %     [B,A] = butter(4,6/(f/2),'low');
% %     for j = 1:3
% %         x = 1:nf;
% %         y = Markers.(names{i});
% %         xx = 1:1:nf;
% %         temp = interp1(x,y,xx,'spline');
% %         Markers.(names{i}) = filtfilt(B,A,temp);
% %     end        
% %     Markers.(names{i}) = permute(Markers.(names{i}),[2,3,1]);
% % end
% % 
% % Rfunctional(3).rM = [Markers.Shank_Proximal,Markers.Shank_Anterior,Markers.Shank_Posterior];
% % Rfunctional(4).rM = [Markers.Thigh_Proximal,Markers.Thigh_Anterior,Markers.Thigh_Posterior];
% % 
% % for j = 3:4        
% %     Rotation = [];
% %     Translation = [];
% %     RMS = [];        
% %     for i = 1:nf
% %         [Rotation(:,:,i),Translation(:,:,i),RMS(:,:,i)] ...
% %             = soder(Rstatic(j).rM',Rfunctional(j).rM(:,:,i)');
% %     end        
% %     Rfunctional(j).Q = [Mprod_array3(Rotation , ...
% %         repmat(Rstatic(j).Q(1:3,1,:),[1 1 nf])); ...
% %         Mprod_array3(Rotation,repmat(Rstatic(j).Q(4:6,1,:),[1 1 nf])) ...
% %         + Translation; ...
% %         Mprod_array3(Rotation,repmat(Rstatic(j).Q(7:9,1,:),[1 1 nf])) ...
% %         + Translation; ...
% %         Mprod_array3(Rotation,repmat(Rstatic(j).Q(10:12,1,:),[1 1 nf]))];        
% % end
% % 
% % Rfunctional(3).T = Q2Tuv_array3(Rfunctional(3).Q);
% % Rfunctional(4).T = Q2Tuv_array3(Rfunctional(4).Q);
% % 
% % AoR = SARA_array3(Rfunctional(4).T,Rfunctional(3).T);
% % CoR = SCoRE_array3(Rfunctional(4).T,Rfunctional(3).T);
% % % Rfunctional(4).Q(7:9,:,:) = CoR;
% % Rfunctional(4).Q(10:12,:,:) = AoR;
% % % Rfunctional(3).Q(4:6,:,:) = CoR;
% % % Segment = Rfunctional;
% % % Main_Segment_Visualisation;
% % 
% % for j = 3:4        
% %     Rotation = [];
% %     Translation = [];
% %     RMS = [];        
% %     for i = 1:nf
% %         [Rotation(:,:,i),Translation(:,:,i),RMS(:,:,i)] ...
% %             = soder(Rfunctional(j).rM(:,:,i)',Rstatic(j).rM');
% %     end      
% %     Rstatic(j).Q = [];
% %     Rstatic(j).Q = mean([Mprod_array3(Rotation , ...
% %         Rfunctional(j).Q(1:3,1,:)); ...
% %         Mprod_array3(Rotation,Rfunctional(j).Q(4:6,1,:)) ...
% %         + Translation; ...
% %         Mprod_array3(Rotation,Rfunctional(j).Q(7:9,1,:)) ...
% %         + Translation; ...
% %         Mprod_array3(Rotation,Rfunctional(j).Q(10:12,1,:))],3);        
% % end

% % =========================================================================
% % Functional method (for ankle joint)
% % =========================================================================
% Rstatic(2).rM = [Markers.R_FCC,Markers.R_FM5,Markers.R_FM1];
% Rstatic(3).rM = [Markers.R_FAX,Markers.R_TTC,Markers.R_FAL];
% 
% clear Markers n n1 n2 f1 f2 e;
% ffunctional = Session.Functional(1).file;
% Markers = btkGetMarkers(ffunctional);
% nf = btkGetLastFrame(ffunctional)-btkGetFirstFrame(ffunctional)+1;
% f = 100;
% 
% names = fieldnames(Markers);
% for i = 1:length(names)
%     temp1 = Markers.(names{i})(:,1);
%     temp2 = Markers.(names{i})(:,3);
%     temp3 = -Markers.(names{i})(:,2);
%     Markers.(names{i})(:,1) = temp1;
%     Markers.(names{i})(:,2) = temp2;
%     Markers.(names{i})(:,3) = temp3;        
%     Markers.(names{i}) = Markers.(names{i})*10^(-3);        
%     for j = 1:nf
%         if Markers.(names{i})(j,:) == [0 0 0]
%             Markers.(names{i})(j,:) = nan(1,3);
%         end
%     end        
%     [B,A] = butter(4,6/(f/2),'low');
%     for j = 1:3
%         x = 1:nf;
%         y = Markers.(names{i});
%         xx = 1:1:nf;
%         temp = interp1(x,y,xx,'spline');
%         Markers.(names{i}) = filtfilt(B,A,temp);
%     end        
%     Markers.(names{i}) = permute(Markers.(names{i}),[2,3,1]);
% end
% 
% Rfunctional(2).rM = [Markers.R_FCC,Markers.R_FM5,Markers.R_FM1];
% Rfunctional(3).rM = [Markers.R_FAX,Markers.R_TTC,Markers.R_FAL];
% 
% for j = 2:3        
%     Rotation = [];
%     Translation = [];
%     RMS = [];        
%     for i = 1:nf
%         [Rotation(:,:,i),Translation(:,:,i),RMS(:,:,i)] ...
%             = soder(Rstatic(j).rM',Rfunctional(j).rM(:,:,i)');
%     end        
%     Rfunctional(j).Q = [Mprod_array3(Rotation , ...
%         repmat(Rstatic(j).Q(1:3,1,:),[1 1 nf])); ...
%         Mprod_array3(Rotation,repmat(Rstatic(j).Q(4:6,1,:),[1 1 nf])) ...
%         + Translation; ...
%         Mprod_array3(Rotation,repmat(Rstatic(j).Q(7:9,1,:),[1 1 nf])) ...
%         + Translation; ...
%         Mprod_array3(Rotation,repmat(Rstatic(j).Q(10:12,1,:),[1 1 nf]))];        
% end
% 
% Rfunctional(2).T = Q2Tuv_array3(Rfunctional(2).Q);
% Rfunctional(3).T = Q2Tuv_array3(Rfunctional(3).Q);
% 
% AoR = SARA_array3(Rfunctional(3).T,Rfunctional(2).T);
% CoR = SCoRE_array3(Rfunctional(3).T,Rfunctional(2).T);
% Rfunctional(3).Q(7:9,:,:) = CoR;
% Rfunctional(3).Q(10:12,:,:) = -AoR;
% Rfunctional(2).Q(4:6,:,:) = CoR;
% % Segment = Rfunctional;
% % Main_Segment_Visualisation;
% 
% for j = 2:3        
%     Rotation = [];
%     Translation = [];
%     RMS = [];        
%     for i = 1:nf
%         [Rotation(:,:,i),Translation(:,:,i),RMS(:,:,i)] ...
%             = soder(Rfunctional(j).rM(:,:,i)',Rstatic(j).rM');
%     end      
%     Rstatic(j).Q = [];
%     Rstatic(j).Q = mean([Mprod_array3(Rotation , ...
%         Rfunctional(j).Q(1:3,1,:)); ...
%         Mprod_array3(Rotation,Rfunctional(j).Q(4:6,1,:)) ...
%         + Translation; ...
%         Mprod_array3(Rotation,Rfunctional(j).Q(7:9,1,:)) ...
%         + Translation; ...
%         Mprod_array3(Rotation,Rfunctional(j).Q(10:12,1,:))],3);        
% end

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
        Grf = btkGetGroundReactionWrenches(gait);
        n0 = btkGetFirstFrame(gait);
        n1 = btkGetLastFrame(gait)-btkGetFirstFrame(gait)+1;
        n2 = btkGetAnalogFrameNumber(gait);
        % Detect foot strike and foot off events
        e = btkGetEvents(gait);
%         e2 = detectionCycleEvents(Markers,n1,f1,Session.system);             % Current problem: not only 1 cycle per side ...
        % Set kinematic data in the correct format
        [Markers,minusX] = prepareCycleKinematicData(Markers,Session.Gait(i),n1,Session.fpoint,Session.system);
        % Set kinetic data in the correct format
        Grf = prepareCycleKineticData(Grf,Session.Gait(i),n1,n2,Session.fanalog,minusX,Session.system);        
        
        % Right gait cycle
        % -----------------------------------------------------------------
        % Initialise variables
        disp('        Right gait cycle');        
        clear Segment Joint Emg n1 s;
        [Emg,Info.emg] = btkGetAnalogs(gait);
        n1 = btkGetLastFrame(gait)-btkGetFirstFrame(gait)+1;
        s = Session.Gait(i).s(1);
        % EMG signal treatment
        Remg = prepareCycleEmgData(Session,Emg,Info.emg.units,Session.Gait(i),Session.fanalog,'Right',Session.system);
        % Keep only data between two consecutive "foot strikes"
        [Rmarkers,Rgrf,Remg,n1,n2,e] = cutCycleData(Markers,Grf,Remg,Session.Gait(i),n0,Session.fpoint,Session.fanalog,e,s,'Right');
%         if strcmp(Session.markersset,'EMG')
%             Condition.Gait(j).Remg = exportEmg(Remg,Session.Gait(i),n2);
%         end
        if strcmp(Session.markersset,'Paramètres')
            Condition.Gait(j).Rkinematics = prepareCycleSegmentParametersFootOnly(Rmarkers,Session.Gait(j),n1,'Right');
        else
            % Define the gait phases described by Perry
            [Revents,Rphases] = detectionGaitPhases(Rmarkers,n0,Session.fpoint,e,'Right',Session.system);
            % Define segments parameters
            [Segment,Rmarkers,Rvmarkers] = prepareCycleSegmentParameters(Rstatic,...
                Rmarkers,Rvmarkers,Rgrf,n1,'Right',Session.system);
            % Define segments inertial parameters
            Segment = prepareCycleInertialParameters(Patient,Session,Segment);
%           % Plot cycle
%           plotCycle(Rmarkers,Rvmarkers,n1,'Right',Session.system);
            % Compute inverse kinematics
            Segment = Extend_Segment_Fields(Segment);
            Condition.Gait(j).Rkinematics = inverseKinematics(...
                Rstatic,Segment,Rmarkers,Rvmarkers,Revents,n1,'Right',Session.system);
            % Compute inverse dynamics
            Joint = prepareJoint(Rgrf,'Right');
            [Condition.Gait(j).Rdynamics,Segment,Joint] = inverseDynamics(...
                Session,Segment,Joint,Session.Gait(i),n1,Session.fpoint,s,'Right'); 
            % Export emg
            Condition.Gait(j).Remg = exportEmg(Remg,Session.Gait(i),n2);
            % Export events
            [Condition.Gait(j).Revents,Condition.Gait(j).Rphases] = exportEvents(...
                Revents,Rphases,Session.Gait(i),n1);        
            % =============================================================
            % Compute postural angles
            % =============================================================
            [Segment] = preparePosturoSegmentParameters(...
                Pstatic,Segment,Rmarkers,Pvmarkers,Session.Gait(i),'Right',Session.system);   
            Condition.Gait(j).Rposturalangle = inverseKinematicsPosturo(Segment,Session.Gait(i),n1);
            % Anchoring index and intercorrelation functions 
            [Condition.Gait(j).Rposturalindex] = computeIndexPosturalAngles(Condition.Gait(j).Rposturalangle,Session.Gait(i));
            % Store limb Segment and Joint structures
            Condition.Gait(j).Rsegment = Segment;
            Condition.Gait(j).Rjoint = Joint;  
        end
        % Left gait cycle
        % -----------------------------------------------------------------
        % Initialise variables
        disp('        Left gait cycle');        
        clear Segment Joint Emg n1 s;
        [Emg,Info.emg] = btkGetAnalogs(gait);
        n1 = btkGetLastFrame(gait)-btkGetFirstFrame(gait)+1;
        s = Session.Gait(i).s(2);
        % EMG signal treatment
        Lemg = prepareCycleEmgData(Session,Emg,Info.emg.units,Session.Gait(i),Session.fanalog,'Left',Session.system);
        % Keep only data between two consecutive "foot strikes"
        if ~strcmp(Session.markersset,'EMG')
            [Lmarkers,Lgrf,Lemg,n1,n2] = cutCycleData(Markers,Grf,Lemg,Session.Gait(i),n0,Session.fpoint,Session.fanalog,e,s,'Left');
        else
            Condition.Gait(j).Lemg = exportEmg(Lemg,Session.Gait(i),n2);
        end
        if strcmp(Session.markersset,'Paramètres')
            Condition.Gait(j).Lkinematics = prepareCycleSegmentParametersFootOnly(Lmarkers,Session.Gait(j),n1,'Left');
        end
        if ~strcmp(Session.markersset,'Paramètres') && ~strcmp(Session.markersset,'EMG')
            % Define the gait phases described by Perry
            [Levents,Lphases] = detectionGaitPhases(Lmarkers,n0,Session.fpoint,e,'Left',Session.system);
            % Define segments parameters
            [Segment,Lmarkers,Lvmarkers] = prepareCycleSegmentParameters(...
                Lstatic,Lmarkers,Lvmarkers,Lgrf,n1,'Left',Session.system);
            % Define segments inertial parameters
            Segment = prepareCycleInertialParameters(Patient,Session,Segment);
    %         % Plot cycle
    %         plotCycle(Rmarkers,Rvmarkers,n1,'Right',Session.system);
            % Compute inverse kinematics
            if strcmp(Session.Gait(i).gaittrial,'yes')
                Segment = Extend_Segment_Fields(Segment);
            end
            Condition.Gait(j).Lkinematics = inverseKinematics(...
                Lstatic,Segment,Lmarkers,Lvmarkers,Levents,n1,'Left',Session.system);
            % Compute inverse dynamics
            Joint = prepareJoint(Lgrf,'Left');
            [Condition.Gait(j).Ldynamics,Segment,Joint] = inverseDynamics(...
                Session,Segment,Joint,Session.Gait(i),n1,Session.fpoint,s,'Left');    
            % Export emg
            Condition.Gait(j).Lemg = exportEmg(Lemg,Session.Gait(i),n2);
            % Export events
            [Condition.Gait(j).Levents,Condition.Gait(j).Lphases] = exportEvents(...
                Levents,Lphases,Session.Gait(i),n1);        
%             % Compute postural angles
%             [Segment] = preparePosturoSegmentParameters(...
%                 Pstatic,Segment,Lmarkers,Lvmarkers,Pvmarkers,Session.Gait(i),'Left',Session.system);       
%             Condition.Gait(j).Lposturalangle = inverseKinematicsPosturo(Segment,Session.Gait(i),n1);
%             % Anchoring index and intercorrelation functions 
%             [Condition.Gait(j).Lposturalindex] = computeIndexPosturalAngles(Condition.Gait(j).Lposturalangle,Session.Gait(i));
%             % Store limb Segment and Joint structures
            Condition.Gait(j).Lsegment = Segment;
            Condition.Gait(j).Ljoint = Joint;
        end
      
        
        % Gait parameters
        % -----------------------------------------------------------------
        if ~strcmp(Session.markersset,'Paramètres')  && ~strcmp(Session.markersset,'EMG')
            Condition.Gait(j).Gaitparameters = gaitParameters(Rmarkers,...
                Lmarkers,Rvmarkers,Lvmarkers,Session.Gait(i),e,Session);
        elseif ~strcmp(Session.markersset,'EMG')
            Condition.Gait(j).Gaitparameters = gaitParametersSimplified(Rmarkers,...
                Lmarkers,Session.Gait(i),e);
        end
        
        % Detect abnormalities
        % -----------------------------------------------------------------
        if ~strcmp(Session.markersset,'Paramètres')  && ~strcmp(Session.markersset,'EMG')
            Condition.Gait(j).Abnormalities = detectionAbnormalities(...
                Rmarkers,Lmarkers,Revents,Levents,Session.Gait(i),Session.system);
        end
        
        j = j+1;
        
    end

end