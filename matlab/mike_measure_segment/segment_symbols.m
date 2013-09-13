function [symbol_bounds] = segment_symbols(img, sl_width)

% this code locates symbols by checking for blackness
% in between stafflines.  known problems with it
% include: 1. mis-cuts due to non-straight stafflines, 
% 2. grouping more than one symbol together when they
% are too close, and 3. mis-cuts due to notes above
% and below staff

[h w] = size(img);

% determine the location of stafflines:
[staff_lines dummy] = staff_segment(img, 1);

% add an additional staffline location above and below the staff
% (used for detecting symbols above and below the staff):
staff_lines = [2*staff_lines(1)-staff_lines(2); staff_lines];
staff_lines = [staff_lines; 2*staff_lines(6) - staff_lines(5)];

% determine pixel indices in between stafflines for testing symbols
% (they are located 3/8 and 5/8 the distance between lines)
middle_lines = zeros(12, 1);
for i=1:6,
    middle_lines(2*i-1) = round((staff_lines(i)+staff_lines(i+1))/2);
    middle_lines(2*i) = round((staff_lines(i)+staff_lines(i+1))/2);
end

% remove all rows from image except those to be tested:
findings = img(middle_lines, :);

% project rows onto x axis:
proj_onto_x = sum(findings, 1);

% locate symbols (check if 2 or more test points are "lit up"):
crude_symbols = find(proj_onto_x > 1);

% determine cuts
cs = crude_symbols;
symbol_bounds = [];
l = length(cs);
while (i < l)
    s_begin = cs(i);
    
    % next symbol must be more than 1.2 * width between stafflines
    % (this is required to accurately detect whole and half notes):
    while ( ((i+1)<l) && ((cs(i+1) < cs(i) + round(1.2*sl_width))) )
        i = i + 1;
    end
    s_end = cs(i);
    
    % pad cuts one quarter of the width between stafflines
    s_begin = max(1, s_begin-round(sl_width/4));
    s_end = min(w, s_end+round(sl_width/4));
    
    % add cut to return variable:
    symbol_bounds = [symbol_bounds; s_begin s_end];
    
    i = i + 1;
end

% optional output:
%img(:, symbol_bounds(:, 1)) = -1;
%img(:, symbol_bounds(:, 2)) = 2;
%imagesc(img), colormap(gray)

end