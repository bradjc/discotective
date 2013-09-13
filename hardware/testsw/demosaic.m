%img = [];

%read in the same file
%figure(5);
fid = fopen('raw1.bin','rb');        %open file
for i=1:1944
    data = fread(fid, 2592, 'uchar');
    img = [img; data'];
end
fclose(fid);

%colormap(gray);
%imagesc(img);


uimg = uint8(img);
J = demosaic(uimg,'grbg');
figure(1);
imshow(J);