%% Figure 3
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

%% conformity
EXP2_conformity = table();
EXP2_conformity.ID = EXP2_rating_data(:,1);
EXP2_conformity.group = categorical(EXP2_rating_data(:,2));
EXP2_conformity.Smoking1_Past2 = EXP2_questionnaire_data.Smoking1_Past2;

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

%% smoker and past-smoker data
EXP2_questionnaire_data_smoker = EXP2_questionnaire_data(EXP2_questionnaire_data.Smoking1_Past2==1,:);
EXP2_conformity_smoker = EXP2_conformity(EXP2_questionnaire_data.Smoking1_Past2==1,:);
EXP2_rating_data_smoker = EXP2_rating_data(EXP2_questionnaire_data.Smoking1_Past2==1,:);

EXP2_questionnaire_data_past = EXP2_questionnaire_data(EXP2_questionnaire_data.Smoking1_Past2==2,:);
EXP2_conformity_past = EXP2_conformity(EXP2_questionnaire_data.Smoking1_Past2==2,:);
EXP2_rating_data_past = EXP2_rating_data(EXP2_questionnaire_data.Smoking1_Past2==2,:);

% Exclude past-smoker who smoke last 12, and 24 hours
disp(['Past-smokers who smoke last 12 hours N= ',num2str(sum(EXP2_questionnaire_data_past.num_cigarettes_last_12h>0))])
disp(['Past-smokers who smoke last 24 hours N= ',num2str(sum(EXP2_questionnaire_data_past.num_cigarettes_last_24h>0))])
[idxs12,~] = find(EXP2_questionnaire_data_past.num_cigarettes_last_12h>0);
[idxs24,~] = find(EXP2_questionnaire_data_past.num_cigarettes_last_24h>0);
exclude_idx = unique([idxs12;idxs24]); clearvars idxs12 idxs24
disp(['LD exclude N = ', num2str(sum( strcmp(EXP2_questionnaire_data_past.group(exclude_idx) , 'LD')))]);
disp(['HD exclude N = ', num2str(sum( strcmp(EXP2_questionnaire_data_past.group(exclude_idx) , 'HD')))]);
disp(['ED exclude N = ', num2str(sum( strcmp(EXP2_questionnaire_data_past.group(exclude_idx) , 'ED')))]);

EXP2_rating_data_past(EXP2_questionnaire_data_past.num_cigarettes_last_12h>0,:)=[];
EXP2_conformity_past(EXP2_questionnaire_data_past.num_cigarettes_last_12h>0,:)=[];
EXP2_questionnaire_data_past(EXP2_questionnaire_data_past.num_cigarettes_last_12h>0,:)=[];

EXP2_rating_data_past(EXP2_questionnaire_data_past.num_cigarettes_last_24h>0,:)=[];
EXP2_conformity_past(EXP2_questionnaire_data_past.num_cigarettes_last_24h>0,:)=[];
EXP2_questionnaire_data_past(EXP2_questionnaire_data_past.num_cigarettes_last_24h>0,:)=[];

%% figure 3
for grp = 1:2
    disp(['Figure 3 (',char(grp + 'a' - 1),')'])
    figure('Color','w','Position',[grp*300 500 280 200])
    hold on
    title({group_title{grp},'      Smoker         Past-smoker'})
    
    x.low_smoker = EXP2_conformity_smoker.c_low(EXP2_conformity_smoker.group==group_var{grp});
    x.high_smoker = EXP2_conformity_smoker.c_high(EXP2_conformity_smoker.group==group_var{grp});
    x.low_past = EXP2_conformity_past.c_low(EXP2_conformity_past.group==group_var{grp});
    x.high_past = EXP2_conformity_past.c_high(EXP2_conformity_past.group==group_var{grp});
    
    z.low_smoker = EXP2_conformity_smoker.c_low_z(EXP2_conformity_smoker.group==group_var{grp});
    z.high_smoker = EXP2_conformity_smoker.c_high_z(EXP2_conformity_smoker.group==group_var{grp});
    z.low_past = EXP2_conformity_past.c_low_z(EXP2_conformity_past.group==group_var{grp});
    z.high_past = EXP2_conformity_past.c_high_z(EXP2_conformity_past.group==group_var{grp});
    
    V=violinplot(x);
    V(1).ViolinColor = group_dotC{grp};
    V(2).ViolinColor = group_dotC{grp};
    V(3).ViolinColor = group_dotC{grp};
    V(4).ViolinColor = group_dotC{grp};
    
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
    
    scatter([1,2, 3.8 4.8],[nanmean(x.low_smoker),nanmean(x.high_smoker),nanmean(x.low_past), nanmean(x.high_past)],15,'r','filled')
    
    xticks([1,2, 3.8 4.8]); xticklabels({'Low','High','Low','High'}); xlim([0.2 5.6]);
    ylabel({'Conformity'});
    ylim([-0.4 1.4]);
    yline(0,'--');
    set(gca,'LineWidth',1,'FontSize',14);
    
%     saveas(gcf,['../_figure_tiff/figure3_',char(grp + 'a' - 1),'.tiff'])
%     close all
    
    disp(group_name{grp})
    disp('smoker')
    [~,p,~,st] = ttest(z.low_smoker);
    disp(['low = ',num2str(nanmean(x.low_smoker)),' ± ',num2str(nanstd(x.low_smoker))])
    disp(['t(',num2str(st.df),')=',num2str(st.tstat),', P=',num2str(p)])
    clearvars p st
    [~,p,~,st] = ttest(z.high_smoker);
    disp(['high = ',num2str(nanmean(x.high_smoker)),' ± ',num2str(nanstd(x.high_smoker))])
    disp(['t(',num2str(st.df),')=',num2str(st.tstat),', P=',num2str(p)])
    clearvars p st
    
    [~,p,~,st] = ttest(z.low_smoker, z.high_smoker);
    disp(['low vs high: t(',num2str(st.df),')=',num2str(st.tstat),', P=',num2str(p)])
    clearvars p st
    disp(' ')
    
    disp('past-smoker')
    if length(z.low_past)<20
        [p,~,st] = signrank(z.low_past);
        disp(['low = ',num2str(nanmean(x.low_past)),' ± ',num2str(nanstd(x.low_past))])
        disp(['signed rank = ',num2str(st.signedrank),', P=',num2str(p)])
        clearvars p st
        [p,~,st] = signrank(z.high_past);
        disp(['high = ',num2str(nanmean(x.high_past)),' ± ',num2str(nanstd(x.high_past))])
        disp(['signed rank = ',num2str(st.signedrank),', P=',num2str(p)])
        clearvars p st
        
        [p,~,st] = ranksum(z.low_past, z.high_past);
        disp(['low vs high: ranksum =',num2str(st.ranksum),', P=',num2str(p)])
        clearvars p st
        disp(' ')
    else
        [~,p,~,st] = ttest(z.low_past);
        disp(['low = ',num2str(nanmean(x.low_past)),' ± ',num2str(nanstd(x.low_past))])
        disp(['t(',num2str(st.df),')=',num2str(st.tstat),', P=',num2str(p)])
        clearvars p st
        [~,p,~,st] = ttest(z.high_past);
        disp(['high = ',num2str(nanmean(x.high_past)),' ± ',num2str(nanstd(x.high_past))])
        disp(['t(',num2str(st.df),')=',num2str(st.tstat),', P=',num2str(p)])
        clearvars p st
        
        [~,p,~,st] = ttest(z.low_past, z.high_past);
        disp(['low vs high: t(',num2str(st.df),')=',num2str(st.tstat),', P=',num2str(p)])
        clearvars p st
        disp(' ')
    end
    
    % rm ANOVA
    tmp_smoker = [z.low_smoker, z.high_smoker]; tmp_smoker(isnan(tmp_smoker),:)=[];
    tmp_past = [z.low_past, z.high_past]; tmp_past(isnan(tmp_past),:)=[];
    [~, tbl] = anova_rm({tmp_smoker, tmp_past},'off'); 
    disp(' ')
    disp(tbl)
    disp(' ')
    clearvars tbl tmp_smoker tmp_past
    
    % 2-sample t-test
    [~,p,~,st] = ttest2(z.low_smoker, z.low_past);
    disp(['low, smoker vs past-smoker: t(',num2str(st.df),')=',num2str(st.tstat),', P=',num2str(p)])
    clearvars p st
    [~,p,~,st] = ttest2(z.high_smoker, z.high_past);
    disp(['high, smoker vs past-smoker: t(',num2str(st.df),')=',num2str(st.tstat),', P=',num2str(p)])
    clearvars p st
    
    clearvars x z V tmp_ratings tbl
end

