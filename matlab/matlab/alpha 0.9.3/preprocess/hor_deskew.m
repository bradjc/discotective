function [new_img] = hor_deskew(img)

%%% OVERVIEW %%%
%
% this code works in a similar way to
% the vertical deskew script. it works
% by points along the top and bottom
%   *                *
% ---------------------
%
%
%
%
%
% ---------------------
%  *                *
% where the lines connecting them likely
% run along the edges of the staffs.
% afterward, the vansihing point is calculated
% and we use a transform to correct for skew.

[h w] = size(img);
strt = round(w/10);
img = [zeros(h, strt) img zeros(h, strt)];
[h w] = size(img);

%%% SETUP %%%

y = 1:h;
a1 = h;
a2 = 1;
c1 = a1;
c2 = a2;

% initial values:
bmax1 = round(0.85*w);
bmax2 = bmax1;
dmax1 = round(0.15*w);
dmax2 = dmax1;

% steps:
stepsizes = [31 23 19 11 7 3 1];
restrictions = linspace(0.80, 0.60, length(stepsizes));
steps = 25;
fudge = 5;

%%% OPTIMIZE B1, B2, D1, and D2 points %%%

% iterate step size:
max_b = -2*h;
for ind = 1:length(stepsizes);
    
    % initial general parameters:
    sz = stepsizes(ind);
    rs = restrictions(ind);
    
    % initial parameters for the right side:
    mn1_b = max(rs*w, bmax1 - floor(steps/2)*sz);
    mn2_b = max(rs*w, bmax2 - floor(steps/2)*sz);
    mx1_b = min(w, bmax1 + floor(steps/2)*sz);
    mx2_b = min(w, bmax2 + floor(steps/2)*sz);
    
    % iteration for right half:
    for b1=round(linspace(mn1_b, mx1_b, steps)),
        for b2=round(linspace(mn2_b, mx2_b, steps)),
        
            % draw line between points:
            x_test = round((b1-b2)/(a1-a2)*(y-1)+b2);
    
            % look for large difference in area of line:
            s1 = sum(img(sub2ind(size(img), y, x_test)));
            s2 = sum(img(sub2ind(size(img), y, x_test-fudge)));
            s = s2 - 2*s1;
            
            % maximize:
            if (s > max_b)
                bmax1 = b1-round(fudge/2);
                bmax2 = b2-round(fudge/2);
                max_b = s;
            end
        end
    end
    
    % initial parameters for left side:
    max_d = -2*h^2;
    mn1_d = max(1, dmax1 - floor(steps/2)*sz);
    mn2_d = max(1, dmax2 - floor(steps/2)*sz);
    mx1_d = min((1-rs)*w, bmax1 + floor(steps/2)*sz);
    mx2_d = min((1-rs)*w, bmax2 + floor(steps/2)*sz);
    
    % iteration for left half:
    for d1=round(linspace(mn1_d, mx1_d, steps)),
        for d2=round(linspace(mn2_d, mx2_d, steps)),
        
            % draw line between points:
            x_test = round((d1-d2)/(c1-c2)*(y-1)+d2);
    
            % look for large difference near line:
            s1 = sum(img(sub2ind(size(img), y, x_test)));
            s2 = sum(img(sub2ind(size(img), y, x_test+fudge)));
            s = s2 - 2*s1;
            
            % maximize:
            if (s > max_d)
                dmax1 = d1+round(fudge/2);
                dmax2 = d2+round(fudge/2);
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


%%% CALCULATE VANISHING POINT AND RATIO %%%

% algebra (intersection of two lines):
right = d1 - b1 + a1*(b1-b2)/(a1-a2) - c1*(d1-d2)/(c1-c2);
left = (b1-b2)/(a1-a2) - (d1-d2)/(c1-c2);
y_vp = right / left;
x_vp = (y_vp - a1) * (b1-b2)/(a1-a2) + b1;

% use line with largest slope to calculate ratio for transformation:
if (abs(d1 - d2) < abs(b1 - b2) && (abs(b1 - b2) > 3))
    x = (b1 - b2)/(a1 - a2)*(y - a1) + b1;
    r = (b1 - x_vp)./(x - x_vp);
elseif (abs(d1 - d2) > 3)
    x = (d1 - d2)/(c1 - c2)*(y - c1) + d1;
    r = (d1 - x_vp)./(x - x_vp);
else
    % no correction needed:
    new_img = img';        
    return
end 


%%% DEBUG %%% 

% x1 = (b1 - b2)/(a1 - a2)*(y - a1) + b1;
% x2 = (d1 - d2)/(c1 - c2)*(y - c1) + d1;
% img(sub2ind(size(img), y, round(x1))) = 0.5;
% img(sub2ind(size(img), y, round(x2))) = 0.5;


%%% PERFORM TRANSFORMATION %%%

new_img = zeros(h, w);
for row=1:h,
    for col=1:w,
        % calculate coordinate from which to take pixel:
        old_x = round(x_vp + (col-x_vp)./r(row));
        
        % boundary checking:
        old_x = max(old_x, 1);
        old_x = min(old_x, w);
        
        % assign pixel in new image:
        new_img(row, col) = img(row, old_x);
    end
end

end