
img = [];

%read in the same file
figure(6);
fid = fopen('vga4.bin','rb');        %open file
for i=1:480
    data = fread(fid, 640, 'uchar');
    img = [img; data'];
end
fclose(fid);

colormap(gray);
imagesc(img);

