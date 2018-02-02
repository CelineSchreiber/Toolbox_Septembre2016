% =========================================================================
% REHAZENTER TOOLBOX
% =========================================================================
% File name:    computeBiomechanicalStatistics
% -------------------------------------------------------------------------
% Subject:      Compute mean, std, errors, correlations, anchoring index 
%               and intercorrelation functions
% -------------------------------------------------------------------------
% Inputs:       - Condition (structure)
% Outputs:      - Condition (structure)
% -------------------------------------------------------------------------
% Author: F. Moissenet, C. Schreiber, A. Naaim
% Date of creation: 26/03/2014
% Version: 1
% -------------------------------------------------------------------------
% Updates: - 16/09/2014: Introduction of postural statistics
%          - 16/12/2014: Test if parameters exist in the normative data
% =========================================================================

function Condition = computeBiomechanicalStatistics(Session,Condition)

% =========================================================================
% Gait parameters (MEAN, STD, TTEST)
% =========================================================================
if ~strcmp(Session.markersset,'Aucun') && ~strcmp(Session.markersset,'EMG')
    names = fieldnames(Condition.Gait(1).Gaitparameters);
    ngait = length(Condition.Gait);
    for i = 1:length(names)
        temp = [];
        for j = 1:ngait
            if ~isempty(Condition.Gait(j).Gaitparameters.right_stance_phase)
                temp = [temp eval(['Condition.Gait(',num2str(j),').Gaitparameters.',names{i},';'])];
            end
        end
        eval(['Condition.All.Gaitparameters.',names{i},'.mean = nanmean(temp,2);']);
        eval(['Condition.All.Gaitparameters.',names{i},'.std = nanstd(temp,1,2);']);
    end
    
    % =========================================================================
    % Right kinematics (MEAN, STD, RMSE, R2)
    % =========================================================================
    names = fieldnames(Condition.Gait(1).Rkinematics);
    ngait = length(Condition.Gait);
    for i = 1:length(names)
        temp = [];
        for j = 1:ngait
            temp = [temp eval(['Condition.Gait(',num2str(j),').Rkinematics.',names{i},';'])];
        end
        eval(['Condition.All.Rkinematics.',names{i},'.mean = nanmean(temp,2);']);
        eval(['Condition.All.Rkinematics.',names{i},'.std = nanstd(temp,1,2);']); 
        if ~isempty(eval(['Condition.All.Rkinematics.',names{i},'.mean']))
            if exist(['Normatives.Rkinematics.',names{i},'.mean;'])
                value = eval(['Condition.All.Rkinematics.',names{i},'.mean;']);
                norm = eval(['Normatives.Rkinematics.',names{i},'.mean;']);
                I = ~isnan(norm) & ~isnan(value);
                norm = norm(I); value = value(I);
                eval(['Condition.All.Rkinematics.',names{i},'.RMSE = sqrt(sum((norm(:)-value(:)).^2)/numel(norm));']);
                eval(['Condition.All.Rkinematics.',names{i},'.R2 = corr2(value,norm);']);
            else
                eval(['Condition.All.Rkinematics.',names{i},'.RMSE = [];']);
                eval(['Condition.All.Rkinematics.',names{i},'.R2 = [];']);
            end
        end
    end

    % =========================================================================
    % Left kinematics (MEAN, STD, RMSE, R2)
    % =========================================================================
    names = fieldnames(Condition.Gait(1).Lkinematics);
    ngait = length(Condition.Gait);
    for i = 1:length(names)
        temp = [];
        for j = 1:ngait
            temp = [temp eval(['Condition.Gait(',num2str(j),').Lkinematics.',names{i},';'])];
        end
        eval(['Condition.All.Lkinematics.',names{i},'.mean = nanmean(temp,2);']);
        eval(['Condition.All.Lkinematics.',names{i},'.std = nanstd(temp,1,2);']);    
        if ~isempty(eval(['Condition.All.Lkinematics.',names{i},'.mean']))
            if exist(['Normatives.Lkinematics.',names{i},'.mean;'])
                value = eval(['Condition.All.Lkinematics.',names{i},'.mean;']);
                norm = eval(['Normatives.Lkinematics.',names{i},'.mean;']);
                I = ~isnan(norm) & ~isnan(value);
                norm = norm(I); value = value(I);
                eval(['Condition.All.Lkinematics.',names{i},'.RMSE = sqrt(sum((norm(:)-value(:)).^2)/numel(norm));']);
                eval(['Condition.All.Lkinematics.',names{i},'.R2 = corr2(value,norm);']);
            else
                eval(['Condition.All.Lkinematics.',names{i},'.RMSE = [];']);
                eval(['Condition.All.Lkinematics.',names{i},'.R2 = [];']);
            end
        end
    end

end

if  ~strcmp(Session.markersset,'Paramètres') && ~strcmp(Session.markersset,'Aucun') && ~strcmp(Session.markersset,'EMG') 
    
    % =========================================================================
    % Right dynamics (MEAN, STD, RMSE, R2)
    % =========================================================================
    names = fieldnames(Condition.Gait(1).Rdynamics);
    ngait = length(Condition.Gait);
    for i = 1:length(names)
        temp = [];
        for j = 1:ngait
            if ~isempty(Condition.Gait(j).Rdynamics)
                temp = [temp eval(['Condition.Gait(',num2str(j),').Rdynamics.',names{i},';'])];
            end
        end
        eval(['Condition.All.Rdynamics.',names{i},'.mean = nanmean(temp,2);']);
        eval(['Condition.All.Rdynamics.',names{i},'.std = nanstd(temp,1,2);']);  
        if ~isempty(eval(['Condition.All.Rdynamics.',names{i},'.mean']))
            if exist(['Normatives.Rdynamics.',names{i},'.mean;'])
                value = eval(['Condition.All.Rdynamics.',names{i},'.mean;']);
                norm = eval(['Normatives.Rdynamics.',names{i},'.mean;']);
                I = ~isnan(norm) & ~isnan(value);
                norm = norm(I); value = value(I);
                eval(['Condition.All.Rdynamics.',names{i},'.RMSE = sqrt(sum((norm(:)-value(:)).^2)/numel(norm));']);
                eval(['Condition.All.Rdynamics.',names{i},'.R2 = corr2(value,norm);']);
            else
                eval(['Condition.All.Rdynamics.',names{i},'.RMSE = [];']);
                eval(['Condition.All.Rdynamics.',names{i},'.R2 = [];']);
            end
        end
    end

    % =========================================================================
    % Left dynamics (MEAN, STD, RMSE, R2)
    % =========================================================================
    names = fieldnames(Condition.Gait(1).Ldynamics);
    ngait = length(Condition.Gait);
    for i = 1:length(names)
        temp = [];
        for j = 1:ngait
            if ~isempty(Condition.Gait(j).Ldynamics)
                temp = [temp eval(['Condition.Gait(',num2str(j),').Ldynamics.',names{i},';'])];
            end
        end
        eval(['Condition.All.Ldynamics.',names{i},'.mean = nanmean(temp,2);']);
        eval(['Condition.All.Ldynamics.',names{i},'.std = nanstd(temp,1,2);']);  
        if ~isempty(eval(['Condition.All.Ldynamics.',names{i},'.mean']))
            if exist(['Normatives.Ldynamics.',names{i},'.mean;'])
                value = eval(['Condition.All.Ldynamics.',names{i},'.mean;']);
                norm = eval(['Normatives.Ldynamics.',names{i},'.mean;']);
                I = ~isnan(norm) & ~isnan(value);
                norm = norm(I); value = value(I);
                eval(['Condition.All.Ldynamics.',names{i},'.RMSE = sqrt(sum((norm(:)-value(:)).^2)/numel(norm));']);
                eval(['Condition.All.Ldynamics.',names{i},'.R2 = corr2(value,norm);']);
            else
                eval(['Condition.All.Ldynamics.',names{i},'.RMSE = [];']);
                eval(['Condition.All.Ldynamics.',names{i},'.R2 = [];']);
            end
        end
    end

    % =========================================================================
    % Right EMG (MEAN, STD)
    % =========================================================================
    names=[];
    for j = 1:ngait
        if ~isempty(Condition.Gait(j).Remg) && isempty(names)
            names = fieldnames(Condition.Gait(j).Remg);
        end
    end
    k=0;
    for j = 1:length(Session.Gait)
        if strcmp(Session.Gait(j).condition,Condition.name) & k==0
            k=j;
        end
    end
    if ~isempty(names)
        for i = 1:length(names)
            if strfind(names{i},'_cycle_filt')
                temp=[];
                for j=1:ngait
                    if strcmp(Session.Gait(k+j-1).emgtrial,'yes')
                        temp = [temp eval(['Condition.Gait(',num2str(j),').Remg.',names{i},'/max(Condition.Gait(',num2str(j),').Remg.',names{i},');'])];
                    end
                end
                eval(['Condition.All.Remg.',names{i},'.mean = nanmean(temp,2);']);
                eval(['Condition.All.Remg.',names{i},'.std = nanstd(temp,1,2);']);
            end
        end
    else
        Condition.All.Remg.mean = [];
        Condition.All.Remg.std = [];
    end


    % =========================================================================
    % Left EMG (MEAN, STD)
    % =========================================================================
    names=[];
    for j = 1:ngait
        if ~isempty(Condition.Gait(j).Lemg) && isempty(names)
            names = fieldnames(Condition.Gait(j).Lemg);
        end
    end

    if ~isempty(names)
        for i = 1:length(names)
            if strfind(names{i},'_cycle_filt')
                temp=[];
                for j=1:ngait
                    if strcmp(Session.Gait(k+j-1).emgtrial,'yes')
                        temp = [temp eval(['Condition.Gait(',num2str(j),').Lemg.',names{i},'/max(Condition.Gait(',num2str(j),').Lemg.',names{i},');'])];
                    end
                end
                eval(['Condition.All.Lemg.',names{i},'.mean = nanmean(temp,2);']);
                eval(['Condition.All.Lemg.',names{i},'.std = nanstd(temp,1,2);']);
            end
        end
    else
        Condition.All.Lemg.mean = [];
        Condition.All.Lemg.std = [];
    end

    % =========================================================================
    % Cycle events (MEAN, STD, TTEST)
    % =========================================================================
    % Right cycle events
    names = fieldnames(Condition.Gait(1).Revents);
    ngait = length(Condition.Gait);
    for i = 2:length(names)-1
        temp = [];
        for j = 1:ngait
            if ~isempty(Condition.Gait(j).Revents)
                temp = [temp eval(['Condition.Gait(',num2str(j),').Revents.',names{i},';'])];
            end
        end
        eval(['Condition.All.Revents.',names{i},'.mean = nanmean(temp,2);']);
        eval(['Condition.All.Revents.',names{i},'.std = nanstd(temp,1,2);']);
    end
    % Left cycle events
    names = fieldnames(Condition.Gait(1).Levents);
    ngait = length(Condition.Gait);
    for i = 2:length(names)-1
        temp = [];
        for j = 1:ngait
            if ~isempty(Condition.Gait(j).Levents)
                temp = [temp eval(['Condition.Gait(',num2str(j),').Levents.',names{i},';'])];
            end
        end
        eval(['Condition.All.Levents.',names{i},'.mean = nanmean(temp,2);']);
        eval(['Condition.All.Levents.',names{i},'.std = nanstd(temp,1,2);']);
    end
    % Right cycle phases
    names = fieldnames(Condition.Gait(1).Rphases);
    ngait = length(Condition.Gait);
    for i = 1:length(names)
        temp = [];
        for j = 1:ngait
            if ~isempty(Condition.Gait(j).Rphases)
                temp = [temp eval(['Condition.Gait(',num2str(j),').Rphases.',names{i},';'])];
            end
        end
        eval(['Condition.All.Rphases.',names{i},'.mean = nanmean(temp,2);']);
        eval(['Condition.All.Rphases.',names{i},'.std = nanstd(temp,1,2);']);
    end
    % Left cycle phases
    names = fieldnames(Condition.Gait(1).Lphases);
    ngait = length(Condition.Gait);
    for i = 1:length(names)
        temp = [];
        for j = 1:ngait
            if ~isempty(Condition.Gait(j).Lphases)
                temp = [temp eval(['Condition.Gait(',num2str(j),').Lphases.',names{i},';'])];
            end
        end
        eval(['Condition.All.Lphases.',names{i},'.mean = nanmean(temp,2);']);
        eval(['Condition.All.Lphases.',names{i},'.std = nanstd(temp,1,2);']);
    end

    % =========================================================================
    % Indexes (MEAN, STD, TTEST)
    % =========================================================================
    names1 = fieldnames(Condition.Gait(1).Index);
    ngait = length(Condition.Gait);
    for k=1:length(names1)
        eval(['names=fieldnames(Condition.Gait(1).Index.',names1{k},');']);
        for i = 1:length(names)
            temp = [];
            for j = 1:ngait
                if ~isempty(eval(['Condition.Gait(j).Index.',names1{k},'.',names{i}]))
                    temp = [temp eval(['Condition.Gait(',num2str(j),').Index.',names1{k},'.',names{i}])];
                end
            end
            eval(['Condition.All.Index.',names1{k},'.',names{i},'.mean = nanmean(temp,2);']);
            eval(['Condition.All.Index.',names1{k},'.',names{i},'.std = nanstd(temp,1,2);']);
        end
    end

    % =========================================================================
    % Abnormalities (MEAN, STD, TTEST)
    % =========================================================================
    if isfield(Condition.Gait(1),'Abnormalities')
        names = fieldnames(Condition.Gait(1).Abnormalities);
        ngait = length(Condition.Gait);
        for i = 1:length(names)
            temp = [];
            for j = 1:ngait
                if ~isempty(Condition.Gait(j).Abnormalities)
                    temp = [temp eval(['Condition.Gait(',num2str(j),').Abnormalities.',names{i},'.index;'])];
                end
            end
        end
        eval(['Condition.All.Abnormalities.',names{i},'.mean = nanmean(temp,2);']);
        eval(['Condition.All.Abnormalities.',names{i},'.std = nanstd(temp,1,2);']);
    end

    % =========================================================================
    % Right cycle postural angles (MEAN, STD, RMSE, R2)
    % =========================================================================
    if isfield(Condition.Gait(1),'Rposturalangle')
        names = fieldnames(Condition.Gait(1).Rposturalangle);
        ngait = length(Condition.Gait);
        for i = 1:length(names)
            temp = [];
            for j = 1:ngait                    
                temp = [temp eval(['Condition.Gait(',num2str(j),').Rposturalangle.',names{i},';'])];               
            end
            eval(['Condition.All.Rposturalangle.',names{i},'.mean = nanmean(temp,2);']);
            eval(['Condition.All.Rposturalangle.',names{i},'.std = nanstd(temp,1,2);']);
        end
        if ~isempty(eval(['Condition.All.Rposturalangle.',names{i},'.mean']))
            if exist(['Normatives.Rposturalangle.',names{i},'.mean;'])
                value = eval(['Condition.All.Rposturalangle.',names{i},'.mean;']);
                norm = eval(['Normatives.Rposturalangle.',names{i},'.mean;']);
                I = ~isnan(norm) & ~isnan(value);
                norm = norm(I); value = value(I);
                eval(['Condition.All.Rposturalangle.',names{i},'.RMSE = sqrt(sum((norm(:)-value(:)).^2)/numel(norm));']);
                eval(['Condition.All.Rposturalangle.',names{i},'.R2 = corr2(value,norm);']);
            else
                eval(['Condition.All.Rposturalangle.',names{i},'.RMSE = [];']);
                eval(['Condition.All.Rposturalangle.',names{i},'.R2 = [];']);
            end
        end
    end

    % =========================================================================
    % Left cycle postural angles (MEAN, STD, RMSE, R2)
    % =========================================================================
    if isfield(Condition.Gait(1),'Lposturalangle')
        names = fieldnames(Condition.Gait(1).Lposturalangle);
        ngait = length(Condition.Gait);
        for i = 1:length(names)
            temp = [];
            for j = 1:ngait                    
                temp = [temp eval(['Condition.Gait(',num2str(j),').Lposturalangle.',names{i},';'])];               
            end
            eval(['Condition.All.Lposturalangle.',names{i},'.mean = nanmean(temp,2);']);
            eval(['Condition.All.Lposturalangle.',names{i},'.std = nanstd(temp,1,2);']);
        end
        if ~isempty(eval(['Condition.All.Lposturalangle.',names{i},'.mean']))
            if exist(['Normatives.Lposturalangle.',names{i},'.mean;'])
                value = eval(['Condition.All.Lposturalangle.',names{i},'.mean;']);
                norm = eval(['Normatives.Lposturalangle.',names{i},'.mean;']);
                I = ~isnan(norm) & ~isnan(value);
                norm = norm(I); value = value(I);
                eval(['Condition.All.Lposturalangle.',names{i},'.RMSE = sqrt(sum((norm(:)-value(:)).^2)/numel(norm));']);
                eval(['Condition.All.Lposturalangle.',names{i},'.R2 = corr2(value,norm);']);
            else
                eval(['Condition.All.Lposturalangle.',names{i},'.RMSE = [];']);
                eval(['Condition.All.Lposturalangle.',names{i},'.R2 = [];']);
            end
        end
    end

% %     % =========================================================================
% %     % Right cycle anchoring index and intercorrelation functions
% %     % (MEAN, STD, TTEST)
% %     % =========================================================================
% %     if isfield(Condition.Gait(1).Rposturalindex,'Std') 
% %         if ~isempty(Condition.Gait(1).Rposturalindex.Std)
% %             names = fieldnames(Condition.Gait(1).Rposturalindex.Std);
% %             ngait = length(Condition.Gait);
% %             for i = 1:length(names)
% %                 temp = [];
% %                 for j = 1:ngait
% %                     if ~isempty(Condition.Gait(j).Rposturalindex.Std)
% %                         if isfield(Condition.Gait(j).Rposturalindex.Std,char(names{i}))
% %                             %&& ~isempty(Condition.Gait(j).Rposturalindex.Aindexgr,char(names{i}))
% %                             temp = [temp eval(['Condition.Gait(',num2str(j),').Rposturalindex.Std.',names{i},';'])];
% %                         end
% %                     end
% %                 end
% %                 eval(['Condition.All.Rposturalindex.Std.',names{i},'.mean = nanmean(temp,2);']);
% %                 eval(['Condition.All.Rposturalindex.Std.',names{i},'.std = nanstd(temp,1,2);']);
% %             end
% %         end
% %     end
% %     if isfield(Condition.Gait(1).Rposturalindex,'Aindex')
% %         names = fieldnames(Condition.Gait(1).Rposturalindex.Aindex);
% %         ngait = length(Condition.Gait);
% %         for i = 1:length(names)
% %             temp = [];
% %             tempZ = [];
% %             for j = 1:ngait
% %                 if ~isempty(Condition.Gait(j).Rposturalindex.Aindex)
% %                     if isfield(Condition.Gait(j).Rposturalindex.Aindex,char(names{i}))
% %                         %&& ~isempty(Condition.Gait(j).Rposturalindex.Aindexgr,char(names{i}))
% %                         temp = [temp eval(['Condition.Gait(',num2str(j),').Rposturalindex.Aindex.',names{i},';'])];
% %                         tempZ = [tempZ log((1+temp)/(1-temp))/2];
% %                     end
% %                 end
% %             end
% %             eval(['Condition.All.Rposturalindex.Aindex.',names{i},'.mean = nanmean(temp,2);']);
% %             eval(['Condition.All.Rposturalindex.Aindex.',names{i},'.std = nanstd(temp,1,2);']);
% %             eval(['[Condition.All.Rposturalindex.Aindex.',names{i},...
% %                 '.h,Condition.All.Rposturalindex.Aindex.',names{i},'.pvalue] = ttest(tempZ);']);
% %         end
% %     end
% %     if isfield(Condition.Gait(1).Rposturalindex,'Ifunction')
% %         names = fieldnames(Condition.Gait(1).Rposturalindex.Ifunction);
% %         ngait = length(Condition.Gait);
% %         for i = 1:length(names)
% %             temp = [];
% %             tempZ = [];
% %             for j = 1:ngait
% %                 if ~isempty(Condition.Gait(j).Rposturalindex.Ifunction)
% %                     if isfield(Condition.Gait(j).Rposturalindex.Ifunction,char(names{i}))
% %                         temp = [temp eval(['Condition.Gait(',num2str(j),').Rposturalindex.Ifunction.',names{i},';'])];
% %                     end
% %                 end
% %             end
% %             eval(['Condition.All.Rposturalindex.Ifunction.',names{i},'.mean = nanmean(temp,2);']);
% %             eval(['Condition.All.Rposturalindex.Ifunction.',names{i},'.std = nanstd(temp,1,2);']);        
% %             eval(['[Y,I] = max(Condition.All.Rposturalindex.Ifunction.',names{i},'.mean);']);
% %             eval(['Condition.All.Rposturalindex.Ifunction.',names{i},'.max = Y;']);
% %             eval(['Condition.All.Rposturalindex.Ifunction.',names{i},'.ind = I;']);
% %             for j = 1:size(temp,2)
% %                 tempZ = [tempZ log((1+temp(I,j))/(1-temp(I,j)))/2];
% %             end
% %             eval(['[Condition.All.Rposturalindex.Ifunction.',names{i},...
% %                 '.h,Condition.All.Rposturalindex.Ifunction.',names{i},'.pvalue] = ttest(tempZ);']);
% % 
% %         end
% %     end
% %     if isfield(Condition.Gait(1).Rposturalindex,'Idephasing')
% %         names = fieldnames(Condition.Gait(1).Rposturalindex.Idephasing);
% %         ngait = length(Condition.Gait);
% %         for i = 1:length(names)
% %             temp = [];
% %             for j = 1:ngait
% %                 if ~isempty(Condition.Gait(j).Rposturalindex.Idephasing)
% %                     if isfield(Condition.Gait(j).Rposturalindex.Idephasing,char(names{i}))
% %                         temp = [temp eval(['Condition.Gait(',num2str(j),').Rposturalindex.Idephasing.',names{i},';'])];
% %                     end
% %                 end
% %             end
% %             eval(['Condition.All.Rposturalindex.Idephasing.',names{i},'.mean = nanmean(temp,2);']);
% %             eval(['Condition.All.Rposturalindex.Idephasing.',names{i},'.std = nanstd(temp,1,2);']);
% %         end
% %     end
% % 
% %     % =========================================================================
% %     % Left cycle anchoring index and intercorrelation functions
% %     % (MEAN, STD, TTEST)
% %     % =========================================================================
% %     if isfield(Condition.Gait(1).Lposturalindex,'Std')
% %         if ~isempty(Condition.Gait(1).Lposturalindex.Std)
% %             names = fieldnames(Condition.Gait(1).Lposturalindex.Std);
% %             ngait = length(Condition.Gait);
% %             for i = 1:length(names)
% %                 temp = [];
% %                 for j = 1:ngait
% %                     if ~isempty(Condition.Gait(j).Lposturalindex.Std)
% %                         if isfield(Condition.Gait(j).Lposturalindex.Std,char(names{i}))
% %                             %&& ~isempty(Condition.Gait(j).Lposturalindex.Aindexgr,char(names{i}))
% %                             temp = [temp eval(['Condition.Gait(',num2str(j),').Lposturalindex.Std.',names{i},';'])];
% %                         end
% %                     end
% %                 end
% %                 eval(['Condition.All.Lposturalindex.Std.',names{i},'.mean = nanmean(temp,2);']);
% %                 eval(['Condition.All.Lposturalindex.Std.',names{i},'.std = nanstd(temp,1,2);']);
% %             end
% %         end
% %     end
% %     if isfield(Condition.Gait(1).Lposturalindex,'Aindex')
% %         names = fieldnames(Condition.Gait(1).Lposturalindex.Aindex);
% %         ngait = length(Condition.Gait);
% %         for i = 1:length(names)
% %             temp = [];
% %             tempZ = [];
% %             for j = 1:ngait
% %                 if ~isempty(Condition.Gait(j).Lposturalindex.Aindex)
% %                     if isfield(Condition.Gait(j).Lposturalindex.Aindex,char(names{i}))
% %                         %&& ~isempty(Condition.Gait(j).Lposturalindex.Aindexgr,char(names{i}))
% %                         temp = [temp eval(['Condition.Gait(',num2str(j),').Lposturalindex.Aindex.',names{i},';'])];
% %                         tempZ = [tempZ log((1+temp)/(1-temp))/2];
% %                     end
% %                 end
% %             end
% %             eval(['Condition.All.Lposturalindex.Aindex.',names{i},'.mean = nanmean(temp,2);']);
% %             eval(['Condition.All.Lposturalindex.Aindex.',names{i},'.std = nanstd(temp,1,2);']);
% %             eval(['[Condition.All.Lposturalindex.Aindex.',names{i},...
% %                 '.h,Condition.All.Lposturalindex.Aindex.',names{i},'.pvalue] = ttest(tempZ);']);
% %         end
% %     end
% %     if isfield(Condition.Gait(1).Lposturalindex,'Ifunction')
% %         names = fieldnames(Condition.Gait(1).Lposturalindex.Ifunction);
% %         ngait = length(Condition.Gait);
% %         for i = 1:length(names)
% %             temp = [];
% %             tempZ = [];
% %             for j = 1:ngait
% %                 if ~isempty(Condition.Gait(j).Lposturalindex.Ifunction)
% %                     if isfield(Condition.Gait(j).Lposturalindex.Ifunction,char(names{i}))
% %                         temp = [temp eval(['Condition.Gait(',num2str(j),').Lposturalindex.Ifunction.',names{i},';'])];
% %                     end
% %                 end
% %             end
% %             eval(['Condition.All.Lposturalindex.Ifunction.',names{i},'.mean = nanmean(temp,2);']);
% %             eval(['Condition.All.Lposturalindex.Ifunction.',names{i},'.std = nanstd(temp,1,2);']);        
% %             eval(['[Y,I] = max(Condition.All.Lposturalindex.Ifunction.',names{i},'.mean);']);
% %             eval(['Condition.All.Lposturalindex.Ifunction.',names{i},'.max = Y;']);
% %             eval(['Condition.All.Lposturalindex.Ifunction.',names{i},'.ind = I;']);
% %             for j = 1:size(temp,2)
% %                 tempZ = [tempZ log((1+temp(I,j))/(1-temp(I,j)))/2];
% %             end
% %             eval(['[Condition.All.Lposturalindex.Ifunction.',names{i},...
% %                 '.h,Condition.All.Lposturalindex.Ifunction.',names{i},'.pvalue] = ttest(tempZ);']);
% % 
% %         end
% %     end
% %     if isfield(Condition.Gait(1).Lposturalindex,'Idephasing')
% %         names = fieldnames(Condition.Gait(1).Lposturalindex.Idephasing);
% %         ngait = length(Condition.Gait);
% %         for i = 1:length(names)
% %             temp = [];
% %             for j = 1:ngait
% %                 if ~isempty(Condition.Gait(j).Lposturalindex.Idephasing)
% %                     if isfield(Condition.Gait(j).Lposturalindex.Idephasing,char(names{i}))
% %                         temp = [temp eval(['Condition.Gait(',num2str(j),').Lposturalindex.Idephasing.',names{i},';'])];
% %                     end
% %                 end
% %             end
% %             eval(['Condition.All.Lposturalindex.Idephasing.',names{i},'.mean = nanmean(temp,2);']);
% %             eval(['Condition.All.Lposturalindex.Idephasing.',names{i},'.std = nanstd(temp,1,2);']);
% %         end
% %     end
end

names = fieldnames(Session);
finder = 0;
for i = 1:length(names)
    if strcmp(names{i},'footmarkersset')
        finder = 1;
    end
end
% % if finder == 1
% %     if ~strcmp(Session.footmarkersset,'Aucun')
% %         % =========================================================================
% %         % Left FOOT kinematics (MEAN, STD, RMSE, R2)
% %         % =========================================================================
% %         if isfield(Condition.Foot(1),'Lkinematics')
% %             names = fieldnames(Condition.Foot(1).Lkinematics);
% %             ngait = length(Condition.Foot);
% %             for i = 1:length(names)
% %                 temp = [];
% %                 for j = 1:ngait
% %                     temp = [temp eval(['Condition.Foot(',num2str(j),').Lkinematics.',names{i},';'])];
% %                 end
% %                 eval(['Condition.All.LkinematicsFoot.',names{i},'.mean = nanmean(temp,2);']);
% %                 eval(['Condition.All.LkinematicsFoot.',names{i},'.std = nanstd(temp,1,2);']);    
% %                 if ~isempty(eval(['Condition.All.LkinematicsFoot.',names{i},'.mean']))
% %                     if exist(['Normatives.LkinematicsFoot.',names{i},'.mean;'])
% %                         value = eval(['Condition.All.LkinematicsFoot.',names{i},'.mean;']);
% %                         norm = eval(['Normatives.LkinematicsFoot.',names{i},'.mean;']);
% %                         I = ~isnan(norm) & ~isnan(value);
% %                         norm = norm(I); value = value(I);
% %                         eval(['Condition.All.LkinematicsFoot.',names{i},'.RMSE = sqrt(sum((norm(:)-value(:)).^2)/numel(norm));']);
% %                         eval(['Condition.All.LkinematicsFoot.',names{i},'.R2 = corr2(value,norm);']);
% %                     else
% %                         eval(['Condition.All.LkinematicsFoot.',names{i},'.RMSE = [];']);
% %                         eval(['Condition.All.LkinematicsFoot.',names{i},'.R2 = [];']);
% %                     end
% %                 end
% %             end
% %         end
% % 
% %         % =========================================================================
% %         % Right FOOT kinematics (MEAN, STD, RMSE, R2)
% %         % =========================================================================
% %         if isfield(Condition.Foot(1),'Rkinematics')
% %             names = fieldnames(Condition.Foot(1).Rkinematics);
% %             ngait = length(Condition.Foot);
% %             for i = 1:length(names)
% %                 temp = [];
% %                 for j = 1:ngait
% %                     temp = [temp eval(['Condition.Foot(',num2str(j),').Rkinematics.',names{i},';'])];
% %                 end
% %                 eval(['Condition.All.RkinematicsFoot.',names{i},'.mean = nanmean(temp,2);']);
% %                 eval(['Condition.All.RkinematicsFoot.',names{i},'.std = nanstd(temp,1,2);']);    
% %                 if ~isempty(eval(['Condition.All.RkinematicsFoot.',names{i},'.mean']))
% %                     if exist(['Normatives.RkinematicsFoot.',names{i},'.mean;'])
% %                         value = eval(['Condition.All.RkinematicsFoot.',names{i},'.mean;']);
% %                         norm = eval(['Normatives.RkinematicsFoot.',names{i},'.mean;']);
% %                         I = ~isnan(norm) & ~isnan(value);
% %                         norm = norm(I); value = value(I);
% %                         eval(['Condition.All.RkinematicsFoot.',names{i},'.RMSE = sqrt(sum((norm(:)-value(:)).^2)/numel(norm));']);
% %                         eval(['Condition.All.RkinematicsFoot.',names{i},'.R2 = corr2(value,norm);']);
% %                     else
% %                         eval(['Condition.All.RkinematicsFoot.',names{i},'.RMSE = [];']);
% %                         eval(['Condition.All.RkinematicsFoot.',names{i},'.R2 = [];']);
% %                     end
% %                 end
% %             end
% %         end
% % 
% %     end
% % end

names = fieldnames(Session);
finder = 0;
for i = 1:length(names)
    if strcmp(names{i},'upperlimbsmarkersset')
        finder = 1;
    end
end
% if finder == 1
%     if strcmp(Session.upperlimbsmarkersset,'Oui')
%         % =========================================================================
%         % Left UPPER LIMBS kinematics (MEAN, STD, RMSE, R2)
%         % =========================================================================
%         if isfield(Condition.UpperLimbs(1),'Lkinematics')
%             names = fieldnames(Condition.UpperLimbs(1).Lkinematics);
%             ngait = length(Condition.UpperLimbs);
%             for i = 1:length(names)
%                 temp = [];
%                 for j = 1:ngait
%                     temp = [temp eval(['Condition.UpperLimbs(',num2str(j),').Lkinematics.',names{i},';'])];
%                 end
%                 eval(['Condition.All.LkinematicsUL.',names{i},'.mean = nanmean(temp,2);']);
%                 eval(['Condition.All.LkinematicsUL.',names{i},'.std = nanstd(temp,1,2);']);    
%                 if ~isempty(eval(['Condition.All.LkinematicsUL.',names{i},'.mean']))
% %                     if exist(['Normatives.Lkinematics.',names{i},'.mean;'])
% %                         value = eval(['Condition.All.LkinematicsUL.',names{i},'.mean;']);
% %                         norm = eval(['Normatives.LkinematicsUL.',names{i},'.mean;']);
% %                         I = ~isnan(norm) & ~isnan(value);
% %                         norm = norm(I); value = value(I);
% %                         eval(['Condition.All.LkinematicsUL.',names{i},'.RMSE = sqrt(sum((norm(:)-value(:)).^2)/numel(norm));']);
% %                         eval(['Condition.All.LkinematicsUL.',names{i},'.R2 = corr2(value,norm);']);
% %                     else
% %                         eval(['Condition.All.LkinematicsUL.',names{i},'.RMSE = [];']);
% %                         eval(['Condition.All.LkinematicsUL.',names{i},'.R2 = [];']);
% %                     end
%                 end
%             end
%         end
% 
%         % =========================================================================
%         % Right UPPER LIMBS kinematics (MEAN, STD, RMSE, R2)
%         % =========================================================================
%         if isfield(Condition.UpperLimbs(1),'Rkinematics')
%             names = fieldnames(Condition.UpperLimbs(1).Rkinematics);
%             ngait = length(Condition.UpperLimbs);
%             for i = 1:length(names)
%                 temp = [];
%                 for j = 1:ngait
%                     temp = [temp eval(['Condition.UpperLimbs(',num2str(j),').Rkinematics.',names{i},';'])];
%                 end
%                 eval(['Condition.All.RkinematicsUL.',names{i},'.mean = nanmean(temp,2);']);
%                 eval(['Condition.All.RkinematicsUL.',names{i},'.std = nanstd(temp,1,2);']);    
%                 if ~isempty(eval(['Condition.All.RkinematicsUL.',names{i},'.mean']))
% %                     if exist(['Normatives.RkinematicsUL.',names{i},'.mean;'])
% %                         value = eval(['Condition.All.RkinematicsUL.',names{i},'.mean;']);
% %                         norm = eval(['Normatives.RkinematicsUL.',names{i},'.mean;']);
% %                         I = ~isnan(norm) & ~isnan(value);
% %                         norm = norm(I); value = value(I);
% %                         eval(['Condition.All.RkinematicsUL.',names{i},'.RMSE = sqrt(sum((norm(:)-value(:)).^2)/numel(norm));']);
% %                         eval(['Condition.All.RkinematicsUL.',names{i},'.R2 = corr2(value,norm);']);
% %                     else
% %                         eval(['Condition.All.RkinematicsUL.',names{i},'.RMSE = [];']);
% %                         eval(['Condition.All.RkinematicsUL.',names{i},'.R2 = [];']);
% %                     end
%                 end
%             end
%         end
% 
%     end
% end