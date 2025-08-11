%% figure S1 (a)
clear; close all; clc
addpath(genpath('../functions'));
load('../data/EXP1_data.mat')
group_name = {'EXP1'};
group_title= {'EXP1'};
CData{1} = [0.1 0.1 0.1];
CData{2} = [0.5 0.5 0.5];
CData{3} = [1 1 1];
group_var = {'EXP1','LD','HD'};
group_name = {'EXP1','LD','HD','ED'};

group_title = {'EXP1','EXP2 - LD','EXP2 - HD'};
group_dotC = {[0.3 0.3 0.3];...
    [73 116 400]/510;...
    [30 148 111]/255};

%% figure S1 (a)
figure('Color','w','Position',[200 200 260 150])
tmp_group_ratings = EXP1_rating_data(:,2);
feedbackNum = table();
for subjidx = 1: length(tmp_group_ratings)
    feedbackNum.lower(subjidx) = sum(tmp_group_ratings{subjidx}.conflict<0);
    feedbackNum.equal(subjidx) = sum(tmp_group_ratings{subjidx}.conflict==0);
    feedbackNum.higher(subjidx) = sum(tmp_group_ratings{subjidx}.conflict>0);
end

hold on
title([group_title{1}],'FontSize',14)
y = sortrows(sortrows([feedbackNum.lower, feedbackNum.equal, feedbackNum.higher, feedbackNum.lower-feedbackNum.higher],3,'descend'),1);
ba1 = bar([1:size(feedbackNum.lower,1)],y(:,1:3) ,'stacked','FaceColor','flat','EdgeColor','none','BarWidth', 1);
ba1(1).CData = CData{1};
ba1(2).CData = CData{2};
ba1(3).CData = CData{3}-[0.15 0.15 0.15];
ylim([0 206]);
set(gca,'LineWidth',1.2,'FontSize',14);
xlim([0.5 length(y)+0.5])
clearvars feedbackNum tmp_group_ratings
xlabel('Participants')
% saveas(gcf, ['../_figure_tiff/figureS1_a.tiff'])
% close all


%% figure S1 (b)
figure('Color','w','Position',[300 300 150 170])
hold on
title({group_title{1}})
tmp_ratings = EXP1_rating_data(:,2);

for subjidx = 1: length(tmp_ratings)
    x(subjidx,1) = nanmean(tmp_ratings{subjidx}.initial_rating);
end
V=violinplot(x);
scatter(1,mean(x),20,'r','filled');
V(1).ViolinColor = group_dotC{1};
ylabel({'Initial rating'});
ylim([0 11]);
xlim([0.3 1.8]); xlabel(' '); xticklabels({''});
set(gca,'LineWidth',1,'FontSize',14);

% saveas(gcf, ['../_figure_tiff/figureS1_b.tiff'])
% close all
clearvars x V tmp_ratings

%% figure S1 (c)
% smoker vs past-smokers
EXP1_smoker_rating_data = EXP1_rating_data(EXP1_questionnaire_data.Smoking1_Past2==1,:);
EXP1_past_rating_data = EXP1_rating_data(EXP1_questionnaire_data.Smoking1_Past2==2,:);

smo_group = {'Smoker','Past-Smoker'};
disp(['Figure S1 (c)'])
for grp = 1:2
    
    figure('Color','w','Position',[grp*300 300 250 200])
    hold on
    title({[smo_group{grp},'  '],' '})
    if grp ==1
        tmp_ratings = EXP1_smoker_rating_data(:,2);
    else
        tmp_ratings = EXP1_past_rating_data(:,2);
    end
    feedbackNum = table();
    for subjidx = 1: length(tmp_ratings)
        x.low(subjidx,1) = nanmean(tmp_ratings{subjidx}.rating_diff(tmp_ratings{subjidx}.conflict<0));
        x.equal(subjidx,1) = nanmean(tmp_ratings{subjidx}.rating_diff(tmp_ratings{subjidx}.conflict==0));
        x.high(subjidx,1) = nanmean(tmp_ratings{subjidx}.rating_diff(tmp_ratings{subjidx}.conflict>0));
    end
    V=violinplot(x);
    V(1).ViolinColor = group_dotC{1};
    V(2).ViolinColor = group_dotC{1};
    V(3).ViolinColor = group_dotC{1};
    scatter([1,2, 3],[nanmean(x.low),nanmean(x.equal),nanmean(x.high)],15,'r','filled')
    
    xticks([1,2, 3]); xticklabels({'Low','Equal','High'}); xlim([0.4 4]);
    ylabel({'\Delta Rating','(Day2 - Day1)'});  
    ylim([-10 8]);
    yline(0,'--');
    set(gca,'LineWidth',1,'FontSize',14);
    
%     saveas(gcf,['../_figure_tiff/figureS1_c_',smo_group{grp},'.tiff'])
%     close all
    
    disp(smo_group{grp})
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
    
    clearvars x V tmp_ratings
end



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

%% figure S1 (d)
% smoker vs past-smokers
EXP1_smoker_conformity = EXP1_conformity(EXP1_questionnaire_data.Smoking1_Past2==1,:);
EXP1_past_conformity = EXP1_conformity(EXP1_questionnaire_data.Smoking1_Past2==2,:);
smo_group_var = {'smoker','past'};
disp('Figure S1 (d)')

figure('Color','w','Position',[600 500 300 200])
hold on
title({'EXP1','Smoker           Past-smoker'})
clearvars x V x_*
for grp = 1:2
    eval(['x.',smo_group_var{grp},'_lower = EXP1_',smo_group_var{grp},'_conformity.c_low; '])
    eval(['x.',smo_group_var{grp},'_higher = EXP1_',smo_group_var{grp},'_conformity.c_high; '])
    eval(['z.',smo_group_var{grp},'_lower = EXP1_',smo_group_var{grp},'_conformity.c_low_z; '])
    eval(['z.',smo_group_var{grp},'_higher = EXP1_',smo_group_var{grp},'_conformity.c_high_z; '])
end
V=violinplot(x);
V(1).ViolinColor = group_dotC{1};
V(2).ViolinColor = group_dotC{1};
V(3).ViolinColor = group_dotC{1};
V(4).ViolinColor = group_dotC{1};

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

scatter([1,2, 3.5, 4.5],[nanmean(x.smoker_lower),nanmean(x.smoker_higher),nanmean(x.past_lower),nanmean(x.past_higher)],20,'filled','r')
ylabel('Conformity')
xticks([1,2,3.5, 4.5])
yline(0,'--');
xlim([0.4 5.1]); ylim([-0.4 1.5]);%ylim(ylim_s); %
xticklabels({'Low','High','Low','High'});
set(gca,'FontSize',14,'LineWidth',1)

% saveas(gcf,['../_figure_tiff/figureS1_d.tiff'])
% close all

disp('Smoker ')
disp(['lower : ',num2str(round(nanmean(x.smoker_lower),2)),' ± ',num2str(round(nanstd(x.smoker_lower),2))])
[~,p,~,st]=ttest(z.smoker_lower);
disp(['t(',num2str(st.df),')=',num2str(st.tstat),', p=',num2str(p)])
clearvars p st
disp(['higher : ',num2str(round(nanmean(x.smoker_higher),2)),' ± ',num2str(round(nanstd(x.smoker_higher),2))])
[~,p,~,st]=ttest(z.smoker_higher);
disp(['t(',num2str(st.df),')=',num2str(st.tstat),', p=',num2str(p)])
clearvars p st
[~,p,~,st]=ttest(z.smoker_lower, z.smoker_higher);
disp(['lower vs higher: t(',num2str(st.df),')=',num2str(st.tstat),', p=',num2str(p)])
clearvars p st
disp(' ')

disp('Past-smoker ')
disp(['lower : ',num2str(round(nanmean(x.past_lower),2)),' ± ',num2str(round(nanstd(x.past_lower),2))])
[~,p,~,st]=ttest(z.past_lower);
disp(['t(',num2str(st.df),')=',num2str(st.tstat),', p=',num2str(p)])
clearvars p st
disp(['higher : ',num2str(round(nanmean(x.past_higher),2)),' ± ',num2str(round(nanstd(x.past_higher),2))])
[~,p,~,st]=ttest(z.past_higher);
disp(['t(',num2str(st.df),')=',num2str(st.tstat),', p=',num2str(p)])
clearvars p st
[~,p,~,st]=ttest(z.past_lower, z.past_higher);
disp(['lower vs higher: t(',num2str(st.df),')=',num2str(st.tstat),', p=',num2str(p)])
clearvars p st
disp(' ')


[~,p,~,st]=ttest2(z.smoker_lower, z.past_lower);
disp(['lower conformity smoker vs past-smoker : t(',num2str(st.df),')=',num2str(st.tstat),', p=',num2str(p)])
clearvars p st
[~,p,~,st]=ttest2(z.smoker_higher, z.past_higher); 
disp(['higher conformity smoker vs past-smoker : t(',num2str(st.df),')=',num2str(st.tstat),', p=',num2str(p)])
clearvars p st
disp(' ')
clearvars x V x_* z
