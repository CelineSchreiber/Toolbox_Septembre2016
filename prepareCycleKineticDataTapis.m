% =========================================================================
% REHAZENTER TOOLBOX
% =========================================================================
% File name:    prepareCycleKineticData
% -------------------------------------------------------------------------
% Subject:      Set kinetic data in the correct format
% -------------------------------------------------------------------------
% Inputs:       - Grf (structure)
%               - n1 (int)
%               - n2 (int)
%               - f2 (int)
%               - minusX (int)
%               - system (char)
% Outputs:      - Grf (structure)
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber, A. Naaim
% Date of creation: 26/03/2014
% Version: 1
% -------------------------------------------------------------------------
% Updates: - 16/12/2014 - Replace interpft by interp1 for reframing
%          - 16/12/2014 - Filt the data (Btw 2nd order, 15Hz, lowpass)
% =========================================================================

function Tapis = prepareCycleKineticData(Tapis,units,Gait,n1,n2,f2,minusX,system)

if ~isempty(Tapis)

    % =====================================================================
    % Remove analogs channel not associated to Tapis
    % =====================================================================
    names = fieldnames(Tapis);
    for i = 1:length(names)
        if ~strncmp(names{i},'TAPIS',5)
                Tapis = rmfield(Tapis, names{i});
                units = rmfield(units,names{i});
        end                
    end
    
    % =================================================================
    % Filt the data
    % =================================================================
    [B,A] = butter(2,15/(f2/2),'low');
    NewTapis.FZ1(:,1) = filtfilt(B,A,Tapis.TAPIS_FZ1(:,1));
    NewTapis.FZ2(:,1) = filtfilt(B,A,Tapis.TAPIS_FZ2(:,1));
    NewTapis.FZ3(:,1) = filtfilt(B,A,Tapis.TAPIS_FZ3(:,1));
    NewTapis.FZ4(:,1) = filtfilt(B,A,Tapis.TAPIS_FZ4(:,1));
    NewTapis.FX3_4(:,1) = filtfilt(B,A,Tapis.TAPIS_FX3_4(:,1));
    NewTapis.FX1_2(:,1) = filtfilt(B,A,Tapis.TAPIS_FX1_2(:,1));
    NewTapis.FY1_4(:,1) = filtfilt(B,A,Tapis.TAPIS_FY1_4(:,1));
    NewTapis.FY2_3(:,1) = filtfilt(B,A,Tapis.TAPIS_FY2_3(:,1));
    NewTapis.F1(:,1)=NewTapis.FZ1(:,1)+NewTapis.FZ4(:,1);
    NewTapis.F2(:,1)=NewTapis.FZ2(:,1)-NewTapis.FZ3(:,1);
    NewTapis.F=(NewTapis.F1+NewTapis.F2);
    NewTapis.COPX = (0.5*(NewTapis.F1-NewTapis.F2)+0.1*(NewTapis.FX1_2+NewTapis.FX3_4))./NewTapis.F;

    % % %     % =====================================================================
% % %     % Initialisation
% % %     % =====================================================================
% % %     k = (1:n2)';
% % %     ko = (linspace(1,n2,n1))';
% % % 
% % %     if length(Tapis) > 1 %(FP)
% % %         names = fieldnames(Tapis);
% % %     % =====================================================================
% % %     % Convert from mm to m for Qualisys data
% % %     % =====================================================================
% % %     
% % %         if strcmp(system,'Qualisys')
% % %             Tapis(1).M = Tapis(1).M*10^(-3);
% % %             Tapis(1).P = Tapis(1).P*10^(-3);
% % %             Tapis(2).M = Tapis(2).M*10^(-3);
% % %             Tapis(2).P = Tapis(2).P*10^(-3);
% % %         end
% % %         
% % %     % =====================================================================
% % %     % Modify the ICS to ISB format
% % %     % =====================================================================
% % %         if strcmp(system,'BTS')
% % %             % Forceplate 1
% % %             temp1 = Tapis(1).P(:,3);
% % %             temp2 = Tapis(1).P(:,2);
% % %             temp3 = -Tapis(1).P(:,1);
% % %             Tapis(1).P(:,1) = temp1;
% % %             Tapis(1).P(:,2) = temp2;
% % %             Tapis(1).P(:,3) = temp3;
% % %             temp1 = Tapis(1).F(:,3);
% % %             temp2 = Tapis(1).F(:,2);
% % %             temp3 = -Tapis(1).F(:,1);
% % %             Tapis(1).F(:,1) = temp1;
% % %             Tapis(1).F(:,2) = temp2;
% % %             Tapis(1).F(:,3) = temp3;
% % %             temp1 = Tapis(1).M(:,3);
% % %             temp2 = Tapis(1).M(:,2);
% % %             temp3 = -Tapis(1).M(:,1);
% % %             Tapis(1).M(:,1) = temp1;
% % %             Tapis(1).M(:,2) = temp2;
% % %             Tapis(1).M(:,3) = temp3;
% % %             % Forceplate 2
% % %             temp1 = Tapis(2).P(:,3);
% % %             temp2 = Tapis(2).P(:,2);
% % %             temp3 = -Tapis(2).P(:,1);
% % %             Tapis(2).P(:,1) = temp1;
% % %             Tapis(2).P(:,2) = temp2;
% % %             Tapis(2).P(:,3) = temp3;
% % %             temp1 = Tapis(2).F(:,3);
% % %             temp2 = Tapis(2).F(:,2);
% % %             temp3 = -Tapis(2).F(:,1);
% % %             Tapis(2).F(:,1) = temp1;
% % %             Tapis(2).F(:,2) = temp2;
% % %             Tapis(2).F(:,3) = temp3;
% % %             temp1 = Tapis(2).M(:,3);
% % %             temp2 = Tapis(2).M(:,2);
% % %             temp3 = -Tapis(2).M(:,1);
% % %             Tapis(2).M(:,1) = temp1;
% % %             Tapis(2).M(:,2) = temp2;
% % %             Tapis(2).M(:,3) = temp3;    
% % %         elseif strcmp(system,'Qualisys')
% % %             % Forceplate 1    
% % %             temp1 = Tapis(1).P(:,1);
% % %             temp2 = Tapis(1).P(:,3);
% % %             temp3 = -Tapis(1).P(:,2);
% % %             Tapis(1).P(:,1) = temp1;
% % %             Tapis(1).P(:,2) = temp2;
% % %             Tapis(1).P(:,3) = temp3;
% % %             temp1 = Tapis(1).F(:,1);
% % %             temp2 = Tapis(1).F(:,3);
% % %             temp3 = -Tapis(1).F(:,2);
% % %             Tapis(1).F(:,1) = temp1;
% % %             Tapis(1).F(:,2) = temp2;
% % %             Tapis(1).F(:,3) = temp3;
% % %             temp1 = Tapis(1).M(:,1);
% % %             temp2 = Tapis(1).M(:,3);
% % %             temp3 = -Tapis(1).M(:,2);
% % %             Tapis(1).M(:,1) = temp1;
% % %             Tapis(1).M(:,2) = temp2;
% % %             Tapis(1).M(:,3) = temp3;
% % %             % Forceplate 2    
% % %             temp1 = Tapis(2).P(:,1);
% % %             temp2 = Tapis(2).P(:,3);
% % %             temp3 = -Tapis(2).P(:,2);
% % %             Tapis(2).P(:,1) = temp1;
% % %             Tapis(2).P(:,2) = temp2;
% % %             Tapis(2).P(:,3) = temp3;
% % %             temp1 = Tapis(2).F(:,1);
% % %             temp2 = Tapis(2).F(:,3);
% % %             temp3 = -Tapis(2).F(:,2);
% % %             Tapis(2).F(:,1) = temp1;
% % %             Tapis(2).F(:,2) = temp2;
% % %             Tapis(2).F(:,3) = temp3;
% % %             temp1 = Tapis(2).M(:,1);
% % %             temp2 = Tapis(2).M(:,3);
% % %             temp3 = -Tapis(2).M(:,2);
% % %             Tapis(2).M(:,1) = temp1;
% % %             Tapis(2).M(:,2) = temp2;
% % %             Tapis(2).M(:,3) = temp3;    
% % %         end
% % % 
% % %         % =================================================================
% % %         % Convert -X direction data to +X direction data
% % %         % =================================================================
% % % %         for i=1:length(names)
% % % %             for j=1:2
% % % %                 Grf(j).(names{i})(:,1) = minusX*Grf(j).(names{i})(:,1);
% % % %                 Grf(j).(names{i})(:,3) = minusX*Grf(j).(names{i})(:,3);
% % % %             end
% % % %         end
% % %         
% % %         Tapis(1).P(:,1) = minusX*Tapis(1).P(:,1);
% % %         Tapis(1).P(:,3) = minusX*Tapis(1).P(:,3);
% % %         Tapis(1).F(:,1) = minusX*Tapis(1).F(:,1);
% % %         Tapis(1).F(:,3) = minusX*Tapis(1).F(:,3);
% % %         Tapis(1).M(:,1) = minusX*Tapis(1).M(:,1);
% % %         Tapis(1).M(:,3) = minusX*Tapis(1).M(:,3);
% % %         Tapis(2).P(:,1) = minusX*Tapis(2).P(:,1);
% % %         Tapis(2).P(:,3) = minusX*Tapis(2).P(:,3);
% % %         Tapis(2).F(:,1) = minusX*Tapis(2).F(:,1);
% % %         Tapis(2).F(:,3) = minusX*Tapis(2).F(:,3);
% % %         Tapis(2).M(:,1) = minusX*Tapis(2).M(:,1);
% % %         Tapis(2).M(:,3) = minusX*Tapis(2).M(:,3);

        

        % =================================================================
        % Apply a 10N threshold
        % =================================================================
        threshold = 10;
        for i = 1:n2
            if Tapis(1).F(i,2) < threshold;
                Tapis(1).P(i,:) = zeros(1,3);
                Tapis(1).F(i,:) = zeros(1,3);
                Tapis(1).M(i,:) = zeros(1,3);
            end
            if Tapis(2).F(i,2) < threshold;
                Tapis(2).P(i,:) = zeros(1,3);
                Tapis(2).F(i,:) = zeros(1,3);
                Tapis(2).M(i,:) = zeros(1,3);
            end
        end

        % =================================================================
        % Interpolate data
        % =================================================================
        if ~isnan(mean(Tapis(1).F(1,:,:)))
            Tapis(1).P = interp1(k,Tapis(1).P,ko,'spline');
            Tapis(1).F = interp1(k,Tapis(1).F,ko,'spline');
            Tapis(1).M = interp1(k,Tapis(1).M,ko,'spline');
        end
        if ~isnan(mean(Tapis(2).F(1,:,:)))
            Tapis(2).P = interp1(k,Tapis(2).P,ko,'spline');
            Tapis(2).F = interp1(k,Tapis(2).F,ko,'spline');
            Tapis(2).M = interp1(k,Tapis(2).M,ko,'spline');
        end

        % =================================================================
        % Store markers as 3-array vectors
        % =================================================================
        Tapis(1).P = permute(Tapis(1).P,[2,3,1]);
        Tapis(1).F = permute(Tapis(1).F,[2,3,1]);
        Tapis(1).M = permute(Tapis(1).M,[2,3,1]);
        Tapis(2).P = permute(Tapis(2).P,[2,3,1]);
        Tapis(2).F = permute(Tapis(2).F,[2,3,1]);
        Tapis(2).M = permute(Tapis(2).M,[2,3,1]);
    end

end