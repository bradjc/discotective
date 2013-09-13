function [result] = group(in, space)
% group
% groups together 'objects' that are numerically close together
%
%
% 'in' is ungrouped array of locations
% 'space' is how far apart two objects can be to be considered part of the
% same grouping
%
% in = [1 2 4 5 6 10], space = 1
% result = [1  2] (start / end indices)
%          [3  5]
%          [6  6]

if (isempty(in))
    result = [];
    return;
end

i = 1;
xbegin = 1;
xend = 1;
result = [];
while(1)
    while(1)
        if (xend == length(in))
            result(i,:) = [xbegin xend];
            return;
        end
        if (in(xend+1) > in(xend) + space)
            result(i,:) = [xbegin xend];
            xbegin = xend + 1;
            xend = xend + 1;
            i = i + 1;
            if (xbegin > length(in))
                return;
            end
            break;
        end
        
        xend = xend + 1;
    end
    
   
end




end