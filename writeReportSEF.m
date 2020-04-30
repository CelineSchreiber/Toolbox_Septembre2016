clear filename
cd(matFolder);
filename{1} = uigetfile({'*.mat','MAT-files (*.mat)'}, ...
    'Select a session file without SEF', ...
    'MultiSelect','off');
filename{2} = uigetfile({'*.mat','MAT-files (*.mat)'}, ...
    'Select a session file with SEF', ...
    'MultiSelect','off');
if ~iscell(filename)
    filename = mat2cell(filename,1);
end

cd('Y:\060 Médecins\ANNEXE DOSSIERS\MONITORING\Protocole CHECGAIT');
filenameSEF = uigetfile('Sélectionner le fichier XLS du patient:', 'MultiSelect','off');

Excel = actxserver ('Excel.Application');
fnameSEF=fullfile(pwd,filenameSEF);
invoke(Excel.Workbooks,'Open',fnameSEF);

sheet='AQM T5 - Data';
cd(matFolder);
for iCondition=1:size(filename,2)
   
    load(filename{iCondition});
    
    nline  = (iCondition-1)*103;   % Used for kinematics and kinetics (100 frames data only)
    if iCondition==1
        xlswrite1(fnameSEF,' ',sheet,'A1:U216');
    end
    % =========================================================================
    % Spatiotemporal parameters
    % =========================================================================

    if iCondition==1
            xlswrite1(fnameSEF,{'Phase d''appui' 'Phase d''appui' 'Phase d''appui' 'Phase d''appui' ...
        'Longueur de pas' 'Longueur de pas' 'Longueur de pas' 'Longueur de pas' ...
        'Largeur de pas' 'Largeur de pas' ...
        'Cadence' 'Cadence' ...
        'Vitesse' 'Vitesse' ...
        },sheet,['B',num2str(1)]);
        if strcmp(Pathology.affectedside,'Gauche') | strcmp(Pathology.affectedside,'Droite')
            xlswrite1(fnameSEF,{'Pathologique' 'Pathologique' 'Sain' 'Sain' ...
                'Pathologique' 'Pathologique' 'Sain' 'Sain' ...
                'Moyen' 'Moyen' ...
                'Moyen' 'Moyen' ...
                'Moyen' 'Moyen' ...
                },sheet,['B',num2str(2)]);
        else
            xlswrite1(fnameSEF,{'Droite' 'Droite' 'Gauche' 'Gauche' ...
                'Droite' 'Droite' 'Gauche' 'Gauche' ...
                'Moyen' 'Moyen' ...
                'Moyen' 'Moyen' ...
                'Moyen' 'Moyen' ...
                },sheet,['B',num2str(2)]);
        end
        xlswrite1(fnameSEF,{'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' ...
        'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' ...
        'Moyenne' 'Ecart-type' ...
        'Moyenne' 'Ecart-type' ...
        'Moyenne' 'Ecart-type' ...
        },sheet,['B',num2str(3)]);
    end
    if iCondition==1
        xlswrite1(fnameSEF,cellstr(['Condition sans SEF']),sheet,['A',num2str(4)]);
    else
        xlswrite1(fnameSEF,cellstr(['Condition avec SEF']),sheet,['A',num2str(5)]);
    end
    
    if strcmp(Pathology.affectedside,'Gauche')
        %---
        xlswrite1(fnameSEF,Condition.All.Gaitparameters.left_stance_phase.mean,sheet,['B',num2str(3+iCondition)]);
        xlswrite1(fnameSEF,Condition.All.Gaitparameters.left_stance_phase.std,sheet,['C',num2str(3+iCondition)]);
        xlswrite1(fnameSEF,Condition.All.Gaitparameters.right_stance_phase.mean,sheet,['D',num2str(3+iCondition)]);
        xlswrite1(fnameSEF,Condition.All.Gaitparameters.right_stance_phase.std,sheet,['E',num2str(3+iCondition)]);
        %---
        xlswrite1(fnameSEF,Condition.All.Gaitparameters.left_step_length.mean*1e2,sheet,['F',num2str(3+iCondition)]);
        xlswrite1(fnameSEF,Condition.All.Gaitparameters.left_step_length.std*1e2,sheet,['G',num2str(3+iCondition)]);
        xlswrite1(fnameSEF,Condition.All.Gaitparameters.right_step_length.mean*1e2,sheet,['H',num2str(3+iCondition)]);
        xlswrite1(fnameSEF,Condition.All.Gaitparameters.right_step_length.std*1e2,sheet,['I',num2str(3+iCondition)]);
        %---
        xlswrite1(fnameSEF,Condition.All.Gaitparameters.step_width.mean*1e2,sheet,['J',num2str(3+iCondition)]);
        xlswrite1(fnameSEF,Condition.All.Gaitparameters.step_width.std*1e2,sheet,['K',num2str(3+iCondition)]);
        %---
        xlswrite1(fnameSEF,Condition.All.Gaitparameters.cadence.mean,sheet,['L',num2str(3+iCondition)]);
        xlswrite1(fnameSEF,Condition.All.Gaitparameters.cadence.std,sheet,['M',num2str(3+iCondition)]);
        %---
        xlswrite1(fnameSEF,Condition.All.Gaitparameters.mean_velocity.mean,sheet,['N',num2str(3+iCondition)]);
        xlswrite1(fnameSEF,Condition.All.Gaitparameters.mean_velocity.std,sheet,['O',num2str(3+iCondition)]);
        %---
    else
        %---
        xlswrite1(fnameSEF,Condition.All.Gaitparameters.right_stance_phase.mean,sheet,['B',num2str(3+iCondition)]);
        xlswrite1(fnameSEF,Condition.All.Gaitparameters.right_stance_phase.std,sheet,['C',num2str(3+iCondition)]);
        xlswrite1(fnameSEF,Condition.All.Gaitparameters.left_stance_phase.mean,sheet,['D',num2str(3+iCondition)]);
        xlswrite1(fnameSEF,Condition.All.Gaitparameters.left_stance_phase.std,sheet,['E',num2str(3+iCondition)]);
        %---
        xlswrite1(fnameSEF,Condition.All.Gaitparameters.right_step_length.mean*1e2,sheet,['F',num2str(3+iCondition)]);
        xlswrite1(fnameSEF,Condition.All.Gaitparameters.right_step_length.std*1e2,sheet,['G',num2str(3+iCondition)]);
        xlswrite1(fnameSEF,Condition.All.Gaitparameters.left_step_length.mean*1e2,sheet,['H',num2str(3+iCondition)]);
        xlswrite1(fnameSEF,Condition.All.Gaitparameters.left_step_length.std*1e2,sheet,['I',num2str(3+iCondition)]);
        %---
        xlswrite1(fnameSEF,Condition.All.Gaitparameters.step_width.mean*1e2,sheet,['J',num2str(3+iCondition)]);
        xlswrite1(fnameSEF,Condition.All.Gaitparameters.step_width.std*1e2,sheet,['K',num2str(3+iCondition)]);
        %---
        xlswrite1(fnameSEF,Condition.All.Gaitparameters.cadence.mean,sheet,['L',num2str(3+iCondition)]);
        xlswrite1(fnameSEF,Condition.All.Gaitparameters.cadence.std,sheet,['M',num2str(3+iCondition)]);
        %---
        xlswrite1(fnameSEF,Condition.All.Gaitparameters.mean_velocity.mean,sheet,['N',num2str(3+iCondition)]);
        xlswrite1(fnameSEF,Condition.All.Gaitparameters.mean_velocity.std,sheet,['O',num2str(3+iCondition)]);
        %---
    end

    % =========================================================================
    % Kinematics
    % =========================================================================
    
    if iCondition==1
        xlswrite1(fnameSEF,cellstr('Temps'),sheet,['A',num2str(7)]);
        xlswrite1(fnameSEF,{'Genou' 'Genou' 'Genou' 'Genou' ...
            'Cheville' 'Cheville' 'Cheville' 'Cheville' ...
            'Pied' 'Pied' 'Pied' 'Pied' 'Pied' 'Pied' 'Pied' 'Pied' 'Pied' 'Pied' 'Pied' 'Pied'},sheet,['B',num2str(7)]);
        xlswrite1(fnameSEF,{'Flexion (+) / Extension (-) (°)' 'Flexion (+) / Extension (-) (°)' 'Flexion (+) / Extension (-) (°)' 'Flexion (+) / Extension (-)' ...
            'Dorsif. (+) / Plantarf. (-) (°)' 'Dorsif. (+) / Plantarf. (-) (°)' 'Dorsif. (+) / Plantarf. (-) (°)' 'Dorsif. (+) / Plantarf. (-)' ...
            'tilt' 'tilt' 'tilt' 'tilt' 'Abaissement meta 1 (+) / 5 (-) (°)' 'Abaissement meta 1 (+) / 5 (-) (°)' 'Abaissement meta 1 (+) / 5 (-) (°)' 'Abaissement meta 1 (+) / 5 (-) (°)' 'Angle de progr. (int. + / ext. -) (°)' 'Angle de progr. (int. + / ext. -) (°)' 'Angle de progr. (int. + / ext. -) (°)' 'Angle de progr. (int. + / ext. -) (°)'...
            },sheet,['B',num2str(8)]);
        if strcmp(Pathology.affectedside,'Gauche') | strcmp(Pathology.affectedside,'Droite')
            xlswrite1(fnameSEF,{'Pathologique' 'Pathologique' 'Sain' 'Sain' ...
                'Pathologique' 'Pathologique' 'Sain' 'Sain' ...
                'Pathologique' 'Pathologique' 'Sain' 'Sain' 'Pathologique' 'Pathologique' 'Sain' 'Sain' 'Pathologique' 'Pathologique' 'Sain' 'Sain' ...
                },sheet,['B',num2str(2)]);
        else
            xlswrite1(fnameSEF,{'Droite' 'Droite' 'Gauche' 'Gauche' ...
                'Droite' 'Droite' 'Gauche' 'Gauche' ...
                'Droite' 'Droite' 'Gauche' 'Gauche' 'Droite' 'Droite' 'Gauche' 'Gauche' 'Droite' 'Droite' 'Gauche' 'Gauche' ...
                },sheet,['B',num2str(9)]);
        end
        xlswrite1(fnameSEF,{'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' ...
            'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' ...
            'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type'}...
            ,sheet,['B',num2str(10)]);
        xlswrite1(fnameSEF,cellstr(['Condition sans SEF']),sheet,['A',num2str(12)]);
        xlswrite1(fnameSEF,(0:1:100)',sheet,['A',num2str(13)]);
    else
        xlswrite1(fnameSEF,cellstr(['Condition avec SEF']),sheet,['A',num2str(115)]);
        xlswrite1(fnameSEF,(0:1:100)',sheet,['A',num2str(116)]);
        
    end
    if strcmp(Pathology.affectedside,'Gauche')
        %---
        xlswrite1(fnameSEF,-Condition.All.Lkinematics.FE3.mean,sheet,['B',num2str(nline+13)]);
        xlswrite1(fnameSEF,-Condition.All.Lkinematics.FE3.std,sheet,['C',num2str(nline+13)]);
        xlswrite1(fnameSEF,-Condition.All.Rkinematics.FE3.mean,sheet,['D',num2str(nline+13)]);
        xlswrite1(fnameSEF,-Condition.All.Rkinematics.FE3.std,sheet,['E',num2str(nline+13)]);
        %---
        xlswrite1(fnameSEF,Condition.All.Lkinematics.FE2.mean,sheet,['F',num2str(nline+13)]);
        xlswrite1(fnameSEF,Condition.All.Lkinematics.FE2.std,sheet,['G',num2str(nline+13)]);
        xlswrite1(fnameSEF,Condition.All.Rkinematics.FE2.mean,sheet,['H',num2str(nline+13)]);
        xlswrite1(fnameSEF,Condition.All.Rkinematics.FE2.std,sheet,['I',num2str(nline+13)]);
        %---
        xlswrite1(fnameSEF,Condition.All.Lkinematics.Ftilt.mean,sheet,['J',num2str(nline+13)]);
        xlswrite1(fnameSEF,Condition.All.Lkinematics.Ftilt.std,sheet,['K',num2str(nline+13)]);
        xlswrite1(fnameSEF,Condition.All.Rkinematics.Ftilt.mean,sheet,['L',num2str(nline+13)]);
        xlswrite1(fnameSEF,Condition.All.Rkinematics.Ftilt.std,sheet,['M',num2str(nline+13)]);
        xlswrite1(fnameSEF,Condition.All.Lkinematics.Fobli.mean,sheet,['N',num2str(nline+13)]);
        xlswrite1(fnameSEF,Condition.All.Lkinematics.Fobli.std,sheet,['O',num2str(nline+13)]);
        xlswrite1(fnameSEF,Condition.All.Rkinematics.Fobli.mean,sheet,['P',num2str(nline+13)]);
        xlswrite1(fnameSEF,Condition.All.Rkinematics.Fobli.std,sheet,['Q',num2str(nline+13)]);
        xlswrite1(fnameSEF,Condition.All.Lkinematics.Frota.mean,sheet,['R',num2str(nline+13)]);
        xlswrite1(fnameSEF,Condition.All.Lkinematics.Frota.std,sheet,['S',num2str(nline+13)]);
        xlswrite1(fnameSEF,Condition.All.Rkinematics.Frota.mean,sheet,['T',num2str(nline+13)]);
        xlswrite1(fnameSEF,Condition.All.Rkinematics.Frota.std,sheet,['U',num2str(nline+13)]);
    else
        %---
        xlswrite1(fnameSEF,-Condition.All.Rkinematics.FE3.mean,sheet,['B',num2str(nline+13)]);
        xlswrite1(fnameSEF,-Condition.All.Rkinematics.FE3.std,sheet,['C',num2str(nline+13)]);
        xlswrite1(fnameSEF,-Condition.All.Lkinematics.FE3.mean,sheet,['D',num2str(nline+13)]);
        xlswrite1(fnameSEF,-Condition.All.Lkinematics.FE3.std,sheet,['E',num2str(nline+13)]);
        %---
        xlswrite1(fnameSEF,Condition.All.Rkinematics.FE2.mean,sheet,['F',num2str(nline+13)]);
        xlswrite1(fnameSEF,Condition.All.Rkinematics.FE2.std,sheet,['G',num2str(nline+13)]);
        xlswrite1(fnameSEF,Condition.All.Lkinematics.FE2.mean,sheet,['H',num2str(nline+13)]);
        xlswrite1(fnameSEF,Condition.All.Lkinematics.FE2.std,sheet,['I',num2str(nline+13)]);
        %---
        xlswrite1(fnameSEF,Condition.All.Rkinematics.Ftilt.mean,sheet,['J',num2str(nline+13)]);
        xlswrite1(fnameSEF,Condition.All.Rkinematics.Ftilt.std,sheet,['K',num2str(nline+13)]);
        xlswrite1(fnameSEF,Condition.All.Lkinematics.Ftilt.mean,sheet,['L',num2str(nline+13)]);
        xlswrite1(fnameSEF,Condition.All.Lkinematics.Ftilt.std,sheet,['M',num2str(nline+13)]);
        xlswrite1(fnameSEF,Condition.All.Rkinematics.Fobli.mean,sheet,['N',num2str(nline+13)]);
        xlswrite1(fnameSEF,Condition.All.Rkinematics.Fobli.std,sheet,['O',num2str(nline+13)]);
        xlswrite1(fnameSEF,Condition.All.Lkinematics.Fobli.mean,sheet,['P',num2str(nline+13)]);
        xlswrite1(fnameSEF,Condition.All.Lkinematics.Fobli.std,sheet,['Q',num2str(nline+13)]);
        xlswrite1(fnameSEF,Condition.All.Rkinematics.Frota.mean,sheet,['R',num2str(nline+13)]);
        xlswrite1(fnameSEF,Condition.All.Rkinematics.Frota.std,sheet,['S',num2str(nline+13)]);
        xlswrite1(fnameSEF,Condition.All.Lkinematics.Frota.mean,sheet,['T',num2str(nline+13)]);
        xlswrite1(fnameSEF,Condition.All.Lkinematics.Frota.std,sheet,['U',num2str(nline+13)]);
    end
end

% % cd('C:\Users\celine.schreiber\Documents\MATLAB\Toolbox_Septembre2016\norm')
% % norm = load('Normes spontanee.mat');
% % 
% % % NORMATIVE DATA MEAN
% % xlswrite1(fnameSEF,cellstr(['Norme']),sheet,['A',num2str(218)]);
% % % Knee kinematics
% % xlswrite1(fnameSEF,-norm.Normatives.Rkinematics.FE3.mean,sheet,['B219']); 
% % xlswrite1(fnameSEF,-norm.Normatives.Rkinematics.FE3.std,sheet,['C219']); 
% % % Ankle kinematics
% % xlswrite1(fnameSEF,norm.Normatives.Rkinematics.FE2.mean,sheet,['F219']); 
% % xlswrite1(fnameSEF,norm.Normatives.Rkinematics.FE2.std,sheet,['G219']); 
% % % Foot kinematics
% % xlswrite1(fnameSEF,norm.Normatives.Rkinematics.Ftilt.mean,sheet,['J219']);
% % xlswrite1(fnameSEF,norm.Normatives.Rkinematics.Ftilt.std,sheet,['K219']);
% % xlswrite1(fnameSEF,norm.Normatives.Rkinematics.Fobli.mean,sheet,['L219']);
% % xlswrite1(fnameSEF,norm.Normatives.Rkinematics.Fobli.std,sheet,['M219']);
% % xlswrite1(fnameSEF,norm.Normatives.Rkinematics.Frota.mean,sheet,['N219']);
% % xlswrite1(fnameSEF,norm.Normatives.Rkinematics.Frota.std,sheet,['O219']);

% system(['rename template.xlsx ',Patient.lastname,'_',Patient.firstname,'_',regexprep(Patient.birthdate,'/',''),'_AQM_',regexprep(Session(1).date,'/',''),'.xlsx']);
% cd(toolboxFolder);
disp('Le rapport a été généré !');

invoke(Excel.ActiveWorkbook,'Save');
Excel.Quit
Excel.delete
clear Excel