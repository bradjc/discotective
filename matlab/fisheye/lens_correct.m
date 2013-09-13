clear all;
close all;

load('templeoftime.mat');

fudge = 0.18;

[h w] = size(img);

m_x = w/2;
m_y = h/2;

y_scalers = fudge * (((1:w) - m_x)/w).^2;

new_img = ones(h, w);

for col = 1:w,
    
    scaler = y_scalers(col);
    
    for row = 1:h,
        
        temp = row  + m_y * scaler;
        old_row = round(temp/(1+scaler));
        old_row = max(old_row, 1);
        old_row = min(old_row, h);
        
        new_img(row, col) = img(old_row, col);
        
    end
end

figure
imagesc(1-img), colormap(gray)
title('original')

figure
imagesc(1-new_img), colormap(gray)
title('lens corrected')
