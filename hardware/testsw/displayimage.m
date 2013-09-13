
img = [];

%read in the same file
figure(6);
fid = fopen('demos1.bin','rb');        %open file
for i=1:1944
    data = fread(fid, 2592, 'uchar');
    img = [img; data'];
end
fclose(fid);

colormap(gray);
imagesc(img);

