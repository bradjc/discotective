function [measures stems] = find_lines(img, parameters, staffNumber, out)
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
% stems.eighthEnd       - 1 if it is the last eighth note in a group
%
% measures.begin        - left side of measure marker
% measures.end          - right side of measure marker



line_thickness = round(parameters.thickness);
line_spacing = round(parameters.spacing);

[h,w] = size(img);
xproj = sum(img, 1);
staff_height = 5*line_thickness + 4*line_spacing;


% find vertical lines based on x-projection
if (staffNumber == 1)
    leftCutoff = round(2.3 * staff_height);
else
    leftCutoff = round(1.5 * staff_height);
end

[groupings, goodLines] = find_top_bottom(img(:,leftCutoff:w-3*line_spacing), parameters, leftCutoff);
num_lines = size(groupings,1);




stems = [];
measures = [];

% for use with connected eighth notes:
lastStemEighth = 0;
lastStemPosition = '';



extend = round(1.6 * line_spacing);
for i = 1:num_lines
    
    
    
    notefound = 0;  % 1 if not a measure marker
    
    temp = groupings(i,:);
    startLine = temp(1);
    endLine = temp(2);
    
    xbegin = goodLines(startLine).left;
    xend = goodLines(endLine).right;
    topss = [];
    bottomss = [];
    for joe=startLine:endLine
        topss = [topss goodLines(joe).top];
        bottomss = [bottomss goodLines(joe).bottom];
    end
    top = min(topss);
    bottom = max(bottomss);

    
    % DEBUGGING
    if (staffNumber==out.dbg_s && xbegin >= out.dbg_x)
        keyboard
    end

    line_height = bottom - top;
    if (line_height < 0.7*staff_height)
        continue;   % vertical line not long enough
    end
    

    
    [mini_img topCut leftCut rightCut] = mini_img_cut(img,top,bottom,xbegin,xend,parameters);
    xbeginN = xbegin - leftCut + 1;  % xbegin for use with mini_img
    xendN = xend - leftCut + 1;
    
%     binplot(mini_img);

    
    
    
    % make sure its not quarter rest (check that line is skinny in middle)
    y1 = top + round(4*line_height/10);
    y2 = bottom - round(4*line_height/10);
    rest_found = check_line_is_not_rest(img(y1:y2,leftCut:rightCut),xbeginN,xendN,parameters);
    chordProbably = line_height >= staff_height;
    if (rest_found && ~chordProbably)
        continue;
    end
    
    
    % y projection
    yproj = sum(mini_img,2);
    midPoint = round(length(yproj)/2);

    
    

    thresh = line_spacing * 2;
    
    % MEASURE MARKER FOUND
    difference = sum(abs(yproj-mean(yproj)));
    mmFound = size(mini_img,2) < extend-6 || difference < length(yproj);
    if (mmFound && ~(line_height > 1.2*staff_height))
        measures = [measures; struct('begin',xbegin,'end',xend)];
        
    else    % note found instead
        notefound = 1;
        eighthEnd = 0;
        
        % remove stem
        img(:,xbegin-1:xend+1) = 0;
        
        
        
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
            if (~tail_on_top && ~tail_on_bottom)
                eighthEnd = 1;
            end

        else
            eighth = 0;
            
            top25 = round(midPoint/2);
            bot25 = round((midPoint+length(yproj))/2);
            topWeight = sum(yproj(1:top25));
            bottomWeight = sum(yproj(bot25:end));
            
            % note pointing up
            if (bottomWeight > topWeight) 
                 position = 'left';
            else
                position = 'right';
            end
            
        end
        
        
        if (strcmp(position,'left'))    % notehead is on bottom half
            yproj = sum(mini_img(midPoint:end, 1:xbeginN-1), 2);
            offSet = topCut + midPoint - 2;
            
            
        else    % notehead is on top half
            yproj = sum(mini_img(1:midPoint, xendN+1:end), 2);
            offSet = topCut - 1;
            
        end


        % find line's center of mass (applicable to notes)
        peaks = find(yproj > line_thickness);
        if (length(peaks) > 4) % shave off outliers
            peaks(peaks==min(peaks)) = [];
            peaks(peaks==min(peaks)) = [];
            peaks(peaks==max(peaks)) = [];
            peaks(peaks==max(peaks)) = [];
        end
        center = mean(peaks);
        center_of_mass = center + offSet;    




    % add note info to output struct
    note_struct = struct('begin',xbegin,'end',xend,'position',position,...
      'center_of_mass',center_of_mass,'top',top,'bottom',bottom,...
      'eighth',eighth,'eighthEnd',eighthEnd);
    stems = [stems; note_struct];
    

        
        
    end % end else not measure marker
    
    
end  % end for





end