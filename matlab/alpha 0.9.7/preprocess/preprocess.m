function [pp_img] = preprocess(img, output)

% this function combines all the necessary steps for preprocessing

% grayscale:
gray_img = 0.2126*img(:,:,1)+0.7152*img(:,:,2)+0.0722*img(:, :, 3);
gray_img = double(gray_img);

% binarize:
cur_img = gray_img;
bin_img = binarize(cur_img);

% output binarized:
if (output.pp)
    figure
    imagesc(1-bin_img), colormap(gray), title('binarized')
end

% crop:
cur_img = bin_img;
cur_img = tb_crop(cur_img);
crop_img = lr_crop(cur_img);

% semi-deskew (straighten horizontal lines):
cur_img = crop_img;
semideskew_img = ver_deskew(cur_img);

% remove blobs:
cur_img = semideskew_img;
clean_img = blob_kill(cur_img, 1, 1);

% finish deskew (straighten vertical lines):
cur_img = clean_img;
deskew_img = hor_deskew(cur_img);

% additional cropping:
cur_img = deskew_img;
pp_img = w_crop(cur_img, 0); %(0 => relaxed & padding)

% output preprocessed:
if (output.pp)
    figure
    imagesc(1-pp_img), colormap(gray), title('preprocessed')
end

end