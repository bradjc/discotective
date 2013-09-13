function [result] = group(in, space)
% 'in' is ungrouped array of locations
% 'space' is how far apart two objects must be to be considered part of
% different objects
%
% in = [1 2 4 5 6 10]
% result = [1  2 (start end indices)
%           4  6
%           10 10

i = 1;
xbegin = 1;
xend = 1;
result = [];
while(1)
    while(1)
        if (xend == length(in))
            %result(i,:) = in(xbegin:xend); //CANT HAVE NONRECTANGLE ARRAY
            % =(
            result(i,:) = [in(xbegin) in(xend)];
            return;
        end
        if (in(xend+1) > in(xend) + space)
            %result(i,:) = in(xbegin:xend);
            result(i,:) = [in(xbegin) in(xend)];
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