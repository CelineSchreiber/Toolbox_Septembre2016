% =========================================================================
% REHAZENTER TOOLBOX
% =========================================================================
% File name:    prepareCycleEmgData
% -------------------------------------------------------------------------
% Subject:      EMG signal treatment (offset, filtering, ...)
% -------------------------------------------------------------------------
% Inputs:       - Info (structure)
%               - Emg (structure)
%               - Gait (structure)
%               - f2 (int)
%               - side (char)
%               - system (char)
% Outputs:      - Emg (structure)
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber, A. Naaim
% Date of creation: 26/03/2014
% Version: 1
% -------------------------------------------------------------------------
% Updates: - 
% =========================================================================

function Info = prepareStaticEmgData(Info,Emg,units,n)

    % =====================================================================
    % Remove analogs channel not associated to EMG
    % =====================================================================
    names = fieldnames(Emg);
    for i = 1:length(names)
        if strcmp(names{i},'Nothing')
            Emg = rmfield(Emg, names{i});
            units = rmfield(units,names{i});
        end
        if strcmp(names{i},'Sync')
            Emg = rmfield(Emg, names{i});
            units = rmfield(units,names{i});
        end
    end
    names = fieldnames(Emg);
    for i = 1:length(names)
        if strncmp(names{i},'FP',2)
            Emg = rmfield(Emg, names{i});
            units = rmfield(units,names{i});
        end
        if strncmp(names{i},'PF',2)
            Emg = rmfield(Emg, names{i});
            units = rmfield(units,names{i});
        end
        if strncmp(names{i},'TAPIS',5)
            Emg = rmfield(Emg, names{i});
            units = rmfield(units,names{i});
        end
        if strncmp(names{i},'FSW',3)
            Emg = rmfield(Emg, names{i});
            units = rmfield(units,names{i});
        end
    end
    names = fieldnames(Emg);
    for i = 1:length(names)
        if strfind(names{i},'Channel')
            Emg = rmfield(Emg, names{i});
            units = rmfield(units,names{i});
        end
    end
    names = fieldnames(Emg);
    for i = 1:length(names)
        if strfind(names{i},'Amti')
            Emg = rmfield(Emg, names{i});
            units = rmfield(units,names{i});
        end
    end

    % =====================================================================
    % Rename fields
    % Modifié le 05/08 pour tenir compte de différents nomd pour les EMG
    % dans le c3d
    % =====================================================================
    names = fieldnames(Emg);
    for i=1:length(names)
        if ~strcmp(Info.channel{i},'none')
            Emg = setfield(Emg,Info.channel{i},permute(Emg.(names{i}),[2,3,1]));
            units = setfield(units,Info.channel{i},units.(names{i}));
        end
        Emg = rmfield(Emg,names{i}); 
        units = rmfield(units,names{i});
    end
            
    % =====================================================================
    % Rectify, filt and interpolate
    % =====================================================================
    % Walter et al.
    % Muscle Synergies May Improve Optimization Prediction of Knee Contact 
    % Forces During Walking
    % Journal of Biomechanical Engineering, 136:021031, 2014
    % =====================================================================
    f2=Info.fanalog;
    names = fieldnames(Emg);
    for i=1:length(names)
        if strcmp(units.(names{i}),'mV')
            Emg.(names{i})= Emg.(names{i})*10^(-3);
        end      
        temp = permute(Emg.(names{i}),[3,1,2]);
        % Remove offset
        temp0 = temp-mean(temp);
        % Band-pass filtering of the EMG signals at 30–300 Hz
        % (2th order Butterworth filter)
        [B,A] = butter(2,[30/(f2/2) 300/(f2/2)],'bandpass');
        temp1 = filtfilt(B,A,temp0);
        % Rectify and low-pass filtering of the EMG signals at 6Hz
        % (4th order Butterworth filter)
        [B,A] = butter(4,6/(f2/2),'low');
        temp2 = filtfilt(B,A,abs(temp1));            
        % Export data
        Emg.([names{i},'_raw']) = permute(temp1,[2,3,1]);
        Emg.([names{i},'_cycle_filt']) = permute(temp2,[2,3,1]);
    end
    
    % =====================================================================
    % MVC
    % =====================================================================
    if ~isempty(strfind(Info.Static(n).condition,'Right_Quadriceps'))
        Info.Static(n).MVC.right_vastus_medialis_cycle_filt = max(Emg.right_vastus_medialis_cycle_filt); 
        Info.Static(n).MVC.right_rectus_femoris_cycle_filt = max(Emg.right_rectus_femoris_cycle_filt);
    elseif ~isempty(strfind(Info.Static(n).condition,'Left_Quadriceps'))
        Info.Static(n).MVC.left_vastus_medialis_cycle_filt = max(Emg.left_vastus_medialis_cycle_filt); 
        Info.Static(n).MVC.left_rectus_femoris_cycle_filt = max(Emg.left_rectus_femoris_cycle_filt);
    end