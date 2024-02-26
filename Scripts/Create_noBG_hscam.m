%% Video Analysis
videofolder= 'Z:\Data\Avi_Data\Salience\ExperimentalCohort\59\2023-11-12\P3.2_50pctReward_session19\videos\hispeed2';


videoFilePath = dir(fullfile(videofolder,'*.mkv'));

for i=1:size(videoFilePath,1)
  
        % Create a VideoReader object
        videoReader = VideoReader([videoFilePath(i).folder '\' videoFilePath(i).name]);
        
        Firstframe= read(videoReader,1);
        % imshow(Firstframe) 
        
        % %%
        % Fiftyframe= read(videoReader,350);
        % imshow(Fiftyframe)
        
        %
        % Proframe= imsubtract((255-Fiftyframe),(255-Firstframe))
        % imshow(255-Proframe)
        
        %
        parts=split(videoFilePath(i).name,{'.'});
        directoryPath='Z:\DLC\DLC_Analysis\Mouse59\50pct\Session19_hs2\';
        outputVideoFile = [directoryPath parts{1} '.avi'];  % Replace with the desired output path
        if ~exist(directoryPath, 'dir')
            % If it doesn't exist, create the directory
            mkdir(directoryPath);
            disp(['Directory ', directoryPath, ' created.']);
        end
        outputVideoObj = VideoWriter(outputVideoFile, 'Uncompressed AVI');
        open(outputVideoObj);
        
        % Process each frame, subtracting the first frame
        while hasFrame(videoReader)
            currentFrame = readFrame(videoReader);
            processedFrame = imsubtract((255-currentFrame), (255-Firstframe));
            
            if endsWith(videofolder, '2')
                processedFrame = imrotate(processedFrame, 180);
            end
            % Write the processed frame to the output video file
            writeVideo(outputVideoObj, (255-processedFrame));
        end
        
        % Close the output video file
        close(outputVideoObj);
        
        % Display a message indicating the completion of the process
        disp(['Processing complete. ' outputVideoFile ' created']);
    
    end

        