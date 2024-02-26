function [FramesNumber] = T2F(Timestamps, minTS)
% It converts the timestamps to Frames using the miniscope data.
% Get the Frame number for the time stamps provided.
% Inputs are the query timestamps, and the session struct.

% Check if Timestamps is empty
if isempty(Timestamps)
    FramesNumber = []; % Return an empty array
    return;
end

% Initialize FramesNumber
FramesNumber = zeros(length(Timestamps), 1);

for i = 1:length(Timestamps)
    % Find the index of the closest value in minTS.Var2
    [~, idx] = min(abs(minTS.Var2 - Timestamps(i, 1)));
    
    % Get the corresponding value in column 1
    FramesNumber(i, 1) = minTS.Var1(idx);
end
end

