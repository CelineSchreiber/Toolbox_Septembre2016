% =========================================================================
% REHAZENTER TOOLBOX
% =========================================================================
% File name:    detectionCycleEvents
% -------------------------------------------------------------------------
% Subject:      Detect foot strike and foot off events based on the work
%               of Zeni et al., Two simple methods for determining gait 
%               events during treadmill and overground walking using
%               kinematic data, Gait & Posture 27 (2008) 710–714
% -------------------------------------------------------------------------
% Inputs:       - Markers (structure)
%               - n (int)
%               - f (int)
%               - system (char)
% Outputs:      - e (structure)
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber, A. Naaim
% Date of creation: 12/12/2014
% Version: 1
% -------------------------------------------------------------------------
% Updates: - 
% =========================================================================

function e = detectionCycleEvents(Markers,n,f,system)

% =========================================================================
% Initialisation
% =========================================================================
RHS = [];
RTO = [];
LHS = [];
LTO = []; 

% =========================================================================
% Detect foot events
% =========================================================================
if strcmp(system,'BTS')

elseif strcmp(system,'Qualisys')
    
    for i = 1:n  
        
        % Compute pelvis origin
        % -----------------------------------------------------------------
        orBassin(i,:) = (Markers.L_IAS(i,:)+Markers.L_IPS(i,:)+...
            Markers.R_IAS(i,:)+Markers.R_IPS(i,:))/4;
        YBassin(i,:) = [0,1,0];
        midIAS = (Markers.L_IAS(i,:)+Markers.R_IAS(i,:))/2;
        midIPS = (Markers.L_IPS(i,:)+Markers.R_IPS(i,:))/2;
        ZBassin(i,:) = cross(midIAS-midIPS,YBassin(i,:));        
        XBassin(i,:) = cross(YBassin(i,:),ZBassin(i,:));

        % Compute the reference points (pseudo-origin) for foot strike (HS) 
        % and foot off (TO)
        % -----------------------------------------------------------------
        orPiedDroitHS(i,:) = (Markers.R_FCC(i,:)+Markers.R_FM1(i,:)+...
            Markers.R_FM5(i,:)+Markers.R_FAL(i,:))/4;
        orPiedDroitTO(i,:) = (Markers.R_FM1(i,:)+Markers.R_FM5(i,:))/2;
        orPiedGaucheHS(i,:) = (Markers.L_FCC(i,:)+Markers.L_FM1(i,:)+...
            Markers.L_FM5(i,:)+Markers.L_FAL(i,:))/4;
        orPiedGaucheTO(i,:) = (Markers.L_FM1(i,:)+Markers.L_FM5(i,:))/2;

        % Remove the X component of the pelvis movement for each side
        % -----------------------------------------------------------------
        orPiedDroitModifHorHS(i) = dot(orPiedDroitHS(i,:)-orBassin(i,:),...
            XBassin(i,:));
        orPiedDroitModifHorTO(i) = dot(orPiedDroitTO(i,:)-orBassin(i,:),...
            XBassin(i,:));
        orPiedGaucheModifHorHS(i) = dot(orPiedGaucheHS(i,:)-orBassin(i,:),...
            XBassin(i,:));
        orPiedGaucheModifHorTO(i) = dot(orPiedGaucheTO(i,:)-orBassin(i,:),...
            XBassin(i,:));  
        
    end
    
    for i = 1:n

        % Compute the velocity /X of the reference points of the foot in
        % the pelvis frame
        % -----------------------------------------------------------------
        if i~=1 && i~=n            
            deriveDroitHS(i) = (orPiedDroitModifHorHS(i+1)-...
                orPiedDroitModifHorHS(i-1))/2;
            deriveDroitTO(i) = (orPiedDroitModifHorTO(i+1)-...
                orPiedDroitModifHorTO(i-1))/2;
            deriveGaucheHS(i) = (orPiedGaucheModifHorHS(i+1)-...
                orPiedGaucheModifHorHS(i-1))/2;
            deriveGaucheTO(i) = (orPiedGaucheModifHorTO(i+1)-...
                orPiedGaucheModifHorTO(i-1))/2;            
        elseif i==0
            deriveDroitHS(i) = (orPiedDroitModifHorHS(i+1)-...
                orPiedDroitModifHorHS(i));
            deriveDroitTO(i) = (orPiedDroitModifHorTO(i+1)-...
                orPiedDroitModifHorTO(i));
            deriveGaucheHS(i) = (orPiedGaucheModifHorHS(i+1)-...
                orPiedGaucheModifHorHS(i));
            deriveGaucheTO(i) = (orPiedGaucheModifHorTO(i+1)-...
                orPiedGaucheModifHorTO(i));
        else
            deriveDroitHS(i) = (orPiedDroitModifHorHS(i)-...
                orPiedDroitModifHorHS(i));
            deriveDroitTO(i) = (orPiedDroitModifHorTO(i)-...
                orPiedDroitModifHorTO(i));
            deriveGaucheHS(i) = (orPiedGaucheModifHorHS(i)-...
                orPiedGaucheModifHorHS(i));
            deriveGaucheTO(i) = (orPiedGaucheModifHorTO(i)-...
                orPiedGaucheModifHorTO(i));
        end
        
    end
    nbis = size(deriveDroitHS,2);    
    
    % Detect when velocity cross 0 (+ to -: HS, - to +: TO)
    % ---------------------------------------------------------------------
    threshold = 1000;
    for i = 2:nbis-2            
        if deriveDroitHS(i) > threshold && ...
                deriveDroitHS(i-1) > threshold && ...
                deriveDroitHS(i+1) < threshold && ...
                deriveDroitHS(i+2) < threshold
            RHS = [RHS,i];
        end
        if deriveDroitTO(i) < threshold && ...
                deriveDroitTO(i-1) < threshold && ...
                deriveDroitTO(i+1) > threshold && ...
                deriveDroitTO(i+2) > threshold
            RTO = [RTO,i];
        end
        if deriveGaucheHS(i) > threshold && ...
                deriveGaucheHS(i-1) > threshold && ...
                deriveGaucheHS(i+1) < threshold && ...
                deriveGaucheHS(i+2) < threshold
            LHS = [LHS,i];
        end
        if deriveGaucheTO(i) < threshold && ...
                deriveGaucheTO(i-1) < threshold && ...
                deriveGaucheTO(i+1) > threshold && ...
                deriveGaucheTO(i+2) > threshold
            LTO = [LTO,i];
        end       
    end
    
    % Export events
    % ---------------------------------------------------------------------
    e.RHS = RHS/f;
    e.RTO = RTO/f;
    e.LHS = LHS/f;
    e.LTO = LTO/f;

end