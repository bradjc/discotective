function [line_w] = get_line_width(img)

[h, w] = size(img);

max_line_w = 15;

% choose columns of image to test:
num_x_vals = 16;
x_vals = round(((1:16)-0.5)/16 * w);

% create bins for adding widths of segments:
histo = zeros(1, max_line_w);

% loop through x values:
for ind = 1:num_x_vals,
   
    col = x_vals(ind);

    % loop through y values:
    row = 1;
    while (row < h)
    
        % whitespace:
        while (row <= h && img(row, col) == 0)
            row = row + 1;
        end
        
        % black run:
        leng = 0;
        while (row <= h && img(row, col) == 1)
            row = row + 1;
            leng = leng + 1;
        end
        
        % test length of run and add to bin:
        if (leng > 0 && leng < max_line_w)
            histo(leng) = histo(leng) + 1;
        end
       
    end
end

% take maximum bin:
[a b] = max(histo);

% compute expected value with nearby bins (averaging):
rnge = max(b-2, 1):min(b+2, num_x_vals);
sm = sum(histo(rnge));
line_w = dot(rnge, histo(rnge))/sm;

end