function [img] = crop(img)

% after binarization, we may be left with large
% amounts of black around the edges of the image.
% this can be problematic for furter steps, 
% especially staff segmentation.  this code crops
% out these large amounts of black.

[h w] = size(img);

% project in both dimensions:
proj_onto_x = sum(img, 1);
proj_onto_y = sum(img, 2);

% fraction (amount of pixels) to initial test:
h_frac = 3;
w_frac = 3;

% set up initial crop values:
[dummy crop_l] = max(proj_onto_x(1:w_frac));
[dummy crop_r] = max(proj_onto_x((w-w_frac+1):w));
crop_r = crop_r + w - w_frac - 1;

[dummy crop_t] = max(proj_onto_y(1:h_frac));
[dummy crop_b] = max(proj_onto_y((h-h_frac+1):h));
crop_b = crop_b + h - h_frac - 1;

% create threshold:
h_thrsh = 0.1 * h;
w_thrsh = 0.1 * w;

% crop out sides with large amounts of black:
while (proj_onto_x(crop_l) > h_thrsh)
    crop_l = crop_l + 1;
end

while (proj_onto_x(crop_r) > h_thrsh)
    crop_r = crop_r - 1;
end 
   
while (proj_onto_y(crop_t) > w_thrsh)
    crop_t = crop_t + 1;
end

while (proj_onto_y(crop_b) > w_thrsh)
    crop_b = crop_b - 1;
end

% crop image:
img = img(crop_t:crop_b, crop_l:crop_r);

end