function [result] = remove_notes_measures(img, stems, measures, parameters, staff_lines, output)

line_thickness = parameters.thickness;
line_spacing = parameters.spacing;


for i = 1:length(stems)
    % choose extension based on line spacing
    note_width = round(2.3*line_spacing);
    if (strcmp(stems(i).position, 'left')) % note head on left 
        leftCut = stems(i).begin - note_width;
        rightCut = stems(i).end + line_thickness;
    else
        leftCut = stems(i).begin - line_thickness;
        rightCut = stems(i).end + note_width;
    end
    
    img(:,leftCut:rightCut) = 0;
    
    
end


% REMOVE MEASURES

for i = 1:length(measures)
     leftCut = measures(i).begin - line_thickness;
     rightCut = measures(i).end + line_thickness;
     topCut = round(staff_lines(1) - 2*line_thickness);
     bottomCut = round(staff_lines(5) + 2*line_thickness);

     img(topCut:bottomCut,leftCut:rightCut) = 0;
end


% output
if(output)
    h=figure; imagesc(1-img), colormap(gray), title('staff with stemmed-notes, measures lines removed')
    superplot(h,'bottom');
end

result = img;


end