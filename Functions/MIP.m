function MIP(Cohort,SelAnimals, vargin)
%MIP_SP Get Max Image Projection, either from raw image or the final
%spatial footprint, for the given cohort and animal.
%   put spORmp = 1 for raw images, otherwise anything
% or put it =2 for temporal images.

Animals=fieldnames(Cohort);

for a= SelAnimals
    Sessions=fieldnames(Cohort.(Animals{a}));
    for s= 1:size(Sessions)
        SessionNumbers=fieldnames(Cohort.(Animals{a}).(Sessions{s}));
        for n= 1:size(SessionNumbers)
            try
                if ~isempty(varargin)
                    MIP=cat(3,Cohort.(Animals{a}).(Sessions{s}).(SessionNumbers{n}).CalciumData.MaxProjection);
                else
                    MIP=cat(3,Cohort.(Animals{a}).(Sessions{s}).(SessionNumbers{n}).CalciumData.SpatialFootprints);
                end
                
            catch exception
                fprintf("function failed for Animal %s, Session %s , Number %s ", (Animals{a}), (Sessions{s}), (SessionNumbers{n}))
                disp(exception.message)
            end
            
        end
        
    end
    figure
    imagesc(sum(MIP,3))
    title('Max Image Projection of:', (Animals{a}))
    clearvars MIP
end
end

