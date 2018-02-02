clear
cd ('Y:\_Rehazenter_Toolbox');
P={'Patient32'};

% P={'Patient01','Patient02','Patient03','Patient04','Patient05',...
% 'Patient06','Patient07','Patient08','Patient09','Patient10',...
% 'Patient11','Patient12','Patient13','Patient14','Patient15',...
% 'Patient16','Patient17','Patient18','Patient19','Patient20',...
% 'Patient21','Patient22','Patient24','Patient26','Patient27',...
% 'Patient32'}; 

for p=1:length(P)
        eval(['filesfolder=''P:\My Documents\data\',char(P(p)),''';']);
%         disp(['  > ','Patient ',char(P(p))]); 
        MainRehazenterToolbox(filesfolder,0);
end

% BDD spontane/metronome
% P={'SS2014005','SS2014007','SS2014009','SS2014014','SS2014030',... %30?
% 'SS2014040','SS2014049','SS2014053','SS2015005',...
% 'SS2015015','SS2015016','SS2015017','SS2015020','SS2015021','SS2015022'}; 
% si 10% de la vitesse: 'SS2014019','SS2014034','SS2014052','SS2015002'