% =========================================================================
% REHAZENTER TOOLBOX
% =========================================================================
% File name:    computeIndexPosturalAngles
% -------------------------------------------------------------------------
% Subject:      Compute anchoring index and intercorrelation functions
% -------------------------------------------------------------------------
% Inputs:       - Posturalangles (structure)
%               - Gait (structure)
% Outputs:      - Posturalindex (structure)
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber, A. Naaim
% Date of creation: 26/03/2014
% Version: 1
% -------------------------------------------------------------------------
% Updates: - 
% =========================================================================

function [Posturalindex] = computeIndexPosturalAngles(Posturalangles,Gait)

% =========================================================================
% Initialisation
% =========================================================================
Std.Hgr_tilt = [];
Std.Hgr_rota = [];
Std.Hgr_obli = [];
Std.Hseg_tilt = [];
Std.Hseg_rota = [];
Std.Hseg_obli = [];
Std.Sgr_tilt = [];
Std.Sgr_rota = [];
Std.Sgr_obli = [];
Std.Sseg_tilt = [];
Std.Sseg_rota = [];
Std.Sseg_obli = [];
Std.Rgr_tilt = [];
Std.Rgr_rota = [];
Std.Rgr_obli = [];
Std.Pgr_tilt = [];
Std.Pgr_rota = [];
Std.Pgr_obli = [];
Aindex.S_tilt = [];
Aindex.S_obli = [];
Aindex.S_rota = [];
Aindex.H_tilt = [];
Aindex.H_obli = [];
Aindex.H_rota = [];
Ifunction.HA_TA_TI = [];
Ifunction.HA_TA_OB = [];
Ifunction.HA_TA_RO = [];
Idephasing.HA_TA_TI = [];
Idephasing.HA_TA_OB = [];
Idephasing.HA_TA_RO = [];
Ifunction.TA_PA_TI = [];
Ifunction.TA_PA_OB = [];
Ifunction.TA_PA_RO = [];
Idephasing.TA_PA_TI = [];
Idephasing.TA_PA_OB = [];
Idephasing.TA_PA_RO = [];

if strcmp(Gait.posturetrial,'yes')
    
    % =====================================================================
    % Compute anchoring index for scapular belt and head
    % (Aindexgr: regarding ground, Aindexseg: regarding distal segment)
    % =====================================================================
    names = fieldnames(Posturalangles);
    for j=1:length(names)
        temp = Posturalangles.(names{j});
        if ~isempty(temp)
            Std.(names{j}) = nanstd(temp);
        end
    end
    if isfield(Std,'Sgr_tilt')
        temp.gr = Std.Sgr_tilt;
        temp.seg = Std.Sseg_tilt;
        Aindex.S_tilt = (temp.seg-temp.gr)/(temp.seg+temp.gr);
        temp.gr = Std.Sgr_obli;
        temp.seg = Std.Sseg_obli;
        Aindex.S_obli = (temp.seg-temp.gr)/(temp.seg+temp.gr);
        temp.gr = Std.Sgr_rota;
        temp.seg = Std.Sseg_rota;
        Aindex.S_rota = (temp.seg-temp.gr) / (temp.seg+temp.gr);
    end
    if isfield(Std,'Hgr_tilt')
        temp.gr = Std.Hgr_tilt;
        temp.seg = Std.Hseg_tilt;
        Aindex.H_tilt = (temp.seg-temp.gr)/(temp.seg+temp.gr);
        temp.gr = Std.Hgr_obli;
        temp.seg = Std.Hseg_obli;
        Aindex.H_obli = (temp.seg-temp.gr)/(temp.seg+temp.gr);
        temp.gr = Std.Hgr_rota;
        temp.seg = Std.Hseg_rota;
        Aindex.H_rota = (temp.seg-temp.gr)/(temp.seg+temp.gr);
    end

    % =====================================================================
    % Intercorrelation functions
    % =====================================================================
    if ~isempty(Posturalangles.Hgr_tilt) && ...
            ~isempty(Posturalangles.Sgr_tilt)
        [Ifunction.HA_TA_TI,Idephasing.HA_TA_TI] = ...
            xcorr(Posturalangles.Hgr_tilt,Posturalangles.Sgr_tilt,'coeff');
        [Ifunction.HA_TA_OB,Idephasing.HA_TA_OB] = ...
            xcorr(Posturalangles.Hgr_obli,Posturalangles.Sgr_obli,'coeff');
        [Ifunction.HA_TA_RO,Idephasing.HA_TA_RO] = ...
            xcorr(Posturalangles.Hgr_rota,Posturalangles.Sgr_rota,'coeff');
    end
    if ~isempty(Posturalangles.Sgr_tilt) && ...
            ~isempty(Posturalangles.Pgr_tilt)
        [Ifunction.TA_PA_TI,Idephasing.TA_PA_TI] = ...
            xcorr(Posturalangles.Sgr_tilt,Posturalangles.Pgr_tilt,'coeff');
        [Ifunction.TA_PA_OB,Idephasing.TA_PA_OB] = ...
            xcorr(Posturalangles.Sgr_obli,Posturalangles.Pgr_obli,'coeff');
        [Ifunction.TA_PA_RO,Idephasing.TA_PA_RO] = ...
            xcorr(Posturalangles.Sgr_rota,Posturalangles.Pgr_rota,'coeff');
    end
    
end

% =========================================================================
% Store indexes
% =========================================================================
Posturalindex.Std = Std;
Posturalindex.Aindex = Aindex;
Posturalindex.Ifunction = Ifunction;
Posturalindex.Idephasing = Idephasing;