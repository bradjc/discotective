function [img] = blob_kill(img)

% this algorithm removes black blobs from
% around the image border.  uses a depth
% first search.

% be sure that the blobs are not large
% or the runtime will increase

[h w] = size(img);
stack = [];

nbors = [
    -1 -1
    -1 1
    1 -1
    1 1];

% loop through border pixels:
for col = 1:w,
    for row = 1:h-1:h,
       
        % look for blob:
        if (img(row, col) == 1)
            
            % initialize blob stuff:
            img(row, col) = 0;
            stack = [row col; stack];
            
            % depth first search:
            while (stack)
               pnt = stack(1, :);
               stack(1, :) = [];
                
               % check neighbors:
               for n=1:size(nbors, 1),
                   np = pnt + nbors(n, :);
                   if (np(1)>0 && np(2)>0 && np(1)<=h && np(2)<=w && img(np(1), np(2)))
                       stack = [np; stack];
                       img(np(1), np(2)) = 0;
                   end
               end
            end
        end
    end
end

for col = 1:w-1:w,
    for row = 1:h,
       
        % look for blob:
        if (img(row, col) == 1)
            
            % initialize blob stuff:
            img(row, col) = 0;
            stack = [row col; stack];
            
            % depth first search:
            while (stack)
               pnt = stack(1, :);
               stack(1, :) = [];
                
               % check neighbors:
               for n=1:size(nbors, 1),
                   np = pnt + nbors(n, :);
                   if (np(1)>0 && np(2)>0 && np(1)<=h && np(2)<=w && img(np(1), np(2)))
                       stack = [np; stack];
                       img(np(1), np(2)) = 0;
                   end
               end
            end
        end
    end
end

end