%%

% AllTheSession is the total number of sessions
% Complete analysis done are the ones for which complete analysis is done
% HasData are the ones which went past MotionCorrection
% ToBeDeleted are ones that dont have complete analysis.

% Select the root directory
rootDirectory = uigetdir('Z:\Data\Avi_Data\', 'Select Root Directory');

% Initialize lists to store folder names
HasData = {};
CompleteAnalysisDone={};
AllTheSessions={};

% Get a list of folders in the root directory
Animals = dir(rootDirectory);

% Loop through the contents of the root directory
for i = 1:numel(Animals)
    if Animals(i).isdir && ~strcmp(Animals(i).name, '.') && ~strcmp(Animals(i).name, '..')
        % Enter the first level of directories
        firstLevelDir = fullfile(rootDirectory, Animals(i).name);
        Date = dir(firstLevelDir);
        
        % Loop through the first level of directories
        for j = 1:numel(Date)
            if Date(j).isdir && ~strcmp(Date(j).name, '.') && ~strcmp(Date(j).name, '..')
                % Enter the second level of directories
                secondLevelDir = fullfile(firstLevelDir, Date(j).name);
                Sessions = dir(secondLevelDir);
                
                % Loop through the second level of directories
                for jj = 1:numel(Sessions)
                    if Sessions(jj).isdir && ~strcmp(Sessions(jj).name, '.') && ~strcmp(Sessions(jj).name, '..')
                        % Enter the second level of directories
                        trLevelDir = fullfile(firstLevelDir, Date(j).name, Sessions(jj).name);
                        %                 Sessions = dir(trLevelDir);
                        AllTheSessions{end+1}= fullfile(Sessions(jj).folder, Sessions(jj).name, 'minian-analysis');
                        %                     a=a+1;
                        %                     CompleteList.Animal{a} = Animals(i).name;
                        %                     CompleteList.Date{a} = Date(j).name;
                        %                     CompleteList.Session{a} = Sessions(jj).name;
                        
                        
                        
                        % Check for "minian-analysis" folder
                        minianAnalysisFolder = fullfile(trLevelDir, 'minian-analysis');
                        if exist(minianAnalysisFolder, 'dir') == 7
                            % Add parent folders to the list
                            %                     Analysed.Animal(end+1) = Animals(i).name;
                            %                     Analysed.Date(end+1) = Date(j).name;
                            %                     Analysed.Session(end+1) = Sessions(jj).name;
                            
                            % Check for "data" folder
                            dataFolder = fullfile(minianAnalysisFolder, 'data');
                            if exist(dataFolder, 'dir') == 7
                                % Add parent folder to the data list
                                %                         HasData.Animal(end+1) = Animals(i).name;
                                %                         HasData.Date(end+1) = Date(j).name;
                                %                         HasData.Session(end+1) = Sessions(jj).name;
                                HasData{end+1} = fullfile(Sessions(jj).folder, Sessions(jj).name, 'minian-analysis');
                                % Check for "A.zarr" and "C.zarr" folders
                                azarrFolder = fullfile(dataFolder, 'A.zarr');
                                czarrFolder = fullfile(dataFolder, 'C.zarr');
                                if exist(azarrFolder, 'dir') == 7 && exist(czarrFolder, 'dir') == 7
                                    % Add parent folder to the AZarr list
                                    
                                    CompleteAnalysisDone{end+1} = fullfile(Sessions(jj).folder, Sessions(jj).name, 'minian-analysis');
                                    %                         CompleteAnalysisDone.Date(end+1) = Date(j).name;
                                    %                         CompleteAnalysisDone.Session(end+1) = Sessions(jj).name;
                                    
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
ToBeDeleted=setdiff(AllTheSessions, CompleteAnalysisDone);

%% Separate out the log files from the folders which didnt get analyses completely

choice = questdlg('Do you want to Separate Out the Log Files, and generate a report?', ...
                  'Generate Report:', ...
                  'Yes', 'No', 'No');

if strcmp(choice, 'Yes')
    % Continue with the code for deletion
    
else
    % End the code or handle the cancellation
    disp('Deletion canceled.');
    return; % or use 'error' or 'return' as appropriate
end


HPC_Analysis_Report = struct();
HPC_Analysis_Report.Failed=ToBeDeleted';
HPC_Analysis_Report.Success=CompleteAnalysisDone';
HPC_Analysis_Report.MissingAnalysis={};
HPC_Analysis_Report.MissingLog={}
% Specify the destination folder for the log files
dateStamp = datestr(now, 'dd-mm-yyyy');
destinationFolder = ['Z:\HPC\Logs\' dateStamp '\FailedLogs_' dateStamp];

if exist(destinationFolder, 'dir') ~= 7
    mkdir(destinationFolder);
end

% Loop through each folder path
for i = 1:length(ToBeDeleted)
    currentFolder = ToBeDeleted{i};
    
    % Check if the folder exists
    if exist(currentFolder, 'dir') == 7
        % Get the list of files in the current folder
        files = dir(fullfile(currentFolder, '*.log'));
        
        % Check if any .log files are found
        if ~isempty(files)
            % Copy the first .log file (you can modify this if you want a different criterion)
            sourceFile = fullfile(currentFolder, files(1).name);
            destinationFile = fullfile(destinationFolder, files(1).name);
            
            % Copy the file
            copyfile(sourceFile, destinationFile);
            
            disp(['Copied file from ', currentFolder, ' to ', destinationFile]);
            
        else
            disp(['No .log files found in ', currentFolder]);
            HPC_Analysis_Report.MissingLog{end+1,1}=currentFolder;
        end
    else
        disp(['Folder does not exist: ', currentFolder]);
        HPC_Analysis_Report.MissingAnalysis{end+1,1}=currentFolder;
    end
end
destinationFolder = ['Z:\HPC\Logs\' dateStamp '\SucessfulLogs_' dateStamp];

if exist(destinationFolder, 'dir') ~= 7
    mkdir(destinationFolder);
end

% Loop through each folder path
for i = 1:length(CompleteAnalysisDone)
    currentFolder = CompleteAnalysisDone{i};
    
    % Check if the folder exists
    if exist(currentFolder, 'dir') == 7
        % Get the list of files in the current folder
        files = dir(fullfile(currentFolder, '*.log'));
        
        % Check if any .log files are found
        if ~isempty(files)
            % Copy the first .log file (you can modify this if you want a different criterion)
            sourceFile = fullfile(currentFolder, files(1).name);
            destinationFile = fullfile(destinationFolder, files(1).name);
            
            % Copy the file
            copyfile(sourceFile, destinationFile);
            
            disp(['Copied file from ', currentFolder, ' to ', destinationFile]);
            
            
            
        end
    end
end


%% Save the report


% Specify the full path where you want to save the variable
savePath = 'Z:\Avi_Analysis\Avi_Matlab\Variables\';

% Get the current date as a string in 'dd-mm-yyyy' format
dateStamp = datestr(now, 'dd-mm-yyyy');

% Create a variable name with the date stamp and full path
variableName = fullfile(savePath, ['HPC_Analysis_Report_(AllData)BeforeFINAL' dateStamp]);

% Save the variable with the date stamp in the filename
save(variableName, 'HPC_Analysis_Report');


%% Deleting the failed folders.
s=0;
f=0;
dne=0;

choice = questdlg('Are you sure you want to delete failed folders?', ...
                  'Delete Confirmation', ...
                  'Yes', 'No', 'No');

if strcmp(choice, 'Yes')
    % Continue with the code for deletion
    disp('Item deleted!');
else
    % End the code or handle the cancellation
    disp('Deletion canceled.');
    return; % or use 'error' or 'return' as appropriate
end

% Continue with the rest of your code here
disp('Continuing with the rest of the code...');

for i = 1:numel(ToBeDeleted)
% for i=1;
    folderPath = ToBeDeleted{i};
    
    % Check if the folder exists before attempting to delete
    if exist(folderPath, 'dir')
        % Delete the folder and its contents
         [success, message] = rmdir(folderPath, 's'); % 's' flag deletes recursively
        
        % Check deletion status
        if success
%             fprintf('Folder %s deleted successfully.\n', folderPath);
            s=s+1;
        else
            fprintf('Failed to delete folder %s. Error: %s\n', folderPath, message);
            f=f+1;
        end
    else
%         fprintf('Folder %s does not exist.\n', folderPath);
        dne=dne+1;
    end
end
fprintf('%d folders deleted, %d folders failed, %d folders did not exist \n',s,f,dne);

%% Rename the old analysis.


choice = questdlg('Do you want to rename the analysis, to facilitate new analysis?', ...
    'Rename Analysis', ...
    'Yes', 'No', 'No');

if strcmp(choice, 'Yes')
    % Continue with the code for deletion
    
else
    % End the code or handle the cancellation
    disp('Nothing Renamed');
    return; % or use 'error' or 'return' as appropriate
end

newFolderName = ['analysis_' dateStamp];

% Change the name of each folder
newFolderPaths = cellfun(@(path) moveFolder(path, newFolderName), CompleteAnalysisDone, 'UniformOutput', false);

function newPath = moveFolder(oldPath, newFolderName)
% Extract the parent directory and the current folder name
[parentDir, currentFolder] = fileparts(oldPath);

% Create the new path with the updated folder name
newPath = fullfile(parentDir, newFolderName);

% Rename the folder using movefile
movefile(oldPath, newPath);

% Display a message (optional)
disp(['Renamed folder: ' currentFolder ' to ' newFolderName]);
end
