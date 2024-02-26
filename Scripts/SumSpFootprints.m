%% Create MIP 
clearvars MIP
Animals=fieldnames(Cohort)
for a= 3
Sessions=fieldnames(Cohort.(Animals{a}))
for i= 1:size(Sessions)
SessionNumbers=fieldnames(Cohort.(Animals{a}).(Sessions{i}))
for j= 1:size(SessionNumbers)
    MIP=cat(3,Cohort.(Animals{a}).(Sessions{i}).(SessionNumbers{j}).SpatialFootprints);
end
end

figure
imagesc(sum(MIP,3))
end
%% Have them shown separately

Sessions=fieldnames(Cohort.Mouse57)
for i= 1:size(Sessions)
SessionNumbers=fieldnames(Cohort.Mouse57.(Sessions{i}))
for j= 1:size(SessionNumbers)
    figure;
    imagesc(sum(Cohort.Mouse57.(Sessions{i}).(SessionNumbers{j}).SpatialFootprints,3));
end
end

%% For MaxProj

clearvars MIP
Animals=fieldnames(Cohort)
for a= 5
    Sessions=fieldnames(Cohort.(Animals{a}))
    for i= 1:size(Sessions)
        SessionNumbers=fieldnames(Cohort.(Animals{a}).(Sessions{i}))
        for j= 1:size(SessionNumbers)
            MIP=cat(3,Cohort.(Animals{a}).(Sessions{i}).(SessionNumbers{j}).MaxProjection);
        end
    end
    figure
    imagesc(sum(MIP,3))
end
