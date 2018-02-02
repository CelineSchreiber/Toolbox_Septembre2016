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

function Gaitparameters = initialisationGaitParameters()

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

