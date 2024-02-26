function MIP(Cohort,SelAnimals, mode)
%MIP_SP Get Max Image Projection, either from raw image or the final
%spatial footprint, for the given cohort and animal.
%   put spORmp = 1 for raw images, otherwise anything
% or put it =2 for temporal images.

Animals=fieldnames(Cohort);
for a= SelAnimals
    Sessions=fieldnames(Cohort.(Animals{a}));
    for i= 1:size(Sessions)
        SessionNumbers=fieldnames(Cohort.(Animals{a}).(Sessions{i}));
        for j= 1:size(SessionNumbers)
            if mode == 1
                MIP=cat(3,Cohort.(Animals{a}).(Sessions{i}).(SessionNumbers{j}).MaxProjection);
            else
                MIP=cat(3,Cohort.(Animals{a}).(Sessions{i}).(SessionNumbers{j}).SpatialFootprints);
            end
        end
    end
    
    figure
    imagesc(sum(MIP,3))
    title('Max Image Projection of:', (Animals{a}))
end
end

