function [img] = trim_staff(img)

% simple function to trim excess
% space from left and right edges of staff
% adds five pixels of padding

[h w] = size(img);

proj_onto_x = sum(img, 1);

last_l = 1;
last_r = w;
trsh = h * 0.02;
for i=2:round(w/3),
    if (proj_onto_x(i) < trsh)
        last_l = i;
    end    
    if (proj_onto_x(w+1-i) < trsh)
        last_r = w+1-i;
    end
end

proj_onto_y = sum(img, 2);

last_t = 1;
last_b = h;
trsh = w * 0.005;
for i=2:round(h/3),
    if (proj_onto_y(i) < trsh)
        last_t = i;
    end    
    if (proj_onto_y(h+1-i) < trsh)
        last_b = h+1-i;
    end
end

% crop:
img = img(last_t:last_b, last_l:last_r);

% pad with white:
h = last_b - last_t + 1;
img = [zeros(h, 2) img zeros(h, 2)];

w = last_r - last_l + 5;
img = [zeros(2, w); img; zeros(2, w)]; 

end

    