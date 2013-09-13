function [top, bottom, xbegin, xend] = find_top_bottom_smart(img)
[h w] = size(img);



begins=[]; 
ends=[];
xlocs = [];

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
                
            if(~step || abs(shift) > 1) % can't continue black run
                begins = [begins start];
                ends = [ends cursor(1)];
                left = min([col cursor(2)]);
                right = max([col cursor(2)]);
                xlocs = [xlocs [left; right]];
                inLine = 0;
            end
            
        end % end while in line
    
    end % end for thru each starting location
end % end for thru each column
    


lengths = ends - begins;
[maximum loc] = max(lengths);

top = begins(loc);
bottom = ends(loc);

others = xlocs(:,lengths > 0.8*maximum);
others = reshape(others,1,2*size(others,2));
xbegin = min(others);
xend = max(others);



end