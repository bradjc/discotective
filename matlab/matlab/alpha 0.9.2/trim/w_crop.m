function [img] = w_crop(img, strict)

% this algorithm crops out white space
% according to a threshold fraction
% returns cropped image with some cushion

[h w] = size(img);

% parameters:
if (strict == 0)
    h_thrsh = 0.012*h; % vertical threshold
    w_thrsh = 0.012*w; % horizontal threshold
    pad_lr = 40;    % pixels in lr_padding
    pad_tb = 20;    % pixels in tb_padding
else
    h_thrsh = 1;
    w_thrsh = 1;
    pad_lr = 0;
    pad_tb = 0;
end



% project in both dimensions:
proj_onto_x = sum(img, 1);
proj_onto_y = sum(img, 2);

% initial values
crop_l = 1;
crop_r = w;
crop_t = 1;
crop_b = h;

% find boundaries for crop:
while (crop_l < w && proj_onto_x(crop_l) < h_thrsh)
    crop_l = crop_l + 1;
end

while (crop_r > 1 && proj_onto_x(crop_r) < h_thrsh)
    crop_r = crop_r - 1;
end 
   
while (crop_t < h && proj_onto_y(crop_t) < w_thrsh)
    crop_t = crop_t + 1;
end

while (crop_b > 1 && proj_onto_y(crop_b) < w_thrsh)
    crop_b = crop_b - 1;
end

% cushion:
crop_l = max(1, crop_l - pad_lr);
crop_r = min(w, crop_r + pad_tb);
crop_t = max(1, crop_t - pad_lr);
crop_b = min(h, crop_b + pad_tb);

% crop:
img = img(crop_t:crop_b, crop_l:crop_r);

end