%% Figure 4
clear; close all; clc
addpath(genpath('../functions'));
load('../data/EXP2_data.mat')
% have to revise for experiment 1 data
group_var = {'LD','HD'};
group_name = {'LD','HD'};

group_title = {'Study2 - LD','Study2 - HD'};
group_dotC = {
    [73 116 400]/510;...
    [30 148 111]/255}; %[0.3 0.3 0.3];...

EXP2_questionnaire_LD = EXP2_questionnaire_data(EXP2_questionnaire_data.group=="LD",:);
EXP2_questionnaire_LD_smoker = EXP2_questionnaire_LD(EXP2_questionnaire_LD.Smoking1_Past2==1,:);
EXP2_questionnaire_LD_past = EXP2_questionnaire_LD(EXP2_questionnaire_LD.Smoking1_Past2==2,:);
EXP2_questionnaire_LD_past(EXP2_questionnaire_LD_past.num_cigarettes_last_12h>0,:)=[];
EXP2_questionnaire_LD_past(EXP2_questionnaire_LD_past.num_cigarettes_last_24h>0,:)=[];

EXP2_questionnaire_HD = EXP2_questionnaire_data(EXP2_questionnaire_data.group=="HD",:);
EXP2_questionnaire_HD_smoker = EXP2_questionnaire_HD(EXP2_questionnaire_HD.Smoking1_Past2==1,:);
EXP2_questionnaire_HD_past = EXP2_questionnaire_HD(EXP2_questionnaire_HD.Smoking1_Past2==2,:);
EXP2_questionnaire_HD_past(EXP2_questionnaire_HD_past.num_cigarettes_last_12h>0,:)=[];
EXP2_questionnaire_HD_past(EXP2_questionnaire_HD_past.num_cigarettes_last_24h>0,:)=[];


%% figure 4(a)

disp(['Figure 4(a)'])
figure('Color','w','Position',[300 500 250 200])
hold on
title({' LD            HD'})

x.LD = EXP2_questionnaire_LD.QSU_day2 - EXP2_questionnaire_LD.QSU_day1;
x.HD = EXP2_questionnaire_HD.QSU_day2 - EXP2_questionnaire_HD.QSU_day1;

V=violinplot(x);
V(1).ViolinColor = group_dotC{1};
V(2).ViolinColor = group_dotC{2};

scatter([1,2],[nanmean(x.LD), nanmean(x.HD)],15,'r','filled')

row1 = {'  ', '  '}; row2 = {'  ', '  '}; labelArray = [row1; row2];
txt12 = strtrim(sprintf('%s\\newline%s\n', labelArray{:}));
xticks([1,2]); xticklabels(txt12); xlim([0.4 2.6]);
ylabel({'\DeltaQSU','(Day2 - Day1)'});
ylim([-60 60]);
yline(0,'--');
set(gca,'LineWidth',1,'FontSize',14);

% saveas(gcf,['../_figure_tiff/figure4_a.tiff'])
% close all

[~,p,~,st] = ttest(x.LD,0,"Tail","left");
disp(['LD = ',num2str(nanmean(x.LD)),' ± ',num2str(nanstd(x.LD))])
disp(['t(',num2str(st.df),')=',num2str(st.tstat),', P=',num2str(p)])
clearvars p st

[~,p,~,st] = ttest(x.HD,0,"Tail","right");
disp(['HD = ',num2str(nanmean(x.HD)),' ± ',num2str(nanstd(x.HD))])
disp(['t(',num2str(st.df),')=',num2str(st.tstat),', P=',num2str(p)])
clearvars p st

[~,p,~,st] = ttest2(x.LD, x.HD);
disp(['LD vs HD: t(',num2str(st.df),')=',num2str(st.tstat),', P=',num2str(p)])
clearvars p st
disp(' ')

clearvars x V
%% figure 4(b)

disp(['Figure 4(b)'])
figure('Color','w','Position',[600 500 360 200])
hold on
title({' LD                              HD'})

x.LD_smoker = EXP2_questionnaire_LD_smoker.QSU_day2 - EXP2_questionnaire_LD_smoker.QSU_day1;
x.LD_past = EXP2_questionnaire_LD_past.QSU_day2 - EXP2_questionnaire_LD_past.QSU_day1;
x.HD_smoker = EXP2_questionnaire_HD_smoker.QSU_day2 - EXP2_questionnaire_HD_smoker.QSU_day1;
x.HD_past = EXP2_questionnaire_HD_past.QSU_day2 - EXP2_questionnaire_HD_past.QSU_day1;

V=violinplot(x);
V(1).ViolinColor = group_dotC{1};
V(2).ViolinColor = group_dotC{1};
V(3).ViolinColor = group_dotC{2};
V(4).ViolinColor = group_dotC{2};

V(1, 3).ScatterPlot.XData = V(1, 3).ScatterPlot.XData +0.8;
V(1, 3).ViolinPlot.XData  = V(1, 3).ViolinPlot.XData  +0.8;
V(1, 3).BoxPlot.XData = V(1, 3).BoxPlot.XData   +0.8;
V(1, 3).WhiskerPlot.XData  = V(1, 3).WhiskerPlot.XData   +0.8;
V(1, 3).MedianPlot.XData  = V(1, 3).MedianPlot.XData   +0.8;
V(1, 4).ScatterPlot.XData = V(1, 4).ScatterPlot.XData +0.8;
V(1, 4).ViolinPlot.XData  = V(1, 4).ViolinPlot.XData  +0.8;
V(1, 4).BoxPlot.XData = V(1, 4).BoxPlot.XData   +0.8;
V(1, 4).WhiskerPlot.XData  = V(1, 4).WhiskerPlot.XData   +0.8;
V(1, 4).MedianPlot.XData  = V(1, 4).MedianPlot.XData   +0.8;

scatter([1,2, 3.8 4.8],[nanmean(x.LD_smoker),nanmean(x.LD_past),nanmean(x.HD_smoker), nanmean(x.HD_past)],15,'r','filled')

row1 = {'Smoker', '  Past-', 'Smoker', '  Past-'};%
row2 = {'', 'smoker', '' 'smoker'};%
labelArray = [row1; row2];
txt12 = strtrim(sprintf('%s\\newline%s\n', labelArray{:}));
xticklabels(txt12);

xticks([1,2, 3.8 4.8]);  xlim([0.4 5.4]);
ylabel({'\DeltaQSU','(Day2 - Day1)'});
ylim([-60 60]);
yline(0,'--');
set(gca,'LineWidth',1,'FontSize',14);

% saveas(gcf,['../_figure_tiff/figure4_b.tiff'])
% close all

% ANOVA
datas_tmp=table();
datas_tmp.DeltaQSU = [x.LD_smoker; x.LD_past; x.HD_smoker; x.HD_past];
datas_tmp.Group = categorical([ones(size(x.LD_smoker)); ones(size(x.LD_past)); 2*ones(size(x.HD_smoker)); 2*ones(size(x.HD_past))]);
datas_tmp.Status = categorical([ones(size(x.LD_smoker)); 2*ones(size(x.LD_past)); ones(size(x.HD_smoker)); 2*ones(size(x.HD_past))]);

[p, tbl, stats] = anovan(datas_tmp.DeltaQSU, {datas_tmp.Group, datas_tmp.Status}, 'model', 'interaction', 'varnames', {'Group', 'Status'});
disp(tbl)

disp('LD')
[~,p,~,st] = ttest(x.LD_smoker,0,'Tail','left');
disp(['Smokers = ',num2str(nanmean(x.LD_smoker)),' ± ',num2str(nanstd(x.LD_smoker))])
disp(['t(',num2str(st.df),')=',num2str(st.tstat),', P=',num2str(p)])
clearvars p st
[p,~,st] = signrank(x.LD_past,0,'Tail','left');
disp(['Past-smokers = ',num2str(nanmean(x.LD_past)),' ± ',num2str(nanstd(x.LD_past))])
disp(['signedrank=',num2str(st.signedrank),', P=',num2str(p)])
clearvars p st

[p,~,st] = ranksum(x.LD_smoker, x.LD_past);
disp(['Smokers vs Past: ranksum=',num2str(st.ranksum),', P=',num2str(p)])
clearvars p st
disp(' ')

disp('HD')
[~,p,~,st] = ttest(x.HD_smoker,0,'Tail','right');
disp(['Smokers = ',num2str(nanmean(x.HD_smoker)),' ± ',num2str(nanstd(x.HD_smoker))])
disp(['t(',num2str(st.df),')=',num2str(st.tstat),', P=',num2str(p)])
clearvars p st
[~,p,~,st] = ttest(x.HD_past,0,'Tail','right');
disp(['Past-smokers = ',num2str(nanmean(x.HD_past)),' ± ',num2str(nanstd(x.HD_past))])
disp(['t(',num2str(st.df),')=',num2str(st.tstat),', P=',num2str(p)])
clearvars p st

[~,p,~,st] = ttest2(x.HD_smoker, x.HD_past);
disp(['Smokers vs Past: t(',num2str(st.df),')=',num2str(st.tstat),', P=',num2str(p)])
clearvars p st
disp(' ')

