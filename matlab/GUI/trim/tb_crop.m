function [img] = tb_crop(img)

% this algorithm roughly crops out blackness 
% from the top and bottom

[h w] = size(img);

% project in both dimensions:
proj_onto_y = sum(img, 2);

% initial values:
crop_t = 1;
crop_b = h;

% create threshold:
w_thrsh = 0.1 * w;

% crop out sides with large amounts of black:
while (proj_onto_y(crop_t + 4) > w_thrsh)
    crop_t = crop_t + 4;
end

while (proj_onto_y(crop_b - 4) > w_thrsh)
    crop_b = crop_b - 4;
end

% crop image:
img = img(crop_t:crop_b, :);

end