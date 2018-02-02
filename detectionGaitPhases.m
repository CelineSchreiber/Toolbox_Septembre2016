% =========================================================================
% REHAZENTER TOOLBOX
% =========================================================================
% File name:    detectionGaitPhases
% -------------------------------------------------------------------------
% Subject:      Define the gait phases described by Perry
% -------------------------------------------------------------------------
% Inputs:       - Markers (structure)
%               - Gait (structure)
%               - n0 (int)
%               - f1 (int)
%               - e (structure)
%               - side (char)
%               - system (char)
% Outputs:      - Events (structure)
%               - Phases (structure)
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber, A. Naaim
% Date of creation: 26/03/2014
% Version: 1
% -------------------------------------------------------------------------
% Updates: - 16/09/2014: Store raw events in Events structure
% =========================================================================

function [Events,Phases] = detectionGaitPhases(Markers,n0,f1,e,side,system)

% =====================================================================
% Initialisation
% =====================================================================
Events.IHS = [];
Events.ITO = [];
Events.CTO = [];
Events.CHS = [];
Events.COM = [];
Events.MAL = [];
Events.TIB = [];
Phases.p1 = [];
Phases.p2 = [];
Phases.p3 = [];
Phases.p4 = [];
Phases.p5 = [];
Phases.p6 = [];
Phases.p7 = [];
Phases.p8 = [];

% =====================================================================
% Recorded events
% =====================================================================
start = 0;
stop = 0;
if strcmp(side,'Right')
    start = round((e.RHS(1)*f1)-n0+1);
    stop = round((e.RHS(2)*f1)-n0+1);
elseif strcmp(side,'Left')
    start = round((e.LHS(1)*f1)-n0+1);
    stop = round((e.LHS(2)*f1)-n0+1);
end
n1 = fix(stop-start+1);

% =====================================================================
% Store raw events
% =====================================================================
Events.e = e;

% Events IHS, ITO, CHS and CTO
% ---------------------------------------------------------------------
Events.IHS(1) = 1;
if strcmp(side,'Right')
    Events.ITO = round((e.RTO(end)*f1)-n0+1 - start);
    Events.IHS(2) = round((e.RHS(2)*f1)-n0+1 - start);
    Events.CTO = round((e.LTO(1)*f1)-n0+1 - start);
    if (e.LHS(1)*f1)-n0+1 - start > 0
        Events.CHS = round((e.LHS(1)*f1)-n0+1 - start);
    elseif (e.LHS(2)*f1)-n0+1 - start > 0
        Events.CHS = round((e.LHS(2)*f1)-n0+1 - start);
    end
elseif strcmp(side,'Left')
    Events.ITO = round((e.LTO(end)*f1)-n0+1 - start);
    Events.IHS(2) = round((e.LHS(2)*f1)-n0+1 - start);
    Events.CTO = round((e.RTO(1)*f1)-n0+1 - start);
    if (e.RHS(1)*f1)-n0+1 - start > 0
        Events.CHS = round((e.RHS(1)*f1)-n0+1 - start);
    elseif (e.RHS(2)*f1)-n0+1 - start > 0
        Events.CHS = round((e.RHS(2)*f1)-n0+1 - start);
    end
end

% =================================================================
% Define gait phases
% =================================================================
% From Perry J., Gait Analysis - Normal and Pathological Function
% SLACK, 1992
% =================================================================
% phase 1 : initial contact = ipsilateral heel strike (IHS)
% phase 2 : loading response = from ipsilateral heel strike (IHS)
%           to contralateral toe off (CTO)
% phase 3 : midstance = from contralateral toe off (CTO) to the 
%           moment where CoM is aligned with ipsilateral forefoot 
%           (COM)
% phase 4 : terminal stance = from the moment where CoM is aligned  
%           with forefoot (COM) to contralateral heel strike (CHS)
% phase 5 : preswing = from contralateral heel strike (CHS) to  
%           ipsilateral toe off (ITO)
% phase 6 : initial swing = from ipsilateral toe off /ITO) to   
%           alignment of ipsilateral malleolus to contralateral
%           malleolus (MAL)
% phase 7 : midswing = from alignment of ipsilateral malleolus to 
%           contralateral malleolus (MAL) to the moment where  
%           ipsilateral tibia is vertical (TIB)
% phase 8 : terminal swing = from the moment where ipsilateral  
%           tibia is vertical (TIB) to ipsilateral heel strike(IHS)
% =================================================================

% Event COM
% -----------------------------------------------------------------
if strcmp(system,'BTS')
    marker1 = Markers.r_asis;
    marker2 = Markers.l_asis;
    marker3 = Markers.sacrum;
    CoM = ((marker1+marker2)/2 + marker3)/2;    
    if strcmp(side,'Right')
        ref = Markers.r_met;
    elseif strcmp(side,'Left')
        ref = Markers.l_met;
    end
    threshold = 0.01; % 1 cm
    for i = 1:length(marker1(1,:,:))
        if abs(CoM(1,:,i)-ref(1,:,i)) < threshold
            Events.COM = round(i);
            break;
        end
    end
elseif strcmp(system,'Qualisys')
    marker1 = Markers.R_IAS;
    marker2 = Markers.L_IAS;
    marker3 = (Markers.R_IPS+Markers.L_IPS)/2;
    CoM = ((marker1+marker2)/2 + marker3)/2;    
    if strcmp(side,'Right')
        ref = Markers.R_FM5;
    elseif strcmp(side,'Left')
        ref = Markers.L_FM5;
    end    
    threshold = 0.01; % 1 cm
    for i = 1:length(marker1(1,:,:))
        if abs(CoM(1,:,i)-ref(1,:,i)) < threshold
            Events.COM = round(i);
            break;
        else
            [~,I] = min(abs(CoM(1,:,:)-ref(1,:,:)));
            Events.COM = round(I);
        end
    end
end

% Event MAL
% -----------------------------------------------------------------
if strcmp(system,'BTS')
    if strcmp(side,'Right')
        marker1 = Markers.r_met;
        marker2 = Markers.l_mall;
    elseif strcmp(side,'Left')
        marker1 = Markers.l_met;
        marker2 = Markers.r_mall;
    end    
    for i = Events.ITO:length(marker1(1,:,:))
        if abs(marker1(1,:,i)-marker2(1,:,i)) == ...
                min(abs(marker1(1,:,Events.ITO:length(marker1(1,:,:)))-...
                marker2(1,:,Events.ITO:length(marker1(1,:,:)))))
            Events.MAL = round(i);
            break;
        end
    end
elseif strcmp(system,'Qualisys')
    if strcmp(side,'Right')
        marker1 = Markers.R_FM5;
        marker2 = Markers.L_FAL;
    elseif strcmp(side,'Left')
        marker1 = Markers.L_FM5;
        marker2 = Markers.R_FAL;
    end    
    for i = Events.ITO:length(marker1(1,:,:))
        if abs(marker1(1,:,i)-marker2(1,:,i)) == ...
                min(abs(marker1(1,:,Events.ITO:length(marker1(1,:,:)))-...
                marker2(1,:,Events.ITO:length(marker1(1,:,:)))))
            Events.MAL = round(i);
            break;
        end
    end
end

% Event TIB
% -----------------------------------------------------------------
if strcmp(system,'BTS')
    if strcmp(side,'Right')
        marker1 = Markers.r_mall;
        marker2 = Markers.r_knee_2;
    elseif strcmp(side,'Left')
        marker1 = Markers.l_mall;
        marker2 = Markers.l_knee_2;
    end    
    for i = Events.MAL:length(marker1(1,:,:))
        if abs(marker1(1,:,i)-marker2(1,:,i)) == ...
                min(abs(marker1(1,:,Events.MAL:length(marker1(1,:,:)))-...
                marker2(1,:,Events.MAL:length(marker1(1,:,:)))))
            Events.TIB = round(i);
            break;
        end
    end
elseif strcmp(system,'Qualisys')
    if strcmp(side,'Right')
        marker1 = Markers.R_FAL;
        marker2 = Markers.R_FAX;
    elseif strcmp(side,'Left')
        marker1 = Markers.L_FAL;
        marker2 = Markers.L_FAX;
    end    
    for i = Events.MAL:length(marker1(1,:,:))
        if abs(marker1(1,:,i)-marker2(1,:,i)) == ...
                min(abs(marker1(1,:,Events.MAL:length(marker1(1,:,:)))-...
                marker2(1,:,Events.MAL:length(marker1(1,:,:)))))
            Events.TIB = round(i);
            break;
        end
    end
end

% =====================================================================
% Export gait phases
% =====================================================================
Phases.p1 = Events.IHS(1);
Phases.p2 = Events.CTO;
Phases.p3 = Events.COM;
Phases.p4 = Events.CHS;
Phases.p5 = Events.ITO;
Phases.p6 = Events.MAL;
if Events.TIB > Events.IHS(2)
    Phases.p7 = Events.IHS(2);
else
    Phases.p7 = Events.TIB;
end
Phases.p8 = Events.IHS(2);