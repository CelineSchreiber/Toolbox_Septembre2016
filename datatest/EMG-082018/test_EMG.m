clearvars 
toolboxFolder = 'C:\Users\celine.schreiber\Documents\MATLAB\Toolbox_Septembre2016';
cd(toolboxFolder);
addpath(pwd);
addpath([pwd,'\plugin\clinicalReport']);
addpath([pwd,'\plugin\statistics']);
addpath([pwd,'\plugin\Foot']);
addpath([pwd,'\plugin\Posturo']);
addpath([pwd,'\toolbox\btk']);
addpath([pwd,'\toolbox\Toolbox_M_Inverse_Dynamics']);

% Launch main toolbox
c3dFolder = 'C:\Users\celine.schreiber\Documents\MATLAB\Toolbox_Septembre2016\datatest\EMG-082018';
cd(c3dFolder);

filename='test01.c3d';
file = btkReadAcquisition(filename);
fanalog = btkGetAnalogFrequency(file);
[Emg,Info.emg] = btkGetAnalogs(file);
names = fieldnames(Emg);  
i=13;
% temp = permute(Emg.(names{i}),[3,1,2]);
temp=Emg.(names{i});
temp0 = temp-mean(temp);
[B,A] = butter(2,[30/(fanalog/2) 300/(fanalog/2)],'bandpass');
temp1 = filtfilt(B,A,temp0);
figure; hold on;
subplot(4,1,1);plot(temp1)
      
filename='test02.c3d';
file = btkReadAcquisition(filename);
fanalog = btkGetAnalogFrequency(file);
[Emg,Info.emg] = btkGetAnalogs(file);
names = fieldnames(Emg);  
i=11;
% temp = permute(Emg.(names{i}),[3,1,2]);
temp=Emg.(names{i});
temp0 = temp-mean(temp);
[B,A] = butter(2,[30/(fanalog/2) 300/(fanalog/2)],'bandpass');
temp1 = filtfilt(B,A,temp0);
subplot(4,1,2);plot(temp1)

filename='test03.c3d';
file = btkReadAcquisition(filename);
fanalog = btkGetAnalogFrequency(file);
[Emg,Info.emg] = btkGetAnalogs(file);
names = fieldnames(Emg);  
i=11;
% temp = permute(Emg.(names{i}),[3,1,2]);
temp=Emg.(names{i});
temp0 = temp-mean(temp);
[B,A] = butter(2,[30/(fanalog/2) 300/(fanalog/2)],'bandpass');
temp1 = filtfilt(B,A,temp0);
subplot(4,1,3);plot(temp1)

filename='test04.c3d';
file = btkReadAcquisition(filename);
fanalog = btkGetAnalogFrequency(file);
[Emg,Info.emg] = btkGetAnalogs(file);
names = fieldnames(Emg);  
i=13;
% temp = permute(Emg.(names{i}),[3,1,2]);
temp=Emg.(names{i});
temp0 = temp-mean(temp);
[B,A] = butter(2,[30/(fanalog/2) 300/(fanalog/2)],'bandpass');
temp1 = filtfilt(B,A,temp0);
subplot(4,1,4);plot(temp1)