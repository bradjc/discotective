function [img] = trim_staff(img)

% simple function to trim excess
% space from left and right edges of staff

[h w] = size(img);

proj_onto_x = sum(img, 1);

last_l = 1;
last_r = w;
trsh = h * 0.06;
for i=2:round(w/3),
    if (proj_onto_x(i) < trsh)
        last_l = i;
    end    
    if (proj_onto_x(w+1-i) < trsh)
        last_r = w+1-i;
    end
end
last_l = last_l+2;
last_r = last_r-2;

img = img(:, last_l:last_r);

end

    