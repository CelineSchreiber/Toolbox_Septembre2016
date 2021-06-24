clear filename
cd(matFolder);
filename{1} = uigetfile({'*.mat','MAT-files (*.mat)'}, ...
    'Select a session file PRE botox', ...
    'MultiSelect','off');
filename{2} = uigetfile({'*.mat','MAT-files (*.mat)'}, ...
    'Select a session file POST botox', ...
    'MultiSelect','off');
if ~iscell(filename)
    filename = mat2cell(filename,1);
end

cd('Y:\060 Médecins\ANNEXE DOSSIERS\MONITORING\Protocole MOTOX');
filenameMOTOX = uigetfile('Sélectionner le fichier XLS du patient:', 'MultiSelect','off');

Excel = actxserver ('Excel.Application');
fnameMOTOX=fullfile(pwd,filenameMOTOX);
invoke(Excel.Workbooks,'Open',fnameMOTOX);

cd(matFolder);
sheet='AQMs - Data';
xlswrite1(fnameMOTOX,' ',sheet,'A1:U216');

for iCondition=1:size(filename,2)
        
    load(filename{iCondition});
    nline  = (iCondition-1)*103;   % Used for kinematics and kinetics (100 frames data only)
    
    % =========================================================================
    % Spatiotemporal parameters
    % =========================================================================

    xlswrite1(fnameMOTOX,{'Phase d''appui' 'Phase d''appui' 'Phase d''appui' 'Phase d''appui' ...
        'Longueur de pas' 'Longueur de pas' 'Longueur de pas' 'Longueur de pas' ...
        'Largeur de pas' 'Largeur de pas' ...
        'Cadence' 'Cadence' ...
        'Vitesse' 'Vitesse' ...
        },sheet,['B',num2str(1)]);
    if strcmp(Pathology.affectedside,'Gauche') | strcmp(Pathology.affectedside,'Droite')
    	xlswrite1(fnameMOTOX,{'Pathologique' 'Pathologique' 'Sain' 'Sain' ...
                'Pathologique' 'Pathologique' 'Sain' 'Sain' ...
                'Moyen' 'Moyen' ...
                'Moyen' 'Moyen' ...
                'Moyen' 'Moyen' ...
                },sheet,['B',num2str(2)]);
    else
            xlswrite1(fnameMOTOX,{'Droite' 'Droite' 'Gauche' 'Gauche' ...
                'Droite' 'Droite' 'Gauche' 'Gauche' ...
                'Moyen' 'Moyen' ...
                'Moyen' 'Moyen' ...
                'Moyen' 'Moyen' ...
                },sheet,['B',num2str(2)]);
    end
    xlswrite1(fnameMOTOX,{'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' ...
        'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' ...
        'Moyenne' 'Ecart-type' ...
        'Moyenne' 'Ecart-type' ...
        'Moyenne' 'Ecart-type' ...
        },sheet,['B',num2str(3)]);
    
    xlswrite1(fnameMOTOX,cellstr(['Condition pre toxine']),sheet,['A',num2str(4)]);
    xlswrite1(fnameMOTOX,cellstr(['Condition post toxine']),sheet,['A',num2str(5)]);
    
    if strcmp(Pathology.affectedside,'Gauche')
        %---
        xlswrite1(fnameMOTOX,Condition.All.Gaitparameters.left_stance_phase.mean,sheet,['B',num2str(3+iCondition)]);
        xlswrite1(fnameMOTOX,Condition.All.Gaitparameters.left_stance_phase.std,sheet,['C',num2str(3+iCondition)]);
        xlswrite1(fnameMOTOX,Condition.All.Gaitparameters.right_stance_phase.mean,sheet,['D',num2str(3+iCondition)]);
        xlswrite1(fnameMOTOX,Condition.All.Gaitparameters.right_stance_phase.std,sheet,['E',num2str(3+iCondition)]);
        %---
        xlswrite1(fnameMOTOX,Condition.All.Gaitparameters.left_step_length.mean*1e2,sheet,['F',num2str(3+iCondition)]);
        xlswrite1(fnameMOTOX,Condition.All.Gaitparameters.left_step_length.std*1e2,sheet,['G',num2str(3+iCondition)]);
        xlswrite1(fnameMOTOX,Condition.All.Gaitparameters.right_step_length.mean*1e2,sheet,['H',num2str(3+iCondition)]);
        xlswrite1(fnameMOTOX,Condition.All.Gaitparameters.right_step_length.std*1e2,sheet,['I',num2str(3+iCondition)]);
        %---
        xlswrite1(fnameMOTOX,Condition.All.Gaitparameters.step_width.mean*1e2,sheet,['J',num2str(3+iCondition)]);
        xlswrite1(fnameMOTOX,Condition.All.Gaitparameters.step_width.std*1e2,sheet,['K',num2str(3+iCondition)]);
        %---
        xlswrite1(fnameMOTOX,Condition.All.Gaitparameters.cadence.mean,sheet,['L',num2str(3+iCondition)]);
        xlswrite1(fnameMOTOX,Condition.All.Gaitparameters.cadence.std,sheet,['M',num2str(3+iCondition)]);
        %---
        xlswrite1(fnameMOTOX,Condition.All.Gaitparameters.mean_velocity.mean,sheet,['N',num2str(3+iCondition)]);
        xlswrite1(fnameMOTOX,Condition.All.Gaitparameters.mean_velocity.std,sheet,['O',num2str(3+iCondition)]);
        %---
    else
        %---
        xlswrite1(fnameMOTOX,Condition.All.Gaitparameters.right_stance_phase.mean,sheet,['B',num2str(3+iCondition)]);
        xlswrite1(fnameMOTOX,Condition.All.Gaitparameters.right_stance_phase.std,sheet,['C',num2str(3+iCondition)]);
        xlswrite1(fnameMOTOX,Condition.All.Gaitparameters.left_stance_phase.mean,sheet,['D',num2str(3+iCondition)]);
        xlswrite1(fnameMOTOX,Condition.All.Gaitparameters.left_stance_phase.std,sheet,['E',num2str(3+iCondition)]);
        %---
        xlswrite1(fnameMOTOX,Condition.All.Gaitparameters.right_step_length.mean*1e2,sheet,['F',num2str(3+iCondition)]);
        xlswrite1(fnameMOTOX,Condition.All.Gaitparameters.right_step_length.std*1e2,sheet,['G',num2str(3+iCondition)]);
        xlswrite1(fnameMOTOX,Condition.All.Gaitparameters.left_step_length.mean*1e2,sheet,['H',num2str(3+iCondition)]);
        xlswrite1(fnameMOTOX,Condition.All.Gaitparameters.left_step_length.std*1e2,sheet,['I',num2str(3+iCondition)]);
        %---
        xlswrite1(fnameMOTOX,Condition.All.Gaitparameters.step_width.mean*1e2,sheet,['J',num2str(3+iCondition)]);
        xlswrite1(fnameMOTOX,Condition.All.Gaitparameters.step_width.std*1e2,sheet,['K',num2str(3+iCondition)]);
        %---
        xlswrite1(fnameMOTOX,Condition.All.Gaitparameters.cadence.mean,sheet,['L',num2str(3+iCondition)]);
        xlswrite1(fnameMOTOX,Condition.All.Gaitparameters.cadence.std,sheet,['M',num2str(3+iCondition)]);
        %---
        xlswrite1(fnameMOTOX,Condition.All.Gaitparameters.mean_velocity.mean,sheet,['N',num2str(3+iCondition)]);
        xlswrite1(fnameMOTOX,Condition.All.Gaitparameters.mean_velocity.std,sheet,['O',num2str(3+iCondition)]);
        %---
    end

    % =========================================================================
    % Kinematics
    % =========================================================================
    
    xlswrite1(fnameMOTOX,cellstr('Temps'),sheet,['A',num2str(7)]);
    xlswrite1(fnameMOTOX,{'Hanche' 'Hanche' 'Hanche' 'Hanche' ...
            'Genou' 'Genou' 'Genou' 'Genou' ...
            'Cheville' 'Cheville' 'Cheville' 'Cheville' ...
            'Pied' 'Pied' 'Pied' 'Pied' 'Pied' 'Pied' 'Pied' 'Pied' ... 
            'Pied' 'Pied' 'Pied' 'Pied'...
            'Clearance' 'Clearance' 'Clearance' 'Clearance'},sheet,['B',num2str(7)]);
    xlswrite1(fnameMOTOX,{'Flexion (+) / Extension (-) (°)' 'Flexion (+) / Extension (-) (°)' 'Flexion (+) / Extension (-) (°)' 'Flexion (+) / Extension (-) (°)' ...
            'Flexion (+) / Extension (-) (°)' 'Flexion (+) / Extension (-) (°)' 'Flexion (+) / Extension (-) (°)' 'Flexion (+) / Extension (-)' ...
            'Dorsif. (+) / Plantarf. (-) (°)' 'Dorsif. (+) / Plantarf. (-) (°)' 'Dorsif. (+) / Plantarf. (-) (°)' 'Dorsif. (+) / Plantarf. (-)' ...
            'tilt' 'tilt' 'tilt' 'tilt' 'Abaissement meta 1 (+) / 5 (-) (°)' 'Abaissement meta 1 (+) / 5 (-) (°)' 'Abaissement meta 1 (+) / 5 (-) (°)' 'Abaissement meta 1 (+) / 5 (-) (°)' ...
            'Angle de progr. (int. + / ext. -) (°)' 'Angle de progr. (int. + / ext. -) (°)' 'Angle de progr. (int. + / ext. -) (°)' 'Angle de progr. (int. + / ext. -) (°)'...
            'Hauteur (cm)' 'Hauteur (cm)' 'Hauteur (cm)' 'Hauteur (cm)'},sheet,['B',num2str(8)]);
    if strcmp(Pathology.affectedside,'Gauche') | strcmp(Pathology.affectedside,'Droite')
        xlswrite1(fnameMOTOX,{'Pathologique' 'Pathologique' 'Sain' 'Sain' ...
                'Pathologique' 'Pathologique' 'Sain' 'Sain' ...
                'Pathologique' 'Pathologique' 'Sain' 'Sain' ...
                'Pathologique' 'Pathologique' 'Sain' 'Sain' ...
                'Pathologique' 'Pathologique' 'Sain' 'Sain' ...
                'Pathologique' 'Pathologique' 'Sain' 'Sain' ...
                'Pathologique' 'Pathologique' 'Sain' 'Sain' ...
                },sheet,['B',num2str(2)]);
    else
        xlswrite1(fnameMOTOX,{'Droite' 'Droite' 'Gauche' 'Gauche' ...
                'Droite' 'Droite' 'Gauche' 'Gauche' ...
                'Droite' 'Droite' 'Gauche' 'Gauche' ...
                'Droite' 'Droite' 'Gauche' 'Gauche' ...
                'Droite' 'Droite' 'Gauche' 'Gauche'...
                'Droite' 'Droite' 'Gauche' 'Gauche' ...
                'Droite' 'Droite' 'Gauche' 'Gauche' ...
                },sheet,['B',num2str(9)]);
    end
    xlswrite1(fnameMOTOX,{'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' ...
            'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' ...
            'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' ...
            'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' ...
            'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' ...
            'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' ...
            'Moyenne' 'Ecart-type' 'Moyenne' 'Ecart-type' ...
            },sheet,['B',num2str(10)]);
    xlswrite1(fnameMOTOX,cellstr(['Condition avant Botox']),sheet,['A',num2str(12)]);
    xlswrite1(fnameMOTOX,(0:1:100)',sheet,['A',num2str(13)]);
    if strcmp(Pathology.affectedside,'Gauche')
        %---
        xlswrite1(fnameMOTOX,Condition.All.Lkinematics.FE4.mean,sheet,['B',num2str(nline+13)]);
        xlswrite1(fnameMOTOX,Condition.All.Lkinematics.FE4.std,sheet,['C',num2str(nline+13)]);
        xlswrite1(fnameMOTOX,Condition.All.Rkinematics.FE4.mean,sheet,['D',num2str(nline+13)]);
        xlswrite1(fnameMOTOX,Condition.All.Rkinematics.FE4.std,sheet,['E',num2str(nline+13)]);
        %---
        xlswrite1(fnameMOTOX,-Condition.All.Lkinematics.FE3.mean,sheet,['F',num2str(nline+13)]);
        xlswrite1(fnameMOTOX,-Condition.All.Lkinematics.FE3.std,sheet,['G',num2str(nline+13)]);
        xlswrite1(fnameMOTOX,-Condition.All.Rkinematics.FE3.mean,sheet,['H',num2str(nline+13)]);
        xlswrite1(fnameMOTOX,-Condition.All.Rkinematics.FE3.std,sheet,['I',num2str(nline+13)]);
        %---
        xlswrite1(fnameMOTOX,Condition.All.Lkinematics.FE2.mean,sheet,['J',num2str(nline+13)]);
        xlswrite1(fnameMOTOX,Condition.All.Lkinematics.FE2.std,sheet,['K',num2str(nline+13)]);
        xlswrite1(fnameMOTOX,Condition.All.Rkinematics.FE2.mean,sheet,['L',num2str(nline+13)]);
        xlswrite1(fnameMOTOX,Condition.All.Rkinematics.FE2.std,sheet,['M',num2str(nline+13)]);
        %---
        xlswrite1(fnameMOTOX,Condition.All.Lkinematics.Ftilt.mean,sheet,['N',num2str(nline+13)]);
        xlswrite1(fnameMOTOX,Condition.All.Lkinematics.Ftilt.std,sheet,['O',num2str(nline+13)]);
        xlswrite1(fnameMOTOX,Condition.All.Rkinematics.Ftilt.mean,sheet,['P',num2str(nline+13)]);
        xlswrite1(fnameMOTOX,Condition.All.Rkinematics.Ftilt.std,sheet,['Q',num2str(nline+13)]);
        xlswrite1(fnameMOTOX,Condition.All.Lkinematics.Fobli.mean,sheet,['R',num2str(nline+13)]);
        xlswrite1(fnameMOTOX,Condition.All.Lkinematics.Fobli.std,sheet,['S',num2str(nline+13)]);
        xlswrite1(fnameMOTOX,Condition.All.Rkinematics.Fobli.mean,sheet,['T',num2str(nline+13)]);
        xlswrite1(fnameMOTOX,Condition.All.Rkinematics.Fobli.std,sheet,['U',num2str(nline+13)]);
        xlswrite1(fnameMOTOX,Condition.All.Lkinematics.Frota.mean,sheet,['V',num2str(nline+13)]);
        xlswrite1(fnameMOTOX,Condition.All.Lkinematics.Frota.std,sheet,['W',num2str(nline+13)]);
        xlswrite1(fnameMOTOX,Condition.All.Rkinematics.Frota.mean,sheet,['X',num2str(nline+13)]);
        xlswrite1(fnameMOTOX,Condition.All.Rkinematics.Frota.std,sheet,['Y',num2str(nline+13)]);
        %---
        xlswrite1(fnameMOTOX,Condition.All.Lkinematics.Clearance.mean,sheet,['Z',num2str(nline+13)]);
        xlswrite1(fnameMOTOX,Condition.All.Lkinematics.Clearance.std,sheet,['AA',num2str(nline+13)]);
        xlswrite1(fnameMOTOX,Condition.All.Rkinematics.Clearance.mean,sheet,['AB',num2str(nline+13)]);
        xlswrite1(fnameMOTOX,Condition.All.Rkinematics.Clearance.std,sheet,['AC',num2str(nline+13)]);
    else
        %---
        xlswrite1(fnameMOTOX,Condition.All.Rkinematics.FE4.mean,sheet,['B',num2str(nline+13)]);
        xlswrite1(fnameMOTOX,Condition.All.Rkinematics.FE4.std,sheet,['C',num2str(nline+13)]);
        xlswrite1(fnameMOTOX,Condition.All.Lkinematics.FE4.mean,sheet,['D',num2str(nline+13)]);
        xlswrite1(fnameMOTOX,Condition.All.Lkinematics.FE4.std,sheet,['E',num2str(nline+13)]);
        %---
        xlswrite1(fnameMOTOX,-Condition.All.Rkinematics.FE3.mean,sheet,['F',num2str(nline+13)]);
        xlswrite1(fnameMOTOX,-Condition.All.Rkinematics.FE3.std,sheet,['G',num2str(nline+13)]);
        xlswrite1(fnameMOTOX,-Condition.All.Lkinematics.FE3.mean,sheet,['H',num2str(nline+13)]);
        xlswrite1(fnameMOTOX,-Condition.All.Lkinematics.FE3.std,sheet,['I',num2str(nline+13)]);
        %---
        xlswrite1(fnameMOTOX,Condition.All.Rkinematics.FE2.mean,sheet,['J',num2str(nline+13)]);
        xlswrite1(fnameMOTOX,Condition.All.Rkinematics.FE2.std,sheet,['K',num2str(nline+13)]);
        xlswrite1(fnameMOTOX,Condition.All.Lkinematics.FE2.mean,sheet,['L',num2str(nline+13)]);
        xlswrite1(fnameMOTOX,Condition.All.Lkinematics.FE2.std,sheet,['M',num2str(nline+13)]);
        %---
        xlswrite1(fnameMOTOX,Condition.All.Rkinematics.Ftilt.mean,sheet,['N',num2str(nline+13)]);
        xlswrite1(fnameMOTOX,Condition.All.Rkinematics.Ftilt.std,sheet,['O',num2str(nline+13)]);
        xlswrite1(fnameMOTOX,Condition.All.Lkinematics.Ftilt.mean,sheet,['P',num2str(nline+13)]);
        xlswrite1(fnameMOTOX,Condition.All.Lkinematics.Ftilt.std,sheet,['Q',num2str(nline+13)]);
        xlswrite1(fnameMOTOX,Condition.All.Rkinematics.Fobli.mean,sheet,['R',num2str(nline+13)]);
        xlswrite1(fnameMOTOX,Condition.All.Rkinematics.Fobli.std,sheet,['S',num2str(nline+13)]);
        xlswrite1(fnameMOTOX,Condition.All.Lkinematics.Fobli.mean,sheet,['T',num2str(nline+13)]);
        xlswrite1(fnameMOTOX,Condition.All.Lkinematics.Fobli.std,sheet,['U',num2str(nline+13)]);
        xlswrite1(fnameMOTOX,Condition.All.Rkinematics.Frota.mean,sheet,['V',num2str(nline+13)]);
        xlswrite1(fnameMOTOX,Condition.All.Rkinematics.Frota.std,sheet,['W',num2str(nline+13)]);
        xlswrite1(fnameMOTOX,Condition.All.Lkinematics.Frota.mean,sheet,['X',num2str(nline+13)]);
        xlswrite1(fnameMOTOX,Condition.All.Lkinematics.Frota.std,sheet,['Y',num2str(nline+13)]);
        %---
        xlswrite1(fnameMOTOX,(Condition.All.Rkinematics.Clearance.mean-min(Condition.All.Rkinematics.Clearance.mean))*100,sheet,['Z',num2str(nline+13)]);
        xlswrite1(fnameMOTOX,Condition.All.Rkinematics.Clearance.std*100,sheet,['AA',num2str(nline+13)]);
        xlswrite1(fnameMOTOX,(Condition.All.Lkinematics.Clearance.mean-min(Condition.All.Lkinematics.Clearance.mean))*100,sheet,['AB',num2str(nline+13)]);
        xlswrite1(fnameMOTOX,Condition.All.Lkinematics.Clearance.std*100,sheet,['AC',num2str(nline+13)]);
      
    end

%     if iCondition==1
%     
%         % =========================================================================
%         % EMG
%         % =========================================================================
% 
%         xlswrite1(fnameMOTOX,cellstr('Temps'),sheet,['AE',num2str(7)]);
%         xlswrite1(fnameMOTOX,{'EMG1' 'EMG2' 'EMG3' 'EMG4'},sheet,['AF',num2str(7)]);
%         xlswrite1(fnameMOTOX,{'' '' '' ''},sheet,['AF',num2str(8)]);
% 
%         xlswrite1(fnameMOTOX,cellstr(['Condition avant Botox']),sheet,['AE',num2str(12)]);
%         xlswrite1(fnameMOTOX,(0:1:100)',sheet,['A',num2str(13)]);
% %         xlswrite1(fnameMOTOX,Condition.Gait(1).Remg.right_rectus_femoris_wire,sheet,['AF',num2str(nline+13)]);
%         % xlswrite1(fnameMOTOX,Condition.All.Lkinematics.FE4.std,sheet,['C',num2str(nline+13)]);
%         % xlswrite1(fnameMOTOX,Condition.All.Rkinematics.FE4.mean,sheet,['D',num2str(nline+13)]);
%         % xlswrite1(fnameMOTOX,Condition.All.Rkinematics.FE4.std,sheet,['E',num2str(nline+13)]);
%     end
end

cd('C:\Users\celine.schreiber\Documents\MATLAB\Toolbox_Septembre2016\norm')
norm = load('Normes spontanee.mat');

% NORMATIVE DATA MEAN
xlswrite1(fnameMOTOX,cellstr(['Norme']),sheet,['A',num2str(218)]);
% Hip kinematics
xlswrite1(fnameMOTOX,norm.Normatives.Rkinematics.FE4.mean,sheet,['B219']); 
xlswrite1(fnameMOTOX,norm.Normatives.Rkinematics.FE4.std,sheet,['C219']);
% Knee kinematics
xlswrite1(fnameMOTOX,-norm.Normatives.Rkinematics.FE3.mean,sheet,['F219']); 
xlswrite1(fnameMOTOX,-norm.Normatives.Rkinematics.FE3.std,sheet,['G219']); 
% Ankle kinematics
xlswrite1(fnameMOTOX,norm.Normatives.Rkinematics.FE2.mean,sheet,['J219']); 
xlswrite1(fnameMOTOX,norm.Normatives.Rkinematics.FE2.std,sheet,['K219']); 
% Foot kinematics
xlswrite1(fnameMOTOX,norm.Normatives.Rkinematics.Ftilt.mean,sheet,['N219']);
xlswrite1(fnameMOTOX,norm.Normatives.Rkinematics.Ftilt.std,sheet,['O219']);
xlswrite1(fnameMOTOX,norm.Normatives.Rkinematics.Fobli.mean,sheet,['R219']);
xlswrite1(fnameMOTOX,norm.Normatives.Rkinematics.Fobli.std,sheet,['S219']);
xlswrite1(fnameMOTOX,norm.Normatives.Rkinematics.Frota.mean,sheet,['V219']);
xlswrite1(fnameMOTOX,norm.Normatives.Rkinematics.Frota.std,sheet,['W219']);
% Clearance kinematics
xlswrite1(fnameMOTOX,norm.Normatives.Rkinematics.Clearance.mean*100,sheet,['Z219']); 
xlswrite1(fnameMOTOX,norm.Normatives.Rkinematics.Clearance.std*100,sheet,['AA219']);

% system(['rename template.xlsx ',Patient.lastname,'_',Patient.firstname,'_',regexprep(Patient.birthdate,'/',''),'_AQM_',regexprep(Session(1).date,'/',''),'.xlsx']);
% cd(toolboxFolder);
disp('Le rapport a été généré !');

invoke(Excel.ActiveWorkbook,'Save');
Excel.Quit
Excel.delete
clear Excel