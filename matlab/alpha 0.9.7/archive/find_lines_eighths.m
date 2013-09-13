function [measures stems] = find_lines_eighths(img, parameters, staffNumber, out)
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

lo_thrsh = 0.65 * staff_height;

% find vertical lines based on x-projection
lines = [];
% try to ignore initial treble clef/ time signature
if (staffNumber == 1)
    leftCutoff = round(2.1 * staff_height);
else
    leftCutoff = round(1.5 * staff_height);
end

for i = leftCutoff:w-2*line_spacing 
    if (xproj(i) >= lo_thrsh)
        lines  = [lines i];
    end
end



% GROUP LINES TOGETHER
groupings = group(lines, 5); %2nd arg chosen to group close lines together
[num_lines dummy] = size(groupings);



stems = [];
measures = [];

% for use with connected eighth notes:
lastStemEighth = 0;
lastStemPosition = '';



extend = round(1.6 * line_spacing);
for i = 1:num_lines
    
    
    
    notefound = 0;  % 1 if not a measure marker
    
    temp = groupings(i,:);
    xbegin = temp(1);
    xend = temp(2);

    
    % find where line begins and ends (vertically) (try several lines and
    % find longest)
    [top bottom xbeginR xendR] = find_top_bottom_smart(img(:,xbegin-1:xend+1));
    xbegin = xbeginR + (xbegin-1) - 1;
    xend = xendR + (xbegin-1) - 1;
    
    % DEBUGGING
    if (staffNumber==out.dbg_s && xbegin >= out.dbg_x)
        keyboard
    end

    line_height = bottom - top;
    if (line_height < 0.7*staff_height)
        continue;   % vertical line not long enough
    end
    

    
    % cut out image just around line (include note head)
%     if (top <= line_spacing)
%         topCut = 1;
%     else
%         topCut = top - line_spacing;
%     end
%     if (bottom >= h - line_spacing)
%         bottomCut = h;
%     else
%         bottomCut = bottom + line_spacing;
%     end
%     leftCut = xbegin - extend; 
%     rightCut = xend + extend;
%     
%     mini_img = img(topCut:bottomCut, leftCut:rightCut);
    [mini_img topCut leftCut rightCut] = mini_img_cut(img,top,bottom,xbegin,xend,parameters);
    

    
    % for determining if its a measure marker:
    xbeginN = xbegin - leftCut + 1;
    xendN = xend - leftCut + 1;
    mmFound = try_measure_marker(mini_img,xbeginN,xendN,parameters);

%     sumLeft = sum(img(topCut:bottomCut, xbegin-2*line_thickness:xbegin-4), 1);
%     sumRight = sum(img(topCut:bottomCut, xend+4:xend+2*line_thickness), 1);
%     sumLeft = sum(sumLeft);
%     sumRight = sum(sumRight);
    
    
    % make sure its not quarter rest (check that line is skinny in middle)
    y1 = top + round(4*line_height/10);
    y2 = bottom - round(4*line_height/10);
    rest_found = check_line_is_not_rest(img(y1:y2,leftCut:rightCut),xbeginN,xendN,parameters);
    chordProbably = line_height >= staff_height;
    if (rest_found && ~chordProbably)
        continue;
    end
    

    thresh = line_spacing * 2;
    % MEASURE MARKER FOUND
%     if (mmFound && (sumLeft < thresh) && (sumRight < thresh))
    if (mmFound && ~(line_height > 1.2*staff_height))
        measures = [measures; struct('begin',xbegin,'end',xend)];
        
    else    % note found instead
        notefound = 1;
        
        % remove stem
        img(:,xbegin-1:xend+1) = 0;
        
        % cut out image just around note
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
        peaks = find(yproj > 2*line_thickness);
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




    % add note info to output struct
    note_struct = struct('begin',xbegin,'end',xend,'position',position,...
      'center_of_mass',center_of_mass,'top',top,'bottom',bottom,'eighth',eighth);
    stems = [stems; note_struct];
    

        
        
    end % end else not measure marker
    
    
end  % end for





end