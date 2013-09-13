function [img] = w_crop(img)

% this algorithm crops out white space
% returns cropped image with 20 pixel cushion

[h w] = size(img);

% project in both dimensions:
proj_onto_x = sum(img, 1);
proj_onto_y = sum(img, 2);

% create threshold:
h_thrsh = 0.02 * h;
w_thrsh = 0.02 * w;

crop_l = 1;
crop_r = w;
crop_t = 1;
crop_b = h;

% crop out sides with large amounts of black:
while (proj_onto_x(crop_l) < h_thrsh)
    crop_l = crop_l + 1;
end

while (proj_onto_x(crop_r) < h_thrsh)
    crop_r = crop_r - 1;
end 
   
while (proj_onto_y(crop_t) < w_thrsh)
    crop_t = crop_t + 1;
end

while (proj_onto_y(crop_b) < w_thrsh)
    crop_b = crop_b - 1;
end

% crop image:
crop_l = max(1, crop_l - 20);
crop_r = min(w, crop_r + 20);
crop_t = max(1, crop_t - 20);
crop_b = min(h, crop_b + 20);

img = img(crop_t:crop_b, crop_l:crop_r);

end