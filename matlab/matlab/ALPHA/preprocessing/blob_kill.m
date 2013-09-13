function [img] = blob_kill(img, lr, tb)

%%% OVERVIEW %%%

% this algorithm removes any black images from
% around the image border using a depth first search

% be sure that the blobs are not large
% or the runtime will increase dramatically

% set lr to 1 to remove blobs from the left and right
% set tb to 1 to remove blobs from the top and bottom

%%% SET-UP %%%

[h w] = size(img);
stack = [];
nbors = [
    -1 -1
    -1 1
    1 -1
    1 1];


%%% ALGORITHM %%%

if (lr == 1)
    % loop through left and right border pixels
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

if (tb == 1)
    % loop through top and bottom border pixels:
    for col = 1:w,
        for row = 1:h-1:h,
            
            % look for blob:
            if (img(row, col) == 1)
                
                % set black to white and add to stack:
                img(row, col) = 0;
                stack = [row col; stack];
                
                % depth first search:
                while (stack)
                    pnt = stack(1, :);
                    stack(1, :) = [];
                    
                    % check neighbors and add to stack if necessary:
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

end