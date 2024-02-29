function selectedIndices = SelectCells(matrix)
    % Create figure
    fig = figure('Name', 'Unit Selection', 'NumberTitle', 'off', 'Position', [100, 100, 400, 300]);

    % Display image
    ax = axes('Parent', fig, 'Position', [0.1, 0.3, 0.8, 0.6]);
    imagesc(sum(matrix, 3), 'Parent', ax);
    colormap(gray);
    axis image;

    % Create button
    btn = uicontrol('Style', 'pushbutton', 'String', 'Select Box', 'Position', [150, 10, 100, 30], 'Callback', @selectBox);

    % Initialize selectedIndices
    selectedIndices = [];

    % Callback function
    function selectBox(~, ~)
        % Let the user draw a rectangle on the image
        h = imrect(ax);
        wait(h);
        rectPos = round(getPosition(h));

        % Get the indices of units not in the selected box
        selectedUnits = matrix(rectPos(2):rectPos(2)+rectPos(4), rectPos(1):rectPos(1)+rectPos(3), :);
        selectedIndices = find(sum(selectedUnits, [1, 2]) == 0);

        % Display the indices
        disp('Indices of units not in the selected box:');
        disp(selectedIndices);

        % Export the selectedIndices variable to the workspace
        assignin('base', 'selectedIndices', selectedIndices);
        disp('Selected indices exported to the workspace.');

        % Close the figure and resume execution
        close(fig);
    end

    % Wait for the user to finish selecting indices before returning
    uiwait(fig);
end