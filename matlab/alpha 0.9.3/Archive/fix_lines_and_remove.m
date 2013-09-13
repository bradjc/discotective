function [result,new_start,STAFFLINES] = fix_lines_and_remove(img,params,previous_start)

line_thickness = round(params.thickness);
line_spacing = round(params.spacing);

[h,w] = size(img);
STAFFLINES = [];

% y projection
yprojection = sum(img,2);
max_project = max(yprojection);
staffLines = [];
for i=1:h
    if (yprojection(i) > .90*max_project)    %delete staff line, twiddle with the 85% later
       staffLines = [staffLines i];
    end
end



%%% remove "pebbles"
%extend = floor(line_thickness/2); % amount of space above/below <- EXPERIMENT WITH THIS!
extend = floor(line_thickness);

lineBegin = 1;    % deal with lines greater than one pixel
lineEnd = 1;

i=1;
while(i<6)  % 5 staff lines
    
    while(1)    % with each pass move downward to determine when staff line ends
        if (lineEnd >= length(staffLines)) % we've reached the end of the array
            i=100;
            break;
        end
        if (staffLines(lineEnd+1) ~= staffLines(lineEnd)+1) % we've reached the bottom of the current staff line
            break;
        end
        lineEnd = lineEnd+1;
    end
    % lineBegin is top of line, lineEnd is bottom
    
    if(i>1)
        found_spacing = staffLines(lineBegin) - lastEndInd;
        if (found_spacing < 0.8*line_spacing) %bad line
            lineBegin = lineEnd+1;
            lineEnd = lineEnd+1;
            continue;
        end
    end
    
    %found_thickness = lineEnd-lineBegin+1;
    
    middle = ceil((staffLines(lineEnd) + staffLines(lineBegin))/2);
    lineBeginInd = middle - round(line_thickness/2);
    lineEndInd = lineBeginInd + line_thickness - 1;
    
    % SAVE STAFF LINE LOCATIONS
    STAFFLINES = [STAFFLINES; [lineBeginInd lineEndInd]];
    
    % paint over (remove "dents", aka "bam-bams")
    img(lineBeginInd:lineEndInd,:) = 1;
    if (i==1)
        topLine = lineBeginInd;
    end
    
    
    % top of staff line
    for j=1:w
        for ii = (lineBeginInd-1):-1:(lineBeginInd-extend)
            if (img(ii,j)==0) % then erase
                img(ii:middle, j) = 0;
                break;
            end
        end
    end
    
    % bottom of staff line
    for j=1:w
        for ii = (lineEndInd+1):(lineEndInd+extend)
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
    
    lineBegin = lineEnd+1;
    lineEnd = lineEnd+1;
    lastEndInd = lineEndInd;
    i = i+1;
    
end % end staff line

%figure,imagesc(1-img),colormap(gray)

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
STAFFLINES = round((STAFFLINES(:,1) + STAFFLINES(:,2))/2);

end

