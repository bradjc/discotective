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
%
% the algorithm is adopted from ver_deskew, so
% the variable names are confusing at the moment.

[h w] = size(img);
img = [zeros(h, round(w/10)) img zeros(h, round(w/10))];

img = img';
[h w] = size(img);

%%% SETUP %%%

% x indices:
x = 1:w;
a1 = w;
a2 = 1;
c1 = a1;
c2 = a2;

% initial values:
bmax1 = round(0.92*h);
bmax2 = bmax1;
dmax1 = round(0.08*h);
dmax2 = dmax1;

% steps:
%stepsizes = round([h/20 h/60 h/200 1]);
stepsizes = round([50 30 15 8 4 1]);
steps = 21;

fudge = 10;

%%% OPTIMIZE B1, B2, D1, and D2 points %%%

% iterate step size:
for ind = 1:length(stepsizes);
    
    % initial parameters (bottom half):
    max_b = -2*w;
    stp = stepsizes(ind);
    mn1_b = max(0.65*h, bmax1 - 0.5*(steps-1)*stp);
    mn2_b = max(0.65*h, bmax2 - 0.5*(steps-1)*stp);
    mx1_b = min(h, bmax1 + 0.5*(steps-1)*stp);
    mx2_b = min(h, bmax2 + 0.5*(steps-1)*stp);
    
    % iteration for bottom half:
    for b1=round(linspace(mn1_b, mx1_b, steps)),
        for b2=round(linspace(mn2_b, mx2_b, steps)),
        
            % draw line between points:
            y_test = round((b1-b2)/(a1-a2)*(x-1)+b2);
    
            % sum pixels intersected by line:
            s1 = sum(img(sub2ind(size(img), y_test, x)));
            s2 = sum(img(sub2ind(size(img), y_test-fudge, x)));
            s = s2 - s1 ^ 2;
            
            % maximize:
            if (s > max_b)
                bmax1 = b1-round(fudge/2);
                bmax2 = b2-round(fudge/2);
                max_b = s;
            end
        end
    end
    
    % initial parameters (top half):
    max_d = -2*w;
    mn1_d = max(1, dmax1 - 0.5*(steps-1)*stp);
    mn2_d = max(1, dmax2 - 0.5*(steps-1)*stp);
    mx1_d = min(0.35*h, bmax1 + 0.5*(steps-1)*stp);
    mx2_d = min(0.35*h, bmax2 + 0.5*(steps-1)*stp);
    
    % iteration for top half:
    for d1=round(linspace(mn1_d, mx1_d, steps)),
        for d2=round(linspace(mn2_d, mx2_d, steps)),
        
            % draw line between points:
            y_test = round((d1-d2)/(c1-c2)*(x-1)+d2);
    
            % sum pixels intersected by line:
            s1 = sum(img(sub2ind(size(img), y_test, x)));
            s2 = sum(img(sub2ind(size(img), y_test+fudge, x)));
            s = s2 - s1 ^ 2;
            
            % maximize:
            if (s > max_d)
                dmax1 = d1+round(fudge/2);
                dmax2 = d2+round(fudge/2);
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
    new_img = img';        
    return
end 

% debugging output:
% y1 = (b1 - b2)/(a1 - a2)*(x - a1) + b1;
% y2 = (d1 - d2)/(c1 - c2)*(x - c1) + d1;
% img(sub2ind(size(img), round(y1), x)) = 0.5;
% img(sub2ind(size(img), round(y2), x)) = 0.5;
% imagesc((1-img)') 


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

new_img = new_img';

end