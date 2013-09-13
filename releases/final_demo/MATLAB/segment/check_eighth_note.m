function [isEighth] = check_eighth_note(img,xbegin,xend,parameters)
% checks whether note is an eighth note
%
% returns:
% isEighth - 1 if note is an eighth note (single)

[h,w] = size(img);

% find x coordinate of starting position
start = 1;
if (xbegin - 1 > 0)
    start = xbegin -1;
end
if (xbegin - 2 > 0)
    start = xbegin -2;
end

% below algorithm looks for white space inbetween stem and flag
flags = 0;
for i=1:h
    % states
    hitBlack = 0;
    hitWhite = 0;
    
    
    for j=start:w-1
        if (~hitBlack && img(i,j))
            hitBlack = 1;
        elseif (hitBlack && ~hitWhite && ~any(img(i,j:j+1)))
            hitWhite = 1;
        elseif (hitWhite && img(i,j))
            flags = flags + 1;
            break;
        end
    end
end



if (flags > h/3)
    isEighth = 1;
else
    isEighth = 0;
end


end