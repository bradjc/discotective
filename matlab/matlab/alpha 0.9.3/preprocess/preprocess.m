function [pp_img] = preprocess(img, output)

% this function combines all the necessary steps for preprocessing

% parameters:
bin_fudge = -20;

% grayscale:
gray_img = 0.2126*img(:,:,1)+0.7152*img(:,:,2)+0.0722*img(:, :, 3);
gray_img = double(gray_img);

% output gray image:
if (output.pp)
    figure
    imagesc(gray_img), colormap(gray), title('grayscaled')
end

% binarize:
cur_img = gray_img;
bin_img = binarize(cur_img, bin_fudge);

% output binarized:
if (output.pp)
    figure
    imagesc(1-bin_img), colormap(gray), title('binarized')
end

% crop:
cur_img = bin_img;
cur_img = tb_crop(cur_img);
cur_img = lr_crop(cur_img);
crop_img = blob_kill(cur_img, 1, 1);

% output cropped image:
if (output.pp)
    figure
    imagesc(1-crop_img), colormap(gray), title('cropped')
end

% semi-deskew (straighten horizontal lines):
cur_img = crop_img;
semideskew_img = ver_deskew(cur_img);

% output semi-deskewed image:
if (output.pp)
    figure
    imagesc(1-semideskew_img), colormap(gray), title('semideskewed')
end

% remove blobs:
cur_img = semideskew_img;
clean_img = blob_kill(cur_img, 1, 1);

% output clean image:
if (output.pp)
    figure
    imagesc(1-clean_img), colormap(gray), title('cleaned')
end

% finish deskew (straighten vertical lines):
cur_img = clean_img;
deskew_img = hor_deskew(cur_img);

% output dewskewed image:
if (output.pp)
    figure
    imagesc(1-deskew_img), colormap(gray), title('deskewed')
end

% additional cropping:
cur_img = deskew_img;
pp_img = w_crop(cur_img, 0); %(0 => relaxed & padding)

% output preprocessed:
if (output.pp)
    figure
    imagesc(1-pp_img), colormap(gray), title('preprocessed')
end

end