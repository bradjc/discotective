function [img] = remove_staff_lines(img, line_thickness)

[h,w] = size(img);

yprojection = sum(img,2);

max_project = max(yprojection);
staffLines = [];
for i=1:h
    if (yprojection(i) > .85*max_project)    %delete staff line, twidle with the 85% later
       staffLines = [staffLines i];
    end
end

%%% REMOVE STAFF LINES %%%
% note: maybe later we want to remove the mini lines on lower C etc?
lineBegin = 1;    % deal with lines greater than one pixel
lineEnd = 1;

for i=1:5  % 5 staff lines
    
    while(1)    % with each pass move downward to determine when staff line ends
        if (lineEnd == length(staffLines)) % we've reached the end of the array
            break;
        end
        if (staffLines(lineEnd+1) ~= staffLines(lineEnd)+1) % we've reached the bottom of the current staff line
            break;
        end
        lineEnd = lineEnd+1;
    end
     
    cutStart = staffLines(lineBegin);
    cutEnd = staffLines(lineEnd);

    %working with noisy lines
    if (lineEnd-lineBegin < line_thickness) 
        dif = line_thickness - (lineEnd-lineBegin);
        extend = round(dif/2);  % ceil instead? we can fiddle with this
        cutStart = cutStart - extend;
        cutEnd = cutEnd + extend;
    end 
        
    for col = 1:w 
        if (~img(cutStart-1,col) && ~img(cutEnd+1,col))
            img(cutStart:cutEnd,col) = 0; % remove line at this column only if either pixel above or below is 0
        end
    end
    
    lineBegin = lineEnd+1;
    lineEnd = lineEnd+1;
    
end % end remove staff lines



end