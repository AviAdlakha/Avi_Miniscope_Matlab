function ForAllSessions(Cohort,funct,varargin)
%FORALLSESSIONS Summary of this function goes here
%   Instead of repeating the code multiple times, and creating class or
%   method, just use this function to use a function on each session.
    
%     if mod(length(userAnimals), 2) ~= 0 || mod(length(userSessions), 2) ~= 0
%         error('Optional inputs must be specified as name-value pairs.');
%     end

    if isempty(varargin)
        Animals=fieldnames(Cohort);
    else
        Animals=varargin{1};
    end
    
for a= 1:size(Animals)
    if length(varargin)<2
        Sessions=fieldnames(Cohort.(Animals{a}));
    else
        Sessions=varargin{2};
    end
    for s= 1:size(Sessions)
        SessionNumbers=fieldnames(Cohort.(Animals{a}).(Sessions{s}));
        for n= 1:size(SessionNumbers)
            try
                feval(funct, Cohort.(Animals{a}).(Sessions{s}).(SessionNumbers{n}))
            catch exception
                fprintf("function failed for Animal %s, Session %s , Number %s ", (Animals{a}), (Sessions{s}), (SessionNumbers{n}))
                disp(exception.message)
            end
        end
    end
end

end

