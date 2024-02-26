function [Cohort,path,errortable] = ReadNC()
%This gets the Calcium and Behaviour files for all the sessions in the
%folder you select. Keep in mind it only fetches behaviour for which there
%are Calcium data. Refer to the HPC filter report for more info on which
%sessions failed etc.

%This will fetch all the data about the given folder to the MATLAB
%workspace. Except for HiSpeed data, or DLC data so far.
path = uigetdir('Z:\Data\', 'Select Folder to analyse');
% Get a list of folders in the root directory
files = dir(fullfile(path,'**','CalciumData.nc'));
errortable=table('Size', [0, 6], 'VariableTypes', {'double', 'string', 'string', 'string', 'string', 'string'}, 'VariableNames', {'Index','Error', 'Mouse','Session','SessionNumber','type'});
Cohort=struct();
for i = 1:size(files,1)
    folder=files(i).folder;
    string2=strrep(folder, path, '');
    
    parts=split(string2,"\");
    Mouse=['Mouse' parts{2}];
    F=split(parts{4},"_");
    Session=['s' F{2}];
    
    if contains(F{3},".")
        G=split(F{3},".");
        Number=[G{1} '_' G{2}];
    else
        Number=F{3};
    end
    
    try
        Cohort.(Mouse).(Session).(Number).CalciumData.SpatialFootprints=ncread(fullfile(files(i).folder,files(i).name),'A');
        Cohort.(Mouse).(Session).(Number).CalciumData.TemporalFootprints=ncread(fullfile(files(i).folder,files(i).name),'C');
        Cohort.(Mouse).(Session).(Number).CalciumData.MaxProjection=ncread(fullfile(files(i).folder,files(i).name),'max_proj');
        
    catch exception
        type="Calcium";
        errortable=[errortable; table(i, string(exception.message) , string(Mouse), string(Session), string(Number) , type , 'VariableNames', {'Index','Error', 'Mouse','Session','SessionNumber','type'})];
        
    end
    try
        Cohort.(Mouse).(Session).(Number).BehaviourData=readtable(fullfile(files(i).folder,'events','table.csv'));
    catch exception
        type="Behaviour";
        errortable=[errortable; table(i, string(exception.message) , string(Mouse), string(Session), string(Number) ,type , 'VariableNames', {'Index','Error', 'Mouse','Session','SessionNumber','type'})];
    end
    try
        Cohort.(Mouse).(Session).(Number).Timestamps=readtable(fullfile(files(i).folder,'videos','miniscope','timestamps','Timestamps_01.csv'));
        if exists(fullfile(files(i).folder,'videos','miniscope','timestamps','Timestamps_02.csv'),'file')==2
            Cohort.(Mouse).(Session).(Number).Timestamps=[Cohort.(Mouse).(Session).(Number).Timestamps; readtable(fullfile(files(i).folder,'videos','miniscope','timestamps','Timestamps_01.csv'))]
        end
    catch exception
        type="Timestamps"
        errortable=[errortable; table(i, string(exception.message) , string(Mouse), string(Session), string(Number) ,type , 'VariableNames', {'Index','Error', 'Mouse','Session','SessionNumber','type'})];
end

end

