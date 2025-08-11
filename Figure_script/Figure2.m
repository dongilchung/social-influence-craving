%% Figure 2
clear; close all; clc
addpath(genpath('../functions'));
load('../data/EXP1_data.mat','*_rating_data')
load('../data/EXP2_data.mat','*_rating_data')
% have to revise for experiment 1 data
group_var = {'Study1','LD','HD'};
group_name = {'Study1','LD','HD','ED'};

group_title = {'Study1','Study2 - LD','Study2 - HD'};
group_dotC = {[0.3 0.3 0.3];...
    [73 116 400]/510;...
    [30 148 111]/255};

%% figure 2 (a-c)
exp2_rating_diff = [];
for grp = 1:3
    disp(['Figure2 (',char(grp + 'a' - 1),')'])
    figure('Color','w','Position',[grp*300 600 270 200])
    hold on
    title({group_title{grp},' '})
    if grp ==1
        tmp_ratings = EXP1_rating_data(:,2);
    else
        tmp_ratings = EXP2_rating_data(strcmp(EXP2_rating_data(:,2),group_name{grp}),3);
    end
    feedbackNum = table();
    for subjidx = 1: length(tmp_ratings)
        x.low(subjidx,1) = nanmean(tmp_ratings{subjidx}.rating_diff(tmp_ratings{subjidx}.conflict<0));
        x.equal(subjidx,1) = nanmean(tmp_ratings{subjidx}.rating_diff(tmp_ratings{subjidx}.conflict==0));
        x.high(subjidx,1) = nanmean(tmp_ratings{subjidx}.rating_diff(tmp_ratings{subjidx}.conflict>0));
    end
    V=violinplot(x);
    V(1).ViolinColor = group_dotC{grp};
    V(2).ViolinColor = group_dotC{grp};
    V(3).ViolinColor = group_dotC{grp};
    scatter([1,2, 3],[nanmean(x.low),nanmean(x.equal),nanmean(x.high)],15,'r','filled')
    
    xticks([1,2, 3]); xticklabels({'Low','Equal','High'}); xlim([0.2 3.8]);
    ylabel({'\Delta Rating','(Day2 - Day1)'});  
    if grp ==1; ylim([-10 8]);
    else; ylim([-8 8]); end
    yline(0,'--');
    set(gca,'LineWidth',1,'FontSize',14);
    
%     saveas(gcf,['../_figure_tiff/figure2_',char(grp + 'a' - 1),'.tiff'])
%     close all
    
    disp(group_name{grp})
    
    % rm ANOVA
    tmp_data_LD = [x.low,x.equal,x.high]; tmp_data_LD(isnan(tmp_data_LD),:)=[];
    [~, tbl] = anova_rm(tmp_data_LD,'off'); 
    disp(tbl)
    disp(' ')
    clearvars tbl tmp_data
    
    [~,p,~,st] = ttest(x.low);
    disp(['low = ',num2str(round(nanmean(x.low),2)),' ± ',num2str(round(nanstd(x.low),2))])
    disp(['t(',num2str(st.df),')=',num2str(st.tstat),', P=',num2str(p)])
    clearvars p st
    [~,p,~,st] = ttest(x.equal);
    disp(['equal = ',num2str(round(nanmean(x.equal),2)),' ± ',num2str(round(nanstd(x.equal),2))])
    disp(['t(',num2str(st.df),')=',num2str(st.tstat),', P=',num2str(p)])
    clearvars p st
    [~,p,~,st] = ttest(x.high);
    disp(['high = ',num2str(round(nanmean(x.high),2)),' ± ',num2str(round(nanstd(x.high),2))])
    disp(['t(',num2str(st.df),')=',num2str(st.tstat),', P=',num2str(p)])
    clearvars p st
    
    disp(' ')
    [~,p,~,st] = ttest(x.low, x.equal);
    disp(['low vs equal: t(',num2str(st.df),')=',num2str(st.tstat),', P=',num2str(p)])
    clearvars p st
    [~,p,~,st] = ttest(x.low, x.high);
    disp(['low vs high: t(',num2str(st.df),')=',num2str(st.tstat),', P=',num2str(p)])
    clearvars p st
    [~,p,~,st] = ttest(x.equal, x.high);
    disp(['equal vs high: t(',num2str(st.df),')=',num2str(st.tstat),', P=',num2str(p)])
    clearvars p st
    disp(' ')
    x_tmp = [x.low, x.equal, x.high];
    if grp >1
        exp2_rating_diff = [exp2_rating_diff; x.low, x.equal, x.high];
    end
    x_tmp(isnan(x_tmp),:)=[];
    [~, tbl] = anova_rm(x_tmp,'off')
%     close all
    clearvars x V tmp_ratings x_tmp
    
end

disp('all study2 data')
exp2_rating_diff(isnan(exp2_rating_diff),:)=[];
[~, tbl] = anova_rm(exp2_rating_diff,'off')
clearvars exp2_rating_diff
disp(' ')
%% conformity
EXP1_conformity = table();
EXP1_conformity.ID = EXP1_rating_data(:,1);
tmp_ratings = EXP1_rating_data(:,2);
for subjidx = 1: length(tmp_ratings)
    [rho,~] = corr(tmp_ratings{subjidx}.conflict, tmp_ratings{subjidx}.rating_diff);
    EXP1_conformity.conformity(subjidx,1) = rho; clearvars rho
    EXP1_conformity.conformity_z(subjidx,1) = atanh(EXP1_conformity.conformity(subjidx,1));
    [rho,~] = corr(tmp_ratings{subjidx}.conflict(tmp_ratings{subjidx}.conflict<=0), tmp_ratings{subjidx}.rating_diff(tmp_ratings{subjidx}.conflict<=0));
    EXP1_conformity.c_low(subjidx,1) = rho; clearvars rho
    EXP1_conformity.c_low_z(subjidx,1) = atanh(EXP1_conformity.c_low(subjidx,1));
    [rho,~] = corr(tmp_ratings{subjidx}.conflict(tmp_ratings{subjidx}.conflict>=0), tmp_ratings{subjidx}.rating_diff(tmp_ratings{subjidx}.conflict>=0));
    EXP1_conformity.c_high(subjidx,1) = rho; clearvars rho
    EXP1_conformity.c_high_z(subjidx,1) = atanh(EXP1_conformity.c_high(subjidx,1));
end
clearvars tmp_ratings

EXP2_conformity = table();
EXP2_conformity.ID = EXP2_rating_data(:,1);
EXP2_conformity.group = categorical(EXP2_rating_data(:,2));
tmp_ratings = EXP2_rating_data(:,3);
for subjidx = 1: length(tmp_ratings)
    [rho,~] = corr(tmp_ratings{subjidx}.conflict, tmp_ratings{subjidx}.rating_diff);
    EXP2_conformity.conformity(subjidx,1) = rho; clearvars rho
    EXP2_conformity.conformity_z(subjidx,1) = atanh(EXP2_conformity.conformity(subjidx,1));
    [rho,~] = corr(tmp_ratings{subjidx}.conflict(tmp_ratings{subjidx}.conflict<=0), tmp_ratings{subjidx}.rating_diff(tmp_ratings{subjidx}.conflict<=0));
    EXP2_conformity.c_low(subjidx,1) = rho; clearvars rho
    EXP2_conformity.c_low_z(subjidx,1) = atanh(EXP2_conformity.c_low(subjidx,1));
    [rho,~] = corr(tmp_ratings{subjidx}.conflict(tmp_ratings{subjidx}.conflict>=0), tmp_ratings{subjidx}.rating_diff(tmp_ratings{subjidx}.conflict>=0));
    EXP2_conformity.c_high(subjidx,1) = rho; clearvars rho
    EXP2_conformity.c_high_z(subjidx,1) = atanh(EXP2_conformity.c_high(subjidx,1));
end
EXP2_conformity_LD_HD = EXP2_conformity;
EXP2_conformity_LD_HD(EXP2_conformity_LD_HD.group=='ED',:)=[];
exp2_c_z_low_high = [EXP2_conformity_LD_HD.c_low_z, EXP2_conformity_LD_HD.c_high_z];
exp2_c_z_low_high(isnan(exp2_c_z_low_high),:)=[];
[~, tbl] = anova_rm(exp2_c_z_low_high,'off')
clearvars exp2_c_z_low_high
%% figure 2 (d)
disp('Figure2 (d)')
figure('Color','w','Position',[300 300 270 200])
hold on
title({'Study1',' '})
tmp_ratings = EXP1_rating_data(:,2);

disp('Study 1')

disp(['all trials conformity : ',num2str(round(nanmean(EXP1_conformity.conformity),2)),' ± ',num2str(round(nanstd(EXP1_conformity.conformity),2))])
[~,p,~,st]=ttest(EXP1_conformity.conformity_z);
disp(['t(',num2str(st.df),')=',num2str(st.tstat),', p=',num2str(p)])
clearvars p st

disp(['lower conformity : ',num2str(round(nanmean(EXP1_conformity.c_low),2)),' ± ',num2str(round(nanstd(EXP1_conformity.c_low),2))])
[~,p,~,st]=ttest(EXP1_conformity.c_low_z);
disp(['t(',num2str(st.df),')=',num2str(st.tstat),', p=',num2str(p)])
clearvars p st

disp(['higher conformity : ',num2str(round(nanmean(EXP1_conformity.c_high),2)),' ± ',num2str(round(nanstd(EXP1_conformity.c_high),2))])
[~,p,~,st]=ttest(EXP1_conformity.c_high_z);
disp(['t(',num2str(st.df),')=',num2str(st.tstat),', p=',num2str(p)])
clearvars p st

[~,p,~,st]=ttest(EXP1_conformity.c_low_z, EXP1_conformity.c_high_z);
disp(['low vs high conformity paired t-test t(',num2str(st.df),')=',num2str(st.tstat),', p=',num2str(p)])
clearvars p st
disp(' ')

x.all = EXP1_conformity.conformity_z;
x.low = EXP1_conformity.c_low_z;
x.high = EXP1_conformity.c_high_z;
V=violinplot(x);
V(1).ViolinColor = group_dotC{1};
V(2).ViolinColor = group_dotC{1};
V(3).ViolinColor = group_dotC{1};

V(1, 2).ScatterPlot.XData = V(1, 2).ScatterPlot.XData +0.5;
V(1, 2).ViolinPlot.XData  = V(1, 2).ViolinPlot.XData  +0.5;
V(1, 2).BoxPlot.XData = V(1, 2).BoxPlot.XData   +0.5;
V(1, 2).WhiskerPlot.XData  = V(1, 2).WhiskerPlot.XData   +0.5;
V(1, 2).MedianPlot.XData  = V(1, 2).MedianPlot.XData   +0.5;
V(1, 3).ScatterPlot.XData = V(1, 3).ScatterPlot.XData +0.5;
V(1, 3).ViolinPlot.XData  = V(1, 3).ViolinPlot.XData  +0.5;
V(1, 3).BoxPlot.XData = V(1, 3).BoxPlot.XData   +0.5;
V(1, 3).WhiskerPlot.XData  = V(1, 3).WhiskerPlot.XData   +0.5;
V(1, 3).MedianPlot.XData  = V(1, 3).MedianPlot.XData   +0.5;

scatter([1,2.5,3.5],[nanmean(x.all),nanmean(x.low),nanmean(x.high)],20,'filled','r')
ylabel('Conformity')
xticks([1 2.5 3.5])
yline(0,'--');
xlim([0.4 4.1]); ylim([-0.4 1.5]);% ylim([-0.8 0.8]);%ylim(ylim_s); %
xticklabels({'All trials','Low','High'});
set(gca,'FontSize',14,'LineWidth',1)
% saveas(gcf,['../_figure_tiff/figure2_d.tiff'])
%     close all
    
clearvars x V tmp_ratings

%% figure 2 (e)
disp('Figure2 (e)')

disp('Study2')
EXP2_conformity.conformity_z = atanh(EXP2_conformity.conformity);
EXP2_conformity.c_low_z = atanh(EXP2_conformity.c_low);
EXP2_conformity.c_high_z = atanh(EXP2_conformity.c_high);

figure('Color','w','Position',[600 300 240 200])
hold on
title({'Study2',' LD            HD'})
clearvars x V
for grp = 2:3
    eval(['x.',group_var{grp},' = EXP2_conformity.conformity(EXP2_conformity.group==group_name{grp},:); '])
    eval(['z.',group_var{grp},' = EXP2_conformity.conformity_z(EXP2_conformity.group==group_name{grp},:); '])
end
V=violinplot(x);
V(1).ViolinColor = group_dotC{2};
V(2).ViolinColor = group_dotC{3};

scatter([1,2],[nanmean(x.LD),nanmean(x.HD)],20,'filled','r')
ylabel('Conformity')
xticks([1,2])
yline(0,'--');
xlim([0.3 2.7]); ylim([-0.4 1.5]);%ylim([-0.15 0.75]);%ylim(ylim_s); %
xticklabels({'All trials','All trials'});
set(gca,'FontSize',14,'LineWidth',1)

disp('conformity for all trials')
disp(['LD : ',num2str(round(nanmean(x.LD),2)),' ± ',num2str(round(nanstd(x.LD),2))])
[~,p,~,st]=ttest(z.LD);
disp(['t(',num2str(st.df),')=',num2str(st.tstat),', p=',num2str(p)])
clearvars p st
disp(['HD : ',num2str(round(nanmean(x.HD),2)),' ± ',num2str(round(nanstd(x.HD),2))])
[~,p,~,st]=ttest(z.HD);
disp(['t(',num2str(st.df),')=',num2str(st.tstat),', p=',num2str(p)])
clearvars p st

[~,p,~,st]=ttest2(z.LD, z.HD);
disp(['LD vs HD 2 sample t-test t(',num2str(st.df),')=',num2str(st.tstat),', p=',num2str(p)])
disp(' ')
clearvars p st x z V

% saveas(gcf,['../_figure_tiff/figure2_e.tiff'])
%     close all
    
%% figure 2(f)
disp('Figure2 (f)')

figure('Color','w','Position',[900 300 300 200])
hold on
title({'Study2','LD                        HD'})
clearvars x V x_*
for grp = 2:3
    eval(['x.',group_var{grp},'_lower = EXP2_conformity.c_low(EXP2_conformity.group==group_name{grp},:); '])
    eval(['x.',group_var{grp},'_higher = EXP2_conformity.c_high(EXP2_conformity.group==group_name{grp},:); '])
    eval(['z.',group_var{grp},'_lower = EXP2_conformity.c_low_z(EXP2_conformity.group==group_name{grp},:); '])
    eval(['z.',group_var{grp},'_higher = EXP2_conformity.c_high_z(EXP2_conformity.group==group_name{grp},:); '])
end
V=violinplot(x);
V(1).ViolinColor = group_dotC{2};
V(2).ViolinColor = group_dotC{2};
V(3).ViolinColor = group_dotC{3};
V(4).ViolinColor = group_dotC{3};

V(1, 3).ScatterPlot.XData = V(1, 3).ScatterPlot.XData +0.5;
V(1, 3).ViolinPlot.XData  = V(1, 3).ViolinPlot.XData  +0.5;
V(1, 3).BoxPlot.XData = V(1, 3).BoxPlot.XData   +0.5;
V(1, 3).WhiskerPlot.XData  = V(1, 3).WhiskerPlot.XData   +0.5;
V(1, 3).MedianPlot.XData  = V(1, 3).MedianPlot.XData   +0.5;
V(1, 4).ScatterPlot.XData = V(1, 4).ScatterPlot.XData +0.5;
V(1, 4).ViolinPlot.XData  = V(1, 4).ViolinPlot.XData  +0.5;
V(1, 4).BoxPlot.XData = V(1, 4).BoxPlot.XData   +0.5;
V(1, 4).WhiskerPlot.XData  = V(1, 4).WhiskerPlot.XData   +0.5;
V(1, 4).MedianPlot.XData  = V(1, 4).MedianPlot.XData   +0.5;

scatter([1,2, 3.5, 4.5],[nanmean(x.LD_lower),nanmean(x.LD_higher),nanmean(x.HD_lower),nanmean(x.HD_higher)],20,'filled','r')
ylabel('Conformity')
xticks([1,2,3.5, 4.5])
yline(0,'--');
xlim([0.4 5.1]); ylim([-0.4 1.5]);%ylim(ylim_s); %
xticklabels({'Low','High','Low','High'});
set(gca,'FontSize',14,'LineWidth',1)

% saveas(gcf,['../_figure_tiff/figure2_f.tiff'])
% close all

    % rm ANOVA
    tmp_data_LD = [z.LD_lower,z.LD_higher]; tmp_data_LD(isnan(tmp_data_LD),:)=[];
    tmp_data_HD = [z.HD_lower,z.HD_higher]; tmp_data_HD(isnan(tmp_data_HD),:)=[];
    [~, tbl] = anova_rm({tmp_data_LD,tmp_data_HD},'off'); 
    disp(tbl)
    disp(' ')
    clearvars tbl tmp_data_*
    
disp('LD ')
disp(['lower : ',num2str(round(nanmean(x.LD_lower),2)),' ± ',num2str(round(nanstd(x.LD_lower),2))])
[~,p,~,st]=ttest(z.LD_lower);
disp(['t(',num2str(st.df),')=',num2str(st.tstat),', p=',num2str(p)])
clearvars p st
disp(['higher : ',num2str(round(nanmean(x.LD_higher),2)),' ± ',num2str(round(nanstd(x.LD_higher),2))])
[~,p,~,st]=ttest(z.LD_higher);
disp(['t(',num2str(st.df),')=',num2str(st.tstat),', p=',num2str(p)])
clearvars p st
[~,p,~,st]=ttest(z.LD_lower, z.LD_higher);
disp(['lower vs higher: t(',num2str(st.df),')=',num2str(st.tstat),', p=',num2str(p)])
clearvars p st
disp(' ')

disp('HD ')
disp(['lower : ',num2str(round(nanmean(x.HD_lower),2)),' ± ',num2str(round(nanstd(x.HD_lower),2))])
[~,p,~,st]=ttest(z.HD_lower);
disp(['t(',num2str(st.df),')=',num2str(st.tstat),', p=',num2str(p)])
clearvars p st
disp(['higher : ',num2str(round(nanmean(x.HD_higher),2)),' ± ',num2str(round(nanstd(x.HD_higher),2))])
[~,p,~,st]=ttest(z.HD_higher);
disp(['t(',num2str(st.df),')=',num2str(st.tstat),', p=',num2str(p)])
clearvars p st
[~,p,~,st]=ttest(z.HD_lower, z.HD_higher);
disp(['lower vs higher: t(',num2str(st.df),')=',num2str(st.tstat),', p=',num2str(p)])
clearvars p st
disp(' ')


[~,p,~,st]=ttest2(z.LD_lower, z.HD_lower);
disp(['lower conformity LD vs HD : t(',num2str(st.df),')=',num2str(st.tstat),', p=',num2str(p)])
clearvars p st
[~,p,~,st]=ttest2(z.LD_higher, z.HD_higher); 
disp(['higher conformity LD vs HD : t(',num2str(st.df),')=',num2str(st.tstat),', p=',num2str(p)])
clearvars p st
disp(' ')
clearvars x V x_* z

