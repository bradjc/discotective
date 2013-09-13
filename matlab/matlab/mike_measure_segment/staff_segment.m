function [staff_lines staff_bounds line_w] = staff_segment(img, range_f)

% this code uses a projection to determine cuts for 
% segmenting a music page into individual lines of music

[h w] = size(img);

% projection on to vertical axis:
proj_onto_y = sum(img , 2);

% calculate threshold:
thrsh = 0.42 * max(proj_onto_y);
crude_lines = find(proj_onto_y > thrsh);

% create array holding y values of all stafflines:
staff_lines = [];
line_w = [];
cl = crude_lines;
l = length(cl);
i = 1;
while (i < l)
    s_begin = cl(i);
    
    % next staffline must be at least two pixels away:
    while ( (i+1)<l) && ((cl(i)+1)==cl(i+1)||((cl(i)+2)==cl(i+1)))
        i = i + 1;
    end
    s_end = cl(i);
    
    % add staffline to array:
    staff_lines = [staff_lines round((s_begin + s_end)/2)];
    line_w = [line_w s_end - s_begin];
    i = i + 1;
end

% averaeg line width:
line_w = round(mean(line_w));

% search for any incorrect lines
% (check against others):
kill = [];
dif = median(diff(staff_lines));
fudge = dif/5;
l = length(staff_lines);
i = 1;
while (i<(l-5)),
    test = staff_lines(i:i+4);
	if max(abs(diff(test)) - dif > fudge)
       kill = [kill i];
       i = i + 1;
    else
        i = i + 5;
    end
end

% kill bad stafflines:
staff_lines(kill) = [];

% reshape into groups of staffs:
l = length(staff_lines);
staff_lines = reshape(staff_lines, 5, l/5);%What if l is not a multiple of 5??-MH

% calculate a good place to cut stafflines
% (may want to make the range larger later):
range = round((range_f/2)*mean(staff_lines(5, :) - staff_lines(1, :)));
middles = staff_lines(3, :)';
delta = range*ones(length(middles), 1);
staff_bounds = [max(middles - delta, 1) min(middles + delta, h)];

end