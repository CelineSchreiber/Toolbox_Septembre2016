function Markers2 = modifyMarkersNames(Markers)

Markers2.R_IAS = Markers.R_ASIS ;
Markers2.R_IPS = Markers.R_PSIS ;
Markers2.R_FTC = Markers.R_GTR ;
Markers2.R_FLE = Markers.R_Knee ;
if isfield(Markers,'R_Knee_Medial')
    Markers2.R_FME = Markers.R_Knee_Medial ;
end
Markers2.R_FAX = Markers.R_HF ;
Markers2.R_TTC = Markers.R_TT ;
Markers2.R_FAL = Markers.R_Ankle ;
if isfield(Markers,'R_Ankle_Medial')
    Markers2.R_TAM = Markers.R_Ankle_Medial ;
end
Markers2.R_FCC = Markers.R_Heel ;
Markers2.R_FM1 = Markers.R_MT1 ;
if isfield(Markers,'R_MT2')
    Markers2.R_FM2 = Markers.R_MT2 ;
end
Markers2.R_FM5 = Markers.R_MT5 ;

Markers2.L_IAS = Markers.L_ASIS ;
Markers2.L_IPS = Markers.L_PSIS ;
Markers2.L_FTC = Markers.L_GTR ;
Markers2.L_FLE = Markers.L_Knee ;
if isfield(Markers,'L_Knee_Medial')
    Markers2.L_FME = Markers.L_Knee_Medial ;
end
Markers2.L_FAX = Markers.L_HF ;
Markers2.L_TTC = Markers.L_TT ;
Markers2.L_FAL = Markers.L_Ankle ;
if isfield(Markers,'L_Ankle_Medial')
    Markers2.L_TAM = Markers.L_Ankle_Medial ;
end
Markers2.L_FCC = Markers.L_Heel ;
Markers2.L_FM1 = Markers.L_MT1 ;
if isfield(Markers,'L_MT2')
    Markers2.L_FM2 = Markers.L_MT2 ;
end
Markers2.L_FM5 = Markers.L_MT5 ;