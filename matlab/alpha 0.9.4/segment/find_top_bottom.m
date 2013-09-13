function [groupings, goodLines] = find_top_bottom(img,parameters,leftCutoff)
% finds all vertical lines (stems, measure markers)
% Returns:
% groupings - indices of start and end of each vertical line
%   ex: [40 42
%        55 58
%        100 110]
%
% goodLines - struct for each vertical found
%   .top
%   .bottom
%   .left
%   .right

[h w] = size(img);
staff_height = 5*parameters.thickness + 4*parameters.spacing;



goodLines = [];

for col = 1:w
    column = img(:,col);
    starts = [];
    for i = 2:h
        if(~column(i-1) && column(i))
            starts = [starts i];
        end
    end
    
    for start = starts;
        inLine = 1;
        cursor = [start  col];
        shift = 0;
        
        while(inLine)
            step = 0;
            if ( img(cursor(1)+1,cursor(2)) ) % right below
                cursor = [cursor(1)+1, cursor(2)];
                step = 1;
            end

            if ( cursor(2)+1 <= w && ~step ) % to the bottom right
                if (img(cursor(1)+1,cursor(2)+1) )
                    cursor = [cursor(1)+1, cursor(2)+1];
                    step = 1;
                    shift = shift + 1;
                end
            end
                
            if ( cursor(2)-1 >= 1 && ~step) % to the bottom left
                if (img(cursor(1)+1,cursor(2)-1) )
                    cursor = [cursor(1)+1, cursor(2)-1];
                    step = 1;
                    shift = shift - 1;
                end
            end
                
            if(~step || abs(shift) > 2) % can't continue black run
                top = start; %top
                bottom = cursor(1); %bottom
                left = min([col cursor(2)]);
                right = max([col cursor(2)]);
                left = left + leftCutoff - 1;
                right = right + leftCutoff - 1;
                
                % if line is tall enough, then we accept
                line_height = bottom - top;
                if (line_height >= 0.7*staff_height)
                    line_struct = struct('top',start,'bottom',bottom,'left',left,'right',right);
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
groupings = group(xlocs, 5); %2nd arg chosen to group close lines together

for i=1:size(groupings,1)
    for j=1:2
        groupings(i,j) = find(xlocs==groupings(i,j),1); % revert back to index in goodLines
    end
end





end