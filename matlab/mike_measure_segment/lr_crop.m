function [img] = lr_crop(img)

% this algorithm roughly crops out blackness 
% from the left and right

[h w] = size(img);

% project in both dimensions:
proj_onto_x = sum(img, 1);

% fraction (amount of pixels) to initial test:
w_frac = 10;

% set up initial crop values:
[dummy crop_l] = max(proj_onto_x(1:w_frac));
[dummy crop_r] = max(proj_onto_x((w-w_frac+1):w));
crop_r = crop_r + w - w_frac;

% create threshold:
h_thrsh = 0.2 * h;

% crop out sides with large amounts of black:
% (turn into do-whiles in c)
while (proj_onto_x(crop_l + 4) > h_thrsh)
    crop_l = crop_l + 4;
end

while (proj_onto_x(crop_r - 4) > h_thrsh)
    crop_r = crop_r - 4;
end 

% crop image:
img = img(:, crop_l:crop_r);

end