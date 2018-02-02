% =========================================================================
% REHAZENTER TOOLBOX
% =========================================================================
% File name:    prepareCycleKinematicData
% -------------------------------------------------------------------------
% Subject:      Set kinematic data in the correct format
% -------------------------------------------------------------------------
% Inputs:       - Markers (structure)
%               - Gait (structure)
%               - n (int)
%               - f (int)
%               - system (char)
% Outputs:      - Markers (structure)
%               - minusX (int)
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber, A. Naaim
% Date of creation: 26/03/2014
% Version: 1
% -------------------------------------------------------------------------
% Updates: - 20/09/2016
% =========================================================================

function [Markers,minusX] = prepareCycleKinematicData(Markers,Gait,n,f,system)

% =========================================================================
% Initialisation
% =========================================================================
names = fieldnames(Markers);
minusX = 1; % gait direction (+X:1, -X:-1) 

if ~isempty(Markers)

    % =====================================================================
    % Remove empty markers
    % =====================================================================
    toremove = [];
    for i = 1:size(names,1)
        test = Markers.(names{i});
        if isempty(test)
            toremove = [toremove i];
        end
    end
    for i = 1:length(toremove)
        Markers = rmfield(Markers,Markers.(names{toremove(i)}));
    end

    % =====================================================================
    % Set correct format for all markers
    % =====================================================================
    for i = 1:size(names,1)    

        % Modify the ICS from BTS to ISB format
        % -----------------------------------------------------------------
        if strcmp(system,'BTS')
            temp1 = Markers.(names{i})(:,3);
            temp2 = Markers.(names{i})(:,2);
            temp3 = -Markers.(names{i})(:,1);
            Markers.(names{i})(:,1) = temp1;
            Markers.(names{i})(:,2) = temp2;
            Markers.(names{i})(:,3) = temp3;
        end

        % Modify the ICS from Qualisys to ISB format
        % -----------------------------------------------------------------
        if strcmp(system,'Qualisys')
            temp1 = Markers.(names{i})(:,1);
            temp2 = Markers.(names{i})(:,3);
            temp3 = -Markers.(names{i})(:,2);
            Markers.(names{i})(:,1) = temp1;
            Markers.(names{i})(:,2) = temp2;
            Markers.(names{i})(:,3) = temp3;
        end 
    end

    % =====================================================================
    % Convert -X direction data to +X direction data
    % "+100" to avoid troubles with negative coordinates
    % =====================================================================
    minusX = 1; % gait direction (+X:1, -X:-1) 
    if strcmp(system,'BTS')
        if (Markers.sacrum(end-100,1)+100) - (Markers.sacrum(1+100,1)+100) < 0
            for i = 1:size(names,1)
                Markers.(names{i})(:,1) = -Markers.(names{i})(:,1);
                Markers.(names{i})(:,3) = -Markers.(names{i})(:,3);
            end
            minusX = -1;
        end
    end
    if strcmp(system,'Qualisys')
        if isfield(Markers,'R_IAS')
            s=sum(Markers.R_IPS,2);
            ind=find(s>0);        
            if (Markers.R_IAS(ind(end)-100,1)+100) - (Markers.R_IPS(ind(1),1)+100) < 0    %(Markers.R_IPS(end-100,1)+100) - (Markers.R_IPS(1,1)+100) < 0
                for i = 1:size(names,1)  
                    Markers.(names{i})(:,1) = -Markers.(names{i})(:,1);
                    Markers.(names{i})(:,3) = -Markers.(names{i})(:,3);
                end
                minusX = -1;
            end
        elseif isfield(Markers,'R_FM5') && isfield(Markers,'R_FCC') % pas juste?
            s=sum(Markers.R_FCC,2).^2;
            ind=find(s>0);        
            if (Markers.R_FM5(round((ind(1)+ind(end))/2),1)+100) - (Markers.R_FCC(round((ind(1)+ind(end))/2),1)+100) < 0    %(Markers.R_IPS(end-100,1)+100) - (Markers.R_IPS(1,1)+100) < 0
                for i = 1:size(names,1)   
                    Markers.(names{i})(:,1) = -Markers.(names{i})(:,1);
                    Markers.(names{i})(:,3) = -Markers.(names{i})(:,3);
                end
                minusX = -1;
            end
        end
    end

    % =====================================================================
    % Set correct format for all markers
    % =====================================================================
    for i = 1:size(names,1)  

        % Convert from mm to m
        % -----------------------------------------------------------------
        if strcmp(btkGetPointsUnit(Gait.file,'marker'),'mm')
           Markers.(names{i}) = Markers.(names{i})*10^(-3);
        end

        % Replace [0 0 0] position by NaN
        % -----------------------------------------------------------------
        for j = 1:n
            if Markers.(names{i})(j,:) == [0 0 0];
                Markers.(names{i})(j,:) = nan(1,3);
            end
        end

        % Interpolate and filt data
        % -----------------------------------------------------------------
        [B,A] = butter(4,6/(f/2),'low');
        x = 1:n;
        y = Markers.(names{i});
        xx = 1:1:n;
        temp = interp1(x,y,xx,'spline');
        Markers.(names{i}) = filtfilt(B,A,temp);
        
        % Store Markers as 3-array vectors
        % -----------------------------------------------------------------
        Markers.(names{i}) = permute(Markers.(names{i}),[2,3,1]);


    end

end