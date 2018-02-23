clear
toolboxFolder = 'C:\Users\celine.schreiber\Documents\MATLAB\Toolbox_Septembre2016';
cd(toolboxFolder);
addpath(pwd);
addpath([pwd,'\plugin\clinicalReport']);
addpath([pwd,'\plugin\statistics']);
addpath([pwd,'\plugin\Posturo']);
addpath([pwd,'\plugin\Foot']);
addpath([pwd,'\plugin\Upper_Limbs']);
addpath([pwd,'\toolbox\btk']);
addpath([pwd,'\toolbox\Toolbox_M_Inverse_Dynamics']);

% BDD Adultes
P={'SS2015043'};
% P={'SS2014001','SS2014002','SS2014003','SS2014004','SS2014005','SS2014006',...
% 'SS2014007','SS2014008','SS2014009','SS2014011','SS2014013','SS2014014',...
% 'SS2014015','SS2014019','SS2014022','SS2014024','SS2014025','SS2014026',...
% 'SS2014029','SS2014030','SS2014031','SS2014032','SS2014033','SS2014034',...
% 'SS2014040','SS2014046','SS2014048','SS2014049','SS2014050','SS2014051',...
% 'SS2014052','SS2014053','SS2014054','SS2015002','SS2015003',...%'SS2015001',
% 'SS2015004','SS2015005','SS2015007','SS2015013','SS2015015','SS2015016',...
% 'SS2015017','SS2015020','SS2015021','SS2015026','SS2015027','SS2015030',...
% 'SS2015032','SS2015034','SS2015035','SS2015037','SS2015041','SS2015042',...
% 'SS2015043'}; 

% BDD enfants <6ans
% P={'SS2014010','SS2014016','SS2014023','SS2014035','SS2014036','SS2014037',...
% 'SS2014041','SS2014042','SS2014045','SS2015006','SS2015009',...% SS2015008 a verifier!!!   
% 'SS2015010','SS2015011','SS2015014','SS2015023','SS2015025','SS2015031',...
% 'SS2015040','SS2016005','SS2016006','SS2016008','SS2016011'}; 

%BDD enfants [6,12]
% P={'SS2014012','SS2014020','SS2014021','SS2014027','SS2014028','SS2014043',...
% 'SS2014044','SS2014047','SS2015018','SS2015019','SS2015029','SS2015036',...
% 'SS2015038','SS2015039','SS2016002','SS2016003','SS2016004','SS2016007',...
% 'SS2016010'};                     

% BDD enfants [13,18]
% P={'SS2014017','SS2014018','SS2014038','SS2014039','SS2015024','SS2015033',...
%     'SS2016001','SS2017001'};                                            

% BDD spontane/metronome
% P={'SS2014005','SS2014007','SS2014015','SS2014022','SS2014029','SS2014030',...
% 'SS2014053','SS2015005','SS2015024','SS2015030','SS2015032','SS2015037',...
% 'SS2015041','SS2015042',...
% 'SS2015020','SS2015034','SS2015043'}; 

% BDD Tapis
% P={'SS2014001','SS2014002','SS2014003','SS2014004','SS2014005','SS2014006',...
% 'SS2014007','SS2014008','SS2014009','SS2014011','SS2014013','SS2014014',...
% 'SS2014015','SS2014017','SS2014019','SS2014022','SS2014024','SS2014025',...
% 'SS2014026','SS2014029','SS2014030','SS2014031','SS2014032','SS2014033'...
% 'SS2014034','SS2014040','SS2014046','SS2014049','SS2014050'};

% BDD Membre sup
% P={'SS2014001','SS2014002','SS2014003','SS2014004',...%'SS2014005','SS2014006',...
%     'SS2014007','SS2014008','SS2014009','SS2014011','SS2014013','SS2014014',...
%     'SS2014015','SS2014019','SS2014022','SS2014024','SS2014025',...
%     'SS2014026','SS2014029','SS2014030','SS2014031','SS2014032','SS2014033','SS2014034',...
%     'SS2014040','SS2014046','SS2014048','SS2014049',...
%     'SS2014050','SS2014051','SS2014052','SS2014053','SS2014054',...
%     'SS2015002','SS2015003','SS2015004','SS2015005','SS2015007','SS2015013',...
%     'SS2015015'};

for p=1:length(P)
        c3dFolder=['C:\Users\celine.schreiber\Documents\MATLAB\Toolbox_Rehazenter_Normatives\normativeData\',char(P(p))];
%         disp(['  > ','Patient ',char(P(p))]); 
        matFolder = c3dFolder(1:(end-10));
        MainRehazenterToolbox(c3dFolder,0); % folder, database
end

filenameNormatives='Normes spontanee.mat';
MainStatistics();
% MainPluginClinicalReport();
% [Patient,Pathology,Treatment,Session,Condition] = mergeConditions(temp,a,b);
% reportUpperLimbsKinematics(Patient,Session,Condition,pluginFolder,normFolder,norm)

% BDD spontane/metronome
% P={'SS2014005','SS2014007','SS2014009','SS2014014','SS2014030',... %30?
% 'SS2014040','SS2014049','SS2014053','SS2015005',...
% 'SS2015015','SS2015016','SS2015017','SS2015020','SS2015021','SS2015022'}; 
% si 10% de la vitesse: 'SS2014019','SS2014034','SS2014052','SS2015002'