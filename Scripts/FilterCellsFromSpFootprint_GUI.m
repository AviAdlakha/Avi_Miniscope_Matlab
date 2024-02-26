% Sample 3D double data (replace this with your actual data)
my_3d_double = Cohort.Mouse64.s100pctreward.session04.SpatialFootprints;

% Display the summed image
hFig = figure;
hAx = axes('Parent', hFig);
imshow(sum(my_3d_double, 3), 'Parent', hAx);

% Get user input with ginput
disp('Click on the items you want to delete. Press Enter when done.');
[x, y] = ginput;

% Convert cursor coordinates to indices
% indices = sub2ind(size(my_3d_double), round(y), round(x), ones(size(x)));
% 
% % Set the selected items to zero
% my_3d_double(indices) = 0;

% Update the displayed image
imshow(sum(my_3d_double, 3), 'Parent', hAx);

% Close the figure after a delay
pause(2);
close(hFig);

x_rounded = round(x);
y_rounded = round(y);


% Check for nonzero values at the specified coordinates
for i = 1:size(my_3d_double, 3)
    value_at_coordinates = my_3d_double(y_rounded, x_rounded, i);
    if value_at_coordinates~= 0
        nonzero_values(i) = 1;
    else
        nonzero_values(i)= 0;
    end
end

% Display the results
disp('Nonzero/Non-NaN values in the third dimension at the specified coordinates:');
disp(find(nonzero_values));
