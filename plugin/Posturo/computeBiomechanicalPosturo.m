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

function [Session,Condition] = computeBiomechanicalPosturo(Session,Condition)

% =========================================================================
% Static
% =========================================================================
disp('    - Static');
% Load static files for each kind of data (kinematics, EMG and posture)
staticP = [];
if isfield(Session,'Static')
    for i = 1:length(Session.Static)
        if strcmp(Session.Static(i).condition,Condition.name) || strcmp(Session.Static(i).condition,'toutes conditions')
            if strcmp(Session.Static(i).posturetrial,'yes')
                staticP = Session.Static(i).file;
            
                % Define postural segments parameters
                Pmarkers = btkGetMarkers(staticP);
                nP = btkGetLastFrame(staticP)-btkGetFirstFrame(staticP)+1;
                Pmarkers = prepareStaticKinematicData(Pmarkers,staticP,nP,Session.system);
                [Pstatic,Pvmarkers] = prepareStaticPosturoSegmentParameters(Pmarkers,Session.system);
            end
        end
    end
end


% =========================================================================
% Gait cycles
% =========================================================================
j = 1;
for i = 1:length(Session.Gait)
    
    if strcmp(Session.Gait(i).condition,Condition.name) && strcmp(Session.Gait(i).posturetrial,'yes')

        disp(['    - Posturo',num2str(i),' = ',char(Session.Gait(i).filename)]);        
        gait = Session.Gait(i).file;

        % Prepare gait cycle data
        % ----------------------------------------------------------------- 
        % Initialise variables
        clear Markers n0 n1;      
        Markers = btkGetMarkers(gait);
        n0 = btkGetFirstFrame(gait);
        n1 = btkGetLastFrame(gait)-n0+1;
         % Set kinematic data in the correct format
        [Markers,minusX] = prepareCycleKinematicData(Markers,Session.Gait(i),n1,Session.fpoint,Session.system);
        
        % Right gait cycle
        % -----------------------------------------------------------------
        % Initialise variables
        disp('        Right gait cycle');        
        clear Segment n1;
        % Keep only data between two consecutive "foot strikes"
        [Rmarkers,~,~,n1,~] = cutCycleData(Markers,[],[],n0,...
            Session.fpoint,Session.fanalog,Session.Gait(i).e,0,'Right');
        Segment = preparePosturoSegmentParameters(Pstatic,Rmarkers,Pvmarkers,'Right',Session.system);   
        Condition.Posturo(j).Rangle = inverseKinematicsPosturo(Segment,n1);
        % Anchoring index and intercorrelation functions 
        [Std,Aindex,Ifunction,Idephasing] = computeIndexPosturalAngles(Condition.Posturo(j).Rangle);
        Condition.Posturo(j).Rstd = Std;
        Condition.Posturo(j).Rindex = Aindex;
        Condition.Posturo(j).Rfunction = Ifunction;
        Condition.Posturo(j).Rdephasing = Idephasing;
    
        % Left gait cycle
        % -----------------------------------------------------------------
        % Initialise variables
        disp('        Left gait cycle');        
        clear Segment n1 Std Aindex Ifunction Idephasing;
        n1 = btkGetLastFrame(gait)-n0+1;
        % Keep only data between two consecutive "foot strikes"
        [Lmarkers,~,~,n1,~] = cutCycleData(Markers,[],[],n0,...
            Session.fpoint,Session.fanalog,Session.Gait(i).e,0,'Left');
        Segment = preparePosturoSegmentParameters(Pstatic,Lmarkers,Pvmarkers,'Left',Session.system);       
        Condition.Posturo(j).Langle = inverseKinematicsPosturo(Segment,n1);
        % Anchoring index and intercorrelation functions 
        [Std,Aindex,Ifunction,Idephasing] = computeIndexPosturalAngles(Condition.Posturo(j).Langle);
        Condition.Posturo(j).Lstd = Std;
        Condition.Posturo(j).Lindex = Aindex;
        Condition.Posturo(j).Lfunction = Ifunction;
        Condition.Posturo(j).Ldephasing = Idephasing; 
       
        j = j+1;
    elseif strcmp(Session.Gait(i).condition,Condition.name) && strcmp(Session.Gait(i).posturetrial,'no')
        names={'Pgr_tilt';'Pgr_rota';'Pgr_obli';'Rgr_tilt';'Rgr_rota';'Rgr_obli';...
            'Sgr_tilt';'Sgr_rota';'Sgr_obli';'Sseg_tilt';'Sseg_rota';'Sseg_obli'; ...
           'Hgr_tilt';'Hgr_rota';'Hgr_obli';'Hseg_tilt';'Hseg_rota';'Hseg_obli';};
        for k=1:length(names)
            Condition.Posturo(j).Rangle.(names{k})=[];
            Condition.Posturo(j).Rstd.(names{k})=[];
        end
        names={'S_tilt','S_obli','S_rota','H_tilt','H_obli','H_rota'};
        for k=1:length(names)
            Condition.Posturo(j).Rindex.(names{k})=[];
        end
        names={'HA_TA_TI','HA_TA_OB','HA_TA_RO','TA_PA_TI','TA_PA_OB','TA_PA_RO'};
        for k=1:length(names)
            Condition.Posturo(j).Rfunction.(names{k})=[];
            Condition.Posturo(j).Rdephasing.(names{k})=[];
        end 
        names={'Pgr_tilt';'Pgr_rota';'Pgr_obli';'Rgr_tilt';'Rgr_rota';'Rgr_obli';...
            'Sgr_tilt';'Sgr_rota';'Sgr_obli';'Sseg_tilt';'Sseg_rota';'Sseg_obli'; ...
           'Hgr_tilt';'Hgr_rota';'Hgr_obli';'Hseg_tilt';'Hseg_rota';'Hseg_obli';};
        for k=1:length(names)
            Condition.Posturo(j).Langle.(names{k})=[];
            Condition.Posturo(j).Lstd.(names{k})=[];
        end
        names={'S_tilt','S_obli','S_rota','H_tilt','H_obli','H_rota'};
        for k=1:length(names)
            Condition.Posturo(j).Lindex.(names{k})=[];
        end
        names={'HA_TA_TI','HA_TA_OB','HA_TA_RO','TA_PA_TI','TA_PA_OB','TA_PA_RO'};
        for k=1:length(names)
            Condition.Posturo(j).Lfunction.(names{k})=[];
            Condition.Posturo(j).Ldephasing.(names{k})=[];
        end 
        
        j=j+1;
    end
end