function [groupings, goodLines] = find_top_bottom(img,height_min,leftCutoff)
% finds all vertical lines (stems, measure markers)
% Returns:
% groupings - indices within goodLines array of start and end of each vertical line
%   ex: [40 42
%        55 58
%        100 110]
%
% goodLines - array of structs for each vertical found
%   .top
%   .bottom
%   .left
%   .right

[h w] = size(img);



goodLines = [];

for col = 1:w
    

    
    column = img(:,col);
    starts = [];
    for i = 2:h
        if(~column(i-1) && column(i))
            starts = [starts i]; %y position of each start of vertical black run
        end
    end
    
    for start = starts;
        inLine = 1;
        cursor = [start  col];
        shift = 0;
        shift_max = 3; % maximum pixels line is allowed to shift left/right
        
        while(inLine)
            step = 0;
            if ( img(cursor(1)+1,cursor(2)) ) % line continues below
                cursor = [cursor(1)+1, cursor(2)];
                step = 1;
            end

            if ( cursor(2)+1 <= w && ~step && shift < shift_max) % to the bottom right
                if (img(cursor(1)+1,cursor(2)+1) )
                    cursor = [cursor(1)+1, cursor(2)+1];
                    step = 1;
                    shift = shift + 1;
                end
            end
                
            if ( cursor(2)-1 >= 1 && ~step && shift < shift_max) % to the bottom left
                if (img(cursor(1)+1,cursor(2)-1) )
                    cursor = [cursor(1)+1, cursor(2)-1];
                    step = 1;
                    shift = shift + 1;
                end
            end
                
            if(cursor(1) - start > height_min) % line is already long enough
                shift_max = shift;  % dont allow any more shifting left/right
            end
            
            if(~step || abs(shift) > shift_max) % can't continue black run
                top = start; %top
                bottom = cursor(1); %bottom
                left = min([col cursor(2)]);
                right = max([col cursor(2)]);
                left = left + leftCutoff - 1;
                right = right + leftCutoff - 1;
                
                % if line is tall enough, then we accept
                line_height = bottom - top;
                if (line_height >= height_min)
                    line_struct = struct('top',start,'bottom',bottom,'left',left,'right',right,'index',col);
                    goodLines = [goodLines line_struct];                   
                    
                end
             
                inLine = 0;
            end
            
        end % end while in line
    
    end % end for thru each starting location    
    
end % end for thru each column

xlocs = [];
for i=1:length(goodLines)
    xlocs = [xlocs goodLines(i).left];
end

% GROUP LINES TOGETHER
groupings = group(xlocs, 10); %2nd arg chosen to group close lines together






end