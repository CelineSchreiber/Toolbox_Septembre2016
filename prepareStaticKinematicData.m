% =========================================================================
% REHAZENTER TOOLBOX
% =========================================================================
% File name:    prepareStaticKinematicData
% -------------------------------------------------------------------------
% Subject:      Set kinematic data in the correct format
% -------------------------------------------------------------------------
% Inputs:       - Markers (structure)
%               - static (btk)
%               - n (int)
%               - system (char)
% Outputs:      - Markers (structure)
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber, A. Naaim
% Date of creation: 26/03/2014
% Version: 1
% -------------------------------------------------------------------------
% Updates: - 
% =========================================================================

function Markers = prepareStaticKinematicData(Markers,static,n,system)

names = fieldnames(Markers);
for i = 1:size(names,1)
    
% =========================================================================    
% Modify the ICS from ZXY to XYZ for BTS data
% =========================================================================
    if strcmp(system,'BTS')
        temp1 = Markers.(names{i})(:,3);
        temp2 = Markers.(names{i})(:,1);
        temp3 = Markers.(names{i})(:,2);
        Markers.(names{i})(:,1) = temp1;
        Markers.(names{i})(:,2) = temp2;
        Markers.(names{i})(:,3) = temp3;
    end

    if strcmp(system,'Fukuchi')
        temp1 = Markers.(names{i})(:,1);
        temp2 = -Markers.(names{i})(:,3);
        temp3 = Markers.(names{i})(:,2);
        Markers.(names{i})(:,1) = temp1;
        Markers.(names{i})(:,2) = temp2;
        Markers.(names{i})(:,3) = temp3;
    end
% =========================================================================
% Convert from mm to m
% =========================================================================
    if strcmp(btkGetPointsUnit(static,'marker'),'mm')
        Markers.(names{i}) = Markers.(names{i})*10^(-3);
    end
    
% =========================================================================    
% Replace [0 0 0] position by NaN during static trial
% =========================================================================
    for j = 1:n
        if Markers.(names{i})(j,:) == [0 0 0];
            Markers.(names{i})(j,:) = nan(1,3);
        end
    end

% =========================================================================
% Compute mean position of each marker during static trial
% =========================================================================
    Markers.(names{i}) = nanmean(Markers.(names{i}));

% =========================================================================
% Store Markers as 3-array vectors
% =========================================================================
    Markers.(names{i}) = permute(Markers.(names{i}),[2,3,1]);
    
end