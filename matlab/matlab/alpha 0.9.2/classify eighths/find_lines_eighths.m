function [measures stems] = find_lines_eighths(img, parameters, staffNumber)
% finds all stemmed notes and measure markers
%
%
% stems.begin           - beginning of stem (left)
% stems.end             - end of stem (right)
% stems.position        - either 'left' or 'right' depending which side notehead is on
% stems.center_of_mass  - y position of center of notehead
% stems.top             - top of stem
% stems.bottom          - bottom of stem
% stems.eighth          - 1 if it is a connected eighth note
%
% measures.begin        - left side of measure marker
% measures.end          - right side of measure marker



line_thickness = round(parameters.thickness);
line_spacing = round(parameters.spacing);

[h,w] = size(img);
xproj = sum(img, 1);
staff_height = 5*line_thickness + 4*line_spacing;

lo_thrsh = 0.7 * staff_height;

% find vertical lines based on x-projection
lines = [];
% try to ignore initial treble clef/ time signature
if (staffNumber == 1)
    leftCutoff = round(2.1 * staff_height);
else
    leftCutoff = round(1.5 * staff_height);
end

for i = leftCutoff:w-2*line_spacing 
    if (xproj(i) > lo_thrsh)
        lines  = [lines i];
    end
end



% GROUP LINES TOGETHER
groupings = group(lines, 1.5*line_spacing); %2nd arg chosen to group close lines together
[num_lines dummy] = size(groupings);



stems = [];
measures = [];

% for use with connected eighth notes:
lastStemEighth = 0;
lastStemPosition = '';



extend = round(1.7 * line_spacing);
for i = 1:num_lines
    
    
    notefound = 0;  % 1 if not a measure marker
    
    temp = groupings(i,:);
    xbegin = temp(1);
    xend = temp(2);

    
    % find where line begins and ends (vertically) (try several lines and
    % find longest)
    top = [];
    bottom = [];
    for go = xbegin:xend
        [top1 bottom1] = find_top_bottom(img(:,go));
        top = [top top1];
        bottom = [bottom bottom1];
    end
    top = min(top);
    bottom = max(bottom);
    
    if ((bottom - top) < 0.7*staff_height)
        continue;   % vertical line not long enough
    end
    

    
    
    
    % cut out image just around line (include note head)
    if (top <= line_spacing)
        topCut = 1;
    else
        topCut = top - line_spacing;
    end
    if (bottom >= h - line_spacing)
        bottomCut = h;
    else
        bottomCut = bottom + line_spacing;
    end
    leftCut = xbegin - extend; 
    rightCut = xend + extend;
    
    
    % for determining if s its a measure marker:
    xproj = sum( img(topCut:bottomCut, leftCut:rightCut) ,1);
    left = xproj(1:extend-line_thickness);
    right = xproj(end-extend+line_thickness:end);
    sumLeft = sum(left);
    sumRight = sum(right);    
    
    thresh = 2 * line_thickness;
    % MEASURE MARKER FOUND
    if (sumLeft < thresh && sumRight < thresh) 
        measures = [measures; struct('begin',xbegin,'end',xend)];
        
    else    % note found instead
        notefound = 1;
        
        % remove stem
        img(:,xbegin-1:xend+1) = 0;
        
        % cut out image just around note
        mini_img = img(topCut:bottomCut, leftCut:rightCut);
        yproj = sum(mini_img,2);
        midPoint = round(length(yproj)/2);
        
        
        
        % check for eighth note connecting tails
        tail_on_top = check_eighth_tail(img, parameters, top+line_thickness, xend+3); % top+x*linethickness?
        tail_on_bottom = check_eighth_tail(img, parameters, bottom-line_thickness, xend+3);

        if (tail_on_top || tail_on_bottom || lastStemEighth)   % this and next note are eighth notes
            eighth = 1;
            if (tail_on_top)
                position = 'left';
                lastStemEighth = 1;
            elseif (tail_on_bottom)
                position = 'right';
                lastStemEighth = 1;
            else
                position = lastStemPosition;
                lastStemEighth = 0;
            end
            lastStemPosition = position;

        else
            eighth = 0;
            
            topWeight = sum(yproj(1:midPoint));
            bottomWeight = sum(yproj(midPoint:end));
            
            % note pointing up
            if (bottomWeight > topWeight) 
                 position = 'left';
            else
                position = 'right';
            end
            
        end
        
        
        if (strcmp(position,'left'))    % notehead is on bottom half
            yproj = sum(mini_img(midPoint:end, 1:extend), 2);
            offSet = topCut + midPoint - 2;
            
            
        else    % notehead is on top half
            yproj = sum(mini_img(1:midPoint, extend:end), 2);
            offSet = topCut - 1;
            
        end


        % find line's center of mass (applicable to notes)
        peaks = find(yproj > line_thickness);
        delete = [];
    %     if (strcmp(position,'left'))
    %         for ind=1:length(peaks)
    %             if (peaks(ind) > (bottom+2*line_spacing) || peaks(ind) < (bottom-2*line_spacing))
    %                 delete = [delete ind];
    %             end
    %         end
    %     elseif (strcmp(position,'right'))
    %         for ind=1:length(peaks)
    %             if (peaks(ind) > (top+2*line_spacing) || peaks(ind) < (top-2*line_spacing))
    %                 delete = [delete ind];
    %             end
    %         end
    %     end
        peaks(delete) = [];
        center = median(peaks); % or mean
        % NOTE center needs to be improved ^
        center_of_mass = center + offSet;    

        %DEBUGGING
%         if (i==1 && staffNumber==3)
%             keyboard
%         end


    % add note info to output struct
    note_struct = struct('begin',xbegin,'end',xend,'position',position,...
      'center_of_mass',center_of_mass,'top',top,'bottom',bottom,'eighth',eighth);
    stems = [stems; note_struct];
    

        
        
    end % end else not measure marker
    
    
end  % end for





end