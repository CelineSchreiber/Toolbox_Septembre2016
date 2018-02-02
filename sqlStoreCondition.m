% =========================================================================
% REHAZENTER TOOLBOX
% =========================================================================
% File name:    sqlStoreCondition
% -------------------------------------------------------------------------
% Subject:      Store condition information in the database
% -------------------------------------------------------------------------
% Inputs:       - Patient (structure)
%               - Session (structure)
%               - db (structure)
% Outputs:      - None
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber, A. Naaim
% Date of creation: 08/09/2014
% Version: 1
% -------------------------------------------------------------------------
% Updates: - 
% =========================================================================

function [] = sqlStoreCondition(Patient,Session,db)

% =========================================================================
% Get patientid from database
% =========================================================================
merge = strcat('SELECT `patientid` FROM `patient` WHERE `lastname` ="',...
    Patient.lastname,'" && firstname ="',...
    Patient.firstname,'" && birthdate ="',...
    Patient.birthdate,'"');
db.prepareStatement(merge, 10001);
finder1 = db.query();

% =========================================================================
% Get sessionid from database
% =========================================================================
merge = strcat('SELECT `sessionid` FROM `session` WHERE `patientid` ="',...
    num2str(finder1.patientid),'" && date ="',Session.date,'"');
db.prepareStatement(merge, 10001);
finder2 = db.query();

% =========================================================================
% Add conditions
% =========================================================================
for i = 1:length(Session.conditions)
    clear finder3
    
    % Check if condition exist or not in the database
    % test = check sessionID and name
    merge = strcat('SELECT * FROM `condition` WHERE `sessionid` ="',...
        num2str(finder2.sessionid),'" && `name` ="',Session.conditions{i},'"');
    db.prepareStatement(merge);
    finder3 = db.query();
    
    % If the condition is not already in the database, add it
    if size(finder3.conditionid,1) == 0
        counter = 0;
        for j = 1:length(Session.Gait)
            if strcmp(Session.conditions{i},Session.Gait(j).condition)
                counter = counter+1;
            end
        end
        if strfind(Session.conditions{i},'-A')
            temp = [Session.conditions{i},' : ',char(Session.details{i})];
        else
            temp = [Session.conditions{i},' : ',translateNomenclature(char(Session.conditions{i}))];
        end
        merge = strcat('INSERT INTO `condition` (`sessionid`, `name`, `ntrial`) VALUES ("',...
            num2str(finder2.sessionid),'","',temp,'","',num2str(counter),'")');
        db.prepareStatement(merge);
        db.query(); 
    end
end