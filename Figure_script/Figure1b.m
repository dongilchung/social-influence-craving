%% figure 1 (B)
clear; close all; clc
addpath(genpath('../functions'));
load('../data/EXP2_data.mat','*_rating_data')
group_name = {'LD','HD','ED'};
group_title= {'Low Dominant (LD)','High Dominant (HD)','Equal Dominant (ED)'};
CData{1} = [0.1 0.1 0.1];
CData{2} = [0.5 0.5 0.5];
CData{3} = [1 1 1];

%%
figure('Color','w','Position',[200 200 260 430])
for grp = 1:3
    tmp_group_ratings = EXP2_rating_data(strcmp(EXP2_rating_data(:,2),group_name{grp}),3);
    feedbackNum = table();
    for subjidx = 1: length(tmp_group_ratings)
        feedbackNum.lower(subjidx) = sum(tmp_group_ratings{subjidx}.conflict<0);
        feedbackNum.equal(subjidx) = sum(tmp_group_ratings{subjidx}.conflict==0);
        feedbackNum.higher(subjidx) = sum(tmp_group_ratings{subjidx}.conflict>0);
    end
    
    subplot(3,1,grp)
    hold on
    title([group_title{grp}],'FontSize',14)
    % 
    if grp ==1
        y = sortrows(sortrows([feedbackNum.lower, feedbackNum.equal, feedbackNum.higher, feedbackNum.lower-feedbackNum.higher],3,'descend'),1);
    elseif grp==2
        y = sortrows(sortrows([feedbackNum.lower, feedbackNum.equal, feedbackNum.higher, feedbackNum.higher-feedbackNum.lower],1,'descend'),3);
    else
        y = sortrows(sortrows([feedbackNum.lower, feedbackNum.equal, feedbackNum.higher,feedbackNum.lower +feedbackNum.higher],1),4,'descend');
    end
    
    ba1 = bar([1:size(feedbackNum.lower,1)],y ,'stacked','FaceColor','flat','EdgeColor','none','BarWidth', 1);
    ba1(1).CData = CData{1};
    ba1(2).CData = CData{2};
    ba1(3).CData = CData{3}-[0.15 0.15 0.15];
    ylim([0 206]);
    set(gca,'LineWidth',1.2,'FontSize',14);
    xlim([0.5 length(y)+0.5])
    clearvars feedbackNum tmp_group_ratings
    if grp ==3
        xlabel('Participants')
    end
end


