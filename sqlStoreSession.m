% =========================================================================
% REHAZENTER TOOLBOX
% =========================================================================
% File name:    sqlStoreSession
% -------------------------------------------------------------------------
% Subject:      Store session information in the database
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

function [] = sqlStoreSession(Patient,Session,db)

% =========================================================================
% Get PatientID from database
% =========================================================================
merge = strcat('SELECT `patientid` FROM `patient` WHERE `lastname` ="',...
    Patient.lastname,'" && `firstname` ="',...
    Patient.firstname,'" && `birthdate` ="',...
    Patient.birthdate,'"');
db.prepareStatement(merge);
finder1 = db.query();

% =========================================================================
% Check if session exist or not in the database
% test = check patientID and date of session
% =========================================================================
merge = strcat('SELECT * FROM `session` WHERE `patientid` ="',...
    num2str(finder1.patientid),'" && `date` ="',Session.date,'"');
db.prepareStatement(merge);
finder2 = db.query();

% =========================================================================
% If the session is not already in the database, add it
% =========================================================================
if size(finder2.sessionid,1) == 0
    merge = strcat('INSERT INTO `session` (`patientid`, `date`, `clinician`, `operator`, `patientweight`, `patientheight`, `system`, `fpoint`, `fanalog`, `markersset`, `footmarkersset`, `course`, `reason`, `comments`) VALUES("',...
        num2str(finder1.patientid),'","',Session.date...
        ,'","',Session.clinician,'","',Session.operator...
        ,'","',num2str(Session.weight),'","',num2str(Session.height)...
        ,'","',Session.system,'","',num2str(Session.fpoint)...
        ,'","',num2str(Session.fanalog),'","',Session.markersset,'","',Session.footmarkersset...
        ,'","',Session.course,'","',Session.reason,'","',Session.comments,'")');
    db.prepareStatement(merge);
    db.query();
end