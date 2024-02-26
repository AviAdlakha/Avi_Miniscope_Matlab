%% Load multisens data

Mouse60zeromaze.Temp=ncread("D:\Data\Batch4Data\#60\2023-10-06\ZeroMaze_Session1\videos\miniscope\minian_analysis\minian_dataset.nc",'C')

%%
cue.air=[30 210 270 420 600 690 750]
cue.light=[60 180 360 480 540 720 780]
cue.sound = [90 150 330 450 510 630 810]
cue.odour = [120 240 300 390 570 660 840]

%%

tp.air= cue.air*30
tp.light=cue.light*30
tp.sound=cue.sound*30
tp.odour=cue.odour*30


%%

% Fig1= figure;
for i = 1:7
    temp.air{i}=Mouse60Multisens.Temp(tp.air(i):tp.air(i)+90,:);
    temp.light{i}=Mouse60Multisens.Temp(tp.light(i):tp.light(i)+90,:);
    temp.sound{i}=Mouse60Multisens.Temp(tp.sound(i):tp.sound(i)+90,:);
    temp.odour{i}=Mouse60Multisens.Temp(tp.odour(i):tp.odour(i)+90,:);
end

%%

signal=sum(rmmissing(Mouse60Multisens.Temp,2),2);

figure;
plot(signal(300:end), 'b'); % 'b' specifies a blue line, you can change the color

hold on; % Keep the current plot and add vertical lines

% Plot vertical lines for each set of time points with different colors
% vline(zmtppp, {'r', 'LineWidth', 1});
vline(tp.air, {'r', 'LineWidth', 2}, 'Air'); % 'r' specifies a red line
vline(tp.light, {'color', [0.2 0.6 0.2], 'LineWidth', 2}, 'Light'); % 'g' specifies a green line
vline(tp.sound, {'k', 'LineWidth', 2}, 'Sound'); % 'm' specifies a magenta line
vline(tp.odour, {'color',[0.2 0.2 0.6], 'LineWidth', 2}, 'Odour'); % 'c' specifies a cyan line

% Customize the plot as needed
title('Combined activity of cells.');
xlabel('Time');
ylabel('Signal Intensity');
legend('Calcium Trace', 'Air', 'Light', 'Sound', 'Odour');
grid on; % Add grid lines if desired

hold off; % Release the hold on the current plot


%%

zmtp=[8 9 10 11 24 34 49 60 94 102 123 134 139 146 162 172 176 209 261 270 294 310 317 357 383 401 424 440 488 496 513 549 597]
zmtpp= zmtp*30
scalefac=21317/17910;
zmtppp=zmtpp*scalefac;

%% Check the number of cells obtained in each session


Animals=fieldnames(Cohort1);
k=1;
Number=[];
for a= 3
    Sessions=fieldnames(Cohort1.(Animals{a}));
    for i= 1:size(Sessions)
        SessionNumbers=fieldnames(Cohort1.(Animals{a}).(Sessions{i}));
        for j= 1:size(SessionNumbers)
            Number(k,1)=size(Cohort1.(Animals{a}).(Sessions{i}).(SessionNumbers{j}).SpatialFootprints,3);
            k=k+1;
        end
    end
end

%%
for i=1:79
    if table.Tag(i)== 'gs1' || table.Tag(i) == 'gs2'
    tag(i,1)=1;
    elseif table.Tag(i)== 'ngs1'|| table.Tag(i)== 'ngs2'
    tag(i,1)=2;
    elseif table.Tag(i) == 'gf1'|| table.Tag(i)=='gf2'
    tag(i,1)=3;
    elseif table.Tag(i)=='ngf1'|| table.Tag(i)=='ngf2'
    tag(i,1)=4;
    end
end

%%
figure
% Sample data
x = 1:27509; % X values
y = Cohort.Mouse59.s50pctReward.session03.TemporalFootprints(:,11);
% Use mesh to create a surface plot


area(x,y)


