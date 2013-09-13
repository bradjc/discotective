
img = [];

%read in the same file
%figure();
fid = fopen('notes_gone.bin','rb');        %open file
for i=1:268
    data = fread(fid, 227*8, 'bit1');
    img = [img; data'];
end
fclose(fid);

img = double(img)*-1;

%img = img/max(img(:));

%colormap(gray);
%imagesc(img);

imwrite(img, 'notes_gone.tiff', 'Compression', 'none');
%imwrite(img, gray, 'grayscale.png', 'bitdepth', 8);
imshow('notes_gone.tiff');

