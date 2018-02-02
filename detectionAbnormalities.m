% =========================================================================
% REHAZENTER TOOLBOX
% =========================================================================
% File name:    detectionAbnormalities
% -------------------------------------------------------------------------
% Subject:      Compute gait abnormalities using Lissajous figures
%               Reference: Itoh N. et al., Quantitative assessment of 
%               circumduction, hip hiking, and forefoot contact gait using 
%               Lissajous figures, Jpn J Compr Rehabil Sci, 3, 2012
% -------------------------------------------------------------------------
% Inputs:       - Rmarkers (structure)
%               - Lmarkers (structure)
%               - Revents (structure)
%               - Levents (structure)
%               - Gait (structure)
%               - system (char)
% Outputs:      - Abnormalities (structure)
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber, A. Naaim
% Date of creation: 26/03/2014
% Version: 1
% -------------------------------------------------------------------------
% Updates: - 25/03/2015 - Moissenet - Global recoding of the indexes
%            processing
% =========================================================================

function Abnormalities = detectionAbnormalities(Rmarkers,Lmarkers,Revents,Levents,Gait,system)

% =========================================================================
% Initialisation
% =========================================================================
Abnormalities.Rcircumduction.index = [];
Abnormalities.Lcircumduction.index = [];
Abnormalities.Rhiphicking.index = [];
Abnormalities.Lhiphicking.index = [];
Abnormalities.Rforefoot.index = [];
Abnormalities.Lforefoot.index = [];
    
if strcmp(Gait.gaittrial,'yes')

    % =====================================================================
    % Circumduction
    % =====================================================================
    % The index for circumduction is measured as the difference in distance 
    % between the lateral-most Z (ISB) coordinate of the ankle joint marker  
    % during 25-75 % of the swing phase and the medial-most Z (ISB)   
    % coordinate during 25-75 % of the stance phase
    % =====================================================================
    % 0.78 ± 1.09 cm in healthy subjects
    % 2.96 ± 2.75 cm in hemiplegic patients
    % The normal range of each index was defined as the mean ±2sd of the  
    % values obtained from healthy subjects
    % =====================================================================
    
    % Right side
    % ---------------------------------------------------------------------
    stance25 = round(25*Revents.ITO/100);
    stance75 = round(75*Revents.ITO/100);
    swing25 = round(Revents.ITO+25*(Revents.IHS(2)-Revents.ITO)/100);
    swing75 = round(Revents.ITO+75*(Revents.IHS(2)-Revents.ITO)/100);
    if strcmp(system,'BTS')
        sacrumX = permute(Rmarkers.sacrum(1,:,:),[3,1,2]);
        markerZ = permute(Rmarkers.r_mall(3,:,:),[3,1,2]);
        markerX = permute(Rmarkers.r_mall(1,:,:),[3,1,2]) - sacrumX;
    elseif strcmp(system,'Qualisys')
        sacrumX = permute((Rmarkers.R_IPS(1,:,:)+Rmarkers.L_IPS(1,:,:))/2,[3,1,2]);
        markerZ = permute(Rmarkers.R_FAL(3,:,:),[3,1,2]);
        markerX = permute(Rmarkers.R_FAL(1,:,:),[3,1,2]) - sacrumX;
    end
    Abnormalities.Rcircumduction.index = max(markerZ(swing25:swing75)+100)-...   
        min(markerZ(stance25:stance75)+100); % in m, +100 to avoid negative values
%     figure; 
%     hold on;
%     axis equal;
%     plot(markerZ(1:stance25),markerX(1:stance25),'Color',[0.7,0.7,0.7],...
%         'LineStyle','--','LineWidth',2);
%     plot(markerZ(stance25:Revents.ITO),markerX(stance25:Revents.ITO),'Color',...
%         [0.7,0.7,0.7],'LineStyle','-','LineWidth',2);
%     plot(markerZ(Revents.ITO+1:swing75),markerX(Revents.ITO+1:swing75),'Color',[0,0,0],...
%         'LineStyle','-','LineWidth',2);
%     plot(markerZ(swing75:end),markerX(swing75:end),'Color',[0,0,0],...
%         'LineStyle','--','LineWidth',2);
    clear markerZ markerX stance25 stance75 swing25 swing75 sacrumX

    % Left side
    % ---------------------------------------------------------------------
    stance25 = round(25*Levents.ITO/100);
    stance75 = round(75*Levents.ITO/100);
    swing25 = round(Levents.ITO+25*(Levents.IHS(2)-Levents.ITO)/100);
    swing75 = round(Levents.ITO+75*(Levents.IHS(2)-Levents.ITO)/100);
    if strcmp(system,'BTS')
        sacrumX = permute(Lmarkers.sacrum(1,:,:),[3,1,2]);
        markerZ = permute(Lmarkers.l_mall(3,:,:),[3,1,2]);
        markerX = permute(Lmarkers.l_mall(1,:,:),[3,1,2]) - sacrumX;
    elseif strcmp(system,'Qualisys')
        sacrumX = permute((Lmarkers.R_IPS(1,:,:)+Lmarkers.L_IPS(1,:,:))/2,[3,1,2]);
        markerZ = permute(Lmarkers.L_FAL(3,:,:),[3,1,2]);
        markerX = permute(Lmarkers.L_FAL(1,:,:),[3,1,2]) - sacrumX;
    end
    Abnormalities.Lcircumduction.index = max(markerZ(swing25:swing75)+100)-...   
        min(markerZ(stance25:stance75)+100); % in m, +100 to avoid negative values
%     figure; 
%     hold on;
%     axis equal;
%     plot(markerZ(1:stance25),markerX(1:stance25),'Color',[0.7,0.7,0.7],...
%         'LineStyle','--','LineWidth',2);
%     plot(markerZ(stance25:Levents.ITO),markerX(stance25:Levents.ITO),'Color',...
%         [0.7,0.7,0.7],'LineStyle','-','LineWidth',2);
%     plot(markerZ(Levents.ITO+1:swing75),markerX(Levents.ITO+1:swing75),'Color',[0,0,0],...
%         'LineStyle','-','LineWidth',2);
%     plot(markerZ(swing75:end),markerX(swing75:end),'Color',[0,0,0],...
%         'LineStyle','--','LineWidth',2);
    clear markerZ markerX stance25 stance75 swing25 swing75 sacrumX

    % =====================================================================
    % Hip hiking
    % =====================================================================
    % The index for hip hiking is obtained from the difference between the
    % maximum value of the Y (ISB) coordinate of the hip joint marker  
    % during the swing phase and the Y (ISB) coordinate of the   
    % contralateral hip joint marker at the same time, corrected for the  
    % mean left-right  difference of the Y (ISB) coordinate during the  
    % double support phase
    % =====================================================================
    % 0.26 ± 0.53 cm in healthy subjects
    % 1.73 ± 1.08 cm in hemiplegic patients
    % The normal range of each index was defined as the mean ±2sd of the  
    % values obtained from healthy subjects
    % =====================================================================

    % Right side    
    % ---------------------------------------------------------------------
    if strcmp(system,'BTS')
        markerRY = permute(Rmarkers.r_thigh(2,:,:),[3,1,2]);
        markerRZ = permute(Rmarkers.r_thigh(3,:,:),[3,1,2]);
        markerLY = permute(Rmarkers.l_thigh(2,:,:),[3,1,2]);
        markerLZ = permute(Rmarkers.l_thigh(3,:,:),[3,1,2]);
    elseif strcmp(system,'Qualisys')
        markerRY = permute(Rmarkers.R_FTC(2,:,:),[3,1,2]);
        markerRZ = permute(Rmarkers.R_FTC(3,:,:),[3,1,2]);
        markerLY = permute(Rmarkers.L_FTC(2,:,:),[3,1,2]);
        markerLZ = permute(Rmarkers.L_FTC(3,:,:),[3,1,2]);
    end
    offset = mean(markerRY(Revents.CHS:Revents.ITO) - ...
        markerLY(Revents.CHS:Revents.ITO)); % to apply on Y coord of left marker
    Abnormalities.Rhiphicking.index = max(markerRY(Revents.ITO+1:end)) - ...
        (markerLY(find(markerRY == max(markerRY(Revents.ITO+1:end))))+offset);
%     figure; 
%     hold on;
%     axis equal;
%     sb1 = subplot(1,2,2); hold on;
%     plot(markerRZ(1:Revents.ITO),markerRY(1:Revents.ITO),'Color',[0.7,0.7,0.7],...
%         'LineStyle','-','LineWidth',2);
%     plot(markerRZ(Revents.ITO:end),markerRY(Revents.ITO:end),'Color',[0,0,0],...
%         'LineStyle','-','LineWidth',2);
%     sb2 = subplot(1,2,1); hold on;
%     plot(markerLZ(1:Revents.ITO),markerLY(1:Revents.ITO)+offset,'Color',[0.7,0.7,0.7],...
%         'LineStyle','-','LineWidth',2);
%     plot(markerLZ(Revents.ITO:end),markerLY(Revents.ITO:end)+offset,'Color',[0,0,0],...
%         'LineStyle','-','LineWidth',2);
%     linkaxes([sb1,sb2],'y');
    clear markerRY markerRZ markerLY markerLZ
    
    % Left side
    % ---------------------------------------------------------------------
    if strcmp(system,'BTS')
        markerRY = permute(Lmarkers.r_thigh(2,:,:),[3,1,2]);
        markerRZ = permute(Lmarkers.r_thigh(3,:,:),[3,1,2]);
        markerLY = permute(Lmarkers.l_thigh(2,:,:),[3,1,2]);
        markerLZ = permute(Lmarkers.l_thigh(3,:,:),[3,1,2]);
    elseif strcmp(system,'Qualisys')
        markerRY = permute(Lmarkers.R_FTC(2,:,:),[3,1,2]);
        markerRZ = permute(Lmarkers.R_FTC(3,:,:),[3,1,2]);
        markerLY = permute(Lmarkers.L_FTC(2,:,:),[3,1,2]);
        markerLZ = permute(Lmarkers.L_FTC(3,:,:),[3,1,2]);
    end
    offset = mean(markerRY(Levents.CHS:Levents.ITO) - ...
        markerLY(Levents.CHS:Levents.ITO)); % to apply on Y coord of left marker
    Abnormalities.Lhiphicking.index = max((markerLY(Levents.ITO+1:end))+offset) - ...
        markerRY(find(markerLY == max(markerLY(Levents.ITO+1:end))));
%     figure; 
%     hold on;
%     axis equal;
%     sb1 = subplot(1,2,2); hold on;
%     plot(markerRZ(1:Levents.ITO),markerRY(1:Levents.ITO),'Color',[0.7,0.7,0.7],...
%         'LineStyle','-','LineWidth',2);
%     plot(markerRZ(Levents.ITO:end),markerRY(Levents.ITO:end),'Color',[0,0,0],...
%         'LineStyle','-','LineWidth',2);
%     sb2 = subplot(1,2,1); hold on;
%     plot(markerLZ(1:Levents.ITO),markerLY(1:Levents.ITO)+offset,'Color',[0.7,0.7,0.7],...
%         'LineStyle','-','LineWidth',2);
%     plot(markerLZ(Levents.ITO:end),markerLY(Levents.ITO:end)+offset,'Color',[0,0,0],...
%         'LineStyle','-','LineWidth',2);
%     linkaxes([sb1,sb2],'y');
    clear markerRY markerRZ markerLY markerLZ

    % =====================================================================
    % Forefoot contact
    % =====================================================================
    % The index for forefoot contact is obtained from the difference in 
    % distance between the vertical coordinate of the ankle joint marker  
    % and the vertical coordinate of the toe marker at initial contact,   
    % minus the difference in distance between the vertical coordinates of    
    % the ankle joint marker and toe marker during standing
    % =====================================================================
    % 2.79 ± 0.64 cm in healthy subjects
    % 0.12 ± 1.31 cm in hemiplegic patients
    % The normal range of each index was defined as the mean ±2sd of the  
    % values obtained from healthy subjects
    % =====================================================================

    % Right side    
    % ---------------------------------------------------------------------
    if strcmp(system,'BTS')
        sacrumX = permute(Rmarkers.sacrum(1,:,:),[3,1,2]);
        marker1X = permute(Rmarkers.r_mall(1,:,:),[3,1,2]) - sacrumX;
        marker1Y = permute(Rmarkers.r_mall(2,:,:),[3,1,2]);
        marker2X = permute(Rmarkers.r_met(1,:,:),[3,1,2]) - sacrumX;
        marker2Y = permute(Rmarkers.r_met(2,:,:),[3,1,2]);
    elseif strcmp(system,'Qualisys')
        sacrumX = permute((Rmarkers.R_IPS(1,:,:)+...
            Rmarkers.L_IPS(1,:,:))/2,[3,1,2]);
        marker1X = permute(Rmarkers.R_FAL(1,:,:),[3,1,2]) - sacrumX;
        marker1Y = permute(Rmarkers.R_FAL(2,:,:),[3,1,2]);
        marker2X = permute(Rmarkers.R_FM5(1,:,:),[3,1,2]) - sacrumX;
        marker2Y = permute(Rmarkers.R_FM5(2,:,:),[3,1,2]);
    end
    offset = min(marker1Y) - marker2Y(find(marker1Y==min(marker1Y))); % to apply on Y coord of toe marker
    Abnormalities.Rforefoot.index = (marker1Y(1) - (marker2Y(1)+offset)); % in m
%     figure;
%     hold on;
%     axis equal;
%     plot(marker1X(1:Revents.ITO),marker1Y(1:Revents.ITO),'Color',[0.7,0.7,0.7],...
%         'LineStyle','-','LineWidth',2)
%     plot(marker1X(Revents.ITO+1:end),marker1Y(Revents.ITO+1:end),'Color',[0,0,0],...
%         'LineStyle','-','LineWidth',2)
%     plot(marker2X(1:Revents.ITO),marker2Y(1:Revents.ITO)+offset,'Color',[0.7,0.7,0.7],...
%         'LineStyle','-','LineWidth',2)
%     plot(marker2X(Revents.ITO+1:end),marker2Y(Revents.ITO+1:end)+offset,'Color',[0,0,0],...
%         'LineStyle','-','LineWidth',2)
    clear marker1Y marker1Z marker2X marker2X sacrumX

    % Left side    
    % ---------------------------------------------------------------------
    if strcmp(system,'BTS')
        sacrumX = permute(Lmarkers.sacrum(1,:,:),[3,1,2]);
        marker1X = permute(Lmarkers.l_mall(1,:,:),[3,1,2]) - sacrumX;
        marker1Y = permute(Lmarkers.l_mall(2,:,:),[3,1,2]);
        marker2X = permute(Lmarkers.l_met(1,:,:),[3,1,2]) - sacrumX;
        marker2Y = permute(Lmarkers.l_met(2,:,:),[3,1,2]);
    elseif strcmp(system,'Qualisys')
        sacrumX = permute((Lmarkers.R_IPS(1,:,:)+...
            Lmarkers.L_IPS(1,:,:))/2,[3,1,2]);
        marker1X = permute(Lmarkers.L_FAL(1,:,:),[3,1,2]) - sacrumX;
        marker1Y = permute(Lmarkers.L_FAL(2,:,:),[3,1,2]);
        marker2X = permute(Lmarkers.L_FM5(1,:,:),[3,1,2]) - sacrumX;
        marker2Y = permute(Lmarkers.L_FM5(2,:,:),[3,1,2]);
    end
    offset = min(marker1Y) - marker2Y(find(marker1Y==min(marker1Y))); % to apply on Y coord of toe marker
    Abnormalities.Lforefoot.index = (marker1Y(1) - (marker2Y(1)+offset)); % in m
%     figure;
%     hold on;
%     axis equal;
%     plot(marker1X(1:Levents.ITO),marker1Y(1:Levents.ITO),'Color',[0.7,0.7,0.7],...
%         'LineStyle','-','LineWidth',2)
%     plot(marker1X(Levents.ITO+1:end),marker1Y(Levents.ITO+1:end),'Color',[0,0,0],...
%         'LineStyle','-','LineWidth',2)
%     plot(marker2X(1:Levents.ITO),marker2Y(1:Levents.ITO)+offset,'Color',[0.7,0.7,0.7],...
%         'LineStyle','-','LineWidth',2)
%     plot(marker2X(Levents.ITO+1:end),marker2Y(Levents.ITO+1:end)+offset,'Color',[0,0,0],...
%         'LineStyle','-','LineWidth',2)
    clear marker1Y marker1Z marker2X marker2X sacrumX
    
end