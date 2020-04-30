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

function Emg = prepareCycleEmgData(Info,Emg,units,f2,side,system)

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
        names = fieldnames(Emg);
        for i = 1:length(names)
            if strfind(names{i},'Optogait')
                Emg = rmfield(Emg, names{i});
                units = rmfield(units,names{i});
            end
        end
    end

    
    % =====================================================================
    % Rename fields
    % Modifié le 05/08 pour tenir compte de différents nomd pour les EMG
    % dans le c3d
    % =====================================================================
    names = fieldnames(Emg);
    if strcmp(system,'BTS')
        i=1;
        for j=1:16
            if ~strcmp(Info.channel{j},'none')
                Emg = setfield(Emg,Info.channel{j},permute(Emg.(names{i}),[2,3,1]));
                units = setfield(units,Info.channel{j},units.(names{i}));
                Emg = rmfield(Emg,names{i}); 
                units = rmfield(units,names{i});
                i=i+1;
            end
        end
    elseif strcmp(system,'Qualisys')
        for i=1:length(names)
            if ~strcmp(Info.channel{i},'none')
                Emg = setfield(Emg,Info.channel{i},permute(Emg.(names{i}),[2,3,1]));
                units = setfield(units,Info.channel{i},units.(names{i}));
            end
            Emg = rmfield(Emg,names{i}); 
            units = rmfield(units,names{i});
        end
    end
            
%     names = fieldnames(Emg);
%     for i = 1:length(Info.channel)
%         if ~strcmp(Info.channel{i},'none')
%             for j=1:length(names)
%                 if ~isempty(strfind(names{j},num2str(i)))
%                     Emg = setfield(Emg,Info.channel{i},permute(eval(['Emg.',names{j},';']),[2,3,1]));
%                     units = setfield(units,Info.channel{i},eval(['units.',names{j},';']));
%                     Emg = rmfield(Emg,names{j}); 
%                     units = rmfield(units,names{j});
%                     break
%                 end
%             end
%             names = fieldnames(Emg);
%         end
%     end

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
        if strcmp(units.(names{i}),'mV')
            Emg.(names{i})= Emg.(names{i})*10^(-3);
        end
    end        
    if strcmp(side,'Right')    
        for i = 1:length(names)
            if strfind(names{i},'right_')
                if strfind(names{i},'wire')
                    temp = permute(Emg.(names{i}),[3,1,2]);
                    % Remove offset
                    temp0 = temp-mean(temp);
                    % Band-pass filtering of the EMG signals at 30–300 Hz
                    % (2th order Butterworth filter)
                    [B,A] = butter(2,[60/(f2/2) 300/(f2/2)],'bandpass');
                    temp1 = filtfilt(B,A,temp0);
                    % Rectify and low-pass filtering of the EMG signals at 6Hz
                    % (4th order Butterworth filter)
                    [B,A] = butter(4,6/(f2/2),'low');
                    temp2 = filtfilt(B,A,abs(temp1));            
                    % Export data
                    Emg.([names{i},'_raw']) = permute(temp1,[2,3,1]);
                    Emg.([names{i},'_cycle_filt']) = permute(temp2,[2,3,1]);
                else
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
            else
                Emg = rmfield(Emg,names{i});
            end
        end    
    elseif strcmp(side,'Left')    
        for i = 1:length(names)
            if strfind(names{i},'left_')                        
                if strfind(names{i},'wire')
                    temp = permute(Emg.(names{i}),[3,1,2]);
                    % Remove offset
                    temp0 = temp-mean(temp);
                    % Band-pass filtering of the EMG signals at 30–300 Hz
                    % (2th order Butterworth filter)
                    [B,A] = butter(2,[60/(f2/2) 300/(f2/2)],'bandpass');
                    temp1 = filtfilt(B,A,temp0);
                    % Rectify and low-pass filtering of the EMG signals at 6Hz
                    % (4th order Butterworth filter)
                    [B,A] = butter(4,6/(f2/2),'low');
                    temp2 = filtfilt(B,A,abs(temp1));            
                    % Export data
                    Emg.([names{i},'_raw']) = permute(temp1,[2,3,1]);
                    Emg.([names{i},'_cycle_filt']) = permute(temp2,[2,3,1]);
                else
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
            else
                Emg = rmfield(Emg,names{i});
            end
        end    
    end