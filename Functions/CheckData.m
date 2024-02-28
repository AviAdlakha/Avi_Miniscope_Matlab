function [NoFields] = CheckData(Cohort,fields,varargin)
%FORALLSESSIONS Summary of this function goes here
%   It checks if a certain field is there in the data or not, returns a
%   table describing the situation
NoFields(1,1)="Has all the data";
if isempty(varargin)
    Animals=fieldnames(Cohort);
else
    Animals=varargin{1};
end
i=1;
for a= 1:size(Animals)
    if length(varargin)<2
        Sessions=fieldnames(Cohort.(Animals{a}));
    else
        Sessions=varargin{2};
    end
    for s= 1:size(Sessions)
        SessionNumbers=fieldnames(Cohort.(Animals{a}).(Sessions{s}));
        for n= 1:size(SessionNumbers)
            for field = fields
%                 try
                    if ~isfield(Cohort.(Animals{a}).(Sessions{s}).(SessionNumbers{n}),field)
%                         fprintf(" Animal %s, Session %s , Number %s doesnt have %s", (Animals{a}), (Sessions{s}), (SessionNumbers{n}), field)
                        NoFields(i,1) = sprintf(" Animal %s, Session %s , Number %s doesnt have %s", (Animals{a}), (Sessions{s}), (SessionNumbers{n}), (field));
                        i=i+1;
                       
%                         Cohort.(Animals{a}).(Sessions{s})=rmfield(Cohort.(Animals{a}).(Sessions{s}),SessionNumbers{n});
%                         add this line, and Cohort in the output when you
%                         want to remove things
                        
                    end
%                 catch exception
%                     disp(exception.message)
                    
%                 end
            end
        end
    end
end
end
