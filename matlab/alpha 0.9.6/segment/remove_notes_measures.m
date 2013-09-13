function [result] = remove_notes_measures(img, stems, measures, parameters, staff_lines, output)
% removes all stemmed notes and measure markers from the image

[h,w] = size(img);
line_thickness = round(parameters.thickness);
line_spacing = round(parameters.spacing);
line_w = parameters.thickness + parameters.spacing;
output = output.stems;



% REMOVE STEMMED NOTES
note_width = round(1.4*line_w);

inEighth = 0;

for i = 1:length(stems)
    
    if (~inEighth && stems(i).dur==.5) % start an eighth grouping
        inEighth = 1;
        group = stems(i);      
        
    elseif (stems(i).dur==.5) % continue an eighth grouping
        group = [group stems(i)];
        
    else    % cut out single note
        % choose extension based on line spacing
        if (strcmp(stems(i).position, 'left')) % note head on left 
            leftCut = stems(i).begin - note_width;
            rightCut = stems(i).end + line_thickness;
            topCut = stems(i).top - line_thickness;
            bottomCut = stems(i).bottom + round(1.5*line_spacing);
        else
            leftCut = stems(i).begin - line_thickness;
            rightCut = stems(i).end + note_width;
            topCut = stems(i).top - round(1.5*line_spacing);
            bottomCut = stems(i).bottom + line_thickness;
        end
        
        %segfault precaution:
        if (leftCut < 1), leftCut = 1; end
        if (rightCut > w), rightCut = w; end
        if (topCut < 1), topCut = 1; end
        if (bottomCut > h), bottomCut = h; end
        
        % cut out image
        img(topCut:bottomCut,leftCut:rightCut) = 0;
        
    end
    
    
    
    if (stems(i).eighthEnd) % end an eighth grouping/single eighth and cut
        
        inEighth = 0;
        
        % cut out individual notes
        for j = 1:length(group)
            if (strcmp(group(j).position,'left'))
                leftCut = group(j).begin - note_width;
                rightCut = group(j).end + round(line_w/6);
            else
                leftCut = group(j).begin - round(line_w/6);
                rightCut = group(j).end + note_width;                
            end
            topCut = group(j).top - round(line_w);
            bottomCut = group(j).bottom + round(line_w);
            
            %segfault precaution:
            if (leftCut < 1), leftCut = 1; end
            if (rightCut > w), rightCut = w; end
            if (topCut < 1), topCut = 1; end
            if (bottomCut > h), bottomCut = h; end
            
            % cut image
            img(topCut:bottomCut, leftCut:rightCut) = 0;
        end
        
        % cut out connector
        if (length(group) > 1)
            tops = [];
            bottoms = [];
            for j=1:length(group)
                tops = [tops group(j).top];
                bottoms = [bottoms group(j).bottom];
            end
            
            if (strcmp(group(1).position,'left')) % group is left pointing
                topCut = min(tops) - round(line_w);
                bottomCut = max(tops) + round(line_w);
            else
                topCut = min(bottoms) - round(line_w);
                bottomCut = max(bottoms) + round(line_w);
            end
            leftCut = group(1).begin - round(line_w/6);
            rightCut = group(end).end + round(line_w/6);
            
            %segfault precaution:
            if (leftCut < 1), leftCut = 1; end
            if (rightCut > w), rightCut = w; end
            if (topCut < 1), topCut = 1; end
            if (bottomCut > h), bottomCut = h; end
            
            % cut image
            img(topCut:bottomCut, leftCut:rightCut) = 0;            
        end
            
    end
     
        
    
    
end


% REMOVE MEASURE LINES

for i = 1:length(measures)
     leftCut = measures(i).begin - line_thickness;
     rightCut = measures(i).end + line_thickness;
     topCut = round(staff_lines(1) - 2*line_thickness);
     bottomCut = round(staff_lines(5) + 2*line_thickness);
     % seg fault precaution:
     if(leftCut < 1) leftCut = 1; end
     if(rightCut > w) rightCut = w; end
     if(topCut < 1) topCut = 1; end
     if (bottomCut > h) bottomCut = h; end

     img(topCut:bottomCut,leftCut:rightCut) = 0;
end


% output
if(output)
    %h=figure; imagesc(1-img), colormap(gray), title('staff with stemmed-notes, measures lines removed')
    %superplot(h,'bottom');
end

result = img;


end