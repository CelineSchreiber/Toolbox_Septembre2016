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

function Emg = prepareCycleEmgData(Info,Emg,units,Gait,f2,side,system)

if strcmp(Gait.emgtrial,'yes')

    % =====================================================================
    % Remove analogs channel not associated to EMG
    % =====================================================================
    names = fieldnames(Emg);
    if strcmp(system,'BTS')
        for i = 1:min(12,length(names)) % first 12 channels are forceplate data
            if isempty(strfind(names{i},'EMG'))
                Emg = rmfield(Emg, names{i});
                units = rmfield(units,names{i});
            end
        end
        names = fieldnames(Emg);
        for i = 1:length(names)
            if (isempty(strfind(names{i},'Left')) && isempty(strfind(names{i},'Right')))
                Emg = rmfield(Emg, names{i});
                units = rmfield(units,names{i});
            end
        end     
    elseif strcmp(system,'Qualisys')
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
    end

    % =====================================================================
    % Rename fields
    % =====================================================================
    names = fieldnames(Emg);
    if length(names) > 8 && strcmp(Info.channel{1},'none') && ...
            strcmp(Info.channel{2},'none') && ...
            strcmp(Info.channel{3},'none') && ...
            strcmp(Info.channel{4},'none') && ...
            strcmp(Info.channel{5},'none') && ...
            strcmp(Info.channel{6},'none') && ...
            strcmp(Info.channel{7},'none') && ...
            strcmp(Info.channel{8},'none')
        for j = 1:8
            Emg = rmfield(Emg,names{j});
            units = rmfield(units,names{j});
        end
    end
    names = fieldnames(Emg);
    j = 0;
    for i = 1:16
        if length(names) == 16
            if ~strcmp(Info.channel{i},'none')
                Emg = setfield(Emg,Info.channel{i},permute(eval(['Emg.',names{i},';']),[2,3,1]));
                units = setfield(units,Info.channel{i},eval(['units.',names{i},';']));
            end
        else
            if ~strcmp(Info.channel{i},'none')
                j = j+1;
                Emg = setfield(Emg,Info.channel{i},permute(eval(['Emg.',names{j},';']),[2,3,1]));
                units = setfield(units,Info.channel{i},eval(['units.',names{j},';']));
            end
        end
    end
    for i = 1:length(names)
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
    names = fieldnames(Emg);
    for i=1:length(names)
        if eval(['strcmp(units.',names{i},',''mV'')'])
            eval(['Emg.',names{i},'= Emg.',names{i},'*10^(-3);']);
        end
    end        
    if strcmp(side,'Right')    
        for i = 1:length(names)
            if strfind(names{i},'right_')
                temp = permute(eval(['Emg.',names{i},';']),[3,1,2]);
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
                eval(['Emg.',names{i},'_raw = permute(temp1,[2,3,1]);']);
                eval(['Emg.',names{i},'_cycle_filt = permute(temp2,[2,3,1]);']);
            else
                Emg = rmfield(Emg,names{i});
            end
        end    
    elseif strcmp(side,'Left')    
        for i = 1:length(names)
            if strfind(names{i},'left_')                        
                temp = permute(eval(['Emg.',names{i},';']),[3,1,2]);
                % Remove offset
                temp0 = temp-mean(temp);
                % Band-pass filtering of the EMG signals at 30–300 Hz
                % (4th order Butterworth filter)
                [B,A] = butter(4,[30/(f2/2) 300/(f2/2)],'bandpass');
                temp1 = filtfilt(B,A,temp0);
                % Rectify and low-pass filtering of the EMG signals at 6Hz
                % (4th order Butterworth filter)
                [B,A] = butter(4,6/(f2/2),'low');
                temp2 = filtfilt(B,A,abs(temp1));            
                % Export data
                eval(['Emg.',names{i},'_raw = permute(temp1,[2,3,1]);']);
                eval(['Emg.',names{i},'_cycle_filt = permute(temp2,[2,3,1]);']);
            else
                Emg = rmfield(Emg,names{i});
            end
        end    
    end

else
   Emg = [];
end