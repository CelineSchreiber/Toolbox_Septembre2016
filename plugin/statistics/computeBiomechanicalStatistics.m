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

if isfield(Condition,'Gait')
   ngait = length(Condition.Gait);
end

if ~strcmp(Session.markersset,'Aucun')

    % =========================================================================
    % Gait parameters (MEAN, STD)
    % =========================================================================
    names = fieldnames(Condition.Gait(1).Gaitparameters);
    for i = 1:length(names)
        temp = [];
        for j = 1:ngait
            if ~isempty(Condition.Gait(j).Gaitparameters.right_stance_phase)
                temp = [temp Condition.Gait(j).Gaitparameters.(names{i})];
            end
        end
        Condition.All.Gaitparameters.(names{i}).data = temp;
        Condition.All.Gaitparameters.(names{i}).mean = nanmean(temp,2);
        Condition.All.Gaitparameters.(names{i}).std = nanstd(temp,1,2);
    end
       
    % =========================================================================
    % Right kinematics (MEAN, STD, RMSE, R2)
    % =========================================================================
    names = fieldnames(Condition.Gait(1).Rkinematics);
    for i = 1:length(names)
        temp = [];
        for j = 1:ngait
            if isfield(Condition.Gait(j).Rkinematics,(names{i}))
                temp = [temp Condition.Gait(j).Rkinematics.(names{i})];
            end
        end
        Condition.All.Rkinematics.(names{i}).data = temp;
        Condition.All.Rkinematics.(names{i}).mean = nanmean(temp,2);
        Condition.All.Rkinematics.(names{i}).std = nanstd(temp,1,2);
%         if ~isempty(Condition.All.Rkinematics.(names{i}).mean')
%             if exist(['Normatives.Rkinematics.',names{i},'.mean;'])
%                 value = Condition.All.Rkinematics.(names{i}).mean;
%                 norm = Normatives.Rkinematics.(names{i}).mean;
%                 I = ~isnan(norm) & ~isnan(value);
%                 norm = norm(I); value = value(I);
%                 Condition.All.Rkinematics.(names{i}).RMSE = sqrt(sum((norm(:)-value(:)).^2)/numel(norm));
%                 Condition.All.Rkinematics.(names{i}).R2 = corr2(value,norm);
%             else
%                 Condition.All.Rkinematics.(names{i}).RMSE = [];
%                 Condition.All.Rkinematics.(names{i}).R2 = [];
%             end
%         end
    end

    % =========================================================================
    % Left kinematics (MEAN, STD, RMSE, R2)
    % =========================================================================
    names = fieldnames(Condition.Gait(1).Lkinematics);
    for i = 1:length(names)
        temp = [];
        for j = 1:ngait
            if isfield(Condition.Gait(j).Lkinematics,(names{i}))
                temp = [temp Condition.Gait(j).Lkinematics.(names{i})];
            end
        end
        Condition.All.Lkinematics.(names{i}).data = temp;
        Condition.All.Lkinematics.(names{i}).mean = nanmean(temp,2);
        Condition.All.Lkinematics.(names{i}).std = nanstd(temp,1,2);  
%         if ~isempty(Condition.All.Lkinematics.(names{i}).mean')
%             if exist(Normatives.Lkinematics.(names{i}).mean,'var')
%                 value = Condition.All.Lkinematics.(names{i}).mean;
%                 norm = Normatives.Lkinematics.(names{i}).mean;
%                 I = ~isnan(norm) & ~isnan(value);
%                 norm = norm(I); value = value(I);
%                 Condition.All.Lkinematics.(names{i}).RMSE = sqrt(sum((norm(:)-value(:)).^2)/numel(norm));
%                 Condition.All.Lkinematics.(names{i}).R2 = corr2(value,norm);
%             else
%                 Condition.All.Lkinematics.(names{i}).RMSE = [];
%                 Condition.All.Lkinematics.(names{i}).R2 = [];
%             end
%         end
    end
end

if  ~strcmp(Session.markersset,'Paramètres') && ~strcmp(Session.markersset,'Aucun')
     
    % =========================================================================
    % Right dynamics (MEAN, STD, RMSE, R2)
    % =========================================================================
    names = fieldnames(Condition.Gait(1).Rdynamics);
    for i = 1:length(names)
        temp = [];
        for j = 1:ngait
            if ~isempty(Condition.Gait(j).Rdynamics)
                temp = [temp Condition.Gait(j).Rdynamics.(names{i})];
            end
        end
        Condition.All.Rdynamics.(names{i}).mean = nanmean(temp,2);
        Condition.All.Rdynamics.(names{i}).std = nanstd(temp,1,2);
%         if ~isempty(Condition.All.Rdynamics.(names{i}).mean')
%             if exist(['Normatives.Rdynamics.',names{i},'.mean;'])
%                 value = Condition.All.Rdynamics.(names{i}).mean;
%                 norm = Normatives.Rdynamics.(names{i}).mean;
%                 I = ~isnan(norm) & ~isnan(value);
%                 norm = norm(I); value = value(I);
%                 Condition.All.Rdynamics.(names{i}).RMSE = sqrt(sum((norm(:)-value(:)).^2)/numel(norm));
%                 Condition.All.Rdynamics.(names{i}).R2 = corr2(value,norm);
%             else
%                 Condition.All.Rdynamics.(names{i}).RMSE = [];
%                 Condition.All.Rdynamics.(names{i}).R2 = [];
%             end
%         end
    end

    % =========================================================================
    % Left dynamics (MEAN, STD, RMSE, R2)
    % =========================================================================
    names = fieldnames(Condition.Gait(1).Ldynamics);
    for i = 1:length(names)
        temp = [];
        for j = 1:ngait
            if ~isempty(Condition.Gait(j).Ldynamics)
                temp = [temp Condition.Gait(j).Ldynamics.(names{i})];
            end
        end
        Condition.All.Ldynamics.(names{i}).mean = nanmean(temp,2);
        Condition.All.Ldynamics.(names{i}).std = nanstd(temp,1,2);
%         if ~isempty(Condition.All.Ldynamics.(names{i}).mean')
%             if exist(['Normatives.Ldynamics.',names{i},'.mean;'])
%                 value = Condition.All.Ldynamics.(names{i}).mean;
%                 norm = Normatives.Ldynamics.(names{i}).mean;
%                 I = ~isnan(norm) & ~isnan(value);
%                 norm = norm(I); value = value(I);
%                 Condition.All.Ldynamics.(names{i}).RMSE = sqrt(sum((norm(:)-value(:)).^2)/numel(norm));
%                 Condition.All.Ldynamics.(names{i}).R2 = corr2(value,norm);
%             else
%                 Condition.All.Ldynamics.(names{i}).RMSE = [];
%                 Condition.All.Ldynamics.(names{i}).R2 = [];
%             end
%         end
    end
    
    % =========================================================================
    % Cycle events (MEAN, STD, TTEST)
    % =========================================================================
    % Right cycle events
    names = fieldnames(Condition.Gait(1).Revents);
    for i = 2:length(names)-1
        temp = [];
        for j = 1:ngait
            if ~isempty(Condition.Gait(j).Revents)
                temp = [temp Condition.Gait(j).Revents.(names{i})];
            end
        end
        Condition.All.Revents.(names{i}).data = temp;
        Condition.All.Revents.(names{i}).mean = nanmean(temp,2);
        Condition.All.Revents.(names{i}).std = nanstd(temp,1,2);
    end
    % Left cycle events
    for i = 2:length(names)-1
        temp = [];
        for j = 1:ngait
            if ~isempty(Condition.Gait(j).Levents)
                temp = [temp Condition.Gait(j).Levents.(names{i})];
            end
        end
        Condition.All.Levents.(names{i}).data = temp;
        Condition.All.Levents.(names{i}).mean = nanmean(temp,2);
        Condition.All.Levents.(names{i}).std = nanstd(temp,1,2);
    end
    % Right cycle phases
    names = fieldnames(Condition.Gait(1).Rphases);
    for i = 1:length(names)
        temp = [];
        for j = 1:ngait
            if ~isempty(Condition.Gait(j).Rphases)
                temp = [temp Condition.Gait(j).Rphases.(names{i})];
            end
        end
        Condition.All.Rphases.(names{i}).data = temp;
        Condition.All.Rphases.(names{i}).mean = nanmean(temp,2);
        Condition.All.Rphases.(names{i}).std = nanstd(temp,1,2);
    end
    % Left cycle phases
    for i = 1:length(names)
        temp = [];
        for j = 1:ngait
            if ~isempty(Condition.Gait(j).Lphases)
                temp = [temp Condition.Gait(j).Lphases.(names{i})];
            end
        end
        Condition.All.Lphases.(names{i}).data = temp;
        Condition.All.Lphases.(names{i}).mean = nanmean(temp,2);
        Condition.All.Lphases.(names{i}).std = nanstd(temp,1,2);
    end
    
    % =========================================================================
    % Indexes (MEAN, STD, TTEST)
    % =========================================================================
    names1 = fieldnames(Condition.Gait(1).Index);
    for k=1:length(names1)
        names=fieldnames(Condition.Gait(1).Index.(names1{k}));
        for i = 1:length(names)
            temp = [];
            for j = 1:ngait
                if ~isempty(Condition.Gait(j).Index.(names1{k}).(names{i}))
                    temp = [temp Condition.Gait(j).Index.(names1{k}).(names{i})];
                end
            end
            Condition.All.Index.(names1{k}).(names{i}).mean = nanmean(temp,2);
            Condition.All.Index.(names1{k}).(names{i}).std = nanstd(temp,1,2);
        end
    end
    
    % =========================================================================
    % SENSITIVITY (MEAN, STD, TTEST)
    % =========================================================================
    if ~isempty(Condition.Gait(1).RSensitivity)
        names1 = fieldnames(Condition.Gait(1).RSensitivity.function);
        for k=1:length(names1)
            temp = [];temp2=[];
            for j = 1:ngait
                if ~isempty(Condition.Gait(j).RSensitivity)
                    temp = [temp Condition.Gait(j).RSensitivity.function.(names1{k})];
                    temp2 = [temp2 Condition.Gait(j).RSensitivity.contribution.(names1{k})];
                end
            end
            Condition.All.RSensitivity.function.(names1{k}).data = temp;
            Condition.All.RSensitivity.function.(names1{k}).mean = nanmean(temp,2);
            Condition.All.RSensitivity.function.(names1{k}).std  = nanstd(temp,1,2);
            Condition.All.RSensitivity.contribution.(names1{k}).data = temp2;
            Condition.All.RSensitivity.contribution.(names1{k}).mean = nanmean(temp2,2);
            Condition.All.RSensitivity.contribution.(names1{k}).std  = nanstd(temp2,1,2);
        end
        names2=fieldnames(Condition.Gait(1).RSensitivity);
        for k=3:length(names2)
            temp = [];
            for j = 1:ngait
                if ~isempty(Condition.Gait(j).RSensitivity)
                    temp = [temp Condition.Gait(j).RSensitivity.(names2{k})];
                end
            end
            Condition.All.RSensitivity.(names2{k}).data = temp;
            Condition.All.RSensitivity.(names2{k}).mean = nanmean(temp,2);
            Condition.All.RSensitivity.(names2{k}).std  = nanstd(temp,1,2);
        end
    end
    if ~isempty(Condition.Gait(1).LSensitivity)
        names1 = fieldnames(Condition.Gait(1).LSensitivity.function);
        for k=1:length(names1)
            temp = [];temp2=[];
            for j = 1:ngait
                if ~isempty(Condition.Gait(j).LSensitivity)
                    temp = [temp Condition.Gait(j).LSensitivity.function.(names1{k})];
                    temp2 = [temp2 Condition.Gait(j).LSensitivity.contribution.(names1{k})];
                end
            end
            Condition.All.LSensitivity.function.(names1{k}).data = temp;
            Condition.All.LSensitivity.function.(names1{k}).mean = nanmean(temp,2);
            Condition.All.LSensitivity.function.(names1{k}).std  = nanstd(temp,1,2);
            Condition.All.LSensitivity.contribution.(names1{k}).data = temp2;
            Condition.All.LSensitivity.contribution.(names1{k}).mean = nanmean(temp2,2);
            Condition.All.LSensitivity.contribution.(names1{k}).std  = nanstd(temp2,1,2);
        end
        names2=fieldnames(Condition.Gait(1).LSensitivity);
        for k=3:length(names2)
            temp = [];
            for j = 1:ngait
                if ~isempty(Condition.Gait(j).LSensitivity)
                    temp = [temp Condition.Gait(j).LSensitivity.(names2{k})];
                end
            end
            Condition.All.LSensitivity.(names2{k}).data = temp;
            Condition.All.LSensitivity.(names2{k}).mean = nanmean(temp,2);
            Condition.All.LSensitivity.(names2{k}).std  = nanstd(temp,1,2);
        end
    end
    
%     % =========================================================================
%     % Abnormalities (MEAN, STD, TTEST)
%     % =========================================================================
%     if isfield(Condition.Gait(1),'Abnormalities')
%         names = fieldnames(Condition.Gait(1).Abnormalities);
%         for i = 1:length(names)
%             temp = [];
%             for j = 1:ngait
%                 if ~isempty(Condition.Gait(j).Abnormalities)
%                     temp = [temp Condition.Gait(j).Abnormalities.(names{i}).index];
%                 end
%             end
%         end
%         Condition.All.Abnormalities.(names{i}).mean = nanmean(temp,2);
%         Condition.All.Abnormalities.(names{i}).std = nanstd(temp,1,2);
%     end
end

if sum(strcmp(Session.channel(:),'none'))~=16
    % =========================================================================
    % Right EMG (MEAN, STD)
    % =========================================================================
    names=[];
    for j = 1:ngait
        if ~isempty(Condition.Gait(j).Remg) && isempty(names)
            names = fieldnames(Condition.Gait(j).Remg);
        end
    end
    if ~isempty(names)
        for i = 1:length(names)
            if strfind(names{i},'_cycle_filt')
                temp=[];
                for j=1:ngait
                    if ~isempty(Condition.Gait(j).Remg)
                        temp = [temp Condition.Gait(j).Remg.(names{i})/max(Condition.Gait(j).Remg.(names{i}))];
                    end
                end
                Condition.All.Remg.(names{i}).mean = nanmean(temp,2);
                Condition.All.Remg.(names{i}).std = nanstd(temp,1,2);
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
                    if ~isempty(Condition.Gait(j).Lemg)
                        temp = [temp Condition.Gait(j).Lemg.(names{i})/max(Condition.Gait(j).Lemg.(names{i}))];
                    end
                end
                Condition.All.Lemg.(names{i}).mean = nanmean(temp,2);
                Condition.All.Lemg.(names{i}).std = nanstd(temp,1,2);
            end
        end
    else
        Condition.All.Lemg.mean = [];
        Condition.All.Lemg.std = [];
    end
end

    

% =========================================================================
% Right cycle postural angles (MEAN, STD, RMSE, R2)
% =========================================================================
if isfield(Condition,'Posturo')
    ngait = length(Condition.Posturo);

    if isfield(Condition.Posturo(1),'Rangle')
        names=[];
        for j = 1:ngait
            if ~isempty(Condition.Posturo(j).Rangle) && isempty(names)
                names = fieldnames(Condition.Posturo(j).Rangle);
            end
        end
        for i = 1:length(names)
            temp1 = [];temp2 = [];
            for j = 1:ngait                   
                temp1 = [temp1 Condition.Posturo(j).Rangle.(names{i})];
%                 temp2 = [temp2 Condition.Posturo(j).Rstd.(names{i})];
            end
            Condition.All.Rangle.(names{i}).mean = nanmean(temp1,2);
            Condition.All.Rangle.(names{i}).std = nanstd(temp1,1,2);
%             Condition.All.Rstd.(names{i}).mean = nanmean(temp2,2);
%             Condition.All.Rstd.(names{i}).std = nanstd(temp2,1,2);
        end
    %         if ~isempty(Condition.All.Rangle.(names{i}).mean)
    %             if exist(['Normatives.Rposturalangle.',names{i},'.mean;'])
    %                 value = eval(['Condition.All.Rangle.',names{i},'.mean;']);
    %                 norm = eval(['Normatives.Rposturalangle.',names{i},'.mean;']);
    %                 I = ~isnan(norm) & ~isnan(value);
    %                 norm = norm(I); value = value(I);
    %                 Condition.All.Rangle.(names{i}).RMSE = sqrt(sum((norm(:)-value(:)).^2)/numel(norm));
    %                 Condition.All.Rangle.(names{i}).R2 = corr2(value,norm);
    %             else
    %                 Condition.All.Rangle.(names{i}).RMSE = [];
    %                 Condition.All.Rangle.(names{i}).R2 = [];
    %             end
    %         end

        % =========================================================================
        % Right cycle anchoring index and intercorrelation functions(MEAN, STD, TTEST)
        % =========================================================================

        names=[];
        for j = 1:ngait
            if ~isempty(Condition.Posturo(j).Rindex) && isempty(names)
                names = fieldnames(Condition.Posturo(j).Rindex);
            end
        end
        for i = 1:length(names)
            temp = [];
            tempZ = [];
            for j = 1:ngait
                if ~isempty(Condition.Posturo(j).Rindex)
                    if isfield(Condition.Posturo(j).Rindex,char(names{i}))
                        temp = [temp Condition.Posturo(j).Rindex.(names{i})];
                        tempZ = [tempZ log((1+temp)/(1-temp))/2];
                    end
                end
            end
            Condition.All.Rindex.(names{i}).mean = nanmean(temp,2);
            Condition.All.Rindex.(names{i}).std = nanstd(temp,1,2);
            [Condition.All.Rindex.(names{i}).h,Condition.All.Rindex.(names{i}).pvalue] = ttest(tempZ);
        end

        names=[];
        for j = 1:ngait
            if ~isempty(Condition.Posturo(j).Rfunction) && isempty(names)
                names = fieldnames(Condition.Posturo(j).Rfunction);
            end
        end
        for i = 1:length(names)
            temp = [];
            tempZ = [];
            for j = 1:ngait
                if ~isempty(Condition.Posturo(j).Rfunction)
                    if isfield(Condition.Posturo(j).Rfunction,char(names{i}))
                        temp = [temp Condition.Posturo(j).Rfunction.(names{i})];
                    end
                end
            end
            Condition.All.Rfunction.(names{i}).mean = nanmean(temp,2);
            Condition.All.Rfunction.(names{i}).std = nanstd(temp,1,2);
            [M,I] = max(Condition.All.Rfunction.(names{i}).mean);
            for j = 1:size(temp,2)
                tempZ = [tempZ log((1+temp(I,j))/(1-temp(I,j)))/2];
            end
            Condition.All.Rfunction.(names{i}).max = M;
            Condition.All.Rfunction.(names{i}).ind = I;
            [Condition.All.Rfunction.(names{i}).h,Condition.All.Rfunction.(names{i}).pvalue] = ttest(tempZ);

        end

        names=[];
        for j = 1:ngait
            if ~isempty(Condition.Posturo(j).Rdephasing) && isempty(names)
                names = fieldnames(Condition.Posturo(j).Rdephasing);
            end
        end
        for i = 1:length(names)
            temp = [];
            for j = 1:ngait
                if ~isempty(Condition.Posturo(j).Rdephasing)
                    if isfield(Condition.Posturo(j).Rdephasing,char(names{i}))
                        temp = [temp Condition.Posturo(j).Rdephasing.(names{i})];
                    end
                end
            end
            Condition.All.Rdephasing.(names{i}).mean = nanmean(temp,2);
            Condition.All.Rdephasing.(names{i}).std = nanstd(temp,1,2);
        end
    end
end
% % %
% % %     % =========================================================================
% % %     % Left cycle postural angles (MEAN, STD, RMSE, R2)
% % %     % =========================================================================
% % %     if isfield(Condition.Gait(1),'Langle')
% % %         names = fieldnames(Condition.Gait(1).Langle);
% % %         for i = 1:length(names)
% % %             temp = [];
% % %             for j = 1:length(Condition.Gait)                   
% % %                 temp = [temp Condition.Gait(j).Langle.(names{i})];
% % %             end
% % %             Condition.All.Langle.(names{i}).mean = nanmean(temp,2);
% % %             Condition.All.Langle.(names{i}).std = nanstd(temp,1,2);
% % %         end
% % %         if ~isempty(Condition.All.Langle.(names{i}).mean)
% % %             if exist(['Normatives.Langle.',names{i},'.mean;'])
% % %                 value = Condition.All.Langle.(names{i}).mean;
% % %                 norm = Normatives.Lposturalangle.(names{i}).mean;
% % %                 I = ~isnan(norm) & ~isnan(value);
% % %                 norm = norm(I); value = value(I);
% % %                 Condition.All.Langle.(names{i}).RMSE = sqrt(sum((norm(:)-value(:)).^2)/numel(norm));
% % %                 Condition.All.Langle.(names{i}).R2 = corr2(value,norm);
% % %             else
% % %                 Condition.All.Langle.(names{i}).RMSE = [];
% % %                 Condition.All.Langle.(names{i}).R2 = [];
% % %             end
% % %         end
% % %     end
% % %     % =========================================================================
% % %     % Left cycle anchoring index and intercorrelation functions
% % %     % (MEAN, STD, TTEST)
% % %     % =========================================================================
% % %     if isfield(Condition.Gait(1).Lposturalindex,'Std')
% % %         if ~isempty(Condition.Gait(1).Lposturalindex.Std)
% % %             names = fieldnames(Condition.Gait(1).Lposturalindex.Std);
% % %             ngait = length(Condition.Gait);
% % %             for i = 1:length(names)
% % %                 temp = [];
% % %                 for j = 1:ngait
% % %                     if ~isempty(Condition.Gait(j).Lposturalindex.Std)
% % %                         if isfield(Condition.Gait(j).Lposturalindex.Std,char(names{i}))
% % %                             %&& ~isempty(Condition.Gait(j).Lposturalindex.Aindexgr,char(names{i}))
% % %                             temp = [temp eval(['Condition.Gait(',num2str(j),').Lposturalindex.Std.',names{i},';'])];
% % %                         end
% % %                     end
% % %                 end
% % %                 eval(['Condition.All.Lposturalindex.Std.',names{i},'.mean = nanmean(temp,2);']);
% % %                 eval(['Condition.All.Lposturalindex.Std.',names{i},'.std = nanstd(temp,1,2);']);
% % %             end
% % %         end
% % %     end
% % %     if isfield(Condition.Gait(1).Lposturalindex,'Aindex')
% % %         names = fieldnames(Condition.Gait(1).Lposturalindex.Aindex);
% % %         ngait = length(Condition.Gait);
% % %         for i = 1:length(names)
% % %             temp = [];
% % %             tempZ = [];
% % %             for j = 1:ngait
% % %                 if ~isempty(Condition.Gait(j).Lposturalindex.Aindex)
% % %                     if isfield(Condition.Gait(j).Lposturalindex.Aindex,char(names{i}))
% % %                         %&& ~isempty(Condition.Gait(j).Lposturalindex.Aindexgr,char(names{i}))
% % %                         temp = [temp eval(['Condition.Gait(',num2str(j),').Lposturalindex.Aindex.',names{i},';'])];
% % %                         tempZ = [tempZ log((1+temp)/(1-temp))/2];
% % %                     end
% % %                 end
% % %             end
% % %             eval(['Condition.All.Lposturalindex.Aindex.',names{i},'.mean = nanmean(temp,2);']);
% % %             eval(['Condition.All.Lposturalindex.Aindex.',names{i},'.std = nanstd(temp,1,2);']);
% % %             eval(['[Condition.All.Lposturalindex.Aindex.',names{i},...
% % %                 '.h,Condition.All.Lposturalindex.Aindex.',names{i},'.pvalue] = ttest(tempZ);']);
% % %         end
% % %     end
% % %     if isfield(Condition.Gait(1).Lposturalindex,'Ifunction')
% % %         names = fieldnames(Condition.Gait(1).Lposturalindex.Ifunction);
% % %         ngait = length(Condition.Gait);
% % %         for i = 1:length(names)
% % %             temp = [];
% % %             tempZ = [];
% % %             for j = 1:ngait
% % %                 if ~isempty(Condition.Gait(j).Lposturalindex.Ifunction)
% % %                     if isfield(Condition.Gait(j).Lposturalindex.Ifunction,char(names{i}))
% % %                         temp = [temp eval(['Condition.Gait(',num2str(j),').Lposturalindex.Ifunction.',names{i},';'])];
% % %                     end
% % %                 end
% % %             end
% % %             eval(['Condition.All.Lposturalindex.Ifunction.',names{i},'.mean = nanmean(temp,2);']);
% % %             eval(['Condition.All.Lposturalindex.Ifunction.',names{i},'.std = nanstd(temp,1,2);']);        
% % %             eval(['[Y,I] = max(Condition.All.Lposturalindex.Ifunction.',names{i},'.mean);']);
% % %             eval(['Condition.All.Lposturalindex.Ifunction.',names{i},'.max = Y;']);
% % %             eval(['Condition.All.Lposturalindex.Ifunction.',names{i},'.ind = I;']);
% % %             for j = 1:size(temp,2)
% % %                 tempZ = [tempZ log((1+temp(I,j))/(1-temp(I,j)))/2];
% % %             end
% % %             eval(['[Condition.All.Lposturalindex.Ifunction.',names{i},...
% % %                 '.h,Condition.All.Lposturalindex.Ifunction.',names{i},'.pvalue] = ttest(tempZ);']);
% % % 
% % %         end
% % %     end
% % %     if isfield(Condition.Gait(1).Lposturalindex,'Idephasing')
% % %         names = fieldnames(Condition.Gait(1).Lposturalindex.Idephasing);
% % %         ngait = length(Condition.Gait);
% % %         for i = 1:length(names)
% % %             temp = [];
% % %             for j = 1:ngait
% % %                 if ~isempty(Condition.Gait(j).Lposturalindex.Idephasing)
% % %                     if isfield(Condition.Gait(j).Lposturalindex.Idephasing,char(names{i}))
% % %                         temp = [temp eval(['Condition.Gait(',num2str(j),').Lposturalindex.Idephasing.',names{i},';'])];
% % %                     end
% % %                 end
% % %             end
% % %             eval(['Condition.All.Lposturalindex.Idephasing.',names{i},'.mean = nanmean(temp,2);']);
% % %             eval(['Condition.All.Lposturalindex.Idephasing.',names{i},'.std = nanstd(temp,1,2);']);
% % %         end
% % %     end



if isfield(Condition,'UpperLimbs')
    % =========================================================================
    % Left UPPER LIMBS kinematics (MEAN, STD, RMSE, R2)
    % =========================================================================
    if isfield(Condition.UpperLimbs(1),'Lkinematics')
        ngait = length(Condition.UpperLimbs);
        names=[];
        for j = 1:ngait
            if ~isempty(Condition.UpperLimbs(j).Lkinematics) && isempty(names)
                names = fieldnames(Condition.UpperLimbs(j).Lkinematics);
            end
        end
        for i = 1:length(names)
            temp = [];
            for j = 1:ngait 
                if ~isempty(Condition.UpperLimbs(j).Lkinematics)
                    temp = [temp Condition.UpperLimbs(j).Lkinematics.(names{i})];
                end
            end
            Condition.All.LkinematicsUL.(names{i}).mean = nanmean(temp,2);
            Condition.All.LkinematicsUL.(names{i}).std = nanstd(temp,1,2);
            if ~isempty(eval(['Condition.All.LkinematicsUL.',names{i},'.mean']))
%                     if exist(['Normatives.Lkinematics.',names{i},'.mean;'])
%                         value = eval(['Condition.All.LkinematicsUL.',names{i},'.mean;']);
%                         norm = eval(['Normatives.LkinematicsUL.',names{i},'.mean;']);
%                         I = ~isnan(norm) & ~isnan(value);
%                         norm = norm(I); value = value(I);
%                         eval(['Condition.All.LkinematicsUL.',names{i},'.RMSE = sqrt(sum((norm(:)-value(:)).^2)/numel(norm));']);
%                         eval(['Condition.All.LkinematicsUL.',names{i},'.R2 = corr2(value,norm);']);
%                     else
%                         eval(['Condition.All.LkinematicsUL.',names{i},'.RMSE = [];']);
%                         eval(['Condition.All.LkinematicsUL.',names{i},'.R2 = [];']);
%                     end
            end
        end
    end
    % =========================================================================
    % Right UPPER LIMBS kinematics (MEAN, STD, RMSE, R2)
    % =========================================================================
    if isfield(Condition.UpperLimbs(1),'Rkinematics')
        ngait = length(Condition.UpperLimbs);
        names=[];
        for j = 1:ngait
            if ~isempty(Condition.UpperLimbs(j).Rkinematics) && isempty(names)
                names = fieldnames(Condition.UpperLimbs(j).Rkinematics);
            end
        end
        for i = 1:length(names)
            temp = [];
            for j = 1:ngait
                if ~isempty(Condition.UpperLimbs(j).Rkinematics)
                    temp = [temp Condition.UpperLimbs(j).Rkinematics.(names{i})];
                end
            end
            Condition.All.RkinematicsUL.(names{i}).mean = nanmean(temp,2);
            Condition.All.RkinematicsUL.(names{i}).std = nanstd(temp,1,2);
            if ~isempty(eval(['Condition.All.RkinematicsUL.',names{i},'.mean']))
%                     if exist(['Normatives.RkinematicsUL.',names{i},'.mean;'])
%                         value = eval(['Condition.All.RkinematicsUL.',names{i},'.mean;']);
%                         norm = eval(['Normatives.RkinematicsUL.',names{i},'.mean;']);
%                         I = ~isnan(norm) & ~isnan(value);
%                         norm = norm(I); value = value(I);
%                         eval(['Condition.All.RkinematicsUL.',names{i},'.RMSE = sqrt(sum((norm(:)-value(:)).^2)/numel(norm));']);
%                         eval(['Condition.All.RkinematicsUL.',names{i},'.R2 = corr2(value,norm);']);
%                     else
%                         eval(['Condition.All.RkinematicsUL.',names{i},'.RMSE = [];']);
%                         eval(['Condition.All.RkinematicsUL.',names{i},'.R2 = [];']);
%                     end
            end
        end
    end

end

% % names = fieldnames(Session);
% % finder = 0;
% % for i = 1:length(names)
% %     if strcmp(names{i},'footmarkersset')
% %         finder = 1;
% %     end
% % end
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