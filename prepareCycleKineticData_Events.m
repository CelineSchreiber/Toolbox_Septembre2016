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

function Grf = prepareCycleKineticData_Events(Grf,n2,f2)

if ~isempty(Grf) && length(Grf) > 1
   
        % =================================================================
        % Filt the data
        % =================================================================
        [B,A] = butter(2,15/(f2/2),'low');
        Grf(1).F(:,1) = filtfilt(B,A,Grf(1).F(:,1));
        Grf(1).F(:,2) = filtfilt(B,A,Grf(1).F(:,2));
        Grf(1).F(:,3) = filtfilt(B,A,Grf(1).F(:,3));
        Grf(2).F(:,1) = filtfilt(B,A,Grf(2).F(:,1));
        Grf(2).F(:,2) = filtfilt(B,A,Grf(2).F(:,2));
        Grf(2).F(:,3) = filtfilt(B,A,Grf(2).F(:,3));

        % =================================================================
        % Apply a 10N threshold
        % =================================================================
        threshold = 10;
        for i = 1:n2
            if abs(Grf(1).F(i,3)) < threshold;
                Grf(1).F(i,:) = zeros(1,3);
            end
            if abs(Grf(2).F(i,3)) < threshold;
                Grf(2).F(i,:) = zeros(1,3);
            end
        end

end
