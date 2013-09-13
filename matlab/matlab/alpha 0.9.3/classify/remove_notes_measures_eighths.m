function [result] = remove_notes_measures_eighths(img, stems, measures, parameters, staff_lines, output)
% removes all stemmed notes and measure markers from the image

[h,w] = size(img);
line_thickness = round(parameters.thickness);
line_spacing = round(parameters.spacing);
output = output.stems;

note_width = round(2.3*line_spacing);

inEighth = 0;

for i = 1:length(stems)
    
    if (~inEighth && stems(i).eighth) % start an eighth grouping
        inEighth = 1;
        group = stems(i);        
    elseif (stems(i).eighth) % continue an eighth grouping
        group = [group stems(i)];
    elseif (inEighth) % end current grouping and cut
        inEighth = 0;
        
        %% cut out eighth grouping
        if(strcmp(group(1),'left'))
            leftCut = group(1).begin - note_width;
        else
            leftCut = group(1).begin - line_thickness;
        end
        if(strcmp(group(end),'right'))
            rightCut = group(end).end + note_width;
        else
            rightCut = group(end).end + line_thickness;
        end        
        tops = [];
        bottoms = [];
        for j=1:length(group)
            tops = [tops group(j).top];
            bottoms = [bottoms group(j).bottom];
        end
        maxTop = min(tops);
        maxBottom = max(bottoms);
        
        topCut = maxTop - round(1.5*line_spacing);
        bottomCut = maxBottom + round(1.5*line_spacing);
        if (bottomCut > h)
            bottomCut = h;
        end
        if (topCut < 1)
            topCut = 1;
        end
        
        img(topCut:bottomCut,leftCut:rightCut) = 0;
        %% cut out single note
        
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
        if (bottomCut > h)
            bottomCut = h;
        end
        if (topCut < 1)
            topCut = 1;
        end
        
        img(topCut:bottomCut,leftCut:rightCut) = 0;
        
        
        
    else
    
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
        if (bottomCut > h)
            bottomCut = h;
        end
        if (topCut < 1)
            topCut = 1;
        end
        
        img(topCut:bottomCut,leftCut:rightCut) = 0;
    
    end
    
    
end


%% REMOVE MEASURES

for i = 1:length(measures)
     leftCut = measures(i).begin - line_thickness;
     rightCut = measures(i).end + line_thickness;
     topCut = round(staff_lines(1) - 2*line_thickness);
     bottomCut = round(staff_lines(5) + 2*line_thickness);

     img(topCut:bottomCut,leftCut:rightCut) = 0;
end


%% output
if(output)
    %h=figure; imagesc(1-img), colormap(gray), title('staff with stemmed-notes, measures lines removed')
    %superplot(h,'bottom');
end

result = img;


end