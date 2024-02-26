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
        load("Z:\Avi_Analysis\Avi_Matlab\Variables\CohortSalience.mat");
    case 'Cancel'
        disp('User chose Cancel.');
end

%%

funct= @(x) isfield(x,"Timestamps");
ForAllSessions(Cohort,funct)
    



%%
Cohort.BehaviouralData=GetBehaviorTags();