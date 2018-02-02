% =========================================================================
% REHAZENTER TOOLBOX - PLUGIN CLINICAL REPORT
% =========================================================================
% File name:    mergePdf
% -------------------------------------------------------------------------
% Subject:      Merge .pdf files using Ghostscript
% -------------------------------------------------------------------------
% Inputs:       - Patient (structure)
%               - Session (structure)
%               - toolboxFolder (char)
%               - pluginFolder (char)
%               - filesFolder (char)
%               - database (int)
% Outputs:      - merged pdf
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber, A. Naaim
% Date of creation: 14/01/2015
% Version: 1
% -------------------------------------------------------------------------
% Updates: - 28/04/2015 - Condition "database" to create .pdf file and
%            complete database ... or not
% =========================================================================

function mergePdf(Patient,Session,reportFolder,toolboxFolder,pluginFolder,filesFolder,database)

% =========================================================================
% Initialisation
% =========================================================================
pdfFiles = [];
pdfFiles2 = [];
cd(filesFolder);
cd('temporaryFiles');
pdfFiles2 = [];
clear list;
list = dir('firstPage_*');
for i = 1:length(list)
    pdfFiles2 = [pdfFiles2,' ',list(i).name];
end
clear list;
list = dir('gaitParameters_*');
for i = 1:length(list)
    pdfFiles2 = [pdfFiles2,' ',list(i).name];
end
clear list;
list = dir('indexes_*');
for i = 1:length(list)
    pdfFiles2 = [pdfFiles2,' ',list(i).name];
end
clear list;
list = dir('kinematics_*');
for i = 1:length(list)
    pdfFiles2 = [pdfFiles2,' ',list(i).name];
end
clear list;
list = dir('kinetics_*');
for i = 1:length(list)
    pdfFiles2 = [pdfFiles2,' ',list(i).name];
end
clear list;
list = dir('EMG_*');
for i = 1:length(list)
    pdfFiles2 = [pdfFiles2,' ',list(i).name];
end
list = dir('rachis*');
for i = 1:length(list)
    pdfFiles2 = [pdfFiles2,' ',list(i).name];
end
list = dir('AI_*');
for i = 1:length(list)
    pdfFiles2 = [pdfFiles2,' ',list(i).name];
end
list = dir('NCCF_*');
for i = 1:length(list)
    pdfFiles2 = [pdfFiles2,' ',list(i).name];
end
% =========================================================================
% Merge then using ghostscript
% =========================================================================
filename = [regexprep(Session(1).date,'/','-'),'_',...
    regexprep(Patient(1).lastname,' ','_'),'_',...
    regexprep(Patient(1).firstname,' ','_'),'_',...
    regexprep(Patient(1).birthdate,'/','-')];
command = [toolboxFolder,'\toolbox\gs\bin\gswin32.exe -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -sOutputFile=',filename,'.pdf',pdfFiles2];
[status,cmdout] = system(command);

% =========================================================================
% Delete temporary pdf files
% =========================================================================
delete('*_temp.pdf');
if database == 1
    copyfile('*.pdf',reportFolder);
end
movefile('*.pdf','..');
cd(pluginFolder);

% =========================================================================
% Store all information in the MySQL database
% =========================================================================
if database == 1
    cd(toolboxFolder)
    db = MySQLDatabase('bddlabo.rehazenter.local', 'bddaqm_v1', 'labomarche', 'qualisys');
    sqlStoreReport(Patient,Session,filename,db);
    db.close();
end