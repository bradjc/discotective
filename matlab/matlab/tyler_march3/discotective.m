% the discotective
%
% at the moment, it is segmenting pretty well.
% uncomment want you want to see as output.

clear all;
close all;

bin_fudge = -8; 
staff_range = 1.9;
plotted = 0;

% %{ 
% load image:
img = imread('samples/kings.jpg');

% grayscale:
gray_img = 0.2126*img(:,:,1)+0.7152*img(:,:,2)+0.0722*img(:, :, 3);
gray_img = double(gray_img);

% additional setup:
[h w] = size(img);

% output gray image:
% figure
% imagesc(gray_img), colormap(gray), title('initial gray')

% binarize:
cur_img = gray_img;
bin_img = binarize(cur_img, bin_fudge);

% output binarized:
% figure
% imagesc(1-bin_img), colormap(gray), title('binarized')

% crop:
cur_img = bin_img;
crop_img = crop(cur_img);

% output cropped:
% figure
% imagesc(1-crop_img), colormap(gray), title('cropped')

% deskew:
cur_img = crop_img;
deskew_img = deskew(cur_img);

% output deskewed:
figure
imagesc(1-deskew_img), colormap(gray), title('deskewed')

% optional save (for skipping previous steps):
% save('deskew_img.mat', 'deskew_img');
% %}
% load('deskew_img.mat');

% split staffs:
cur_img = deskew_img;
[staff_lines staff_bounds line_w] = staff_segment(cur_img, staff_range);

% music parameters:
sl_width = round(mean(mean(diff(staff_lines))));

% loop through staffs:
for staff=1:size(staff_bounds,1)
% for staff=1:1, % just first staff

    % isolate staff:
    cur_img = deskew_img;
    top = staff_bounds(staff, 1);
    bot = staff_bounds(staff, 2);
    start_for_measure=staff_lines(1,staff)-top;
    finish_for_measure=staff_lines(5,staff)-top;
    staff_img = cur_img(top:bot, :);
    
    % trim staff:
    cur_img = staff_img;
    trimmed_img = trim_staff(cur_img);
    between_staff_img=trimmed_img(start_for_measure:finish_for_measure, :);
    keyboard
    % ouput trimmed staff:
    % figure
    % imagesc(1 - trimmed_img), colormap(gray)
    
    % isolate smaller images:
    cur_img = trimmed_img;
    small_bounds = segment_symbols(cur_img, sl_width);
    [measure_lines, measure_bounds]=measure_segment(  between_staff_img );
    for measureNumber=1:size(measure_bounds,1)
        measure_start = measure_bounds(measureNumber, 1);
        measure_finish = measure_bounds(measureNumber, 2);
        measure_img=trimmed_img(:,measure_start:measure_finish);
        
        %output current measure:
        figure
        this_title=sprintf('measure # %d',measureNumber);
        imagesc(1-measure_img),colormap(gray),title(this_title)
        
        
        [line_thickness, line_spacing] = get_staff_parameters(measure_img);
        staff_height = 5*line_thickness + 4*line_spacing;
        note_height = 2*line_thickness + line_spacing;

        % segment symbols:
        cur_img = measure_img;
        symbol_cuts = segment_symbols(cur_img, sl_thickness);

        % output individual symbols:
        [a b] = size(symbol_cuts);
        for i=1:a,
          symbol=cur_img(:, symbol_cuts(i, 1):symbol_cuts(i, 2));
          if(i==17)
              joe = symbol;
          end
          symbol = remove_staff_lines(symbol,line_thickness);
          figure
          imagesc(1-symbol), colormap(gray)
        end
        pause
    end
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
%                 subplot(5, 4, plotted)
%                 imagesc(1 - cur_img(t:b, l:r)), colormap(gray)
%             else
%                 plotted = 0;
%                 figure
%             end
%         end
%         
%     end
end
