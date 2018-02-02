% =========================================================================
% Prepare video Data
% =========================================================================
Data = dir('*.avi');

for id = 1:length(Data)
    
    % Get the file name (minus the extension)
    [~, f] = fileparts(Data(id).name);
    
    % Remove blank spaces and create a new file
    input = regexprep(f,' ','_');
    copyfile(Data(id).name, [input,'.avi']);
    
    % Identify frontal/sagittal videos 
    if strfind(input,'13634')
        output = 'video_profil';
    elseif strfind(input,'13641')
        output = 'video_face';
    end
    
    % Convert to .ogg file
%     system(['ffmpeg -i ',input,'.avi -acodec libvorbis -ac 1 -b 5000k ',output,'.ogg'])
    system(['ffmpeg -i ',input,'.avi -vcodec libx264 -acodec libfaac -threads 0 -t 60 ',output,'.mp4'])
    % Delete temporary Data
    delete([input,'.avi']);
    
end

% =========================================================================
% Set availibilities
% =========================================================================
rapportmedical = 0; % 0: no report, 1 : report called "rapportmedical.pdf"
eva = 0;            % 0: no report, 1 : report called "eva.pdf"
nkinematics = 1;    % number of kinematics pages
nkinetics = 1;      % number of kinetics pages
nemg = 1;           % number of emg pages
npostural = 1;      % number of postural pages
nvideo = 1;         % number of video pages
list = {'Allure spontanée'};

% =========================================================================
% Prepare html file
% =========================================================================
cd 'H:\Professionnel\Toolbox_Rehazenter\cdrom\Other';
file = 'report.html';
fid = fopen(file,'w+');

% Main file
fprintf(fid,'<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">\n');
fprintf(fid,'<HTML>\n');
fprintf(fid,'<HEAD>\n');
fprintf(fid,'<meta HTTP-EQUIV="Content-Type" CONTENT="text/html;charset=iso-8859-1">\n');
fprintf(fid,'<title>Rapport AQM</title>\n');
fprintf(fid,'<link rel="stylesheet" type="text/css" href="style.css">\n');
fprintf(fid,'</HEAD>\n');
fprintf(fid,'<BODY>\n');
fprintf(fid,'\t<header height="10%%" style="background-color:#515D69";">\n');
fprintf(fid,'\t\t<img src="banniere.jpg" height="10%%">\n');
fprintf(fid,'\t</header>\n');

fprintf(fid,'\t<table width="100%%" height="90%%">\n');
fprintf(fid,'\t\t<tr style="vertical-align:top;">\n');
fprintf(fid,'\t\t\t<td width="20%%">\n');
fprintf(fid,'\t\t\t\t<iframe name="iframe0" src="sommaire.html"></iframe>\n');
fprintf(fid,'\t\t\t</td>\n');
fprintf(fid,'\t\t\t<td width="60%%">\n');
fprintf(fid,'\t\t\t\t<iframe name="iframe1" src="about:blank"></iframe>\n');
fprintf(fid,'\t\t\t</td>\n');
fprintf(fid,'\t\t\t<td width="20%%">\n');
fprintf(fid,'\t\t\t\t<iframe name="iframe2" src="patient.html"></iframe>\n');
fprintf(fid,'\t\t\t</td>\n');
fprintf(fid,'\t\t</tr>\n');
fprintf(fid,'\t</table>\n');

fprintf(fid,'</BODY>\n');
fprintf(fid,'</HTML>\n');

% Sommaire
file = 'sommaire.html';
fid = fopen(file,'w+');
fprintf(fid,'<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">\n');
fprintf(fid,'<HTML>\n');
fprintf(fid,'<HEAD>\n');
fprintf(fid,'<meta HTTP-EQUIV="Content-Type" CONTENT="text/html;charset=iso-8859-1">\n');
fprintf(fid,'<link rel="stylesheet" type="text/css" href="stylesommaire.css">\n');
fprintf(fid,'</HEAD>\n');
fprintf(fid,'<BODY>\n');
fprintf(fid,['Examen du ',Session.date,' :\n']);
fprintf(fid,'<hr>\n');
fprintf(fid,'<br>\n');
fprintf(fid,['<b>Rapport réalisé par : <br>',Session.clinician,'</b><br>\n']);
fprintf(fid,'<br>\n');
if rapportmedical == 1
    fprintf(fid,'<a href="rapportmedical.pdf" target="iframe1">> Rapport médical</a>\n');
else
    fprintf(fid,'<a href="unavailable.pdf" target="iframe1">> Rapport médical</a>\n');
end
fprintf(fid,'<br>\n');
fprintf(fid,'<br>\n');
fprintf(fid,'<a href="parametres.pdf" target="iframe1">> Evaluation clinique analytique</a>\n');
fprintf(fid,'<br>\n');
fprintf(fid,'<br>\n');
fprintf(fid,'<a href="parametres.pdf" target="iframe1">> Parametres spatio-temporaux</a>\n');
fprintf(fid,'<br>\n');
fprintf(fid,'<br>\n');
fprintf(fid,'> Cinématique\n');
fprintf(fid,'<br>\n');
for i = 1:nkinematics
    fprintf(fid,['<a href="parametres.pdf" target="iframe1"> - <i>',list{i},'</i></a>\n']);
    fprintf(fid,'<br>\n');
end
fprintf(fid,'<br>\n');
fprintf(fid,'<a href="parametres.pdf" target="iframe1">> Dynamique</a>\n');
fprintf(fid,'<br>\n');
fprintf(fid,'<br>\n');
fprintf(fid,'<a href="videos.html" target="iframe1">> Vidéos</a>\n');
fprintf(fid,'<br>\n');
fprintf(fid,'</BODY>\n');
fprintf(fid,'</HTML>\n');

% Patient
file = 'patient.html';
fid = fopen(file,'w+');
fprintf(fid,'Informations patient\n');
fprintf(fid,'<hr>\n');
fprintf(fid,'<br>\n');
fprintf(fid,['<b>Nom :</b> ',Patient.lastname,'<br>\n']);
fprintf(fid,['<b>Prénom :</b> ',Patient.firstname,'<br>\n']);
fprintf(fid,['<b>Genre :</b> ',Patient.gender,'<br>\n']);
fprintf(fid,['<b>Date de naissance :</b> ',Patient.dob,'<br>\n']);
fprintf(fid,'<br>\n');
fprintf(fid,['<b>Pathologie :</b> ',Pathology.name,'<br>\n']);
fprintf(fid,['<b>Type :</b> ',Pathology.type,'<br>\n']);
fprintf(fid,['<b>Commentaires :</b> ',Pathology.comments,'<br>\n']);
fprintf(fid,['<b>Date de l''accident :</b> ',Pathology.accidentdate,'<br>\n']);
fprintf(fid,['<b>Type d''accident :</b> ',Pathology.accidenttype,'<br>\n']);
fprintf(fid,['<b>Côté affecté :</b> ',Pathology.affectedside,'<br>\n']);
fprintf(fid,['<b>Membres affectés :</b> ',Pathology.affectedlimb,'<br>\n']);

% Videos
file = 'videos.html';
fid = fopen(file,'w+');
fprintf(fid,'\t<video width="600" controls="controls" style="display:block;margin-left:auto;margin-right:auto;">\n');
fprintf(fid,'\t\t<source src="video_face.ogg" type="video/ogg" />\n');
fprintf(fid,'\t</video>\n');
fprintf(fid,'\t<br><br>\n');
fprintf(fid,'\t<video width="600" controls="controls" style="display:block;margin-left:auto;margin-right:auto;">\n');
fprintf(fid,'\t\t<source src="video_profil.ogg" type="video/ogg" />\n');
fprintf(fid,'\t</video>\n');