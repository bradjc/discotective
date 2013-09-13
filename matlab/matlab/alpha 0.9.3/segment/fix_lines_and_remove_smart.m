function [result,new_start,STAFFLINES] = fix_lines_and_remove_smart(img,params,last_STAFFLINES,previous_start,cutNum)

line_thickness = round(params.thickness);
line_spacing = round(params.spacing);
STAFFLINES = [];

[h,w] = size(img);




last_STAFFLINES_avg = round((last_STAFFLINES(:,1) + last_STAFFLINES(:,2))/2);

% y projection
yprojection = sum(img,2);
max_project = max(yprojection);
staffLines = [];
for i=1:h
    if (yprojection(i) > .90*max_project)    %delete staff line, twiddle with the 85% later
       staffLines = [staffLines i];
    end
end

staffLines = group(staffLines,3);





for findLine = 1:5

    match = 0;
    for i = 1:size(staffLines,1)

        lineBegin = staffLines(i,1);
        lineEnd = staffLines(i,2);
        % lineBegin is top of line, lineEnd is bottom

        found_thickness = lineEnd-lineBegin+1;
        middle = round((lineBegin + lineEnd)/2);

        % determine if the line is of expected location/size
        tooThick = found_thickness > line_thickness+2;
        tooHigh = middle < last_STAFFLINES_avg(findLine) - 3;
        tooLow = middle > last_STAFFLINES_avg(findLine) + 3;
        if (cutNum == 1)
            tooHigh = middle < (last_STAFFLINES_avg(1) - 2*line_spacing);
            tooLow = middle > (last_STAFFLINES_avg(5) + 2*line_spacing);
        end
        if (~isempty(STAFFLINES))
            lastPt = STAFFLINES(end,2);
            found_spacing = lineBegin - lastPt;
            line_w = params.spacing + params.thickness;
            if (found_spacing < 0.7*line_w || found_spacing > 1.4*line_w)
                continue;
            end
        end
        if (tooThick || tooHigh || tooLow)
            continue;
        else % we found good match for staffline
            match = 1;
            % SAVE STAFF LINE LOCATIONS
            STAFFLINES = [STAFFLINES; [lineBegin lineEnd]];
            staffLines(i,:) = [];
            break;
        end        



    end % end looping thru found lines

    if(~match)
        % use last iterations found staff lines
        lineBegin = last_STAFFLINES(findLine,1);
        lineEnd = last_STAFFLINES(findLine,2);
        STAFFLINES = [STAFFLINES; [lineBegin lineEnd]];
    end


end % end looping through matching staff lines





%   REMOVE STAFF LINES
%%% remove "pebbles"
%extend = floor(line_thickness/2); % amount of space above/below <- EXPERIMENT WITH THIS!
extend = round(line_spacing/4);
for i = 1:5
    
    lineBegin = STAFFLINES(i,1);
    lineEnd = STAFFLINES(i,2);
    middle = round(mean([lineBegin lineEnd]));
    
    % top of staff line
    for j=1:w
        for ii = (lineBegin-1):-1:(lineBegin-extend)
            if (img(ii,j)==0) % then erase
                img(ii:middle, j) = 0;
                break;
            end
        end
    end
    
    % bottom of staff line
    for j=1:w
        for ii = (lineEnd+1):(lineEnd+extend)
            if(img(ii,j)==0)
                img(middle:ii, j) = 0;
                break;
            end
        end
    end
    
   % REMOVE STAFF LINES
%    for col = 1:w 
%         if (~img(lineBeginInd-1,col) && ~img(lineEndInd+1,col))
%             img(lineBeginInd:lineEndInd,col) = 0; % remove line at this column only if either pixel above or below is 0
%         end
%    end
    

    
end % end staff line


topLine = STAFFLINES(1,1);

if(previous_start)
    if(previous_start<topLine)
        shift=topLine-previous_start;
        for shift_loop=1:(h-shift)
            img(shift_loop,:)=img(shift_loop+shift,:);
        end
        img((h-shift):h,:)=0;
        
    elseif(previous_start>topLine)
        shift=previous_start-topLine;
        for shift_loop=h:-1:(1+shift)
            img(shift_loop,:)=img(shift_loop-shift,:);
        end
        img((1:1+shift),:)=0;
    end
else
    previous_start=topLine;
end

result = img;
new_start=previous_start;

end

