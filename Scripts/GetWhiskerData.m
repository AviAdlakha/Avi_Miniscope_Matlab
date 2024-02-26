%% Get whisker track data
folder="Z:\DLC\DLC_Analysis\Mouse59\50pct\Session03_hs2"

load('Z:\Avi_Analysis\Avi_Matlab\Variables\bodyparts.mat')


%% TO PAD THE CSV files so that they load in order, sec1DLC is not greater than sec11DLC.

directory=folder;
% Get a list of all files in the directory
files = dir(fullfile(directory, '*.csv'));
if length(files)>99
    disp("WARNING MORE THAN 100 FILES, NEED MORE PADDING!")
end
% Iterate through each file
for i = 1:length(files)
    file = files(i).name;
    
    % Check if the file name matches the pattern
    if contains(file, 'sec') && endsWith(file, '.csv')
        % Extract the numeric part of the file name
        parts = strsplit(file, 'sec');
        numeric_part = strsplit(parts{2}, 'DLC');
        
        % Pad the numeric part with leading zeros if it's a single digit
        padded_numeric_part = sprintf('%02d', str2double(numeric_part{1}));
        
        % Create the new file name
        new_file_name = sprintf('%ssec%sDLC%s', parts{1}, padded_numeric_part, numeric_part{2});
        
        % Rename the file
        old_path = fullfile(directory, file);
        new_path = fullfile(directory, new_file_name);
        
        % Check if the new file name is different before renaming
        if ~strcmp(old_path, new_path)
            movefile(old_path, new_path);
        end
    end
end
disp("Padded all the csv")


%% Load the csv (labels)

Files=dir(fullfile(folder,'*.csv'));
min_t=zeros(length(Files),1);

for ie=1:length(Files)
        ds = readmatrix(fullfile(folder,Files(ie).name), 'HeaderLines' , 3);
        ds(:, 1) = [];

        % Get time points where its closest to apperture (most likely)
        
        %getting a distance for all the points from the mid line, it should be
        %irrespective of the x. and then using it to calculate the minimum distance
        %for all 4 whiskers, i.e. 32 parameters!!
        
        my= 275;        % median y
        
        min_dist=inf;
        
        for i = 1:size(ds,1)            % This code doesnt take into account the probability.
            
            dist = 0;
            for j = 22:3:115
                dist =  dist+abs(ds(i,j)-my);
            end
            if dist<min_dist
                min_dist=dist;
                min_t(ie,1)=i;
            end
        end
        
end     
disp("csv labels loaded, min dist calculated")
   
%% Get the timestamps for the framenumbers now


tsfolder="Z:\Data\Avi_Data\Salience\ExperimentalCohort\59\2023-10-23\P3.2_50pctReward_session03\videos\hispeed2\timestamps";

tsFile=dir(fullfile(tsfolder, '*.csv'));

for ie = 1:length(tsFile)
    
    % Read the CSV file into a table
    dataTable = readtable(fullfile(tsfolder,tsFile(ie).name));

    % Find the row where the value in column 1 matches the desired value
    matchingRow = find(dataTable.Var1 == min_t(ie,1));
    
    % Check if a match is found
    if ~isempty(matchingRow)
        % Get the corresponding value in column 2
        Timestamp_for_query2(ie,1) = dataTable.Var2(matchingRow);
    end
end




        
%% Plot the bodyparts

imageSize = 608;
% Generate random x and y points for demonstration
selectedItems = listdlg('PromptString', 'Select items:', 'ListString', bodyparts, 'SelectionMode', 'multiple');

figure;
hold on;
for bp = selectedItems*3
    for i=115
        if ds(i,bp)>0.0001
            xPoints(i) = ds(i,bp-2);
            yPoints(i) = ds(i,bp-1);
        else
            xPoints(i)=NaN;
            yPoints(i) = NaN;
        end
    end
scatter(xPoints, yPoints, 'filled');
title('Scatter Plot on a 608x608 Image');
xlabel('X Points');
ylabel('Y Points');
axis([1, imageSize, 1, imageSize]);
grid on;
clearvars xPoints yPoints
end
hold off;

%%
imshow(Firstframe)


% Prompt the user to click points on the image
disp('Click points on the image. Press ENTER when done.');
[x, y] = ginput;

% Display the selected points
disp('Selected points:');
disp([x, y]);

%% Get the closest distance between the whisker lines and the appertures. COULDNT :<

%% Load miniscope timestamps

Timestamps01=readtable("Z:\Data\Avi_Data\Salience\ExperimentalCohort\59\2023-10-23\P3.2_50pctReward_session03\videos\miniscope\timestamps\Timestamps_01.csv");

%% Get the miniscope frame numbers from timestamps

for ie = 1:length(Timestamp_for_query)
    
    % Find the index of the closest value in Timestamps01.VarName2
    [~, idx] = min(abs(Timestamps01.Var2 - Timestamp_for_query2(ie, 1)));
    
    % Get the corresponding value in column 1
    MiniscopeFrame2(ie, 1) = Timestamps01.Var1(idx);
end

%% Plot time
d=Cohort.Mouse59.s50pctReward.session03.TemporalFootprints'
norm_d = d ./ max(d, [], 2);
figure
imagesc(norm_d);
 % Choose your colormap

% Array of x-values where you want to add vertical lines
xValues = MiniscopeFrame1;
x2Values = MiniscopeFrame2;
% Thickness of the vertical lines
lineThickness = 0.5;

% Plot thick red vertical lines at specified x-values
hold on;
for i = 1:length(xValues)
    line([xValues(i), xValues(i)], ylim, 'Color', 'red', 'LineWidth', lineThickness);
end
for i = 1:length(x2Values)
    line([x2Values(i), x2Values(i)], ylim, 'Color', 'red', 'LineWidth', lineThickness);
end
hold off;

% Add labels, title, etc. if needed
xlabel('Frames');
ylabel('Cells/ROI');
title('Temporal Traces');

% Additional x-axis from 0 to 15

