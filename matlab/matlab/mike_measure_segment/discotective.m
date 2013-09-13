% the discotective
%
% the preprocessing seems to be working well
% for a variety of test cases
%
% symbol segmentation still needs work.

clear all;
close all;

bin_fudge = -15; 
staff_range = 1.9;
plotted = 0;

% %{ 
% load image:
img = imread('samples/skew.jpg');

% grayscale:
gray_img = 0.2126*img(:,:,1)+0.7152*img(:,:,2)+0.0722*img(:, :, 3);
gray_img = double(gray_img);

% output gray image:
figure
imagesc(gray_img), colormap(gray), title('grayscaled')

% binarize:
cur_img = gray_img;
bin_img = binarize(cur_img, bin_fudge);

% output binarized:
figure
imagesc(1-bin_img), colormap(gray), title('binarized')

% semi-deskew (straighten horizontal lines):
cur_img = bin_img;
semideskew_img = ver_deskew(cur_img);

% output semi-deskewed image:
figure
imagesc(1-semideskew_img), colormap(gray), title('semideskewed')

% crop top and bottom, left and right:
cur_img = semideskew_img;
temp = tb_crop(cur_img);
crop_img = lr_crop(temp);

% output cropped image:
figure
imagesc(1-crop_img), colormap(gray), title('cropped')

% remove blobs:
cur_img = crop_img;
clean_img = blob_kill(cur_img);

% output clean image:
figure
imagesc(1-clean_img), colormap(gray), title('cleaned')

% finish deskew (straighten vertical lines):
cur_img = clean_img;
deskew_img = hor_deskew(cur_img);

% output dewskewed image:
figure
imagesc(1-deskew_img), colormap(gray), title('deskewed')

% additional cropping:
cur_img = deskew_img;
temp_img = w_crop(cur_img);
temp_img = lr_crop(temp_img);
pp_img = w_crop(temp_img);

% output preprocessed:
figure
imagesc(1-pp_img), colormap(gray), title('preprocessed')

% optional save (for skipping previous steps):
% save('pp_img.mat', 'pp_img');
% %}
% load('pp_img.mat');

% split staffs:
cur_img = pp_img;
[staff_lines staff_bounds line_w] = staff_segment(cur_img, staff_range);

% music parameters:
sl_width = round(mean(mean(diff(staff_lines))));

% loop through staffs:
for staff=1:size(staff_bounds,1)
% for staff=1:1, % just first staff

    % isolate staff:
    cur_img = pp_img;
    top = staff_bounds(staff, 1);
%     top_for_measure=staff_lines(1,staff)-top;
%     bot_for_measure=staff_lines(5,staff)-top;

    bot = staff_bounds(staff, 2);
    staff_img = cur_img(top:bot, :);
    
    % trim staff:
    cur_img = staff_img;
    trimmed_img = trim_staff(cur_img);
    
    % ouput trimmed staff:
    % figure
    % imagesc(1 - trimmed_img), colormap(gray)
    
    % isolate smaller images:
    cur_img = trimmed_img;
    [measure_lines, measure_bounds]=measure_segment(  trimmed_img );
    for measureNumber=1:size(measure_bounds,1)
        measure_start = measure_bounds(measureNumber, 1);
        measure_finish = measure_bounds(measureNumber, 2);
        measure_img=trimmed_img(:,measure_start:measure_finish);
        
        %output current measure:
        figure
        this_title=sprintf('measure # %d',measureNumber);
        imagesc(1-measure_img),colormap(gray),title(this_title)
        pause
    end
%     small_bounds = segment_symbols(cur_img, sl_width);
    
    % loop through smaller images:
%     for symbol=1:length(small_bounds),
%         
%         % isolate smaller images and remove stafflines:
%         cur_img = trimmed_img;
%         left = small_bounds(symbol, 1);
%         right = small_bounds(symbol, 2);
%         small_img = cur_img(:, left:right);
%         lineless_img = remove_staff_lines(small_img, line_w);
%         % note: line_w is set in staff_segment
%         
%         % output symbol:
%         % figure
%         % imagesc(1-small_img), colormap(gray);
%         
%         % isolate symbols:
%         cur_img = small_img;
%         symbol_cuts = disconnect(lineless_img, 1.5*line_w^2);
%         for ind=1:size(symbol_cuts, 1),
%             t = symbol_cuts(ind, 1);
%             b = symbol_cuts(ind, 2);
%             l = symbol_cuts(ind, 3);
%             r = symbol_cuts(ind, 4);
%             
%             if (plotted < 20)
%                 plotted = plotted + 1;
%                 %subplot(5, 4, plotted)
%                 %imagesc(1 - lineless_img(t:b, l:r)), colormap(gray)
%             else
%                 plotted = 0;
%                 %figure
%             end
%         end
%         
%     end
end
