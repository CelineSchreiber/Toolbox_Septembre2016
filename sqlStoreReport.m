% =========================================================================
% REHAZENTER TOOLBOX
% =========================================================================
% File name:    sqlStoreReport
% -------------------------------------------------------------------------
% Subject:      Store session information in the database
% -------------------------------------------------------------------------
% Inputs:       - Patient (structure)
%               - Session (structure)
%               - filename (char)
%               - db (structure)
% Outputs:      - None
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber, A. Naaim
% Date of creation: 08/09/2014
% Version: 1
% -------------------------------------------------------------------------
% Updates: - 
% =========================================================================

function [] = sqlStoreReport(Patient,Session,filename,db)

% =========================================================================
% Get patientid from database
% =========================================================================
merge = strcat('SELECT `patientid` FROM `patient` WHERE `lastname` ="',...
    Patient(1).lastname,'" && firstname ="',...
    Patient(1).firstname,'" && birthdate ="',...
    Patient(1).birthdate,'"');
db.prepareStatement(merge, 10001);
finder1 = db.query();

% =========================================================================
% Get sessionid from database
% =========================================================================
merge = strcat('SELECT `sessionid` FROM `session` WHERE `patientid` ="',...
    num2str(finder1.patientid),'" && date ="',Session(1).date,'"');
db.prepareStatement(merge, 10001);
finder2 = db.query();

% =========================================================================
% Add report
% =========================================================================
% Check if report exist or not in the database
% test = check sessionID (suppose ONLY ONE REPORT PER SESSION)
merge = strcat('SELECT * FROM `report` WHERE `sessionid` ="',...
    num2str(finder2.sessionid),'"');
db.prepareStatement(merge);
finder3 = db.query();
% If the report is not already in the database, add it
if size(finder3.reportid,1) == 0
    merge = strcat('INSERT INTO `report` (`patientid`, `sessionid`, `link`) VALUES ("',...
        num2str(finder1.patientid),'","',...
        num2str(finder2.sessionid),'","',['//bddlabo.rehazenter.local/Reports/',filename,'.pdf'],'")');
    db.prepareStatement(merge);
    db.query(); 
end