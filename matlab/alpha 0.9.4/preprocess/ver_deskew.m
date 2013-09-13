function [new_img] = ver_deskew(img)

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

[h w] = size(img);

%%% SETUP %%%

% x indices:
x = 1:w;
a1 = w;
a2 = 1;
c1 = a1;
c2 = a2;

% initial values:
bmax1 = round(7*h/8);
bmax2 = bmax1;
dmax1 = round(h/4);
dmax2 = dmax1;

% steps:
stepsizes = [50 31 23 19 11 7 3 1];
restrictions = linspace(0.7, 0.4, length(stepsizes));
steps = 25;

%%% OPTIMIZE B1, B2, D1, and D2 points %%%

% iterate step size:
max_b = -1;
for ind = 1:length(stepsizes);
    
    % initial general parameters:
    sz = stepsizes(ind);
    rs = restrictions(ind);
    
    % initial bottom half parameters:
    mn1_b = max(rs*h, bmax1 - floor(steps/2)*sz);
    mn2_b = max(rs*h, bmax2 - floor(steps/2)*sz);
    mx1_b = min(h-3, bmax1 + floor(steps/2)*sz);
    mx2_b = min(h-3, bmax2 + floor(steps/2)*sz);
    
    % iteration for bottom half:
    for b1=round(linspace(mn1_b, mx1_b, steps)),
        for b2=round(linspace(mn2_b, mx2_b, steps)),
            
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
    
    % initial top half parameters):
    max_d = -1;
    mn1_d = max(3, dmax1 - floor(steps/2)*sz);
    mn2_d = max(3, dmax2 - floor(steps/2)*sz);
    mx1_d = min(bmax1-15, dmax1 + floor(steps/2)*sz);
    mx2_d = min(bmax2-15, dmax2 + floor(steps/2)*sz);
    
    % iteration for top half:
    for d1=round(linspace(mn1_d, mx1_d, steps)),
        for d2=round(linspace(mn2_d, mx2_d, steps)),
            
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

% shorten variable names:
b1 = bmax1;
b2 = bmax2;
d1 = dmax1;
d2 = dmax2;


%%% DEBUG %%%
    
% y1 = (b1 - b2)/(a1 - a2)*(x - a1) + b1;
% y2 = (d1 - d2)/(c1 - c2)*(x - c1) + d1;
% img(sub2ind(size(img), round(y1), x)) = 2.5;
% img(sub2ind(size(img), round(y2), x)) = 2.5;


%%% CORRECT %%%

if (abs((b2 - b1) - (d2 - d1)) > 2)
    
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
  
    %%% PERFORM TRANSFORMATION %%%
    
    new_img = zeros(h, w);
    for row=1:h,
        for col=1:w,
            % calculate coordinate from which to take pixel:
            old_y = round(y_vp + (row-y_vp)./r(col));
            
            % boundary checking:
            old_y = max(old_y, 1);
            old_y = min(old_y, h);
            
            % assign pixel in new image:
            new_img(row, col) = img(old_y, col);
        end
    end
    
else
    
    %%% PERFORM ROTATION %%%
    
    theta = -atan((d2-d1)/w);
    m_y = round(h/2);
    m_x = round(w/2);
    
    new_img = zeros(h, w);
    for row=1:h,
        for col=1:w,
            % calculate coordinate from which to take pixel:
            old_y = m_y + (row - m_y)*cos(theta) + (col - m_x)*sin(theta);
            old_x = m_x + -(row - m_y)*sin(theta) + (col - m_x)*cos(theta);
            old_y = round(old_y);
            old_x = round(old_x);
            
            % boundary checking:
            old_y = max(old_y, 1);
            old_y = min(old_y, h);
            old_x = max(old_x, 1);
            old_x = min(old_x, w);
            
            % assign pixel in new image:
            new_img(row, col) = img(old_y, old_x);
        end
    end
   
end

end