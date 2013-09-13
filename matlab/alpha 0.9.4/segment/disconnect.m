%function [vector_table img_vector] = disconnect(img)
function [cuts] = disconnect(img, min_size)

%%% OVERVIEW %%%
% connected component algorithm to isolate all symbols

% cuts (n*4 vector):
%          | top | bottom | left | right |
% symbol 1 | ...     ...
% symbol 2 | ...

[h w] = size(img);
stack = [];
cuts = [];

nbors = [
    -1 -1
    -1 0
    -1 1
    0 -1
    0 1
    1 -1
    1 0
    1 1];

% loop through all pixels:
for col = 1:w,
    for row = 1:h,
        
        % look for blob:
        if (img(row, col) == 1)
            
            % initialize blob stuff:
            img(row, col) = 0;
            stack = [row col; stack];
            top = row;
            bot = row;
            rig = col;
            lef = col;
            count = 1;
            
            % depth first search:
            while (stack)
                pnt = stack(1, :);
                stack(1, :) = [];
                
                % check neighbors and add to stack if neccessary:
                for n=1:8,
                    np = pnt + nbors(n, :);
                    if (np(1)>0 && np(2)>0 && np(1)<=h && np(2)<=w && img(np(1), np(2)))
                        
                        % add point to stack:
                        stack = [np; stack];
                        
                        % set pixel to white (so that its not checked again):
                        img(np(1), np(2)) = 0;
                        
                        % adjust bounding box:
                        top = min(np(1), top);
                        bot = max(np(1), bot);
                        rig = max(np(2), rig);
                        count = count + 1;
                    end
                end
            end
            
            % check against minimum size:
            if (count > min_size)
                cuts = [cuts; top bot lef rig];
            end
        end
    end
end

end