% =========================================================================
% REHAZENTER TOOLBOX
% =========================================================================
% File name:    sqlStorePatient
% -------------------------------------------------------------------------
% Subject:      Store patient information in the database
% -------------------------------------------------------------------------
% Inputs:       - Patient (structure)
%               - db (structure)
% Outputs:      - None
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber, A. Naaim
% Date of creation: 05/09/2014
% Version: 1
% -------------------------------------------------------------------------
% Updates: - 
% =========================================================================

function [] = sqlStorePatient(Patient,db)

% =========================================================================
% Check if the patient exist in the database
% test = check lastname, firstname and date of birth
% =========================================================================
merge = strcat('SELECT * FROM `patient` WHERE `lastname` ="',...
    Patient.lastname,'" && `firstname` ="',...
    Patient.firstname,'" && `birthdate` ="',...
    Patient.birthdate,'"');
db.prepareStatement(merge);
finder = db.query();

% =========================================================================
% If the patient is not already in the database, add it
% =========================================================================
if size(finder.patientid,1) == 0
    merge = strcat('INSERT INTO `patient` (`lastname`, `firstname`, `gender`, `birthdate`) VALUES("',...
        Patient.lastname,'","',Patient.firstname...
        ,'","',Patient.gender,'","',Patient.birthdate,'")');
    db.prepareStatement(merge);
    db.query();
end