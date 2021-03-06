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

function Grf = prepareCycleKineticData(Grf,Gait,n1,n2,f2,minusX,system)

if ~isempty(Grf)

    % =====================================================================
    % Initialisation
    % =====================================================================
    k = (1:n2)';
    ko = (linspace(1,n2,n1))';

    if length(Grf) > 1 %(FP)
        names = fieldnames(Grf);
    % =====================================================================
    % Convert from mm to m for Qualisys data
    % =====================================================================
    
        if strcmp(system,'Qualisys')
            Grf(1).M = Grf(1).M*10^(-3);
            Grf(1).P = Grf(1).P*10^(-3);
            Grf(2).M = Grf(2).M*10^(-3);
            Grf(2).P = Grf(2).P*10^(-3);
        end
        
    % =====================================================================
    % Modify the ICS to ISB format
    % =====================================================================
        if strcmp(system,'BTS')
            % Forceplate 1
            temp1 = Grf(1).P(:,3);
            temp2 = Grf(1).P(:,2);
            temp3 = -Grf(1).P(:,1);
            Grf(1).P(:,1) = temp1;
            Grf(1).P(:,2) = temp2;
            Grf(1).P(:,3) = temp3;
            temp1 = Grf(1).F(:,3);
            temp2 = Grf(1).F(:,2);
            temp3 = -Grf(1).F(:,1);
            Grf(1).F(:,1) = temp1;
            Grf(1).F(:,2) = temp2;
            Grf(1).F(:,3) = temp3;
            temp1 = Grf(1).M(:,3);
            temp2 = Grf(1).M(:,2);
            temp3 = -Grf(1).M(:,1);
            Grf(1).M(:,1) = temp1;
            Grf(1).M(:,2) = temp2;
            Grf(1).M(:,3) = temp3;
            % Forceplate 2
            temp1 = Grf(2).P(:,3);
            temp2 = Grf(2).P(:,2);
            temp3 = -Grf(2).P(:,1);
            Grf(2).P(:,1) = temp1;
            Grf(2).P(:,2) = temp2;
            Grf(2).P(:,3) = temp3;
            temp1 = Grf(2).F(:,3);
            temp2 = Grf(2).F(:,2);
            temp3 = -Grf(2).F(:,1);
            Grf(2).F(:,1) = temp1;
            Grf(2).F(:,2) = temp2;
            Grf(2).F(:,3) = temp3;
            temp1 = Grf(2).M(:,3);
            temp2 = Grf(2).M(:,2);
            temp3 = -Grf(2).M(:,1);
            Grf(2).M(:,1) = temp1;
            Grf(2).M(:,2) = temp2;
            Grf(2).M(:,3) = temp3;    
        elseif strcmp(system,'Qualisys')
            % Forceplate 1    
            temp1 = Grf(1).P(:,1);
            temp2 = Grf(1).P(:,3);
            temp3 = -Grf(1).P(:,2);
            Grf(1).P(:,1) = temp1;
            Grf(1).P(:,2) = temp2;
            Grf(1).P(:,3) = temp3;
            temp1 = Grf(1).F(:,1);
            temp2 = Grf(1).F(:,3);
            temp3 = -Grf(1).F(:,2);
            Grf(1).F(:,1) = temp1;
            Grf(1).F(:,2) = temp2;
            Grf(1).F(:,3) = temp3;
            temp1 = Grf(1).M(:,1);
            temp2 = Grf(1).M(:,3);
            temp3 = -Grf(1).M(:,2);
            Grf(1).M(:,1) = temp1;
            Grf(1).M(:,2) = temp2;
            Grf(1).M(:,3) = temp3;
            % Forceplate 2    
            temp1 = Grf(2).P(:,1);
            temp2 = Grf(2).P(:,3);
            temp3 = -Grf(2).P(:,2);
            Grf(2).P(:,1) = temp1;
            Grf(2).P(:,2) = temp2;
            Grf(2).P(:,3) = temp3;
            temp1 = Grf(2).F(:,1);
            temp2 = Grf(2).F(:,3);
            temp3 = -Grf(2).F(:,2);
            Grf(2).F(:,1) = temp1;
            Grf(2).F(:,2) = temp2;
            Grf(2).F(:,3) = temp3;
            temp1 = Grf(2).M(:,1);
            temp2 = Grf(2).M(:,3);
            temp3 = -Grf(2).M(:,2);
            Grf(2).M(:,1) = temp1;
            Grf(2).M(:,2) = temp2;
            Grf(2).M(:,3) = temp3;    
        end

        % =================================================================
        % Convert -X direction data to +X direction data
        % =================================================================
%         for i=1:length(names)
%             for j=1:2
%                 Grf(j).(names{i})(:,1) = minusX*Grf(j).(names{i})(:,1);
%                 Grf(j).(names{i})(:,3) = minusX*Grf(j).(names{i})(:,3);
%             end
%         end
        
        Grf(1).P(:,1) = minusX*Grf(1).P(:,1);
        Grf(1).P(:,3) = minusX*Grf(1).P(:,3);
        Grf(1).F(:,1) = minusX*Grf(1).F(:,1);
        Grf(1).F(:,3) = minusX*Grf(1).F(:,3);
        Grf(1).M(:,1) = minusX*Grf(1).M(:,1);
        Grf(1).M(:,3) = minusX*Grf(1).M(:,3);
        Grf(2).P(:,1) = minusX*Grf(2).P(:,1);
        Grf(2).P(:,3) = minusX*Grf(2).P(:,3);
        Grf(2).F(:,1) = minusX*Grf(2).F(:,1);
        Grf(2).F(:,3) = minusX*Grf(2).F(:,3);
        Grf(2).M(:,1) = minusX*Grf(2).M(:,1);
        Grf(2).M(:,3) = minusX*Grf(2).M(:,3);

        % =================================================================
        % Filt the data
        % =================================================================
        [B,A] = butter(2,15/(f2/2),'low');
        for i=1:2
            for j=1:3
                I=find(isnan(Grf(i).M(:,j)));
                if ~isempty(I)
                    ind=group(I);
                    for l=1:length(ind)/2
                        if ind(2*l-1)==1
                            Grf(i).M(ind(2*l-1):ind(2*l),j)=Grf(i).M(ind(2*l)+1,j);
                        elseif ind(2*l)==length(Grf(i).M(:,j))
                            Grf(i).M(ind(2*l-1):ind(2*l),j)=Grf(i).M(ind(2*l-1)-1,j);
                        else
                            Grf(i).M(ind(2*l-1):ind(2*l),j)=(Grf(i).M(ind(2*l-1)-1,j)+Grf(i).M(ind(2*l)+1,j))/2;
                        end
                    end
                end
                clear I ind
                I=find(isnan(Grf(i).F(:,j)));
                if ~isempty(I)
                    ind=group(I);
                    for l=1:length(ind)/2
                        if ind(2*l-1)==1
                            Grf(i).F(ind(2*l-1):ind(2*l),j)=Grf(i).F(ind(2*l)+1,j);
                        elseif ind(2*l)==length(Grf(i).M(:,j))
                            Grf(i).F(ind(2*l-1):ind(2*l),j)=Grf(i).F(ind(2*l-1)-1,j);
                        else
                            Grf(i).F(ind(2*l-1):ind(2*l),j)=(Grf(i).F(ind(2*l-1)-1,j)+Grf(i).F(ind(2*l)+1,j))/2;
                        end
                    end
                end
            end
        end
%         Grf(1).P(:,1) = filtfilt(B,A,Grf(1).P(:,1));
%         Grf(1).P(:,2) = filtfilt(B,A,Grf(1).P(:,2));
%         Grf(1).P(:,3) = filtfilt(B,A,Grf(1).P(:,3));
        Grf(1).F(:,1) = filtfilt(B,A,Grf(1).F(:,1));
        Grf(1).F(:,2) = filtfilt(B,A,Grf(1).F(:,2));
        Grf(1).F(:,3) = filtfilt(B,A,Grf(1).F(:,3));
        Grf(1).M(:,1) = filtfilt(B,A,Grf(1).M(:,1));
        Grf(1).M(:,2) = filtfilt(B,A,Grf(1).M(:,2));
        Grf(1).M(:,3) = filtfilt(B,A,Grf(1).M(:,3));
%         Grf(2).P(:,1) = filtfilt(B,A,Grf(2).P(:,1));
%         Grf(2).P(:,2) = filtfilt(B,A,Grf(2).P(:,2));
%         Grf(2).P(:,3) = filtfilt(B,A,Grf(2).P(:,3));
        Grf(2).F(:,1) = filtfilt(B,A,Grf(2).F(:,1));
        Grf(2).F(:,2) = filtfilt(B,A,Grf(2).F(:,2));
        Grf(2).F(:,3) = filtfilt(B,A,Grf(2).F(:,3));
        Grf(2).M(:,1) = filtfilt(B,A,Grf(2).M(:,1));
        Grf(2).M(:,2) = filtfilt(B,A,Grf(2).M(:,2));
        Grf(2).M(:,3) = filtfilt(B,A,Grf(2).M(:,3));

        % =================================================================
        % Apply a 10N threshold
        % =================================================================
        threshold = 10;
        for i = 1:n2
            if Grf(1).F(i,2) < threshold;
                Grf(1).P(i,:) = zeros(1,3);
                Grf(1).F(i,:) = zeros(1,3);
                Grf(1).M(i,:) = zeros(1,3);
            end
            if Grf(2).F(i,2) < threshold;
                Grf(2).P(i,:) = zeros(1,3);
                Grf(2).F(i,:) = zeros(1,3);
                Grf(2).M(i,:) = zeros(1,3);
            end
        end

        % =================================================================
        % Interpolate data
        % =================================================================
        if ~isnan(mean(Grf(1).F(1,:,:)))
            Grf(1).P = interp1(k,Grf(1).P,ko,'spline');
            Grf(1).F = interp1(k,Grf(1).F,ko,'spline');
            Grf(1).M = interp1(k,Grf(1).M,ko,'spline');
        end
        if ~isnan(mean(Grf(2).F(1,:,:)))
            Grf(2).P = interp1(k,Grf(2).P,ko,'spline');
            Grf(2).F = interp1(k,Grf(2).F,ko,'spline');
            Grf(2).M = interp1(k,Grf(2).M,ko,'spline');
        end

        % =================================================================
        % Correction of COP
        % =================================================================
        for i=1:length(Grf)
            for j=1:3
                I=[];
                I=find(abs(Grf(i).P(:,j))>1);
                if ~isempty(I)
                    for k=1:length(I)
                        Grf(i).P(I(k),j)=0;
                    end
                end
            end
        end
        % =================================================================
        % Store markers as 3-array vectors
        % =================================================================
        Grf(1).P = permute(Grf(1).P,[2,3,1]);
        Grf(1).F = permute(Grf(1).F,[2,3,1]);
        Grf(1).M = permute(Grf(1).M,[2,3,1]);
        Grf(2).P = permute(Grf(2).P,[2,3,1]);
        Grf(2).F = permute(Grf(2).F,[2,3,1]);
        Grf(2).M = permute(Grf(2).M,[2,3,1]);
    end

end