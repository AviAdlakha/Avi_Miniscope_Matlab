function TMP(Cohort,SelAnimals)
%MIP_SP Get Max Image Projection, either from raw image or the final
%spatial footprint, for the given cohort and animal.
%   put spORmp = 1 for raw images, otherwise anything
% or put it =2 for temporal images.

Animals=fieldnames(Cohort);

for a= SelAnimals
    figure
    Sessions=fieldnames(Cohort.(Animals{a}));
    for i= 1:size(Sessions)
        SessionNumbers=fieldnames(Cohort.(Animals{a}).(Sessions{i}));
        for j= 1:size(SessionNumbers)
                subplot(length(Sessions),length(SessionNumbers),j)
                imagesc(Cohort.(Animals{a}).(Sessions{i}).(SessionNumbers{j}).TemporalFootprints');
                tit=[(Animals{a}) (Sessions{i}) (SessionNumbers{j})]
            title('TemporalProj of',tit)
        end
    end
    
end
end