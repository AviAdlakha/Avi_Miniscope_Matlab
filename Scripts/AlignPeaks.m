%% Plot for all trials average data

AllTouches=[MiniscopeFrame; MiniscopeFrame2];
d=Cohort.Mouse59.s50pctReward.session03.TemporalFootprints';
norm_d = d ./ max(d, [], 2);
sum_d = sum(norm_d,1);
for i = 1:length(AllTouches)
    if AllTouches(i)==1
        AllTouches(i)=31;
    elseif AllTouches(i)+30>size(norm_d,3)
        AllTouches(i)=AllTouches(i)-30
    end
    TouchCellsFrame(i,:,:)=norm_d(:,AllTouches(i,1)-30:AllTouches(i,1)+30);
end

%% Align Peaks
 for i = 1:size(TouchCellsFrame,2)
    
    A = squeeze(TouchCellsFrame(:,i,:));
    alignedTCF(:,i,:)= alignPeaks(A);
 end
% Display the results

% Display the results
% figure;
% imagesc(alignedArray)

function alignedArray = alignPeaks(originalArray)
    [rows, cols] = size(originalArray);
    alignedArray = zeros(rows, cols);
    [~, maxColumn] = max(originalArray, [], 2)
    % Find the reference row (row with the highest peak)
    refRow = 1;
    
    for i = 1:rows
        % Cross-correlation to find the shift
        if maxColumn(i) < 55 && maxColumn(i) > 5 
            diff = 31-maxColumn(i);
        else
            diff = 0;
        end
        % Find the shift corresponding to the maximum correlation
        %         [~, shift] = max(xcorrResult);
        
        % Apply the shift to align the peaks
        alignedArray(i, :) = circshift(originalArray(i, :), diff);
        
    end
end



function alignedArray = alignPeaks3D(originalArray)
    [rows, cols, depth] = size(originalArray);
    alignedArray = zeros(rows, cols, depth);

    % Find the reference row (row with the highest peak)
    [~, refRow] = max(max(max(originalArray, [], 2), [], 3));

    for i = 1:rows
        % Cross-correlation to find the shift for each slice along the third dimension
        for j = 1:depth
            xcorrResult = xcorr(squeeze(originalArray(refRow, :, j)), squeeze(originalArray(i, :, j)));

            % Find the shift corresponding to the maximum correlation
            [~, shift] = max(xcorrResult);

            % Apply the shift along the third dimension to align the peaks
            alignedArray(i, :, j) = circshift(originalArray(i, :, j), [0, shift - cols]);
        end
    end
end

