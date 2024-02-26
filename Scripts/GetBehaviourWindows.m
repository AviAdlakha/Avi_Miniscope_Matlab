%% Need to describe the windows we want to extract the data from.
% To only get the data after the 4 outcomes.

path='Z:\Data\Avi_Data\Salience\ExperimentalCohort';
files=dir(path);
Animals=files(3:end);


files = dir(fullfile(path, '**', 'events\table.csv'));
%%
for i = 1:length(files)
    folder=files(i).folder;
    string=strrep(folder, path, '');
    
    parts=split(string,"\");
    Mouse=['Mouse' parts{2}];
    F=split(parts{4},"_");
    Session=['s' F{2}];
    
    if contains(F{3},".")
        G=split(F{3},".");
        Number=[G{1} "_" G{2}];
    else
        Number=F{3};
    end
    try
        Cohort.(Mouse).(Session).(Number).BehaviourData=readtable(fullfile(files(i).folder,files(i).name));
    catch ME
        disp(ME)        
    end
end
    %%
        

table=readtable("Z:\Data\Avi_Data\Salience\ExperimentalCohort\59\2023-11-12\P3.2_50pctReward_session19\trials\table.csv");
minTS= readtable("Z:\Data\Avi_Data\Salience\ExperimentalCohort\59\2023-11-12\P3.2_50pctReward_session19\videos\miniscope\timestamps\Timestamps_01.csv");

Tags=struct();
Tags.gs1=table.Time(strcmp(table.Tag,'gs1'));
Tags.gs2=table.Time(strcmp(table.Tag,'gs2'));
Tags.ngs1=table.Time(strcmp(table.Tag,'ngs1'));
Tags.ngs2=table.Time(strcmp(table.Tag,'ngs2'));

Tags.gf1=table.Time(strcmp(table.Tag,'gf1'));
Tags.gf2=table.Time(strcmp(table.Tag,'gf2'));
Tags.ngf1=table.Time(strcmp(table.Tag,'ngf1'));
Tags.ngf2=table.Time(strcmp(table.Tag,'ngf2'));
%%
clearvars Tags2
bt=fieldnames(Tags);
Tags2=struct();
for i = 1:length(bt)
Tags2.(bt{i})=T2F(Tags.(bt{i}),minTS);
end
%%
Tags=Tags2;
imagesc(norm_d)
hold on;
for i = 1:length(Tags.gs1)
    line([Tags.gs1(i), Tags.gs1(i)], ylim, 'Color', 'green', 'LineWidth', lineThickness);
end
for i = 1:length(Tags.gs2)
    line([Tags.gs2(i), Tags.gs2(i)], ylim, 'Color', 'green', 'LineWidth', lineThickness);
end
for i = 1:length(Tags.ngs1)
    line([Tags.ngs1(i), Tags.ngs1(i)], ylim, 'Color', 'red', 'LineWidth', lineThickness);
end
for i = 1:length(Tags.ngs2)
    line([Tags.ngs2(i), Tags.ngs2(i)], ylim, 'Color', 'red', 'LineWidth', lineThickness);
end
hold off;

% Add labels, title, etc. if needed
xlabel('Frames');
ylabel('Cells/ROI');
title('Temporal Traces');