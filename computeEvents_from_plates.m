function computeEvents_from_plates(Session,filesFolder)

for i=1:length(Session.Gait) 
    
    if Session.Gait(i).s(1)~=0 || Session.Gait(i).s(2)~=0
        e=btkGetEvents(Session.Gait(i).file);
        btkClearEvents(Session.Gait(i).file);
        Grf = btkGetGroundReactionWrenches(Session.Gait(i).file);
%         n0 = btkGetFirstFrame(Session.Gait(i).file);
%         n1 = btkGetLastFrame(Session.Gait(i).file)-n0+1;
        n2 = btkGetAnalogFrameNumber(Session.Gait(i).file);
%         Markers = btkGetPoints(Session.Gait(i).file);

        % Set kinematic data in the correct format
%         [~,minusX] = prepareCycleKinematicData(Markers,Session.Gait(i),n1,Session.fpoint,Session.system);
        % Set kinetic data in the correct format
        Grf = prepareCycleKineticData_Events(Grf,n2,Session.fanalog); 
        if Session.Gait(i).s(1)~=0
            ind=[];
            ind = find(Grf(Session.Gait(i).s(1)).F(:,2)~=0);
            if ~isempty(ind)
                events.RHS = ind(1)/Session.fanalog;
                btkAppendEvent(Session.Gait(i).file,'Foot_Strike',ind(1)/Session.fanalog,'Right');
                events.RTO = ind(end)/Session.fanalog;
                btkAppendEvent(Session.Gait(i).file,'Foot_Off',ind(end)/Session.fanalog,'Right');
            end
        end
        if Session.Gait(i).s(2)~=0
            ind=[];
            ind = find(Grf(Session.Gait(i).s(2)).F(:,2)~=0);
            if ~isempty(ind)
                events.LHS = ind(1)/Session.fanalog;
                btkAppendEvent(Session.Gait(i).file,'Foot_Strike',ind(1)/Session.fanalog,'Left');
                events.LTO = ind(end)/Session.fanalog;
                btkAppendEvent(Session.Gait(i).file,'Foot_Off',ind(end)/Session.fanalog,'Left');
            end
        end
        V=[];
        if strcmp(Session.Gait(i).condition,'piste - vitesse spontanee')
            V='V4';
            cd('C:\Users\celine.schreiber\Documents\MATLAB\Toolbox_Rehazenter_Normatives\Data\Detection events\Data\SS\V4');
        elseif strcmp(Session.Gait(i).condition,'piste - vitesse max 0.4ms')
            V='V1';
            cd('C:\Users\celine.schreiber\Documents\MATLAB\Toolbox_Rehazenter_Normatives\Data\Detection events\Data\SS\V1');
        elseif strcmp(Session.Gait(i).condition,'piste - vitesse entre 0.4 et 0.8ms')
            V='V2';
            cd('C:\Users\celine.schreiber\Documents\MATLAB\Toolbox_Rehazenter_Normatives\Data\Detection events\Data\SS\V2');
        elseif strcmp(Session.Gait(i).condition,'piste - vitesse entre 0.8 et 1.2ms')
            V='V3';
            cd('C:\Users\celine.schreiber\Documents\MATLAB\Toolbox_Rehazenter_Normatives\Data\Detection events\Data\SS\V3');
        elseif strcmp(Session.Gait(i).condition,'piste - vitesse rapide')
            V='V5';
            cd('C:\Users\celine.schreiber\Documents\MATLAB\Toolbox_Rehazenter_Normatives\Data\Detection events\Data\SS\V5');
        end
        if Session.Gait(i).s(1)~=0 && Session.Gait(i).s(2)~=0
            c3dfilename=[V filesFolder(end-6:end) 'B' Session.Gait(i).filename];
        elseif Session.Gait(i).s(1)~=0 && Session.Gait(i).s(2)==0 
            c3dfilename=[V filesFolder(end-6:end) 'R' Session.Gait(i).filename];
        elseif Session.Gait(i).s(2)~=0 && Session.Gait(i).s(1)==0 
            c3dfilename=[V filesFolder(end-6:end) 'L' Session.Gait(i).filename];
        end
        btkWriteAcquisition(Session.Gait(i).file,c3dfilename);
    end
 
end