load lines_circles.mat

figure
for i=1:9
    tmp = line(:,:,i);
    subplot(3,3,i), imagesc(1-tmp), colormap(gray)
end

figure
for i=1:9
    tmp = circle(:,:,i);
    subplot(3,3,i), imagesc(1-tmp), colormap(gray)
end