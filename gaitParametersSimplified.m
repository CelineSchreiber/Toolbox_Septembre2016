% =========================================================================
% REHAZENTER TOOLBOX
% =========================================================================
% File name:    gaitParameters
% -------------------------------------------------------------------------
% Subject:      Compute spatiotemporal parameters
% -------------------------------------------------------------------------
% Inputs:       - Rmarkers (structure)
%               - Lmarkers (structure)
%               - Rvmarkers (structure)
%               - Lvmarkers (structure)
%               - Gait (structure)
%               - e (structure)
%               - system (char)
% Outputs:      - Gaitparameters (structure)
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber, A. Naaim
% Date of creation: 26/03/2014
% Version: 1
% -------------------------------------------------------------------------
% Updates: - 28/04/2014: Bugs corrections
% =========================================================================

function Gaitparameters = gaitParametersSimplified(Rmarkers,Lmarkers,Gait,e)

% =========================================================================
% Initialisation
% =========================================================================
Gaitparameters.right_stance_phase = [];
Gaitparameters.left_stance_phase = [];
Gaitparameters.right_swing_phase = [];
Gaitparameters.left_swing_phase = [];
Gaitparameters.right_first_double_support = [];
Gaitparameters.right_second_double_support = [];
Gaitparameters.total_double_support = [];
Gaitparameters.right_stride_length = [];
Gaitparameters.left_stride_length = [];
Gaitparameters.right_step_length = [];
Gaitparameters.left_step_length = [];
Gaitparameters.step_width = [];
Gaitparameters.right_gait_cycle = [];
Gaitparameters.left_gait_cycle = [];
Gaitparameters.cadence = [];
Gaitparameters.mean_velocity = [];
Gaitparameters.mean_velocity_adim = [];

% =========================================================================
% Correct events names
% =========================================================================
if isfield(e,'Right_Foot_Strike')
    e.RHS = e.Right_Foot_Strike;
    e.LHS = e.Left_Foot_Strike;
    e.RTO = e.Right_Foot_Off;
    e.LTO = e.Left_Foot_Off;
    e = rmfield(e,'Right_Foot_Strike');
    e = rmfield(e,'Left_Foot_Strike');
    e = rmfield(e,'Right_Foot_Off');
    e = rmfield(e,'Left_Foot_Off');
end
if isfield(e,'General_RHS')
    if isfield(e,'RHS')
        e.RHS(end+1) = e.General_RHS;
    else
        e.RHS = e.General_RHS;
    end
    e = rmfield(e,'General_RHS');
end
if isfield(e,'General_LHS')
    if isfield(e,'LHS')
        e.LHS(end+1) = e.General_LHS;
    else
        e.LHS = e.General_LHS;
    end
    e = rmfield(e,'General_LHS');
end
if isfield(e,'General_RTO')
    if isfield(e,'RTO')
        e.RTO(end+1) = e.General_RTO;
    else
        e.RTO = e.General_RTO;
    end
    e = rmfield(e,'General_RTO');
end
if isfield(e,'General_LTO')
    if isfield(e,'LTO')
        e.LTO(end+1) = e.General_LTO;
    else
        e.LTO = e.General_LTO;
    end
    e = rmfield(e,'General_LTO');
end

if strcmp(Gait.gaittrial,'yes')

    % =====================================================================
    % Gait phases
    % =====================================================================
    if e.LHS(1) < e.RHS(1)
        Gaitparameters.right_stance_phase = (e.RTO(2) - e.RHS(1)) ...
            * 100/(e.RHS(2) - e.RHS(1));
        Gaitparameters.left_stance_phase = (e.LTO(1) - e.LHS(1)) ...
            * 100/(e.LHS(2) - e.LHS(1));
        Gaitparameters.right_swing_phase = (e.RHS(2) - e.RTO(2)) ...
            * 100/(e.RHS(2) - e.RHS(1));    
        Gaitparameters.left_swing_phase = (e.LHS(2) - e.LTO(1)) ...
            * 100/(e.LHS(2) - e.LHS(1));  
        Gaitparameters.right_first_double_support = (e.LTO(1) - e.RHS(1)) ...
            * 100/(e.RHS(2) - e.RHS(1));
        Gaitparameters.right_second_double_support = (e.RTO(2) - e.LHS(2)) ...
            * 100/(e.RHS(2) - e.RHS(1));
        Gaitparameters.total_double_support = ...
            Gaitparameters.right_first_double_support+Gaitparameters.right_second_double_support;
    elseif e.LHS(1) > e.RHS(1)
        Gaitparameters.right_stance_phase = (e.RTO(1) - e.RHS(1)) ...
            * 100/(e.RHS(2) - e.RHS(1));
        Gaitparameters.left_stance_phase = (e.LTO(2) - e.LHS(1)) ...
            * 100/(e.LHS(2) - e.LHS(1));
        Gaitparameters.right_swing_phase = (e.RHS(2) - e.RTO(1)) ...
            * 100/(e.RHS(2) - e.RHS(1));    
        Gaitparameters.left_swing_phase = (e.LHS(2) - e.LTO(2)) ...
            * 100/(e.LHS(2) - e.LHS(1));  
        Gaitparameters.right_first_double_support = (e.LTO(1) - e.RHS(1)) ...
            * 100/(e.RHS(2) - e.RHS(1));
        Gaitparameters.right_second_double_support = (e.RTO(1) - e.LHS(1)) ...
            * 100/(e.RHS(2) - e.RHS(1));
        Gaitparameters.total_double_support = ...
            Gaitparameters.right_first_double_support+Gaitparameters.right_second_double_support;
    end

    % =====================================================================
    % Lengths
    % =====================================================================
    Rmarkers.r_ajc = (Rmarkers.R_FAL+Rmarkers.R_TAM)/2;
    Lmarkers.l_ajc = (Lmarkers.L_FAL+Lmarkers.L_TAM)/2;
    Gaitparameters.right_stride_length = abs(Rmarkers.r_ajc(1,:,end) - Rmarkers.r_ajc(1,:,1));
    Gaitparameters.left_stride_length = abs(Lmarkers.l_ajc(1,:,end) - Lmarkers.l_ajc(1,:,1));
    if Rmarkers.r_ajc(1,:,end)>Lmarkers.l_ajc(1,:,end)
        Gaitparameters.right_step_length = Rmarkers.r_ajc(1,:,end) - Lmarkers.l_ajc(1,:,end);
        Gaitparameters.left_step_length = Lmarkers.l_ajc(1,:,end) - Rmarkers.r_ajc(1,:,1);
    else
        Gaitparameters.right_step_length = Rmarkers.r_ajc(1,:,end) - Lmarkers.l_ajc(1,:,1);
        Gaitparameters.left_step_length = Lmarkers.l_ajc(1,:,end) - Rmarkers.r_ajc(1,:,end);
    end
    Gaitparameters.step_width = abs(Rmarkers.r_ajc(3,:,end) - ...
            Lmarkers.l_ajc(3,:,end));

    % =====================================================================  
    % Timings
    % =====================================================================
    Gaitparameters.right_gait_cycle = (e.RHS(2) - e.RHS(1));
    Gaitparameters.left_gait_cycle = (e.LHS(2) - e.LHS(1));
    Gaitparameters.cadence = mean([(1/Gaitparameters.right_gait_cycle),...
        (1/Gaitparameters.left_gait_cycle)])*60*2;   
    Gaitparameters.mean_velocity = mean([(((Rmarkers.Cluster_Down_Right(1,:,end)+Rmarkers.Cluster_Down_Left(1,:,end))/2) - ...
        ((Rmarkers.Cluster_Down_Right(1,:,1)+Rmarkers.Cluster_Down_Left(1,:,1))/2))/Gaitparameters.right_gait_cycle, ...
        (((Lmarkers.Cluster_Down_Right(1,:,end)+Lmarkers.Cluster_Down_Left(1,:,end))/2) - ...
        ((Lmarkers.Cluster_Down_Right(1,:,1)+Lmarkers.Cluster_Down_Left(1,:,1))/2))/Gaitparameters.left_gait_cycle]);
% %     Gaitparameters.mean_velocity = mean([(((Rmarkers.R_IAS(1,:,end)+Rmarkers.L_IAS(1,:,end))/2) - ...
% %             ((Rmarkers.R_IAS(1,:,1)+Rmarkers.L_IAS(1,:,1))/2))/Gaitparameters.right_gait_cycle, ...
% %             (((Lmarkers.R_IAS(1,:,end)+Lmarkers.L_IAS(1,:,end))/2) - ...
% %             ((Lmarkers.R_IAS(1,:,1)+Lmarkers.L_IAS(1,:,1))/2))/Gaitparameters.left_gait_cycle]);

   
end