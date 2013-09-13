function [restFound] = check_line_is_not_rest(img,xbegin,xend,parameters)
% checks around middle of line to make sure it is skinny

[h w] = size(img);

xproj = sum(img, 1);

left_empty = 1;
for i = xbegin-1:-1:1
    if (xproj(i) < 2)
        left_empty = i;
        break;
    end
end

right_empty = w;
for i = xend+1:w
    if (xproj(i) < 2)
        right_empty = i;
        break;
    end
end

left_w = xbegin - left_empty-1;
right_w = right_empty - xend-1;

if (left_w < 4 && right_w < 4)
    restFound = 0;
else
    restFound = 1;
end




end