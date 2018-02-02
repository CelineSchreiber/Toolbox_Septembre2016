% =========================================================================
% REHAZENTER TOOLBOX
% =========================================================================
% File name:    sqlStorePathology
% -------------------------------------------------------------------------
% Subject:      Store pathology information in the database
% -------------------------------------------------------------------------
% Inputs:       - Patient (structure)
%               - Pathology (structure)
%               - db (structure)
% Outputs:      - None
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber, A. Naaim
% Date of creation: 05/09/2014
% Version: 1
% -------------------------------------------------------------------------
% Updates: - 
% =========================================================================

function [] = sqlStorePathology(Patient,Pathology,db)

% =========================================================================
% Check if the patient exist in the database
% test = check lastname, firstname and date of birth
% =========================================================================
merge = strcat('SELECT * FROM `patient` WHERE `lastname` ="',...
    Patient.lastname,'" && `firstname` ="',...
    Patient.firstname,'" && `birthdate` ="',...
    Patient.birthdate,'"');
db.prepareStatement(merge);
finder1 = db.query();

% =========================================================================
% Check if pathology exist or not in the database
% test = check patientID and pathology name
% =========================================================================
merge = strcat('SELECT * FROM `pathology` WHERE `patientid` ="',...
    num2str(finder1.patientid),'" && `name` ="',Pathology.name,'"');
db.prepareStatement(merge);
finder2 = db.query();

% =========================================================================
% If the pathology is not already in the database, add it
% =========================================================================
if size(finder2.pathologyid,1) == 0
    merge = strcat('INSERT INTO `pathology` (`patientid`, `name`, `type`, `comments`, `accidentdate`, `accidenttype`, `affectedside`, `affectedlimb`) VALUES("',...
        num2str(finder1.patientid),'","',Pathology.name...
        ,'","',Pathology.type,'","',Pathology.comments...
        ,'","',Pathology.accidentdate,'","',Pathology.accidenttype...
        ,'","',Pathology.affectedside,'","',Pathology.affectedlimb,'")');
    db.prepareStatement(merge);
    db.query(); 
end