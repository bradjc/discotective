function [img] = tb_crop(img)

% this algorithm roughly crops out blackness 
% from the top and bottom

[h w] = size(img);

% project in both dimensions:
proj_onto_y = sum(img, 2);

% fraction (amount of pixels) to initial test:
h_frac = 30;

% set up initial crop values:
[dummy crop_t] = max(proj_onto_y(1:h_frac));
[dummy crop_b] = max(proj_onto_y((h-h_frac+1):h));
crop_b = crop_b + h - h_frac - 1;

% create threshold:
w_thrsh = 0.1 * w;

% crop out sides with large amounts of black:
% (turn into do-whiles in c)
while (proj_onto_y(crop_t + 4) > w_thrsh)
    crop_t = crop_t + 4;
end

while (proj_onto_y(crop_b - 4) > w_thrsh)
    crop_b = crop_b - 4;
end

% crop image:
img = img(crop_t:crop_b, :);

end