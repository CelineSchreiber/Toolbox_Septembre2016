% =========================================================================
% REHAZENTER TOOLBOX
% =========================================================================
% File name:    sessionInformation
% -------------------------------------------------------------------------
% Subject:      Load session, patient and pathology information
% -------------------------------------------------------------------------
% Inputs:       - .xlsx file containing session and patient information
% Outputs:      - Patient (structure)
%               - Pathology (structure)
%               - Treatment (structure)
%               - Examination (structure)
%               - Session (structure)
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber, A. Naaim
% Date of creation: 26/03/2014
% Version: 1
% -------------------------------------------------------------------------
% Updates: - 15/05/2014: Read BTS system information from .xlsx file
%          - 05/09/2014: .xlsx file extended with pathology information,
%            Read pathology information
%          - 26/09/2014: Store static information and introduction of
%            the variables gaittrial, emgtrial and posturetrial to check
%            the kind of information contained in the gait file
%          - 26/11/2014: Introduction of the Treatment structure
%          - 27/11/2014: Introduction of the Examination structure
%          - 22/02/2016: Update of the .xlsx file (v2)
% =========================================================================

function [Patient,Pathology,Treatment,Examination,Session] = sessionInformation(filesFolder)

% =========================================================================
% Initialisation
% =========================================================================
Patient = [];
Pathology = [];
Treatment = [];
Examination = [];
Session = [];

% =========================================================================
% Load session information file
% =========================================================================
cd(filesFolder);
filename = 'sessionInformation.xlsx';                                      % The file name MUST always be the same
Excel = actxserver('Excel.Application');
Excel.Workbooks.Open([filesFolder,'\',filename]);
Excel.Workbooks.Item(filename).RunAutoMacros(1);
File =  [filesFolder,'\',filename];
if ~exist(File,'file')
    ExcelWorkbook = Excel.Workbooks.Add;
    ExcelWorkbook.SaveAs(File,1);
    ExcelWorkbook.Close(false);
end
% Excel.Workbooks.Open(File); 

% =========================================================================
% Get patient information
% =========================================================================
[~, temp1] = xlsread1(Excel,filename,1,'B7');
[~, temp2] = xlsread1(Excel,filename,1,'B8');
[~, temp3] = xlsread1(Excel,filename,1,'B9');
[~, temp4] = xlsread1(Excel,filename,1,'B10');
Patient.lastname = temp1{1};                                               % Patient last name
Patient.firstname = temp2{1};                                              % Patient first name
Patient.gender = temp3{1};                                                 % Gender: 'Homme' or 'Femme'
Patient.birthdate = temp4{1};                                              % Patient date of birth (YYYY-MM-DD)

% =========================================================================
% Get session information
% =========================================================================
[temp5] = xlsread1(Excel,filename,1,'B11');
[temp6] = xlsread1(Excel,filename,1,'B12');
[~, temp7] = xlsread1(Excel,filename,1,'B13');
[~, temp8] = xlsread1(Excel,filename,1,'B14');
[~, temp9] = xlsread1(Excel,filename,1,'B17');
[~, temp10] = xlsread1(Excel,filename,1,'B18');
[~, temp11] = xlsread1(Excel,filename,1,'B19');
[~, temp12] = xlsread1(Excel,filename,1,'B20');
Session.weight = temp5(1);                                                 % Patient weight (kg)
Session.height = temp6(1)*1e-2;                                            % Patient height (m)
if ~isempty(temp7)
    Session.reason = temp7{1};                                             % Session reason
else
    Session.reason = '';
end
if ~isempty(temp8)
    Session.comments = temp8{1};                                           % Comments
else
    Session.comments = '';
end
Session.system = temp9{1};                                                 % System used: 'BTS' or 'Qualisys'
Session.date = temp10{1};                                                  % Date of the session (YYYY-MM-DD)
if ~isempty(temp11)
    Session.clinician = temp11{1};                                         % Clinician
else
    Session.clinician = '';
end
if ~isempty(temp12)
    Session.operator = temp12{1};                                          % Operator
else
    Session.operator = '';
end                                            

if strcmp(Session.system,'BTS')
    [temp101] = xlsread1(Excel,filename,3,'B1');
    [temp102] = xlsread1(Excel,filename,3,'B2');
    [temp103] = xlsread1(Excel,filename,3,'B3');
    [temp104] = xlsread1(Excel,filename,3,'B4');
    [temp105] = xlsread1(Excel,filename,3,'B5');
    [temp106] = xlsread1(Excel,filename,3,'B6');
    [temp107] = xlsread1(Excel,filename,3,'B7');
    [temp108] = xlsread1(Excel,filename,3,'B8');
    [temp109] = xlsread1(Excel,filename,3,'B9');
    Session.pelvis_width = temp101*1e-2;                                   % Pelvis width (m)
    Session.right_hip_width = temp102*1e-2;                                % Right hip width (m)
    Session.left_hip_width = temp103*1e-2;                                 % Left hip width (m)
    Session.right_leg_length = [];%temp104*1e-2;                           % Right leg length (m)
    Session.left_leg_length = [];%temp105*1e-2;                            % Left leg length (m)
    Session.right_knee_width = temp106*1e-2;                               % Right knee width (m)
    Session.left_knee_width = temp107*1e-2;                                % Left knee width (m)
    Session.right_ankle_width = temp108*1e-2;                              % Right ankle width (m)
    Session.left_ankle_width = temp109*1e-2;                               % Left ankle width (m)
    Session.marker_height = 1.5*1e-2;                                      % Markers height (m)
else
    Session.pelvis_width = [];
    Session.right_hip_width = [];
    Session.left_hip_width = [];
    Session.right_leg_length = [];
    Session.left_leg_length = [];
    Session.right_knee_width = [];
    Session.left_knee_width = [];
    Session.right_ankle_width = [];
    Session.left_ankle_width = [];
    Session.marker_height = [];
end

% =========================================================================
% Get protocole information
% =========================================================================
[~, temp13] = xlsread1(Excel,filename,1,'B24');
[~, temp13b] = xlsread1(Excel,filename,1,'F24');
[~, temp13c] = xlsread1(Excel,filename,1,'F25');
[~, temp14] = xlsread1(Excel,filename,1,'B25');
[~, temp15] = xlsread1(Excel,filename,1,'C26');
[~, temp16] = xlsread1(Excel,filename,1,'C27');
[~, temp17] = xlsread1(Excel,filename,1,'C28');
[~, temp18] = xlsread1(Excel,filename,1,'C29');
[~, temp19] = xlsread1(Excel,filename,1,'C30');
[~, temp20] = xlsread1(Excel,filename,1,'C31');
[~, temp21] = xlsread1(Excel,filename,1,'C32');
[~, temp22] = xlsread1(Excel,filename,1,'C33');
[~, temp23] = xlsread1(Excel,filename,1,'G26');
[~, temp24] = xlsread1(Excel,filename,1,'G27');
[~, temp25] = xlsread1(Excel,filename,1,'G28');
[~, temp26] = xlsread1(Excel,filename,1,'G29');
[~, temp27] = xlsread1(Excel,filename,1,'G30');
[~, temp28] = xlsread1(Excel,filename,1,'G31');
[~, temp29] = xlsread1(Excel,filename,1,'G32');
[~, temp30] = xlsread1(Excel,filename,1,'G33');
Session.markersset = temp13{1};                                            % Markers set used
Session.footmarkersset = temp13b{1};    
Session.upperlimbsmarkersset = temp13c{1}; 
Session.course = temp14{1};                                                % Gait course: 'Piste de marche' or 'Tapis de marche'
Session.channel{1} = temp15{1};                                            % EMG channels (please use 'side_name1_name2' format)
Session.channel{2} = temp16{1};                                            % if none, put 'none'
Session.channel{3} = temp17{1}; 
Session.channel{4} = temp18{1}; 
Session.channel{5} = temp19{1}; 
Session.channel{6} = temp20{1}; 
Session.channel{7} = temp21{1}; 
Session.channel{8} = temp22{1}; 
Session.channel{9} = temp23{1}; 
Session.channel{10} = temp24{1}; 
Session.channel{11} = temp25{1}; 
Session.channel{12} = temp26{1}; 
Session.channel{13} = temp27{1}; 
Session.channel{14} = temp28{1}; 
Session.channel{15} = temp29{1}; 
Session.channel{16} = temp30{1}; 

% =========================================================================
% Get info (static or trial)
% =========================================================================

for i=37:174
    [~, test] = xlsread1(Excel,filename,1,['A',num2str(i)]);
    if ~isempty(test)
        if strncmp(test,'static',6)
            index_last_static=i;
        end
    end
end
% =========================================================================
% Get static information
% =========================================================================
j = 1;
for i = 37:index_last_static 
    [~, test] = xlsread1(Excel,filename,1,['A',num2str(i)]);
    if ~isempty(test)
        [~, test1] = xlsread1(Excel,filename,1,['F',num2str(i)]);        % Cell checked or not?
        if strcmp(test1,'X')                                               % Test tracking
            [~, test2] = xlsread1(Excel,filename,1,['G',num2str(i)]);    % Cell checked or not?   
            [~, test3] = xlsread1(Excel,filename,1,['H',num2str(i)]);
            [~, test4] = xlsread1(Excel,filename,1,['I',num2str(i)]);
            [~, test5] = xlsread1(Excel,filename,1,['K',num2str(i)]);
            [~, test6] = xlsread1(Excel,filename,1,['L',num2str(i)]);
            if ~isempty(test2) || ~isempty(test3) || ~isempty(test4) || ~isempty(test5) || ~isempty(test6)
                [~, tmp1] = xlsread1(Excel,filename,1,['D',num2str(i)]); % Condition
                Session.Static(j).condition = tmp1{1};
                Session.Static(j).filename = [char(test),'.c3d'];
                Session.Static(j).gaittrial = 'no';
                Session.Static(j).emgtrial = 'no';
                Session.Static(j).posturetrial = 'no';
                Session.Static(j).foottrial = 'no';
                Session.Static(j).upperlimbstrial = 'no';
                if strcmp(test2,'X')                                       % The current record has been selected as a gait trial (kin/dyn)
                    Session.Static(j).gaittrial = 'yes';
                end
                if strcmp(test3,'X')                                       % The current record has been selected as a EMG trial
                    Session.Static(j).emgtrial = 'yes';
                end
                if strcmp(test4,'X')                                       % The current record has been selected as a posture trial
                    Session.Static(j).posturetrial = 'yes';
                end
                if strcmp(test5,'X')                                       % The current record has been selected as a posture trial
                    Session.Static(j).foottrial = 'yes';
                end
                if strcmp(test6,'X')                                       % The current record has been selected as a posture trial
                    Session.Static(j).upperlimbstrial = 'yes';
                end
                j = j+1;
            end
        end
    else
        break;
    end
end

% =========================================================================
% Get records information
% =========================================================================
j = 1;
for i = (index_last_static+1):174 
    [~, test] = xlsread1(Excel,filename,1,['A',num2str(i)]);
    if ~isempty(test)
        [~, test1] = xlsread1(Excel,filename,1,['G',num2str(i)]);        % Cell checked or not?   
        [~, test2] = xlsread1(Excel,filename,1,['H',num2str(i)]);
        [~, test3] = xlsread1(Excel,filename,1,['I',num2str(i)]);
        [~, test4] = xlsread1(Excel,filename,1,['K',num2str(i)]);
        [~, test5] = xlsread1(Excel,filename,1,['L',num2str(i)]);
        if ~isempty(test1) || ~isempty(test2) || ~isempty(test3) || ~isempty(test4) || ~isempty(test5)
            tmp1 = xlsread1(Excel,filename,1,['B',num2str(i)]);            % PF Right
            tmp2 = xlsread1(Excel,filename,1,['C',num2str(i)]);            % PF Left
            Session.Gait(j).s(1,1) = tmp1;                                 % Column 1: right foot, column2: left foot
            Session.Gait(j).s(1,2) = tmp2;                                 % No GRF: 0, GRF on forceplate1: 1, GRF onf forceplate2: 2
            [~, tmp3] = xlsread1(Excel,filename,1,['D',num2str(i)]);     % Condition
            [~, tmp4] = xlsread1(Excel,filename,1,['E',num2str(i)]);     % Details
            Session.Gait(j).condition = tmp3{1};
            if ~isempty(tmp4)
                Session.Gait(j).details = tmp4{1};
            else
                Session.Gait(j).details = '';
            end
            Session.Gait(j).filename = [char(test),'.c3d'];
            Session.Gait(j).gaittrial = 'no';
            Session.Gait(j).emgtrial = 'no';
            Session.Gait(j).posturetrial = 'no';
            Session.Gait(j).foottrial = 'no';
            Session.Gait(j).upperlimbstrial = 'no';
            if strcmp(test1,'X')                                           % The current record has been selected as a gait trial (kin/dyn)
                Session.Gait(j).gaittrial = 'yes';  
            end
            if strcmp(test2,'X')                                           % The current record has been selected as a EMG trial
                Session.Gait(j).emgtrial = 'yes';
            end            
            if strcmp(test3,'X')                                           % The current record has been selected as a posture trial
                Session.Gait(j).posturetrial = 'yes';
            end
            if strcmp(test4,'X')                                           % The current record has been selected as a posture trial
                Session.Gait(j).foottrial = 'yes';
            end
            if strcmp(test5,'X')                                           % The current record has been selected as a posture trial
                Session.Gait(j).upperlimbstrial = 'yes';
            end
            j = j+1; 
        end
    else
        break;
    end
end

% =========================================================================
% Get clinical information
% =========================================================================
[~, temp31] = xlsread1(Excel,filename,2,'B7');
[~, temp32] = xlsread1(Excel,filename,2,'B8');
[~, temp33] = xlsread1(Excel,filename,2,'B9');
[~, temp34] = xlsread1(Excel,filename,2,'B11');
[~, temp35] = xlsread1(Excel,filename,2,'B12');
[~, temp36] = xlsread1(Excel,filename,2,'B14');
[~, temp37] = xlsread1(Excel,filename,2,'B15');
[~, temp38] = xlsread1(Excel,filename,2,'B18');
[~, temp39] = xlsread1(Excel,filename,2,'B19');
[~, temp40] = xlsread1(Excel,filename,2,'B20');
[~, temp41] = xlsread1(Excel,filename,2,'B21');
[~, temp42] = xlsread1(Excel,filename,2,'B22');
[~, temp43] = xlsread1(Excel,filename,2,'B23');
[~, temp44] = xlsread1(Excel,filename,2,'B24');
[~, temp45] = xlsread1(Excel,filename,2,'B25');
if ~isempty(temp31)                                                        % Pathology name: view full list in documentation
    Pathology.name = temp31{1};
else
    Pathology.name = '';
end
if ~isempty(temp32)                                                        % Pathology type: neurologic, ortho/traumotologic
    Pathology.type = temp32{1};
else
    Pathology.type = '';
end
if ~isempty(temp33)                                                        % Comments
    Pathology.comments = temp33{1};
else
    Pathology.comments = '';
end
if ~isempty(temp34)                                                        % Accident date
    Pathology.accidentdate = temp34{1};
else
    Pathology.accidentdate = '';
end
if ~isempty(temp35)                                                        % Accident type: AVC ischio, AVC hemo, other
    Pathology.accidenttype = temp35{1};
else
    Pathology.accidenttype = '';
end
if ~isempty(temp36)                                                        % Affected side: right, left, both
    Pathology.affectedside = temp36{1}; 
else
    Pathology.affectedside = '';
end                 
if ~isempty(temp37)                                                        % Affected limb: upper, lower, both
    Pathology.affectedlimb = temp37{1};
else
    Pathology.affectedlimb = '';
end
if ~isempty(temp38)                                                        % Last injection date
    Treatment.injectiondate = temp38{1};
else
    Treatment.injectiondate = '';
end
if ~isempty(temp39)                                                        % Injected muscle 1
    Treatment.injectedmuscle1 = temp39{1};
else
    Treatment.injectedmuscle1 = '';
end
if ~isempty(temp40)                                                        % Injected muscle 2
    Treatment.injectedmuscle2 = temp40{1};
else
    Treatment.injectedmuscle2 = '';
end
if ~isempty(temp41)                                                        % Injected muscle 3
    Treatment.injectedmuscle3 = temp41{1};
else
    Treatment.injectedmuscle3 = '';
end
if ~isempty(temp42)                                                        % Injected muscle 4
    Treatment.injectedmuscle4 = temp42{1};
else
    Treatment.injectedmuscle4 = '';
end
if ~isempty(temp43)                                                        % Injected muscle 5
    Treatment.injectedmuscle5 = temp43{1};
else
    Treatment.injectedmuscle5 = '';
end
if ~isempty(temp44)                                                        % Last surgery date
    Treatment.surgerydate = temp44{1};
else
    Treatment.surgerydate = '';
end
if ~isempty(temp45)                                                        % Last surgery purpose
    Treatment.surgerypurpose = temp45{1};
else
    Treatment.surgerypurpose = '';
end

% =========================================================================
% Get clinical examination information
% =========================================================================
if isempty(strfind(Patient.lastname,'SS20'))
    
    % Passive ranges of motion
    % ---------------------------------------------------------------------
    [~, ~, temp46] = xlsread1(Excel,filename,4,'F9');
    [~, ~, temp47] = xlsread1(Excel,filename,4,'F10');
    [~, ~, temp48] = xlsread1(Excel,filename,4,'F11');
    [~, ~, temp49] = xlsread1(Excel,filename,4,'F12');
    [~, ~, temp50] = xlsread1(Excel,filename,4,'F13');
    [~, ~, temp51] = xlsread1(Excel,filename,4,'F14');
    [~, ~, temp52] = xlsread1(Excel,filename,4,'F15');
    [~, ~, temp53] = xlsread1(Excel,filename,4,'F16');
    [~, ~, temp54] = xlsread1(Excel,filename,4,'F17');
    [~, ~, temp55] = xlsread1(Excel,filename,4,'G17');
    [~, ~, temp56] = xlsread1(Excel,filename,4,'F18');
    [~, ~, temp57] = xlsread1(Excel,filename,4,'G18');
    [~, ~, temp58] = xlsread1(Excel,filename,4,'F19');

    [~, ~, temp59] = xlsread1(Excel,filename,4,'F21');
    [~, ~, temp60] = xlsread1(Excel,filename,4,'F22');
    [~, ~, temp61] = xlsread1(Excel,filename,4,'F23');
    [~, ~, temp62] = xlsread1(Excel,filename,4,'F24');
    [~, ~, temp63] = xlsread1(Excel,filename,4,'F25');
    [~, ~, temp64] = xlsread1(Excel,filename,4,'F26');
    [~, ~, temp65] = xlsread1(Excel,filename,4,'F27');
    [~, ~, temp66] = xlsread1(Excel,filename,4,'F28');

    [~, ~, temp67] = xlsread1(Excel,filename,4,'F30');
    [~, ~, temp68] = xlsread1(Excel,filename,4,'F31');
    [~, ~, temp69] = xlsread1(Excel,filename,4,'F32');
    [~, ~, temp70] = xlsread1(Excel,filename,4,'F33');
    [~, ~, temp71] = xlsread1(Excel,filename,4,'F34');

    [~, ~, temp72] = xlsread1(Excel,filename,4,'F35');
    [~, ~, temp73] = xlsread1(Excel,filename,4,'F36');
    [~, ~, temp74] = xlsread1(Excel,filename,4,'F37');
    [~, ~, temp75] = xlsread1(Excel,filename,4,'G37');
    [~, ~, temp76] = xlsread1(Excel,filename,4,'F38');
    [~, ~, temp77] = xlsread1(Excel,filename,4,'G38');
    [~, ~, temp78] = xlsread1(Excel,filename,4,'F39');
    [~, ~, temp79] = xlsread1(Excel,filename,4,'F40');
    [~, ~, temp80] = xlsread1(Excel,filename,4,'F41');
    [~, ~, temp81] = xlsread1(Excel,filename,4,'F42');
    [~, ~, temp82] = xlsread1(Excel,filename,4,'F43');
    [~, ~, temp83] = xlsread1(Excel,filename,4,'F44');
    [~, ~, temp84] = xlsread1(Excel,filename,4,'G44');
    [~, ~, temp85] = xlsread1(Excel,filename,4,'F45');
    [~, ~, temp86] = xlsread1(Excel,filename,4,'F46');
    [~, ~, temp87] = xlsread1(Excel,filename,4,'F47');
    [~, ~, temp88] = xlsread1(Excel,filename,4,'F48');
    [~, ~, temp89] = xlsread1(Excel,filename,4,'F49');

    if ~isnan(temp46{1})                                                    
        Examination.Rprom.Hip.flexion = num2str(temp46{1});
    else
        Examination.Rprom.Hip.flexion = '';
    end
    if ~isnan(temp47{1})                                                    
        Examination.Rprom.Hip.extensionKneeExt = num2str(temp47{1});
    else
        Examination.Rprom.Hip.extensionKneeExt = '';
    end
    if ~isnan(temp48{1})                                                    
        Examination.Rprom.Hip.extensionKneeFlex = num2str(temp48{1});
    else
        Examination.Rprom.Hip.extensionKneeFlex = '';
    end
    if ~isnan(temp49{1})                                                    
        Examination.Rprom.Hip.extensionThomas = num2str(temp49{1});
    else
        Examination.Rprom.Hip.extensionThomas = '';
    end
    if ~isnan(temp50{1})                                                    
        Examination.Rprom.Hip.abductionHipFlexKneeFlex = num2str(temp50{1});
    else
        Examination.Rprom.Hip.abductionHipFlexKneeFlex = '';
    end
    if ~isnan(temp51{1})                                                    
        Examination.Rprom.Hip.abductionHipExtKneeFlex = num2str(temp51{1});
    else
        Examination.Rprom.Hip.abductionHipExtKneeFlex = '';
    end
    if ~isnan(temp52{1})                                                    
        Examination.Rprom.Hip.abductionHipExtKneeExt = num2str(temp52{1});
    else
        Examination.Rprom.Hip.abductionHipExtKneeExt = '';
    end
    if ~isnan(temp53{1})                                                    
        Examination.Rprom.Hip.adduction = num2str(temp53{1});
    else
        Examination.Rprom.Hip.adduction = '';
    end
    if ~isnan(temp54)                                                    
        Examination.Rprom.Hip.rotationIntDD = num2str(temp54);
    else
        Examination.Rprom.Hip.rotationIntDD = '';
    end
    if ~isnan(temp55)                                                    
        Examination.Rprom.Hip.rotationExtDD = num2str(temp55);
    else
        Examination.Rprom.Hip.rotationExtDD = '';
    end
    if ~isnan(temp56)                                                    
        Examination.Rprom.Hip.rotationIntDV = num2str(temp56);
    else
        Examination.Rprom.Hip.rotationIntDV = '';
    end
    if ~isnan(temp57)                                                    
        Examination.Rprom.Hip.rotationExtDV = num2str(temp57);
    else
        Examination.Rprom.Hip.rotationExtDV = '';
    end
    if ~isnan(temp58{1})                                                    
        Examination.Rprom.Hip.antetorsionFemorale = num2str(temp58{1});
    else
        Examination.Rprom.Hip.antetorsionFemorale = '';
    end
    %------------------  
    if ~isnan(temp59{1})                                                    
        Examination.Rprom.Knee.flexion = temp59{1};
    else
        Examination.Rprom.Knee.flexion = '';
    end 
    if ~isnan(temp60{1})                                                    
        Examination.Rprom.Knee.extension = temp60{1};
    else
        Examination.Rprom.Knee.extension = '';
    end
    if ~isnan(temp61{1})                                                    
        Examination.Rprom.Knee.raideurArt = temp61{1};
    else
        Examination.Rprom.Knee.raideurArt = '';
    end
    if ~isnan(temp62{1})                                                    
        Examination.Rprom.Knee.angleMort = temp62{1};
    else
        Examination.Rprom.Knee.angleMort = '';
    end
    if ~isnan(temp63{1})                                                    
        Examination.Rprom.Knee.rotuleHte = temp63{1};
    else
        Examination.Rprom.Knee.rotuleHte = '';
    end
    if ~isnan(temp64{1})                                                    
        Examination.Rprom.Knee.cocontractions = temp64{1};
    else
        Examination.Rprom.Knee.cocontractions = '';
    end
    if ~isnan(temp65{1})                                                    
        Examination.Rprom.Knee.anglePopUni = temp65{1};
    else
        Examination.Rprom.Knee.anglePopUni = '';
    end
    if ~isnan(temp66{1})                                                    
        Examination.Rprom.Knee.anglePopBi = temp66{1};
    else
        Examination.Rprom.Knee.anglePopBi = '';
    end
    %------------------ 
    if ~isnan(temp67{1})                                                    
        Examination.Rprom.Ankle.plantarflex = temp67{1};
    else
        Examination.Rprom.Ankle.plantarflex = '';
    end
    if ~isnan(temp68{1})                                                    
        Examination.Rprom.Ankle.dorsiflexSilverskold = temp68{1};
    else
        Examination.Rprom.Ankle.dorsiflexSilverskold = '';
    end
    if ~isnan(temp69{1})                                                    
        Examination.Rprom.Ankle.dorsiflexKneeExt = temp69{1};
    else
        Examination.Rprom.Ankle.dorsiflexKneeExt = '';
    end
    if ~isnan(temp70{1})                                                    
        Examination.Rprom.Ankle.dorsiflexKneeFlex = temp70{1};
    else
        Examination.Rprom.Ankle.dorsiflexKneeFlex = '';
    end
    if ~isnan(temp71{1})                                                    
        Examination.Rprom.Ankle.dorsiflexMaxCharge = temp71{1};
    else
        Examination.Rprom.Ankle.dorsiflexMaxCharge = '';
    end
    %------------------ 
    if ~isnan(temp72{1})                                                    
        Examination.Rprom.Foot.axeCruroPed = temp72{1};
    else
        Examination.Rprom.Foot.axeCruroPed = '';
    end
    if ~isnan(temp73{1})                                                    
        Examination.Rprom.Foot.axeBiMalleol = temp73{1};
    else
        Examination.Rprom.Foot.axeBiMalleol = '';
    end
    if ~isnan(temp74)                                                    
        Examination.Rprom.Foot.VRspontane = temp74;
    else
        Examination.Rprom.Foot.VRspontane = '';
    end
    if ~isnan(temp75)                                                    
        Examination.Rprom.Foot.VGspontane = temp75;
    else
        Examination.Rprom.Foot.VGspontane = '';
    end
    if ~isnan(temp76)                                                    
        Examination.Rprom.Foot.VRcharge = temp76;
    else
        Examination.Rprom.Foot.VRcharge = '';
    end
    if ~isnan(temp77)                                                    
        Examination.Rprom.Foot.VGcharge = temp77;
    else
        Examination.Rprom.Foot.VGcharge = '';
    end
    if ~isnan(temp78{1})                                                    
        Examination.Rprom.Foot.dislocMedioTars = temp78{1};
    else
        Examination.Rprom.Foot.dislocMedioTars = '';
    end
    if ~isnan(temp79{1})                                                    
        Examination.Rprom.Foot.retractFlexOrteils = temp79{1};
    else
        Examination.Rprom.Foot.retractFlexOrteils = '';
    end
    if ~isnan(temp80{1})                                                    
        Examination.Rprom.Foot.piedPlat = temp80{1};
    else
        Examination.Rprom.Foot.piedPlat = '';
    end
    if ~isnan(temp81{1})                                                    
        Examination.Rprom.Foot.piedCavus = temp81{1};
    else
        Examination.Rprom.Foot.piedCavus = '';
    end
    if ~isnan(temp82{1})                                                    
        Examination.Rprom.Foot.piedConvexe = temp82{1};
    else
        Examination.Rprom.Foot.piedConvexe = '';
    end
    if ~isnan(temp83)                                                    
        Examination.Rprom.Foot.adductusAvPied = temp83;
    else
        Examination.Rprom.Foot.adductusAvPied = '';
    end
    if ~isnan(temp84)                                                    
        Examination.Rprom.Foot.abductusAvPied = temp84;
    else
        Examination.Rprom.Foot.abductusAvPied = '';
    end
    if ~isnan(temp85{1})                                                    
        Examination.Rprom.Foot.halluxValgus = temp85{1};
    else
        Examination.Rprom.Foot.halluxValgus = '';
    end
    if ~isnan(temp86{1})                                                    
        Examination.Rprom.Foot.halluxFlexus = temp86{1};
    else
        Examination.Rprom.Foot.halluxFlexus = '';
    end
    if ~isnan(temp87{1})                                                    
        Examination.Rprom.Foot.halluxRigidus = temp87{1};
    else
        Examination.Rprom.Foot.halluxRigidus = '';
    end
    if ~isnan(temp88{1})                                                    
        Examination.Rprom.Foot.griffePassive = num2str(temp88{1});
    else
        Examination.Rprom.Foot.griffePassive = '';
    end
    if ~isnan(temp89{1})                                                    
        Examination.Rprom.Foot.griffeDynamic = num2str(temp89{1});
    else
        Examination.Rprom.Foot.griffeDynamic = '';
    end

    % Left side
    [~, ~, temp91] = xlsread1(Excel,filename,4,'H9');
    [~, ~, temp92] = xlsread1(Excel,filename,4,'H10');
    [~, ~, temp93] = xlsread1(Excel,filename,4,'H11');
    [~, ~, temp94] = xlsread1(Excel,filename,4,'H12');
    [~, ~, temp95] = xlsread1(Excel,filename,4,'H13');
    [~, ~, temp96] = xlsread1(Excel,filename,4,'H14');
    [~, ~, temp97] = xlsread1(Excel,filename,4,'H15');
    [~, ~, temp98] = xlsread1(Excel,filename,4,'H16');
    [~, ~, temp99] = xlsread1(Excel,filename,4,'H17');
    [~, ~, temp100] = xlsread1(Excel,filename,4,'I17');
    [~, ~, temp101] = xlsread1(Excel,filename,4,'H18');
    [~, ~, temp102] = xlsread1(Excel,filename,4,'I18');
    [~, ~, temp103] = xlsread1(Excel,filename,4,'H19');

    [~, ~, temp104] = xlsread1(Excel,filename,4,'H21');
    [~, ~, temp105] = xlsread1(Excel,filename,4,'H22');
    [~, ~, temp106] = xlsread1(Excel,filename,4,'H23');
    [~, ~, temp107] = xlsread1(Excel,filename,4,'H24');
    [~, ~, temp108] = xlsread1(Excel,filename,4,'H25');
    [~, ~, temp109] = xlsread1(Excel,filename,4,'H26');
    [~, ~, temp110] = xlsread1(Excel,filename,4,'H27');
    [~, ~, temp111] = xlsread1(Excel,filename,4,'H28');

    [~, ~, temp112] = xlsread1(Excel,filename,4,'H30');
    [~, ~, temp113] = xlsread1(Excel,filename,4,'H31');
    [~, ~, temp114] = xlsread1(Excel,filename,4,'H32');
    [~, ~, temp115] = xlsread1(Excel,filename,4,'H33');
    [~, ~, temp116] = xlsread1(Excel,filename,4,'H34');

    [~, ~, temp117] = xlsread1(Excel,filename,4,'H35');
    [~, ~, temp118] = xlsread1(Excel,filename,4,'H36');
    [~, ~, temp119] = xlsread1(Excel,filename,4,'H37');
    [~, ~, temp120] = xlsread1(Excel,filename,4,'I37');
    [~, ~, temp121] = xlsread1(Excel,filename,4,'H38');
    [~, ~, temp122] = xlsread1(Excel,filename,4,'I38');
    [~, ~, temp123] = xlsread1(Excel,filename,4,'H39');
    [~, ~, temp124] = xlsread1(Excel,filename,4,'H40');
    [~, ~, temp125] = xlsread1(Excel,filename,4,'H41');
    [~, ~, temp126] = xlsread1(Excel,filename,4,'H42');
    [~, ~, temp127] = xlsread1(Excel,filename,4,'H43');
    [~, ~, temp128] = xlsread1(Excel,filename,4,'H44');
    [~, ~, temp129] = xlsread1(Excel,filename,4,'I44');
    [~, ~, temp130] = xlsread1(Excel,filename,4,'H45');
    [~, ~, temp131] = xlsread1(Excel,filename,4,'H46');
    [~, ~, temp132] = xlsread1(Excel,filename,4,'H47');
    [~, ~, temp133] = xlsread1(Excel,filename,4,'H48');
    [~, ~, temp134] = xlsread1(Excel,filename,4,'H49');

    if ~isnan(temp91{1})                                                    
        Examination.Lprom.Hip.flexion = temp91{1};
    else
        Examination.Lprom.Hip.flexion = '';
    end
    if ~isnan(temp92{1})                                                    
        Examination.Lprom.Hip.extensionKneeExt = temp92{1};
    else
        Examination.Lprom.Hip.extensionKneeExt = '';
    end
    if ~isnan(temp93{1})                                                    
        Examination.Lprom.Hip.extensionKneeFlex = temp93{1};
    else
        Examination.Lprom.Hip.extensionKneeFlex = '';
    end
    if ~isnan(temp94{1})                                                    
        Examination.Lprom.Hip.extensionThomas = temp94{1};
    else
        Examination.Lprom.Hip.extensionThomas = '';
    end
    if ~isnan(temp95{1})                                                    
        Examination.Lprom.Hip.abductionHipFlexKneeFlex = temp95{1};
    else
        Examination.Lprom.Hip.abductionHipFlexKneeFlex = '';
    end
    if ~isnan(temp96{1})                                                    
        Examination.Lprom.Hip.abductionHipExtKneeFlex = temp96{1};
    else
        Examination.Lprom.Hip.abductionHipExtKneeFlex = '';
    end
    if ~isnan(temp97{1})                                                    
        Examination.Lprom.Hip.abductionHipExtKneeExt = temp97{1};
    else
        Examination.Lprom.Hip.abductionHipExtKneeExt = '';
    end
    if ~isnan(temp98{1})                                                    
        Examination.Lprom.Hip.adduction = temp98{1};
    else
        Examination.Lprom.Hip.adduction = '';
    end
    if ~isnan(temp99)                                                    
        Examination.Lprom.Hip.rotationIntDD = temp99;
    else
        Examination.Lprom.Hip.rotationIntDD = '';
    end
    if ~isnan(temp100)                                                    
        Examination.Lprom.Hip.rotationExtDD = temp100;
    else
        Examination.Lprom.Hip.rotationExtDD = '';
    end
    if ~isnan(temp101)                                                    
        Examination.Lprom.Hip.rotationIntDV = temp101;
    else
        Examination.Lprom.Hip.rotationIntDV = '';
    end
    if ~isnan(temp102)                                                    
        Examination.Lprom.Hip.rotationExtDV = temp102;
    else
        Examination.Lprom.Hip.rotationExtDV = '';
    end
    if ~isnan(temp103{1})                                                    
        Examination.Lprom.Hip.antetorsionFemorale = temp103{1};
    else
        Examination.Lprom.Hip.antetorsionFemorale = '';
    end
    %------------------  
    if ~isnan(temp104{1})                                                    
        Examination.Lprom.Knee.flexion = temp104{1};
    else
        Examination.Lprom.Knee.flexion = '';
    end 
    if ~isnan(temp105{1})                                                    
        Examination.Lprom.Knee.extension = temp105{1};
    else
        Examination.Lprom.Knee.extension = '';
    end
    if ~isnan(temp106{1})                                                    
        Examination.Lprom.Knee.raideurArt = temp106{1};
    else
        Examination.Lprom.Knee.raideurArt = '';
    end
    if ~isnan(temp107{1})                                                    
        Examination.Lprom.Knee.angleMort = temp107{1};
    else
        Examination.Lprom.Knee.angleMort = '';
    end
    if ~isnan(temp108{1})                                                    
        Examination.Lprom.Knee.rotuleHte = temp108{1};
    else
        Examination.Lprom.Knee.rotuleHte = '';
    end
    if ~isnan(temp109{1})                                                    
        Examination.Lprom.Knee.cocontractions = temp109{1};
    else
        Examination.Lprom.Knee.cocontractions = '';
    end
    if ~isnan(temp110{1})                                                    
        Examination.Lprom.Knee.anglePopUni = temp110{1};
    else
        Examination.Lprom.Knee.anglePopUni = '';
    end
    if ~isnan(temp111{1})                                                    
        Examination.Lprom.Knee.anglePopBi = temp111{1};
    else
        Examination.Lprom.Knee.anglePopBi = '';
    end
    %------------------ 
    if ~isnan(temp112{1})                                                    
        Examination.Lprom.Ankle.plantarflex = temp112{1};
    else
        Examination.Lprom.Ankle.plantarflex = '';
    end
    if ~isnan(temp113{1})                                                    
        Examination.Lprom.Ankle.dorsiflexSilverskold = temp113{1};
    else
        Examination.Lprom.Ankle.dorsiflexSilverskold = '';
    end
    if ~isnan(temp114{1})                                                    
        Examination.Lprom.Ankle.dorsiflexKneeExt = temp114{1};
    else
        Examination.Lprom.Ankle.dorsiflexKneeExt = '';
    end
    if ~isnan(temp115{1})                                                    
        Examination.Lprom.Ankle.dorsiflexKneeFlex = temp115{1};
    else
        Examination.Lprom.Ankle.dorsiflexKneeFlex = '';
    end
    if ~isnan(temp116{1})                                                    
        Examination.Lprom.Ankle.dorsiflexMaxCharge = temp116{1};
    else
        Examination.Lprom.Ankle.dorsiflexMaxCharge = '';
    end
    %------------------ 
    if ~isnan(temp117{1})                                                    
        Examination.Lprom.Foot.axeCruroPed = temp117{1};
    else
        Examination.Lprom.Foot.axeCruroPed = '';
    end
    if ~isnan(temp118{1})                                                    
        Examination.Lprom.Foot.axeBiMalleol = temp118{1};
    else
        Examination.Lprom.Foot.axeBiMalleol = '';
    end
    if ~isnan(temp119)                                                    
        Examination.Lprom.Foot.VRspontane = temp119;
    else
        Examination.Lprom.Foot.VRspontane = '';
    end
    if ~isnan(temp120)                                                    
        Examination.Lprom.Foot.VGspontane = temp120;
    else
        Examination.Lprom.Foot.VGspontane = '';
    end
    if ~isnan(temp121)                                                    
        Examination.Lprom.Foot.VRcharge = temp121;
    else
        Examination.Lprom.Foot.VRcharge = '';
    end
    if ~isnan(temp122)                                                    
        Examination.Lprom.Foot.VGcharge = temp122;
    else
        Examination.Lprom.Foot.VGcharge = '';
    end
    if ~isnan(temp123{1})                                                    
        Examination.Lprom.Foot.dislocMedioTars = temp123{1};
    else
        Examination.Lprom.Foot.dislocMedioTars = '';
    end
    if ~isnan(temp124{1})                                                    
        Examination.Lprom.Foot.retractFlexOrteils = temp124{1};
    else
        Examination.Lprom.Foot.retractFlexOrteils = '';
    end
    if ~isnan(temp125{1})                                                    
        Examination.Lprom.Foot.piedPlat = temp125{1};
    else
        Examination.Lprom.Foot.piedPlat = '';
    end
    if ~isnan(temp126{1})                                                    
        Examination.Lprom.Foot.piedCavus = temp126{1};
    else
        Examination.Lprom.Foot.piedCavus = '';
    end
    if ~isnan(temp127{1})                                                    
        Examination.Lprom.Foot.piedConvexe = temp127{1};
    else
        Examination.Lprom.Foot.piedConvexe = '';
    end
    if ~isnan(temp128)                                                    
        Examination.Lprom.Foot.adductusAvPied = temp128;
    else
        Examination.Lprom.Foot.adductusAvPied = '';
    end
    if ~isnan(temp129)                                                    
        Examination.Lprom.Foot.abductusAvPied = temp129;
    else
        Examination.Lprom.Foot.abductusAvPied = '';
    end
    if ~isnan(temp130{1})                                                    
        Examination.Lprom.Foot.halluxValgus = temp130{1};
    else
        Examination.Lprom.Foot.halluxValgus = '';
    end
    if ~isnan(temp131{1})                                                    
        Examination.Lprom.Foot.halluxFlexus = temp131{1};
    else
        Examination.Lprom.Foot.halluxFlexus = '';
    end
    if ~isnan(temp132{1})                                                    
        Examination.Lprom.Foot.halluxRigidus = temp132{1};
    else
        Examination.Lprom.Foot.halluxRigidus = '';
    end
    if ~isnan(temp133{1})                                                    
        Examination.Lprom.Foot.griffePassive = temp133{1};
    else
        Examination.Lprom.Foot.griffePassive = '';
    end
    if ~isnan(temp134{1})                                                    
        Examination.Lprom.Foot.griffeDynamic = temp134{1};
    else
        Examination.Lprom.Foot.griffeDynamic = '';
    end

    % Muscular force
    % ---------------------------------------------------------------------
    % Right side
    [~, ~, temp136] = xlsread1(Excel,filename,4,'M9');
    [~, ~, temp137] = xlsread1(Excel,filename,4,'M11');
    [~, ~, temp138] = xlsread1(Excel,filename,4,'M13');
    [~, ~, temp139] = xlsread1(Excel,filename,4,'M16');
    [~, ~, temp140] = xlsread1(Excel,filename,4,'M18');
    [~, ~, temp141] = xlsread1(Excel,filename,4,'M19');

    [~, ~, temp142] = xlsread1(Excel,filename,4,'M21');
    [~, ~, temp143] = xlsread1(Excel,filename,4,'M25');

    [~, ~, temp144] = xlsread1(Excel,filename,4,'M30');
    [~, ~, temp145] = xlsread1(Excel,filename,4,'M32');
    [~, ~, temp146] = xlsread1(Excel,filename,4,'M33');
    [~, ~, temp147] = xlsread1(Excel,filename,4,'M34');
    [~, ~, temp148] = xlsread1(Excel,filename,4,'M35');
    [~, ~, temp149] = xlsread1(Excel,filename,4,'M36');
    [~, ~, temp150] = xlsread1(Excel,filename,4,'M39');
    [~, ~, temp151] = xlsread1(Excel,filename,4,'M40');
    [~, ~, temp152] = xlsread1(Excel,filename,4,'M41');

    if ~isnan(temp136)                                                    
        Examination.Rforce.Hip.flechisseursDD = temp136;
    else
        Examination.Rforce.Hip.flechisseursDD = '';
    end
    if ~isnan(temp137{1})                                                    
        Examination.Rforce.Hip.extenseurs = temp137{1};
    else
        Examination.Rforce.Hip.extenseurs = '';
    end
    if ~isnan(temp138{1})                                                    
        Examination.Rforce.Hip.abducteurs = temp138{1};
    else
        Examination.Rforce.Hip.abducteurs = '';
    end
    if ~isnan(temp139{1})                                                    
        Examination.Rforce.Hip.adducteurs = temp139{1};
    else
        Examination.Rforce.Hip.adducteurs = '';
    end
    if ~isnan(temp140)                                                    
        Examination.Rforce.Hip.rotInt = temp140;
    else
        Examination.Rforce.Hip.rotInt = '';
    end
    if ~isnan(temp141)                                                    
        Examination.Rforce.Hip.rotExt = temp141;
    else
        Examination.Rforce.Hip.rotExt = '';
    end
    %------------------
    if ~isnan(temp142{1})                                                    
        Examination.Rforce.Knee.flechisseurs = temp142{1};
    else
        Examination.Rforce.Knee.flechisseurs = '';
    end
    if ~isnan(temp143{1})                                                    
        Examination.Rforce.Knee.extenseurs = temp143{1};
    else
        Examination.Rforce.Knee.extenseurs = '';
    end
    %------------------
    if ~isnan(temp144{1})                                                    
        Examination.Rforce.Ankle.tibialisAnt = temp144{1};
    else
        Examination.Rforce.Ankle.tibialisAnt = '';
    end   
    if ~isnan(temp145)                                                    
        Examination.Rforce.Ankle.extDigLong = temp145;
    else
        Examination.Rforce.Ankle.extDigLong = '';
    end  
    if ~isnan(temp146)                                                    
        Examination.Rforce.Ankle.extHalLong = temp146;
    else
        Examination.Rforce.Ankle.extHalLong = '';
    end  
    if ~isnan(temp147)                                                    
        Examination.Rforce.Ankle.peroneus = temp147;
    else
        Examination.Rforce.Ankle.peroneus = '';
    end  
    if ~isnan(temp148)                                                    
        Examination.Rforce.Ankle.tibialisPost = temp148;
    else
        Examination.Rforce.Ankle.tibialisPost = '';
    end  
    if ~isnan(temp149{1})                                                    
        Examination.Rforce.Ankle.gastSol = temp149{1};
    else
        Examination.Rforce.Ankle.gastSol = '';
    end  
    if ~isnan(temp150)                                                    
        Examination.Rforce.Ankle.flexDigLong = temp150;
    else
        Examination.Rforce.Ankle.flexDigLong = '';
    end  
    if ~isnan(temp151)                                                    
        Examination.Rforce.Ankle.flexHalLong = temp151;%{1}
    else
        Examination.Rforce.Ankle.flexHalLong = '';
    end  
    if ~isnan(temp152{1})                                                    
        Examination.Rforce.Ankle.griffe = temp152{1};
    else
        Examination.Rforce.Ankle.griffe = '';
    end  

    % Left side
    [~, ~, temp153] = xlsread1(Excel,filename,4,'P9');
    [~, ~, temp154] = xlsread1(Excel,filename,4,'P11');
    [~, ~, temp155] = xlsread1(Excel,filename,4,'P13');
    [~, ~, temp156] = xlsread1(Excel,filename,4,'P16');
    [~, ~, temp157] = xlsread1(Excel,filename,4,'P18');
    [~, ~, temp158] = xlsread1(Excel,filename,4,'P19');

    [~, ~, temp159] = xlsread1(Excel,filename,4,'P21');
    [~, ~, temp160] = xlsread1(Excel,filename,4,'P25');

    [~, ~, temp161] = xlsread1(Excel,filename,4,'P30');
    [~, ~, temp162] = xlsread1(Excel,filename,4,'P32');
    [~, ~, temp163] = xlsread1(Excel,filename,4,'P33');
    [~, ~, temp164] = xlsread1(Excel,filename,4,'P34');
    [~, ~, temp165] = xlsread1(Excel,filename,4,'P35');
    [~, ~, temp166] = xlsread1(Excel,filename,4,'P36');
    [~, ~, temp167] = xlsread1(Excel,filename,4,'P39');
    [~, ~, temp168] = xlsread1(Excel,filename,4,'P40');
    [~, ~, temp169] = xlsread1(Excel,filename,4,'P41');

    if ~isnan(temp153)                                                    
        Examination.Lforce.Hip.flechisseursDD = temp153;
    else
        Examination.Lforce.Hip.flechisseursDD = '';
    end
    if ~isnan(temp154{1})                                                    
        Examination.Lforce.Hip.extenseurs = temp154{1};
    else
        Examination.Lforce.Hip.extenseurs = '';
    end
    if ~isnan(temp155{1})                                                    
        Examination.Lforce.Hip.abducteurs = temp155{1};
    else
        Examination.Lforce.Hip.abducteurs = '';
    end
    if ~isnan(temp156{1})                                                    
        Examination.Lforce.Hip.adducteurs = temp156{1};
    else
        Examination.Lforce.Hip.adducteurs = '';
    end
    if ~isnan(temp157)                                                    
        Examination.Lforce.Hip.rotInt = temp157;
    else
        Examination.Lforce.Hip.rotInt = '';
    end
    if ~isnan(temp158)                                                    
        Examination.Lforce.Hip.rotExt = temp158;
    else
        Examination.Lforce.Hip.rotExt = '';
    end
    %------------------
    if ~isnan(temp159{1})                                                    
        Examination.Lforce.Knee.flechisseurs = temp159{1};
    else
        Examination.Lforce.Knee.flechisseurs = '';
    end
    if ~isnan(temp160{1})                                                    
        Examination.Lforce.Knee.extenseurs = temp160{1};
    else
        Examination.Lforce.Knee.extenseurs = '';
    end
    %------------------
    if ~isnan(temp161{1})                                                    
        Examination.Lforce.Ankle.tibialisAnt = temp161{1};
    else
        Examination.Lforce.Ankle.tibialisAnt = '';
    end   
    if ~isnan(temp162)                                                    
        Examination.Lforce.Ankle.extDigLong = temp162;
    else
        Examination.Lforce.Ankle.extDigLong = '';
    end  
    if ~isnan(temp163)                                                    
        Examination.Lforce.Ankle.extHalLong = temp163;
    else
        Examination.Lforce.Ankle.extHalLong = '';
    end  
    if ~isnan(temp164)                                                    
        Examination.Lforce.Ankle.peroneus = temp164;
    else
        Examination.Lforce.Ankle.peroneus = '';
    end  
    if ~isnan(temp165)                                                    
        Examination.Lforce.Ankle.tibialisPost = temp165;
    else
        Examination.Lforce.Ankle.tibialisPost = '';
    end  
    if ~isnan(temp166{1})                                                    
        Examination.Lforce.Ankle.gastSol = temp166{1};
    else
        Examination.Lforce.Ankle.gastSol = '';
    end  
    if ~isnan(temp167)                                                    
        Examination.Lforce.Ankle.flexDigLong = temp167;
    else
        Examination.Lforce.Ankle.flexDigLong = '';
    end  
    if ~isnan(temp168)                                                    
        Examination.Lforce.Ankle.flexHalLong = temp168;
    else
        Examination.Lforce.Ankle.flexHalLong = '';
    end  
    if ~isnan(temp169{1})                                                    
        Examination.Lforce.Ankle.griffe = temp169{1};
    else
        Examination.Lforce.Ankle.griffe = '';
    end  

    % Muscular selectivity
    % ---------------------------------------------------------------------
    % Right side
    [~, ~, temp170] = xlsread1(Excel,filename,4,'O9');
    [~, ~, temp171] = xlsread1(Excel,filename,4,'O11');
    [~, ~, temp172] = xlsread1(Excel,filename,4,'O13');
    [~, ~, temp173] = xlsread1(Excel,filename,4,'O16');
    [~, ~, temp174] = xlsread1(Excel,filename,4,'O18');
    [~, ~, temp175] = xlsread1(Excel,filename,4,'O19');

    [~, ~, temp176] = xlsread1(Excel,filename,4,'O21');
    [~, ~, temp177] = xlsread1(Excel,filename,4,'O25');

    [~, ~, temp178] = xlsread1(Excel,filename,4,'O30');
    [~, ~, temp179] = xlsread1(Excel,filename,4,'O32');
    [~, ~, temp180] = xlsread1(Excel,filename,4,'O34');
    [~, ~, temp181] = xlsread1(Excel,filename,4,'O35');
    [~, ~, temp182] = xlsread1(Excel,filename,4,'O36');
    [~, ~, temp183] = xlsread1(Excel,filename,4,'O39');
    [~, ~, temp184] = xlsread1(Excel,filename,4,'O40');

    if ~isnan(temp170)                                                    
        Examination.Rselectivity.Hip.flechisseursDD = temp170;
    else
        Examination.Rselectivity.Hip.flechisseursDD = '';
    end 
    if ~isnan(temp171{1})                                                    
        Examination.Rselectivity.Hip.extenseurs = temp171{1};
    else
        Examination.Rselectivity.Hip.extenseurs = '';
    end 
    if ~isnan(temp172{1})                                                    
        Examination.Rselectivity.Hip.abducteurs = temp172{1};
    else
        Examination.Rselectivity.Hip.abducteurs = '';
    end 
    if ~isnan(temp173{1})                                                    
        Examination.Rselectivity.Hip.adducteurs = temp173{1};
    else
        Examination.Rselectivity.Hip.adducteurs = '';
    end 
    if ~isnan(temp174)                                                    
        Examination.Rselectivity.Hip.rotInt = temp174;
    else
        Examination.Rselectivity.Hip.rotInt = '';
    end 
    if ~isnan(temp175)                                                    
        Examination.Rselectivity.Hip.rotExt = temp175;
    else
        Examination.Rselectivity.Hip.rotExt = '';
    end 
    %------------------
    if ~isnan(temp176{1})                                                    
        Examination.Rselectivity.Knee.flechisseurs = temp176{1};
    else
        Examination.Rselectivity.Knee.flechisseurs = '';
    end 
    if ~isnan(temp177{1})                                                    
        Examination.Rselectivity.Knee.extenseurs = temp177{1};
    else
        Examination.Rselectivity.Knee.extenseurs = '';
    end 
    %------------------
    if ~isnan(temp178{1})                                                    
        Examination.Rselectivity.Ankle.boyd = temp178{1};
    else
        Examination.Rselectivity.Ankle.boyd = '';
    end 
    if ~isnan(temp179{1})                                                    
        Examination.Rselectivity.Ankle.confusionTest = temp179{1};
    else
        Examination.Rselectivity.Ankle.confusionTest = '';
    end 
    if ~isnan(temp180)                                                    
        Examination.Rselectivity.Ankle.peroneus = temp180;
    else
        Examination.Rselectivity.Ankle.peroneus = '';
    end 
    if ~isnan(temp181)                                                    
        Examination.Rselectivity.Ankle.tibialisPost = temp181;
    else
        Examination.Rselectivity.Ankle.tibialisPost = '';
    end 
    if ~isnan(temp182{1})                                                    
        Examination.Rselectivity.Ankle.gastSol = temp182{1};
    else
        Examination.Rselectivity.Ankle.gastSol = '';
    end 
    if ~isnan(temp183)                                                    
        Examination.Rselectivity.Ankle.flexDigLong = temp183;
    else
        Examination.Rselectivity.Ankle.flexDigLong = '';
    end 
    if ~isnan(temp184)                                                    
        Examination.Rselectivity.Ankle.flexHalLong = temp184;
    else
        Examination.Rselectivity.Ankle.flexHalLong = '';
    end 

    % Left side
    [~, ~, temp185] = xlsread1(Excel,filename,4,'R9');
    [~, ~, temp186] = xlsread1(Excel,filename,4,'R11');
    [~, ~, temp187] = xlsread1(Excel,filename,4,'R13');
    [~, ~, temp188] = xlsread1(Excel,filename,4,'R16');
    [~, ~, temp189] = xlsread1(Excel,filename,4,'R18');
    [~, ~, temp190] = xlsread1(Excel,filename,4,'R19');

    [~, ~, temp191] = xlsread1(Excel,filename,4,'R21');
    [~, ~, temp192] = xlsread1(Excel,filename,4,'R25');

    [~, ~, temp193] = xlsread1(Excel,filename,4,'R30');
    [~, ~, temp194] = xlsread1(Excel,filename,4,'R32');
    [~, ~, temp195] = xlsread1(Excel,filename,4,'R34');
    [~, ~, temp196] = xlsread1(Excel,filename,4,'R35');
    [~, ~, temp197] = xlsread1(Excel,filename,4,'R36');
    [~, ~, temp198] = xlsread1(Excel,filename,4,'R39');
    [~, ~, temp199] = xlsread1(Excel,filename,4,'R40');

    if ~isnan(temp185)                                                    
        Examination.Lselectivity.Hip.flechisseursDD = temp185;
    else
        Examination.Lselectivity.Hip.flechisseursDD = '';
    end 
    if ~isnan(temp186{1})                                                    
        Examination.Lselectivity.Hip.extenseurs = temp186{1};
    else
        Examination.Lselectivity.Hip.extenseurs = '';
    end 
    if ~isnan(temp187{1})                                                    
        Examination.Lselectivity.Hip.abducteurs = temp187{1};
    else
        Examination.Lselectivity.Hip.abducteurs = '';
    end 
    if ~isnan(temp188{1})                                                    
        Examination.Lselectivity.Hip.adducteurs = temp188{1};
    else
        Examination.Lselectivity.Hip.adducteurs = '';
    end 
    if ~isnan(temp189)                                                    
        Examination.Lselectivity.Hip.rotInt = temp189;
    else
        Examination.Lselectivity.Hip.rotInt = '';
    end 
    if ~isnan(temp190)                                                    
        Examination.Lselectivity.Hip.rotExt = temp190;
    else
        Examination.Lselectivity.Hip.rotExt = '';
    end 
    %------------------
    if ~isnan(temp191{1})                                                    
        Examination.Lselectivity.Knee.flechisseurs = temp191{1};
    else
        Examination.Lselectivity.Knee.flechisseurs = '';
    end 
    if ~isnan(temp192{1})                                                    
        Examination.Lselectivity.Knee.extenseurs = temp192{1};
    else
        Examination.Lselectivity.Knee.extenseurs = '';
    end 
    %------------------
    if ~isnan(temp193{1})                                                    
        Examination.Lselectivity.Ankle.boyd = temp193{1};
    else
        Examination.Lselectivity.Ankle.boyd = '';
    end 
    if ~isnan(temp194{1})                                                    
        Examination.Lselectivity.Ankle.confusionTest = temp194{1};
    else
        Examination.Lselectivity.Ankle.confusionTest = '';
    end 
    if ~isnan(temp195)                                                    
        Examination.Lselectivity.Ankle.peroneus = temp195;
    else
        Examination.Lselectivity.Ankle.peroneus = '';
    end 
    if ~isnan(temp196)                                                    
        Examination.Lselectivity.Ankle.tibialisPost = temp196;
    else
        Examination.Lselectivity.Ankle.tibialisPost = '';
    end 
    if ~isnan(temp197{1})                                                    
        Examination.Lselectivity.Ankle.gastSol = temp197{1};
    else
        Examination.Lselectivity.Ankle.gastSol = '';
    end 
    if ~isnan(temp198)                                                    
        Examination.Lselectivity.Ankle.flexDigLong = temp198;
    else
        Examination.Lselectivity.Ankle.flexDigLong = '';
    end 
    if ~isnan(temp199)                                                    
        Examination.Lselectivity.Ankle.flexHalLong = temp199;
    else
        Examination.Lselectivity.Ankle.flexHalLong = '';
    end 

    % Muscular spasticity / Ashworth
    % ---------------------------------------------------------------------
    % Right side
    [~, ~, temp200] = xlsread1(Excel,filename,4,'S9');
    [~, ~, temp201] = xlsread1(Excel,filename,4,'S10');
    [~, ~, temp202] = xlsread1(Excel,filename,4,'S11');
    [~, ~, temp203] = xlsread1(Excel,filename,4,'S13');
    [~, ~, temp204] = xlsread1(Excel,filename,4,'S16');
    [~, ~, temp205] = xlsread1(Excel,filename,4,'S18');
    [~, ~, temp206] = xlsread1(Excel,filename,4,'S19');

    [~, ~, temp207] = xlsread1(Excel,filename,4,'S21');
    [~, ~, temp208] = xlsread1(Excel,filename,4,'S25');

    [~, ~, temp209] = xlsread1(Excel,filename,4,'S30');
    [~, ~, temp210] = xlsread1(Excel,filename,4,'S32');
    [~, ~, temp211] = xlsread1(Excel,filename,4,'S33');
    [~, ~, temp212] = xlsread1(Excel,filename,4,'S34');
    [~, ~, temp213] = xlsread1(Excel,filename,4,'S35');
    [~, ~, temp214] = xlsread1(Excel,filename,4,'S37');
    [~, ~, temp215] = xlsread1(Excel,filename,4,'S39');

    if ~isnan(temp200)                                                    
        Examination.Rspasticity.Ashworth.Hip.flechisseursDD = temp200;
    else
        Examination.Rspasticity.Ashworth.Hip.flechisseursDD = '';
    end 
    if ~isnan(temp201)                                                    
        Examination.Rspasticity.Ashworth.Hip.duncanElyTest = temp201;
    else
        Examination.Rspasticity.Ashworth.Hip.duncanElyTest = '';
    end 
    if ~isnan(temp202{1})                                                    
        Examination.Rspasticity.Ashworth.Hip.extenseurs = temp202{1};
    else
        Examination.Rspasticity.Ashworth.Hip.extenseurs = '';
    end 
    if ~isnan(temp203{1})                                                    
        Examination.Rspasticity.Ashworth.Hip.abducteurs = temp203{1};
    else
        Examination.Rspasticity.Ashworth.Hip.abducteurs = '';
    end 
    if ~isnan(temp204{1})                                                    
        Examination.Rspasticity.Ashworth.Hip.adducteurs = temp204{1};
    else
        Examination.Rspasticity.Ashworth.Hip.adducteurs = '';
    end 
    if ~isnan(temp205)                                                    
        Examination.Rspasticity.Ashworth.Hip.rotInt = temp205;
    else
        Examination.Rspasticity.Ashworth.Hip.rotInt = '';
    end 
    if ~isnan(temp206)                                                    
        Examination.Rspasticity.Ashworth.Hip.rotExt = temp206;
    else
        Examination.Rspasticity.Ashworth.Hip.rotExt = '';
    end 
    %------------------
    if ~isnan(temp207{1})                                                    
        Examination.Rspasticity.Ashworth.Knee.flechisseurs = temp207{1};
    else
        Examination.Rspasticity.Ashworth.Knee.flechisseurs = '';
    end 
    if ~isnan(temp208{1})                                                    
        Examination.Rspasticity.Ashworth.Knee.extenseurs = temp208{1};
    else
        Examination.Rspasticity.Ashworth.Knee.extenseurs = '';
    end 
    %------------------
    if ~isnan(temp209{1})                                                    
        Examination.Rspasticity.Ashworth.Ankle.tibialisAnt = temp209{1};
    else
        Examination.Rspasticity.Ashworth.Ankle.tibialisAnt = '';
    end 
    if ~isnan(temp210)                                                    
        Examination.Rspasticity.Ashworth.Ankle.extDigLong = temp210;
    else
        Examination.Rspasticity.Ashworth.Ankle.extDigLong = '';
    end 
    if ~isnan(temp211)                                                    
        Examination.Rspasticity.Ashworth.Ankle.extHalLong = temp211;
    else
        Examination.Rspasticity.Ashworth.Ankle.extHalLong = '';
    end
    if ~isnan(temp212)                                                    
        Examination.Rspasticity.Ashworth.Ankle.peroneus = temp212;
    else
        Examination.Rspasticity.Ashworth.Ankle.peroneus = '';
    end
    if ~isnan(temp213)                                                    
        Examination.Rspasticity.Ashworth.Ankle.tibialisPost = temp213;
    else
        Examination.Rspasticity.Ashworth.Ankle.tibialisPost = '';
    end
    if ~isnan(temp214)                                                    
        Examination.Rspasticity.Ashworth.Ankle.gastSol = temp214;
    else
        Examination.Rspasticity.Ashworth.Ankle.gastSol = '';
    end
    if ~isnan(temp215{1})                                                    
        Examination.Rspasticity.Ashworth.Ankle.flechisseurs = temp215{1};
    else
        Examination.Rspasticity.Ashworth.Ankle.flechisseurs = '';
    end

    % Left side
    [~, ~, temp216] = xlsread1(Excel,filename,4,'U9');
    [~, ~, temp217] = xlsread1(Excel,filename,4,'U10');
    [~, ~, temp218] = xlsread1(Excel,filename,4,'U11');
    [~, ~, temp219] = xlsread1(Excel,filename,4,'U13');
    [~, ~, temp220] = xlsread1(Excel,filename,4,'U16');
    [~, ~, temp221] = xlsread1(Excel,filename,4,'U18');
    [~, ~, temp222] = xlsread1(Excel,filename,4,'U19');

    [~, ~, temp223] = xlsread1(Excel,filename,4,'U21');
    [~, ~, temp224] = xlsread1(Excel,filename,4,'U25');

    [~, ~, temp225] = xlsread1(Excel,filename,4,'U30');
    [~, ~, temp226] = xlsread1(Excel,filename,4,'U32');
    [~, ~, temp227] = xlsread1(Excel,filename,4,'U33');
    [~, ~, temp228] = xlsread1(Excel,filename,4,'U34');
    [~, ~, temp229] = xlsread1(Excel,filename,4,'U35');
    [~, ~, temp230] = xlsread1(Excel,filename,4,'U37');
    [~, ~, temp231] = xlsread1(Excel,filename,4,'U39');

    if ~isnan(temp216)                                                    
        Examination.Lspasticity.Ashworth.Hip.flechisseursDD = temp216;
    else
        Examination.Lspasticity.Ashworth.Hip.flechisseursDD = '';
    end 
    if ~isnan(temp217)                                                    
        Examination.Lspasticity.Ashworth.Hip.duncanElyTest = temp217;
    else
        Examination.Lspasticity.Ashworth.Hip.duncanElyTest = '';
    end 
    if ~isnan(temp218{1})                                                    
        Examination.Lspasticity.Ashworth.Hip.extenseurs = temp218{1};
    else
        Examination.Lspasticity.Ashworth.Hip.extenseurs = '';
    end 
    if ~isnan(temp219{1})                                                    
        Examination.Lspasticity.Ashworth.Hip.abducteurs = temp219{1};
    else
        Examination.Lspasticity.Ashworth.Hip.abducteurs = '';
    end 
    if ~isnan(temp220{1})                                                    
        Examination.Lspasticity.Ashworth.Hip.adducteurs = temp220{1};
    else
        Examination.Lspasticity.Ashworth.Hip.adducteurs = '';
    end 
    if ~isnan(temp221)                                                    
        Examination.Lspasticity.Ashworth.Hip.rotInt = temp221;
    else
        Examination.Lspasticity.Ashworth.Hip.rotInt = '';
    end 
    if ~isnan(temp222)                                                    
        Examination.Lspasticity.Ashworth.Hip.rotExt = temp222;
    else
        Examination.Lspasticity.Ashworth.Hip.rotExt = '';
    end 
    %------------------
    if ~isnan(temp223{1})                                                    
        Examination.Lspasticity.Ashworth.Knee.flechisseurs = temp223{1};
    else
        Examination.Lspasticity.Ashworth.Knee.flechisseurs = '';
    end 
    if ~isnan(temp224{1})                                                    
        Examination.Lspasticity.Ashworth.Knee.extenseurs = temp224{1};
    else
        Examination.Lspasticity.Ashworth.Knee.extenseurs = '';
    end 
    %------------------
    if ~isnan(temp225{1})                                                    
        Examination.Lspasticity.Ashworth.Ankle.tibialisAnt = temp225{1};
    else
        Examination.Lspasticity.Ashworth.Ankle.tibialisAnt = '';
    end 
    if ~isnan(temp226)                                                    
        Examination.Lspasticity.Ashworth.Ankle.extDigLong = temp226;
    else
        Examination.Lspasticity.Ashworth.Ankle.extDigLong = '';
    end 
    if ~isnan(temp227)                                                    
        Examination.Lspasticity.Ashworth.Ankle.extHalLong = temp227;
    else
        Examination.Lspasticity.Ashworth.Ankle.extHalLong = '';
    end
    if ~isnan(temp228)                                                    
        Examination.Lspasticity.Ashworth.Ankle.peroneus = temp228;
    else
        Examination.Lspasticity.Ashworth.Ankle.peroneus = '';
    end
    if ~isnan(temp229)                                                    
        Examination.Lspasticity.Ashworth.Ankle.tibialisPost = temp229;
    else
        Examination.Lspasticity.Ashworth.Ankle.tibialisPost = '';
    end
    if ~isnan(temp230)                                                    
        Examination.Lspasticity.Ashworth.Ankle.gastSol = temp230;
    else
        Examination.Lspasticity.Ashworth.Ankle.gastSol = '';
    end
    if ~isnan(temp231{1})                                                    
        Examination.Lspasticity.Ashworth.Ankle.flechisseurs = temp231{1};
    else
        Examination.Lspasticity.Ashworth.Ankle.flechisseurs = '';
    end

    % Muscular spasticity / Tardieu
    % ---------------------------------------------------------------------
    % Right side
    [~, ~, temp232] = xlsread1(Excel,filename,4,'T9');
    [~, ~, temp233] = xlsread1(Excel,filename,4,'T10');
    [~, ~, temp234] = xlsread1(Excel,filename,4,'T11');
    [~, ~, temp235] = xlsread1(Excel,filename,4,'T13');
    [~, ~, temp236] = xlsread1(Excel,filename,4,'T16');
    [~, ~, temp237] = xlsread1(Excel,filename,4,'T18');
    [~, ~, temp238] = xlsread1(Excel,filename,4,'T19');

    [~, ~, temp239] = xlsread1(Excel,filename,4,'T21');
    [~, ~, temp240] = xlsread1(Excel,filename,4,'T25');

    [~, ~, temp241] = xlsread1(Excel,filename,4,'T30');
    [~, ~, temp242] = xlsread1(Excel,filename,4,'T32');
    [~, ~, temp243] = xlsread1(Excel,filename,4,'T33');
    [~, ~, temp244] = xlsread1(Excel,filename,4,'T34');
    [~, ~, temp245] = xlsread1(Excel,filename,4,'T35');
    [~, ~, temp246] = xlsread1(Excel,filename,4,'T37');
    [~, ~, temp247] = xlsread1(Excel,filename,4,'T38');
    [~, ~, temp248] = xlsread1(Excel,filename,4,'T39');

    if ~isnan(temp232)                                                    
        Examination.Rspasticity.Tardieu.Hip.flechisseursDD = temp232;
    else
        Examination.Rspasticity.Tardieu.Hip.flechisseursDD = '';
    end
    if ~isnan(temp233)                                                    
        Examination.Rspasticity.Tardieu.Hip.duncanElyTest = temp233;
    else
        Examination.Rspasticity.Tardieu.Hip.duncanElyTest = '';
    end
    if ~isnan(temp234{1})                                                    
        Examination.Rspasticity.Tardieu.Hip.extenseurs = temp234{1};
    else
        Examination.Rspasticity.Tardieu.Hip.extenseurs = '';
    end
    if ~isnan(temp235{1})                                                    
        Examination.Rspasticity.Tardieu.Hip.abducteurs = temp235{1};
    else
        Examination.Rspasticity.Tardieu.Hip.abducteurs = '';
    end
    if ~isnan(temp236{1})                                                    
        Examination.Rspasticity.Tardieu.Hip.adducteurs = temp236{1};
    else
        Examination.Rspasticity.Tardieu.Hip.adducteurs = '';
    end
    if ~isnan(temp237)                                                    
        Examination.Rspasticity.Tardieu.Hip.rotInt = temp237;
    else
        Examination.Rspasticity.Tardieu.Hip.rotInt = '';
    end
    if ~isnan(temp238)                                                    
        Examination.Rspasticity.Tardieu.Hip.rotExt = temp238;
    else
        Examination.Rspasticity.Tardieu.Hip.rotExt = '';
    end
    %------------------
    if ~isnan(temp239{1})                                                    
        Examination.Rspasticity.Tardieu.Knee.flechisseurs = temp239{1};
    else
        Examination.Rspasticity.Tardieu.Knee.flechisseurs = '';
    end
    if ~isnan(temp240{1})                                                    
        Examination.Rspasticity.Tardieu.Knee.extenseurs = temp240{1};
    else
        Examination.Rspasticity.Tardieu.Knee.extenseurs = '';
    end
    %------------------
    if ~isnan(temp241{1})                                                    
        Examination.Rspasticity.Tardieu.Ankle.tibialisAnt = temp241{1};
    else
        Examination.Rspasticity.Tardieu.Ankle.tibialisAnt = '';
    end
    if ~isnan(temp242)                                                    
        Examination.Rspasticity.Tardieu.Ankle.extDigLong = temp242;
    else
        Examination.Rspasticity.Tardieu.Ankle.extDigLong = '';
    end
    if ~isnan(temp243)                                                    
        Examination.Rspasticity.Tardieu.Ankle.extHalLong = temp243;
    else
        Examination.Rspasticity.Tardieu.Ankle.extHalLong = '';
    end
    if ~isnan(temp244)                                                    
        Examination.Rspasticity.Tardieu.Ankle.peroneus = temp244;
    else
        Examination.Rspasticity.Tardieu.Ankle.peroneus = '';
    end
    if ~isnan(temp245)                                                    
        Examination.Rspasticity.Tardieu.Ankle.tibialisPost = temp245;
    else
        Examination.Rspasticity.Tardieu.Ankle.tibialisPost = '';
    end
    if ~isnan(temp246)                                                    
        Examination.Rspasticity.Tardieu.Ankle.gastSol = temp246;
    else
        Examination.Rspasticity.Tardieu.Ankle.gastSol = '';
    end
    if ~isnan(temp247)                                                    
        Examination.Rspasticity.Tardieu.Ankle.R1R2 = temp247;%num2str(str2num(Examination.Rprom.Ankle.dorsiflexKneeExt) - str2num(Examination.Rspasticity.Tardieu.Ankle.gastSol));
    else
        Examination.Rspasticity.Tardieu.Ankle.R1R2 = '';
    end
    if ~isnan(temp248{1})                                                    
        Examination.Rspasticity.Tardieu.Ankle.flechisseurs = temp248{1};
    else
        Examination.Rspasticity.Tardieu.Ankle.flechisseurs = '';
    end

    % Left side
    [~, ~, temp249] = xlsread1(Excel,filename,4,'V9');
    [~, ~, temp250] = xlsread1(Excel,filename,4,'V10');
    [~, ~, temp251] = xlsread1(Excel,filename,4,'V11');
    [~, ~, temp252] = xlsread1(Excel,filename,4,'V13');
    [~, ~, temp253] = xlsread1(Excel,filename,4,'V16');
    [~, ~, temp254] = xlsread1(Excel,filename,4,'V18');
    [~, ~, temp255] = xlsread1(Excel,filename,4,'V19');

    [~, ~, temp256] = xlsread1(Excel,filename,4,'V21');
    [~, ~, temp257] = xlsread1(Excel,filename,4,'V25');

    [~, ~, temp258] = xlsread1(Excel,filename,4,'V30');
    [~, ~, temp259] = xlsread1(Excel,filename,4,'V32');
    [~, ~, temp260] = xlsread1(Excel,filename,4,'V33');
    [~, ~, temp261] = xlsread1(Excel,filename,4,'V34');
    [~, ~, temp262] = xlsread1(Excel,filename,4,'V35');
    [~, ~, temp263] = xlsread1(Excel,filename,4,'V37');
    [~, ~, temp264] = xlsread1(Excel,filename,4,'V38');
    [~, ~, temp265] = xlsread1(Excel,filename,4,'V39');

    if ~isnan(temp249)                                                    
        Examination.Lspasticity.Tardieu.Hip.flechisseursDD = temp249;
    else
        Examination.Lspasticity.Tardieu.Hip.flechisseursDD = '';
    end
    if ~isnan(temp250)                                                    
        Examination.Lspasticity.Tardieu.Hip.duncanElyTest = temp250;
    else
        Examination.Lspasticity.Tardieu.Hip.duncanElyTest = '';
    end
    if ~isnan(temp251{1})                                                    
        Examination.Lspasticity.Tardieu.Hip.extenseurs = temp251{1};
    else
        Examination.Lspasticity.Tardieu.Hip.extenseurs = '';
    end
    if ~isnan(temp252{1})                                                    
        Examination.Lspasticity.Tardieu.Hip.abducteurs = temp252{1};
    else
        Examination.Lspasticity.Tardieu.Hip.abducteurs = '';
    end
    if ~isnan(temp253{1})                                                    
        Examination.Lspasticity.Tardieu.Hip.adducteurs = temp253{1};
    else
        Examination.Lspasticity.Tardieu.Hip.adducteurs = '';
    end
    if ~isnan(temp254)                                                    
        Examination.Lspasticity.Tardieu.Hip.rotInt = temp254;
    else
        Examination.Lspasticity.Tardieu.Hip.rotInt = '';
    end
    if ~isnan(temp255)                                                    
        Examination.Lspasticity.Tardieu.Hip.rotExt = temp255;
    else
        Examination.Lspasticity.Tardieu.Hip.rotExt = '';
    end
    %------------------
    if ~isnan(temp256{1})                                                    
        Examination.Lspasticity.Tardieu.Knee.flechisseurs = temp256{1};
    else
        Examination.Lspasticity.Tardieu.Knee.flechisseurs = '';
    end
    if ~isnan(temp257{1})                                                    
        Examination.Lspasticity.Tardieu.Knee.extenseurs = temp257{1};
    else
        Examination.Lspasticity.Tardieu.Knee.extenseurs = '';
    end
    %------------------
    if ~isnan(temp258{1})                                                    
        Examination.Lspasticity.Tardieu.Ankle.tibialisAnt = temp258{1};
    else
        Examination.Lspasticity.Tardieu.Ankle.tibialisAnt = '';
    end
    if ~isnan(temp259)                                                    
        Examination.Lspasticity.Tardieu.Ankle.extDigLong = temp259;
    else
        Examination.Lspasticity.Tardieu.Ankle.extDigLong = '';
    end
    if ~isnan(temp260)                                                    
        Examination.Lspasticity.Tardieu.Ankle.extHalLong = temp260;
    else
        Examination.Lspasticity.Tardieu.Ankle.extHalLong = '';
    end
    if ~isnan(temp261)                                                    
        Examination.Lspasticity.Tardieu.Ankle.peroneus = temp261;
    else
        Examination.Lspasticity.Tardieu.Ankle.peroneus = '';
    end
    if ~isnan(temp262)                                                    
        Examination.Lspasticity.Tardieu.Ankle.tibialisPost = temp262;
    else
        Examination.Lspasticity.Tardieu.Ankle.tibialisPost = '';
    end
    if ~isnan(temp263)                                                    
        Examination.Lspasticity.Tardieu.Ankle.gastSol = temp263;
    else
        Examination.Lspasticity.Tardieu.Ankle.gastSol = '';
    end
    if ~isnan(temp264)                                                    
        Examination.Lspasticity.Tardieu.Ankle.R1R2 = temp264;%num2str(str2num(Examination.Lprom.Ankle.dorsiflexKneeExt) - str2num(Examination.Lspasticity.Tardieu.Ankle.gastSol));
    else
        Examination.Lspasticity.Tardieu.Ankle.R1R2 = '';
    end
    if ~isnan(temp265{1})                                                    
        Examination.Lspasticity.Tardieu.Ankle.flechisseurs = temp265{1};
    else
        Examination.Lspasticity.Tardieu.Ankle.flechisseurs = '';
    end

    % Others
    % ---------------------------------------------------------------------
    [~, ~, temp266a] = xlsread1(Excel,filename,4,'M42');
    [~, ~, temp266b] = xlsread1(Excel,filename,4,'M43');
    [temp266c] = xlsread1(Excel,filename,4,'M44');
    [temp266d] = xlsread1(Excel,filename,4,'M45');

    if ~isnan(temp266a{1})                                                    
        Examination.scoliose = temp266a{1};
    else
        Examination.scoliose = '';
    end
    if ~isnan(temp266b{1})                                                    
        Examination.axeOccipital = temp266b{1};
    else
        Examination.axeOccipital = '';
    end
    if ~isnan(temp266c)                                                    
        Examination.rightLegLength = str2num(temp266c)*1e-2;
    else
        Examination.rightLegLength = '';
    end
    if ~isnan(temp266d)                                                    
        Examination.leftLegLength = str2num(temp266c)*1e-2;
    else
        Examination.leftLegLength = '';
    end

    % Sensitivity
    % ---------------------------------------------------------------------
    [~, ~, temp268] = xlsread1(Excel,filename,4,'M47');
    [~, ~, temp269] = xlsread1(Excel,filename,4,'M49');
    [~, ~, temp270] = xlsread1(Excel,filename,4,'P47');
    [~, ~, temp271] = xlsread1(Excel,filename,4,'P49');

    if ~isnan(temp268{1})                                                    
        Examination.Rsensitivity.superficielle = temp268{1};
    else
        Examination.Rsensitivity.superficielle = '';
    end
    if ~isnan(temp269{1})                                                    
        Examination.Rsensitivity.proprioceptive = temp269{1};
    else
        Examination.Rsensitivity.proprioceptive = '';
    end
    if ~isnan(temp270{1})                                                    
        Examination.Lsensitivity.superficielle = temp270{1};
    else
        Examination.Lsensitivity.superficielle = '';
    end
    if ~isnan(temp271{1})                                                    
        Examination.Lsensitivity.proprioceptive = temp271{1};
    else
        Examination.Lsensitivity.proprioceptive = '';
    end

    % Group
    % ---------------------------------------------------------------------
    [~, ~, temp272] = xlsread1(Excel,filename,4,'U45');
    [~, ~, temp273] = xlsread1(Excel,filename,4,'U46');
    [~, ~, temp274] = xlsread1(Excel,filename,4,'U47');
    [~, ~, temp275] = xlsread1(Excel,filename,4,'U48');
    [~, ~, temp276] = xlsread1(Excel,filename,4,'U49');
    [~, ~, temp277] = xlsread1(Excel,filename,4,'U50');

    if ~isnan(temp272{1})                                                    
        Examination.group = 'Ia';
    elseif ~isnan(temp273{1})                                                    
        Examination.group = 'Ib';
    elseif ~isnan(temp274{1})                                                    
        Examination.group = 'IIa';
    elseif ~isnan(temp275{1})                                                    
        Examination.group = 'IIb';
    elseif ~isnan(temp276{1})                                                    
        Examination.group = 'IIIa';
    elseif ~isnan(temp277{1})                                                    
        Examination.group = 'IIIb';
    else
        Examination.group = '';
    end

end
    
% =========================================================================
% Close activex port
% =========================================================================
Excel.ActiveWorkbook.Save;
Excel.Quit
Excel.delete
clear Excel 