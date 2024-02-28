%% Discription
% Tried to make a clean script which can be used in a systematic way to
% analyse the Ca Imaging data from Miniscope and Salience Setup.
% clear everything

clear
clc

%% Load the necessary Data.
% We read the NC files created by the python script.
% This is a time consuming step for big datasets, if you have already
% analysed it once, consider saving.

choice = questdlg('Do you wanna reload (time consuming) the data?', ...
                  'Confirmation', ...
                  'Yes', 'No', 'Cancel', 'No');

switch choice
    case 'Yes'
        [Cohort,path,ErrorTable]=ReadNC();
    case 'No'
        load("Z:\Avi_Analysis\CohortSalience.mat");
    case 'Cancel'
        disp('User chose Cancel.');
end



%% Match Cells.

% Ideally I would like to remove some cells first, and then join them.

% To remove lets call up MIP

% Using cell Reg to join them

%Find the sessions which dont have a particular field.
fields=["CalciumData","BehaviourData","Timestamps"];
[NoData]=CheckData(Cohort,fields);

%Delete the ones that dont have that field. %CheckData was used, and the
%delte portion is now commented. This Cohort was saved, overwritten.
%% Deleting junk
SEL=zeros(608,608);
%This code will remove the things not in the lens from all the sessions.
figure
hold on

for i = selectedIndices
    SEL=SEL+Cohort.Mouse56.s100pctreward.session03.CalciumData.SpatialFootprints(:,:,i);
end
imagesc(squeeze(sum(SEL,3)))
%%
% Export the spatial footprints as sessions_ordered, in the arrangement
% wanted.

ExportSpatialFootprints(Cohort);



%%
run('CellReg.m')

% MIP(Cohort,1,0)



%% Calculate Peaks.
% It would only make sense to calculate peaks after cell matching has been
% done.
%Peaks(Cohort)
    
%%
Cohort.BehaviouralData=GetBehaviorTags();

%%
clearvars MiniscopeFrame2 Timestamp_for_query Timestamps01
d = Cohort.Mouse60.s50pctReward.session19.CalciumData.TemporalFootprints';


norm_d = d ./ max(d, [], 2);
figure
imagesc(norm_d);


% Array of x-values where you want to add vertical lines
rowsWithGoSuccess = contains(Cohort.Mouse60.s50pctReward.session19.BehaviourData.Description, 'Started');
Timestamp_for_query = Cohort.Mouse60.s50pctReward.session19.BehaviourData.Time(rowsWithGoSuccess);
Timestamps01=Cohort.Mouse60.s50pctReward.session19.Timestamps;
for ie = 1:length(Timestamp_for_query)
    
    % Find the index of the closest value in Timestamps01.VarName2
    [~, idx] = min(abs(Timestamps01.Var2 - (Timestamp_for_query(ie, 1))));
    
    % Get the corresponding value in column 1
    MiniscopeFrame2(ie, 1) = Timestamps01.Var1(idx);
end

x2Values = MiniscopeFrame2;
% Thickness of the vertical lines
lineThickness = 0.5;

% Plot thick red vertical lines at specified x-values
hold on;
% for i = 1:length(xValues)
%     line([xValues(i), xValues(i)], ylim, 'Color', 'red', 'LineWidth', lineThickness);
% end
for i = 1:length(x2Values)
    line([x2Values(i), x2Values(i)], ylim, 'Color', 'red', 'LineWidth', lineThickness);
end
hold off;

% Add labels, title, etc. if needed
xlabel('Frames');
ylabel('Cells/ROI');
title('Temporal Traces');

%%

% Can be also done with the SUM! Get peaks, and then get different windows, and ask, how likely is it to
% fire in a window, for all sessions. Use findpeaks() to get the peaks. Can
% have different thresholds for which peaks to consider.