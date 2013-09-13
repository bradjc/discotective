gray_img = [];

filename = 'downsamp.bin';

%read in the same file
fid = fopen(filename,'rb');        %open file
for i=1:1944
    data = fread(fid, 648, 'uchar');
    gray_img = [gray_img; data'];
end
fclose(fid);

figure(5);
colormap(gray);
imagesc(gray_img);
title('gray');

figure(6);
colormap(gray);
bin_img = binarize(gray_img, -20);
imagesc(1-bin_img);
title('binarized');

