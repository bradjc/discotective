function [measures stems] = find_lines(img, parameters, staffNumber)

line_thickness = parameters.thickness;
line_spacing = parameters.spacing;
staffheigh = 4*line_spacing + 5*line_thickness;

[h,w] = size(img);
xproj = sum(img, 1);
staff_height = 5*line_thickness + 4*line_spacing;

lo_thrsh = 0.7 * staff_height;
hi_thrsh = 1.2 * staff_height;

% find vertical lines based on x-projection
lines = [];
% try to ignore initial treble clef/ time signature
if (staffNumber == 1)
    leftCutoff = round(2.1 * staff_height);
else
    leftCutoff = round(1.5 * staff_height);
end

for i = leftCutoff:w-2*line_spacing 
    if (xproj(i) > lo_thrsh && xproj(i) < hi_thrsh)
        lines  = [lines i];
    end
end



% GROUP LINES TOGETHER
groupings = group(lines, 1.5*line_spacing); %2nd arg chosen to group close lines together
[num_lines dummy] = size(groupings);



stems = [];
measures = [];

extend = round(1.7 * line_spacing);
for i = 1:num_lines
    temp = groupings(i,:);
    xbegin = temp(1);
    xend = temp(2);

    
    % find where line begins and ends (vertically) (try several lines and
    % find longest)
    [top1 bottom1] = find_top_bottom(img(:,xbegin));
    [top2 bottom2] = find_top_bottom(img(:,xend));
    [top3 bottom3] = find_top_bottom(img(:,round((xbegin+xend)/2)));
    top = min([top1 top2 top3]);
    bottom = max([bottom1 bottom2 bottom3]);
    
    if ((bottom - top) < 0.7*staff_height)
        continue;
    end
    
    % remove line
    img(:,xbegin-1:xend+1) = 0;
    
    
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
    
    mini_img = img(topCut:bottomCut, leftCut:rightCut);
    yproj = sum(mini_img,2);
    midPoint = round(length(yproj)/2);
    topWeight = sum(yproj(1:midPoint));
    bottomWeight = sum(yproj(midPoint:end));
 
  
    
%     left = xproj(xbegin-extend:xbegin-3);
%     right = xproj(xend+3:xend+extend);
%     sumLeft = sum(left);
%     sumRight = sum(right);
%MODIFIED: vvv
    xproj = sum(mini_img,1);
    left = xproj(1:extend-line_thickness);
    right = xproj(end-extend+line_thickness:end);
    sumLeft = sum(left);
    sumRight = sum(right);
    

    
    %fprintf('line %d, leftsum=%d, rightsum=%d\n',i,sumLeft,sumRight);
    
    
    % classify as either measure marker or note and store
    thresh = 2 * line_thickness;
    notefound = 0;
    % measure marker
    if (sumLeft < thresh && sumRight < thresh) 
        measures = [measures; struct('begin',xbegin,'end',xend)];
        position = 'measure';
        
    % note pointing up
    elseif (bottomWeight > topWeight) 
        notefound = 1;
        position = 'left';
        yproj = sum(mini_img(:,1:extend), 2);
        
    % note pointing down   
    else
        notefound = 1;
        position = 'right';
        yproj = sum(mini_img(:,extend:end), 2);
        
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
    center_of_mass = center + topCut - 1;    
    
    %DEBUGGING
%     if (i==2 && staffNumber==2)
%         keyboard
%     end
    

    if(notefound)
        note_struct = struct('begin',xbegin,'end',xend,'position',position,...
          'center_of_mass',center_of_mass,'top',top,'bottom',bottom);
        stems = [stems; note_struct];
    end
    
    
end  % end for





end