clear
toolboxFolder = 'C:\Users\celine.schreiber\Documents\MATLAB\Toolbox_Septembre2016';
saveFolder = 'C:\Users\celine.schreiber\Documents\MATLAB\Toolbox_Rehazenter_Normatives\normativeData\DataSet';
    
cd(toolboxFolder);
addpath(pwd);
addpath([pwd,'\toolbox\btk']);
addpath('C:\Program Files\MATLAB\R2011b\toolbox\btk');
addpath(pwd);
addpath([pwd,'\toolbox']);
addpath([pwd,'\toolbox\xlsread1']);

P={'SS2014001','SS2014002','SS2014003','SS2014004','SS2014005','SS2014006',...
'SS2014007','SS2014008','SS2014009','SS2014011','SS2014013','SS2014014',...
'SS2014015','SS2014019','SS2014022','SS2014024','SS2014025','SS2014026',...
'SS2014029','SS2014030','SS2014031','SS2014032','SS2014033','SS2014034',...
'SS2014040','SS2014046','SS2014048','SS2014049','SS2014050','SS2014051',...
'SS2014052','SS2014053','SS2014054','SS2015002','SS2015003',...%'SS2015001',
'SS2015004','SS2015005','SS2015007','SS2015013','SS2015015','SS2015016',...
'SS2015017','SS2015020','SS2015021','SS2015026','SS2015027','SS2015030',...
'SS2015032','SS2015034','SS2015035','SS2015037','SS2015041','SS2015042',...
'SS2015043'}; 

for p=1:length(P)
    Patient=[];Session=[];
    c3dFolder=['C:\Users\celine.schreiber\Documents\MATLAB\Toolbox_Rehazenter_Normatives\normativeData\',char(P(p))];
    [Patient,~,~,~,Session] = sessionInformation(c3dFolder);    
    Count.C1=0;Count.C2=0;Count.C3=0;Count.C4=0;Count.C5=0;
    
    for i=1:length(Session.Gait)
        if strcmp(Session.Gait(i).condition,'piste - vitesse max 0.4ms')
            cond = 'C1';
            Count.C1 = Count.C1+1;
            Newfilename = [Patient.lastname,'_',cond,'_0',int2str(Count.C1),'_raw.c3d'];
        elseif strcmp(Session.Gait(i).condition,'piste - vitesse entre 0.4 et 0.8ms')
            cond = 'C2';
            Count.C2 = Count.C2+1;
            Newfilename = [Patient.lastname,'_',cond,'_0',int2str(Count.C2),'_raw.c3d'];
        elseif strcmp(Session.Gait(i).condition,'piste - vitesse entre 0.8 et 1.2ms')
            cond = 'C3';
            Count.C3 = Count.C3+1;
            Newfilename = [Patient.lastname,'_',cond,'_0',int2str(Count.C3),'_raw.c3d'];
        elseif strcmp(Session.Gait(i).condition,'piste - vitesse spontanee')
            cond = 'C4';
            Count.C4 = Count.C4+1;
            Newfilename = [Patient.lastname,'_',cond,'_0',int2str(Count.C4),'_raw.c3d'];
        elseif strcmp(Session.Gait(i).condition,'piste - vitesse rapide')
            cond = 'C5';
            Count.C5 = Count.C5+1;
            Newfilename = [Patient.lastname,'_',cond,'_0',int2str(Count.C5),'_raw.c3d'];
        else
            tapis=1;
        end
        
        cd(c3dFolder)
        h = btkReadAcquisition(Session.Gait(i).filename);

        [markers, markersInfo, markersResidual] = btkGetMarkers(h);
        if isfield(markers,'R_SAE')
            btkSetPointLabel(h,'R_SAE','R_SAJ'); 
        end
        if isfield(markers,'L_SAE')
            btkSetPointLabel(h,'L_SAE','L_SAJ'); 
        end

        cd(saveFolder);
        btkWriteAcquisition(h,Newfilename);
        
    end
    
    % Static file
    cd(c3dFolder)
    h = btkReadAcquisition(Session.Static.filename);
    
    age=datevec(Session.date,'yyyy-mm-dd')-datevec(Patient.birthdate,'yyyy-mm-dd');
    if age(3)<0
        age(2)=age(2)-1;
    end
    if age(2)<0
        age(1)=age(1)-1;
    end
    btkAppendAnalysisParameter(h,'Age','General','années',age(1)); 
    gender=0;
    if strcmp(Patient.gender,'Homme')
        gender=2;
    elseif strcmp(Patient.gender,'Femme')
        gender=1;
    end
    btkAppendAnalysisParameter(h,'Sexe','General','adim',gender);
    btkAppendAnalysisParameter(h,'Height','General','m',Session.height);
    btkAppendAnalysisParameter(h,'Weight','General','Kg',Session.weight);
    [markers, markersInfo, markersResidual] = btkGetMarkers(h);
    if isfield(markers,'R_SAE')
        btkSetPointLabel(h,'R_SAE','R_SAJ'); 
    end
    if isfield(markers,'L_SAE')
        btkSetPointLabel(h,'L_SAE','L_SAJ'); 
    end

    cd(saveFolder);
    btkWriteAcquisition(h,[Patient.lastname,'_static_raw.c3d']);
end