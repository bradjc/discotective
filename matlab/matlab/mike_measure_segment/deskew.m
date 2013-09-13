function [new_img] = deskew(img)

%%% OVERVIEW %%%
%
% this code works by first choosing
% the points d1, d2, b1, and b2.
% d2|             |
%   |             |d1
%   |             |
%   |             |
%   |             |b1
% b2|             |
%   |             |
% the points are chosen so that the line
% that connects them passes through many
% dark pixels (a staffline hopefully).
%
% next the vanishing point is calculated
% using algebra, and a simple map is
% created to adjust for any skew
%
% as a result, the image is corrected
% so that the stafflines are more horizontal
%
% later, we can possibly correct for skew in the
% perpendicular dimension, straightening the vertical
% lines as well (this can be accomplished in a similar
% manner).
%
% this algorithm is also limited by any bowing
% or wavy lines on the page.

[h w] = size(img);


%%% SETUP %%%

% x indices:
x = 1:w;
a1 = w;
a2 = 1;
c1 = a1;
c2 = a2;

% initial values:
bmax1 = round(3*h/4);
bmax2 = bmax1;
dmax1 = round(h/4);
dmax2 = dmax1;

% steps:
steps = [40 15 4 1];

%%% OPTIMIZE B1, B2, D1, and D2 points %%%

% iterate step size:
for ind = 1:length(steps);
    
    % initial parameters (bottom half):
    max_b = -1;
    stp = steps(ind);
    mn1_b = max(0.7*h, bmax1 - 5*stp);
    mn2_b = max(0.7*h, bmax2 - 5*stp);
    mx1_b = min(h, bmax1 + 5* stp);
    mx2_b = min(h, bmax2 + 5* stp);
    
    % iteration for bottom half:
    for b1=round(linspace(mn1_b, mx1_b, 11)),
        for b2=round(linspace(mn2_b, mx2_b, 11)),
        
            % draw line between points:
            y_test = round((b1-b2)/(a1-a2)*(x-1)+b2);
    
            % sum pixels intersected by line:
            s = sum(img(sub2ind(size(img), y_test, x)));
        
            % maximize:
            if (s > max_b)
                bmax1 = b1;
                bmax2 = b2;
                max_b = s;
            end
        end
    end
    
    % initial parameters (top half):
    max_d = -1;
    mn1_d = max(1, dmax1 - 5*stp);
    mn2_d = max(1, dmax2 - 5*stp);
    mx1_d = min(0.3*h, bmax1 + 5* stp);
    mx2_d = min(0.3*h, bmax2 + 5* stp);
    
    % iteration for top half:
    for d1=round(linspace(mn1_d, mx1_d, 11)),
        for d2=round(linspace(mn2_d, mx2_d, 11)),
        
            % draw line between points:
            y_test = round((d1-d2)/(c1-c2)*(x-1)+d2);
    
            % sum pixels intersected by line:
            s = sum(img(sub2ind(size(img), y_test, x)));
        
            % maximize:
            if (s > max_d)
                dmax1 = d1;
                dmax2 = d2;
                max_d = s;
            end
        end
    end
end

% reassign values:
b1 = bmax1;
b2 = bmax2;
d1 = dmax1;
d2 = dmax2;


%%% CALCULATE VANISHING POINT AND RATIO %%%

% algebra (intersection of two lines):
right = d1 - b1 + a1*(b1-b2)/(a1-a2) - c1*(d1-d2)/(c1-c2);
left = (b1-b2)/(a1-a2) - (d1-d2)/(c1-c2);
x_vp = right / left;
y_vp = (x_vp - a1) * (b1-b2)/(a1-a2) + b1;

% use line with largest slope to calculate ratio for transformation:
if (abs(d1 - d2) < abs(b1 - b2) && (abs(b1 - b2) > 3))
    y = (b1 - b2)/(a1 - a2)*(x - a1) + b1;
    r = (b1 - y_vp)./(y - y_vp);
elseif (abs(d1 - d2) > 3)
    y = (d1 - d2)/(c1 - c2)*(x - c1) + d1;
    r = (d1 - y_vp)./(y - y_vp);
else
    % no correction needed:
    new_img = img;        
    return
end 

% debugging output:
% y1 = (b1 - b2)/(a1 - a2)*(x - a1) + b1;
% y2 = (d1 - d2)/(c1 - c2)*(x - c1) + d1;
% img(sub2ind(size(img), round(y1), x)) = 0.5;
% img(sub2ind(size(img), round(y2), x)) = 0.5;
% imagesc(1-img) 


%%% PERFORM TRANSFORMATION %%%

new_img = zeros(h, w);
for row=1:h,
    for col=1:w,
        % calculate coordinate from which to take pixel:
        old_y = floor(y_vp + (row-y_vp)./r(col));
        
        % boundary checking:
        old_y = max(old_y, 1);
        old_y = min(old_y, h);
        
        % assign pixel in new image:
        new_img(row, col) = img(old_y, col);
    end
end

end