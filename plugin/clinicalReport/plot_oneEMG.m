g=3;
itrial=2;
icondition=1;

colorL = [0.8 0 0];
names = fieldnames(Condition(icondition).Gait(itrial).Lemg);
k1=1;k2=1;
for j = 1:length(names)
        if strfind(names{j},'_raw')
            Lemg_raw(1:size(Condition(icondition).Gait(itrial).Lemg.(names{j}),1),k1) = ...
                Condition(icondition).Gait(itrial).Lemg.(names{j});
            Lemg_name{k1} = regexprep(names{j},'_raw','');
            k1 = k1+1;
        end
        if strfind(names{j},'_filt')
            Lemg_filt.mean(1:size(Condition(icondition).All.Lemg.(names{j}).mean,1),k2) = ...
                Condition(icondition).All.Lemg.(names{j}).mean;
            Lemg_filt.std(1:size(Condition(icondition).All.Lemg.(names{j}).mean,1),k2) = ...
                Condition(icondition).All.Lemg.(names{j}).std;
            k2 = k2+1;
        end
    end
isize = size(find(~isnan(Lemg_raw(:,g))),1);


figure('Units','centimeters','Position',[10 4 30 10],...
        'Color','white','PaperUnits','centimeters',...
        'PaperPosition',[0 0 10 4]);

subplot(1,3,[1,2]);hold on;
title(regexprep(regexprep(Lemg_name{g},'left_',''),'_',' '),'FontWeight','Bold');
ylabel('Amplitude(uV)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
xlabel('Time(s)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
plot(Lemg_raw(1:isize,g),'Linestyle','-','Linewidth',0.5,'Color',colorL(1,:));
axis tight;
        
YL = [-2e-4,2e-4];
XL = xlim;
XL(1) = 15000;
axis([XL(1) XL(2) YL(1) YL(2)]);
        
plot([Condition(icondition).Gait(itrial).Revents.e.LHS(1)*Session(icondition).fanalog ...
            Condition(icondition).Gait(itrial).Revents.e.LHS(1)*Session(icondition).fanalog],...
            [YL(1) YL(2)],'Linestyle','-','Linewidth',1,'Color','black');
plot([Condition(icondition).Gait(itrial).Revents.e.LTO(end)*Session(icondition).fanalog ...
            Condition(icondition).Gait(itrial).Revents.e.LTO(end)*Session(icondition).fanalog],...
            [YL(1) YL(2)],'Linestyle','--','Linewidth',1,'Color','black');
plot([Condition(icondition).Gait(itrial).Revents.e.LHS(2)*Session(icondition).fanalog ...
            Condition(icondition).Gait(itrial).Revents.e.LHS(2)*Session(icondition).fanalog],...
            [YL(1) YL(2)],'Linestyle','-','Linewidth',1,'Color','black');
        
subplot(1,3,3);hold on;
title(regexprep(regexprep(Lemg_name{g},'left_',''),'_',' '),'FontWeight','Bold');
ylabel('Amplitude(%max)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
xlabel('Gait cycle(%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
plot(Lemg_filt.mean(1:101,g),'Linestyle','-','Linewidth',2,'Color',colorL(1,:));
axis tight;axis([0 100 0 1]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('Units','centimeters','Position',[5 5 15 15],...
        'Color','white','PaperUnits','centimeters',...
        'PaperPosition',[0 0 10 4]);

hold on;
ylabel('Amplitude(%max)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
xlabel('Gait cycle(%)','FontSize',8,'HorizontalAlignment','center','VerticalAlignment','Middle');
plot(Lemg_filt.mean(1:101,2),'Linestyle','-','Linewidth',2,'Color','k');
plot(Lemg_filt.mean(1:101,4),'Linestyle','-','Linewidth',2,'Color','r');
% plot(Lemg_filt.mean(1:101,5),'Linestyle','-','Linewidth',2,'Color','m');
plot(Lemg_filt.mean(1:101,6),'Linestyle','-','Linewidth',2,'Color','b');
plot(Lemg_filt.mean(1:101,7),'Linestyle','-','Linewidth',2,'Color','g');
axis tight;axis([0 100 0 1]);
legend('RF surface','RF fil','VMed fil','VLat fil')