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

function Gaitparameters = gaitParameters(Rmarkers,Lmarkers,Rvmarkers,Lvmarkers,Gait,e,Session)

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
Gaitparameters.right_stride_length = Rvmarkers.r_ajc(1,:,end) - Rvmarkers.r_ajc(1,:,1);
Gaitparameters.left_stride_length = Lvmarkers.l_ajc(1,:,end) - Lvmarkers.l_ajc(1,:,1);
if Rvmarkers.r_ajc(1,:,end)>Lvmarkers.l_ajc(1,:,end)
    Gaitparameters.right_step_length = Rvmarkers.r_ajc(1,:,end) - Lvmarkers.l_ajc(1,:,end);
    Gaitparameters.left_step_length = Lvmarkers.l_ajc(1,:,end) - Rvmarkers.r_ajc(1,:,1);
else
    Gaitparameters.right_step_length = Rvmarkers.r_ajc(1,:,end) - Lvmarkers.l_ajc(1,:,1);
    Gaitparameters.left_step_length = Lvmarkers.l_ajc(1,:,end) - Rvmarkers.r_ajc(1,:,end);
end
Gaitparameters.step_width = abs(Rvmarkers.r_ajc(3,:,end) - ...
        -Lvmarkers.l_ajc(3,:,end));

% =====================================================================  
% Timings
% =====================================================================
Gaitparameters.right_gait_cycle = (e.RHS(2) - e.RHS(1));
Gaitparameters.left_gait_cycle = (e.LHS(2) - e.LHS(1));
Gaitparameters.cadence = mean([(1/Gaitparameters.right_gait_cycle),...
    (1/Gaitparameters.left_gait_cycle)])*60*2;   
if ~strcmp(Session.markersset,'Aucun')
    if strcmp(Session.system,'BTS')
        Gaitparameters.mean_velocity = mean([(Rmarkers.sacrum(1,:,end) - ...
            Rmarkers.sacrum(1,:,1))/Gaitparameters.right_gait_cycle, ...
            (Lmarkers.sacrum(1,:,end) - Lmarkers.sacrum(1,:,1))/Gaitparameters.left_gait_cycle]);
    elseif strcmp(Session.system,'Qualisys')
        Gaitparameters.mean_velocity = mean([(((Rmarkers.R_IAS(1,:,end)+Rmarkers.L_IAS(1,:,end))/2) - ...
            ((Rmarkers.R_IAS(1,:,1)+Rmarkers.L_IAS(1,:,1))/2))/Gaitparameters.right_gait_cycle, ...
            (((Lmarkers.R_IAS(1,:,end)+Lmarkers.L_IAS(1,:,end))/2) - ...
            ((Lmarkers.R_IAS(1,:,1)+Lmarkers.L_IAS(1,:,1))/2))/Gaitparameters.left_gait_cycle]);
    end
    L0=(Session.right_leg_length+Session.right_leg_length)/2;
    Gaitparameters.mean_velocity_adim=Gaitparameters.mean_velocity/L0;
end

if Gaitparameters.mean_velocity<0.06 %TAPIS!!!
    if e.LHS(1) < e.RHS(1)
        T2R = round((e.RTO(2)-e.RHS(1))*Session.fpoint)-10;
        T2L = round((e.LTO(1)-e.LHS(1))*Session.fpoint)-10;
    elseif e.LHS(1) > e.RHS(1)
        T2R = round((e.RTO(1)-e.RHS(1))*Session.fpoint)-10;
        T2L = round((e.LTO(2)-e.LHS(1))*Session.fpoint)-10;
    end
    Gaitparameters.mean_velocity = mean([(((Rmarkers.R_FM1(1,:,11)+Rmarkers.R_FM5(1,:,11))/2) - ...
            ((Rmarkers.R_FM1(1,:,T2R)+Rmarkers.R_FM5(1,:,T2R))/2))/((T2R-11)/Session.fpoint), ...
            (((Lmarkers.L_FM1(1,:,11)+Lmarkers.L_FM5(1,:,11))/2) - ...
            ((Lmarkers.L_FM1(1,:,T2L)+Lmarkers.L_FM5(1,:,T2L))/2))/((T2L-11)/Session.fpoint)]);
    Gaitparameters.mean_velocity_adim=Gaitparameters.mean_velocity/L0;    
end