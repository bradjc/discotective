function [result, STAFFLINES] = remove_lines(img, params, numCuts, output)
line_thickness = params.thickness;
line_spacing = params.spacing;

[h,w] = size(img);
beginCut = 1;
endCut = 1 + floor(w/numCuts);


%output
if (output)
    handle=figure;
    subplot(211)
    imagesc(1-img), colormap(gray), title('trimmed staff')
end
    
    

shift_variable=0;
for vertSplice = 1:numCuts
    fixThatImage = img(:,beginCut:endCut);

    % pretty up staff lines
    [img(:,beginCut:endCut),shift_variable,stafflines] = ...
        fix_lines_and_remove(fixThatImage,line_thickness,line_spacing,shift_variable);
    if (vertSplice==1)
        STAFFLINES = stafflines;
    end

    beginCut = endCut + 1;
    endCut = endCut + floor(w/numCuts);
    if (endCut > w)
        endCut = w;
    end
end


%output
if (output)
    subplot(212)
    imagesc(1-img), colormap(gray), title('lineless staff')
    superplot(handle,'top');
end


result = img;
end