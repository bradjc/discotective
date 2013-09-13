function [handle] = binplot(img)
% plots the binary image img
% returns figure handle

handle = figure;
imagesc(1-img), colormap(gray)

end