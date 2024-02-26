%% Load data into MATLAB

Cohort=struct(); %Basic stucture to hold all the data
     
while true
    
    prompt = 'Enter animal Name';
    dlgTitle = 'Input Name';
    numLines = 1; % Number of lines in the input box
    defaultString = 'Mouse69'; % Default value (empty in this case)
    userInput = inputdlg(prompt, dlgTitle, numLines, {defaultString});
    
    
    selectedPath = uigetdir('Z:\', 'Select NC data path (Only till session)');
    parts = strsplit(selectedPath, '\');
    SessionName=parts{end};
    Cohort.(userInput{1}).(SessionName)=LoadData(selectedPath); %Loads the data using the function
    
    
    % Ask the user if they want to repeat the action
    userChoice = questdlg('Do you want to add another animal?', 'Another animal?', 'Yes', 'No', 'No');
    
    % Check the user's choice
    if strcmpi(userChoice, 'no')
        break;  % Exit the loop
        
    end
end
clearvars -except Cohort

%% Add the motion
folderpath=[Cohort.Mouse59.OpenField_Session01.NCDFolder '\EzTrackAnalysis'];
files = dir(folderpath);
files = files(~ismember({files.name}, {'.', '..'}));
fileNames = cellfun(@(x) strtok(x, '.'), {files.name}, 'UniformOutput', false);

% Extract file names after '_' and before the extension
% fileNamesWithoutExtension = cell(size(files));
% for i = 1:numel(files)
%     [~, fileName, ext] = fileparts(files(i).name);
%     parts = strsplit(fileName, '_');
%     if numel(parts) > 1
%         fileNamesWithoutExtension{i} = parts{end};
%     else
%         fileNamesWithoutExtension{i} = fileName;
%     end
% end

% Now, 'fileNamesWithoutExtension' contains an array of file names after '_' and before the extension.

for i=1:length(fileNames)
Cohort.Mouse59.OpenField_Session01.BehaviourData.(fileNames{i})=readtable(fullfile(folderpath,files(i).name),'VariableNamingRule', 'preserve');
end

%%

for i=1:54
Corr(i) = corr(motion,traces(:,i));
end

%%
figure;
hold on
plot(motion)
plot(traces(:,2))