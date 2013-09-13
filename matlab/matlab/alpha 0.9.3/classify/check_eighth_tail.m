function [eighth] = check_eighth_tail(img, params, row, col)
% looks for a connecting tail between eighth notes
% row, col are the guessed starting point for a tail
[h, w] = size(img);

ymoved = 0;

line_spacing = round(params.spacing);

% find black starting pixel
if (img(row,col))
    cursor = [row col];
elseif (img(row-1,col))
    cursor = [row-1 col];
elseif (img(row+1,col))
    cursor = [row+1 col];
elseif (img(row-2,col))
    cursor = [row-2 col];
elseif (img(row+2,col))
    cursor = [row+2 col];
elseif (img(row-3,col))
    cursor = [row-3 col];
elseif (img(row+3,col))
    cursor = [row+3 col];
elseif (img(row-4,col))
    cursor = [row-4 col];
elseif (img(row+4,col))
    cursor = [row+4 col];
elseif (img(row-5,col))
    cursor = [row-5 col];
elseif (img(row+5,col))
    cursor = [row+5 col];
else
    eighth = 0;
    return;
end


extension = 0;
while (extension < round(4 * line_spacing))
    if (img( cursor(1), cursor(2)+1 ))
        cursor = [cursor(1), cursor(2)+1];
    else
        findRow = cursor(1);
        while (~img( findRow, cursor(2)+1) && (findRow < h-5))
            findRow = findRow + 1;
        end
        if (all(img( cursor(1):findRow , cursor(2))) && img(findRow, cursor(2)+1))
            cursor = [findRow, cursor(2)+1];
            ymoved = ymoved + abs(findRow - cursor(1));
        else
            findRow = cursor(1);
            while (~img( findRow, cursor(2)+1) && (findRow > 5))
                findRow = findRow - 1;
            end
            if (all(img( findRow:cursor(1) , cursor(2))) && img(findRow, cursor(2)+1))
                cursor = [findRow, cursor(2)+1];
                ymoved = ymoved + abs(findRow - cursor(1));
            else
                eighth = 0;
                return;
            end
        end
    end
    extension = extension + 1;
end % end while


if (ymoved < 1.2*line_spacing)
    eighth = 1;
end



end