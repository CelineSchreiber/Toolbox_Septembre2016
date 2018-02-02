function MainRehazenterToolbox_Events(filesFolder,database)

warning('off','All'); clc;
addpath('C:\Program Files\MATLAB\R2011b\toolbox\btk');
addpath(pwd);
addpath([pwd,'\toolbox']);
addpath([pwd,'\toolbox\Toolbox_M_Inverse_Dynamics']);
addpath([pwd,'\toolbox\queryMySQL']);
addpath([pwd,'\toolbox\queryMySQL\src']);
addpath([pwd,'\toolbox\xlsread1']);
matFolder = filesFolder(1:(end-10));
toolboxFolder = pwd;
cd(toolboxFolder);
if nargin == 0
    filesFolder = uigetdir; % Set the work folder
end

disp('>> Import session information ...');
if ~exist('Session','var')
    [~,~,~,~,Session] = sessionInformation(filesFolder);
end
temp1 = cell(0);
temp2 = cell(0);
for i = 1:length(Session.Gait)
    count1 = 0;
    if ~isempty(temp1)
        for j = 1:length(temp1)
            if ~strcmp(temp1{j},Session.Gait(i).condition)
                count1 = count1+1;
            end
        end
        if count1 == length(temp1)
            temp1{length(temp1)+1} = Session.Gait(i).condition;
            temp2{length(temp2)+1} = Session.Gait(i).details;
        end
    else
        temp1{length(temp1)+1} = Session.Gait(i).condition;
        temp2{length(temp2)+1} = Session.Gait(i).details;
    end
end
Session.conditions = temp1;
Session.details = temp2;
disp('>> Information importation achieved!');
disp(' ');

disp('>> Load files ...');
cd(filesFolder);
temp = 0;
for i = 1:length(Session.Gait)      
    if ~isempty(Session.Gait(i).filename)
        Session.Gait(i).file = btkReadAcquisition(Session.Gait(i).filename);
        if temp == 0
            temp = i;
        end
    end
end
cd(toolboxFolder);
% Get frequencies from Gait(1)
Session.fpoint = btkGetPointFrequency(Session.Gait(1).file);
Session.fanalog = btkGetAnalogFrequency(Session.Gait(1).file);
disp('>> Files importation achieved!');
disp(' ');

disp(['>> ',num2str(length(Session.conditions)),...
    ' condition(s) detected ...']); 
disp(' ');        
if exist('Session','var')
    computeEvents_from_plates(Session,filesFolder);
end    
end    

