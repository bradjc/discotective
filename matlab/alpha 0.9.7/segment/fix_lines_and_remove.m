function [result,new_start,STAFFLINES] = fix_lines_and_remove(img,params,last_STAFFLINES,previous_start,cutNum)
% remvoe lines from small portion of staff. also straightens staff.


line_thickness = round(params.thickness);
line_spacing = round(params.spacing);
line_w = params.spacing + params.thickness;
STAFFLINES = [];

[h,w] = size(img);


last_STAFFLINES_avg = round((last_STAFFLINES(:,1) + last_STAFFLINES(:,2))/2);

% y projection
yprojection = sum(img,2);
max_project = max(yprojection);
staffLines = [];
for i=1:h
    if (yprojection(i) > .90*max_project)    %delete staff line, twiddle with the 80% later (90%)
       staffLines = [staffLines i];
    end
end

temp = group(staffLines,3);
for i=1:size(temp,1)
    for j=1:2
        temp(i,j) = staffLines(temp(i,j)); % revert back to index in goodLines
    end
end

staffLines = temp;


if (cutNum == 1 && (size(staffLines,1) == 5) )
    STAFFLINES = staffLines;
    
elseif (size(staffLines,1) == 0)
    STAFFLINES = last_STAFFLINES;
    
elseif (cutNum == 1 && size(staffLines,1) < 5) % MODIFY LATER????
    % choose one line, then find closest line in last_STAFFLINES
    goodLine = round((staffLines(1,1)+staffLines(1,2))/2);
    [dummy loc] = min(abs(last_STAFFLINES_avg - goodLine));
    shift = goodLine - last_STAFFLINES_avg(loc);
    
    STAFFLINES = last_STAFFLINES + shift;
    
    
else
    
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
%             if (~isempty(STAFFLINES))
%                 lastPt = STAFFLINES(end,2);
%                 found_spacing = lineBegin - lastPt;
%                 if (found_spacing < 0.7*line_w || found_spacing > 1.4*line_w)
%                     continue;
%                 end
%             end
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

        if(~match) % CHANGED
            % flag that no match was found
            STAFFLINES = [STAFFLINES; [0 0]];
        end
        
       

    end % end looping through matching staff lines
    
    % CHANGED BELOW
    
    % check for lines that did not get match
    if (any(STAFFLINES(:,1) == 0))
        % find shift value first
        shift = 100; % big value
        for findLine = 1:5 % loop to find nonzero entry in STAFFLINES, then calculate shift
            if (STAFFLINES(findLine,1)) % if nonzero
                now_avg = round((STAFFLINES(findLine,1)+STAFFLINES(findLine,2))/2);
                last_avg = last_STAFFLINES_avg(findLine);
                shift = now_avg - last_avg;
                break;
            end
        end
        if (shift==100)
            shift = 0;
        end
        % replace any flagged (with 0) entries in STAFFLINES
        for findLine = 1:5
            if (STAFFLINES(findLine,1) == 0)
                lineBegin = last_STAFFLINES(findLine,1);
                lineEnd = last_STAFFLINES(findLine,2);
                STAFFLINES(findLine,1:2) = [lineBegin+shift, lineEnd+shift];
            end
        end
    end
    
end


% also remove mini staff lines that might appear above/below for high/low
% notes
extend = round(line_w/4)+1;

% create stafflines above
aboveLINES = [];
lineY = round(mean([STAFFLINES(1,1) STAFFLINES(1,2)]) - line_w); % first above line
while (1)
   if lineY < (extend + 2)
       break;
   else
       aboveLINES = [[lineY lineY]; aboveLINES];
       lineY = round(lineY - line_w);
   end
end

% create stafflines below
belowLINES = [];
lineY = round(mean([STAFFLINES(5,1) STAFFLINES(5,2)]) + line_w); % first above line
while (1)
   if lineY > (h - extend - 2)
       break;
   else
       belowLINES = [belowLINES; [lineY lineY]];
       lineY = round(lineY + line_w);
   end
end


allLINES = [aboveLINES; STAFFLINES; belowLINES];
% if (size(allLINES,1) > 5)
%     keyboard
% end


%   REMOVE STAFF LINES
for i = 1:size(allLINES,1)
    
    lineBegin = allLINES(i,1);
    lineEnd = allLINES(i,2);
    middle = round(mean([lineBegin lineEnd]));
    lastDelete = 0;
    
    
    for j=1:w
        
        % top of staff line
        topStop = 1;
        for ii = (lineBegin-1):-1:(lineBegin-extend)
            if (ii < 1)
                break;
            end
            if (img(ii,j)==0) % then erase
                topStop = ii+1;
                break;
            end
        end
    
        % bottom of staff line
        botStop = h;
        for ii = (lineEnd+1):(lineEnd+extend)
            if (ii > h)
                break;
            end
            if(img(ii,j)==0)
                botStop = ii-1;              
                break;
            end
        end
    
        
        % check thickness of line, delete if skinny
        thickness = botStop - topStop + 1;
        if (params.thickness < 3)
            paramThickness = params.thickness + 1;
        else
            paramThickness = params.thickness;
        end
        if (lastDelete) % there was a line deletion last iteration
            thickness_th = paramThickness*2; % higher threshold
        else
            thickness_th = paramThickness*2-2;
        end
        if (thickness <= thickness_th)
            img(topStop:botStop, j) = 0;
            lastDelete = 1;
        else
            lastDelete = 0;
        end
    
    end
        
   
    

    
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

