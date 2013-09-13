function [measures stems] = find_lines(img, parameters, staffNumber, staff_lines, out)
% finds all stemmed notes and measure markers
%
% input 'out' not necessary for C-code (just for matlab graphing)
%
% Returned structs:
% stems.begin           - beginning of stem (left)
% stems.end             - end of stem (right)
% stems.position        - either 'left' or 'right' depending which side notehead_img is on
% stems.center_of_mass  - y position of center of notehead_img
% stems.top             - top of stem
% stems.bottom          - bottom of stem
% stems.eighthEnd       - 1 if it is the last eighth note in a group (or single eighth)
% stems.midi            - midi number (field modified later)
% stems.letter          - letter (ie 'G3') (not necessary for C)
% stems.mod             - modifier (+1 for sharp, -1 for flat, 0 for
%                         natural) (field modified later)
%
% measures.begin        - left side of measure marker
% measures.end          - right side of measure marker



line_thickness = round(parameters.thickness);
line_spacing = round(parameters.spacing);

[h,w] = size(img);


% find vertical lines based on x-projection
if (staffNumber == 1)
    leftCutoff = round(parameters.height);
else
    leftCutoff = 1;
end

% group close lines together
% note: find_top_bottom can be ported to inside this function
% note: not run all the way to right of image, just to not deal with
% segfaulting
[groupings, goodLines] = find_top_bottom(img(:,leftCutoff:w-3*line_spacing), .7*parameters.height, leftCutoff);
num_lines = size(groupings,1);
img(:,w-3*line_spacing:end) = 0; % just delete end of staff, but add extra measure marker later


% initialize struct arrays for output
stems = [];
measures = [];


% for use with connected eighth notes:
lastStemEighth = 0;
lastStemPosition = '';



extend = round(1.4*(parameters.spacing+parameters.thickness));


for i = 1:num_lines
    
    % grab start and end xlocations for vertical line
    temp = groupings(i,:);
    startLine = temp(1);
    endLine = temp(2);   
    xbegin = goodLines(startLine).left;
    xend = goodLines(endLine).right;
    
    % get top and bottom of found line (y axis)
    topss = [];
    bottomss = [];
    for joe=startLine:endLine
        topss = [topss goodLines(joe).top];
        bottomss = [bottomss goodLines(joe).bottom];
    end
    top = min(topss);
    bottom = max(bottomss);
    
    duration = 0;

    
    % DEBUGGING
    if (staffNumber==out.dbg_s && xbegin >= out.dbg_x)
        keyboard
    end

    
    line_height = bottom - top;
    
    % cut small image just around line
    [mini_img topCut leftCut] = mini_img_cut(img,top,bottom,xbegin,xend,parameters);
    xbeginN = xbegin - leftCut + 1;  % xbegin/xend for use with mini_img
    xendN = xend - leftCut + 1;

    
    
    
    % y projection
    yproj = sum(mini_img,2);
    mini_height = length(yproj);
    midPoint = round(length(yproj)/2);

    
    
    % check for measure marker
    top_bot_proj = yproj([2:round(mini_height/4) round(3*mini_height/4):end-1]); % take top and bottom
    mid_proj = yproj(round(mini_height/4):round(3*mini_height/4));
    difference = sum(abs(top_bot_proj-mean(top_bot_proj)));
    mmFound = size(mini_img,2) < .7*extend ||...
        (difference < length(top_bot_proj) && mean(top_bot_proj) < mean(mid_proj)*2);
    
    
    if (mmFound && ~(line_height > 1.2*parameters.height))
        % MEASURE MARKER FOUND
        measures = [measures; struct('begin',xbegin,'end',xend)]; % add to measure struct array
        
    else    % note found instead
        
        % make sure its not quarter rest (check that line is skinny in middle)
        rest_found = check_line_is_not_rest_new(mini_img,staff_lines,topCut,(xendN+xbeginN)/2,parameters);
        chordProbably = line_height >= parameters.height; % true for very tall lines (chords)
        if (rest_found && ~chordProbably)
            continue;
        end
        
        
        eighthEnd = 0;
        
        % remove stem
        img(:,xbegin-1:xend+1) = 0;    
        
        
        % check for eighth note connecting tails on top and bottom
        tail_on_top = check_eighth_tail(img, parameters, top+line_thickness, xend+3); % top+x*linethickness?
        tail_on_bottom = check_eighth_tail(img, parameters, bottom-line_thickness, xend+3);


        if (tail_on_top || tail_on_bottom || lastStemEighth)   % this and next note are eighth notes
            duration = 0.5;
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
            if(check_eighth_note(mini_img,xbeginN,xendN,parameters))
                % note is single eighth note
                duration = 0.5;
            end
            
            top25 = round(midPoint/2);
            bot25 = round((midPoint+length(yproj))/2);
            topWeight = sum(yproj(1:top25));
            bottomWeight = sum(yproj(bot25:end));
            
            % note pointing up or pointing down?
            if (bottomWeight > topWeight) 
                position = 'left';
            else
                position = 'right';
            end
            
        end
        
        
        if (strcmp(position,'left'))    % notehead_img is on bottom half
            yproj = sum(mini_img(round(0.6*mini_height):end, 1:xbeginN-1), 2);
            maxPos = xbeginN - 1;
            offSet = topCut + round(0.6*mini_height) - 2;
            
            if(duration ~= 0.5)
                % get small image of notehead_img
                notehead_img = mini_img(end-line_spacing-line_thickness:end, 1:round((xbeginN+xendN)/2));
            end
                        
            
        else    % notehead is on top half
            yproj = sum(mini_img(1:round(0.4*mini_height), xendN+1:end), 2);
            maxPos = size(mini_img,2) - xendN;
            offSet = topCut - 1;
            
            if(duration ~= 0.5)
                % get small image of notehead_img
                notehead_img = mini_img(1:line_spacing+line_thickness, round((xbeginN+xendN)/2):end);
            end
            
        end
        
        if(duration ~= 0.5)
            % determine if notehead is filled or open
            type = determine_filled_open(notehead_img);
            if(strcmp(type,'fill'))
                duration = 1;
            else
                duration = 2;
            end
        end
        
        
        % find center of mass of notehead
        if (duration==0.5)
            temp_thresh = maxPos/3;
            peaks = find(yproj > temp_thresh);
            center = mean(peaks);
        else
        	temp_thresh = line_spacing/6;
            % find line's center of mass (applicable to notes)
            peaks = find(yproj > temp_thresh);
            center = mean(peaks);
        end
        center_of_mass = center + offSet; 




    % add note info to output struct
    note_struct = struct('begin',xbegin,'end',xend,'position',position,...
      'center_of_mass',center_of_mass,'top',top,'bottom',bottom,...
      'dur',duration,'eighthEnd',eighthEnd,...
      'midi',0,'letter','','mod',0);
    stems = [stems; note_struct];
    

        
        
    end % end else not measure marker
    
    
end  % end for


% add measure positioned at very end of staff
measures = [measures; struct('begin',w,'end',w)]; 


end