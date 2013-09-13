function [restFound] = check_line_is_not_rest_new(img,staff_lines,topCut,xbegin,parameters)
% checks if found vert line is actually a quarter rest
% img is mini_img

[h w] = size(img);

restFound = 0;


% top should be blow top staffline
if (topCut < staff_lines(1)-parameters.spacing/3)
    return; % not rest
end

% bottom should be above last staffline
if (topCut + h > staff_lines(5)+1)
    return; % not rest
end


line_spacing = round(parameters.spacing);
extend = round(1.6*line_spacing);

% should be skinny width
if (w > 4+extend)
    return; % not rest
end

% line for a rest will be in middle of the image if it is a rest, for a
% note it should be on one side
if (xbegin > w/4 && xbegin < 3*w/4)
    restFound = 1;
end





end