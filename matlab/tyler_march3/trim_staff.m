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

%{
proj_onto_y = sum(img, 2);
last_t = 1;
last_b = h;
trsh = w * 0.01;
for i=2:round(h/4),
    if (proj_onto_y(i) < trsh)
        last_t = i;
    end    
    if (proj_onto_y(h+1-i) < trsh)
        last_b = h+1-i;
    end
end
last_t = last_t+2;
last_b = last_b-2;
%}

img = img(:, last_l:last_r);
%img = img(last_t:last_b, last_l:last_r);


end

    