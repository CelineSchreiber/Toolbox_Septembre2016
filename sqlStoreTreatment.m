% =========================================================================
% REHAZENTER TOOLBOX
% =========================================================================
% File name:    sqlStoreTreatment
% -------------------------------------------------------------------------
% Subject:      Store treatment information in the database
% -------------------------------------------------------------------------
% Inputs:       - Patient (structure)
%               - Treatment (structure)
%               - db (structure)
% Outputs:      - None
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber, A. Naaim
% Date of creation: 26/11/2014
% Version: 1
% -------------------------------------------------------------------------
% Updates: - 
% =========================================================================

function [] = sqlStoreTreatment(Patient,Session,Treatment,db)

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
% If the treatment is not already in the database, add it
% =========================================================================
merge = strcat('SELECT * FROM `treatment` WHERE `sessionid` ="',...
    num2str(finder2.sessionid),'"');
db.prepareStatement(merge);
finder3 = db.query();
% If the treatment is not already in the database, add it
if size(finder3.treatmentid,1) == 0
    merge = strcat('INSERT INTO `treatment` (`sessionid`, `injectiondate`, `injectedmuscle1`, `injectedmuscle2`, `injectedmuscle3`, `injectedmuscle4`, `injectedmuscle5`, `surgerydate`, `surgerypurpose`) VALUES("',...
        num2str(finder2.sessionid),'","',Treatment.injectiondate...
        ,'","',Treatment.injectedmuscle1,'","',Treatment.injectedmuscle2...
        ,'","',Treatment.injectedmuscle3,'","',Treatment.injectedmuscle4...
        ,'","',Treatment.injectedmuscle5,'","',Treatment.surgerydate...
        ,'","',Treatment.surgerypurpose,'")');
    db.prepareStatement(merge);
    db.query(); 
end