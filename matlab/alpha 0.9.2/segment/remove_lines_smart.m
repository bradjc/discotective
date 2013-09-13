function [result, STAFFLINES] = remove_lines_smart(img, params, numCuts)
% returns staff without lines, and STAFFLINES as a 5x2 array

line_thickness = round(params.thickness);
[h,w] = size(img);
beginCut = 1;
endCut = 1 + floor(w/numCuts);

% get inital staff line estimates
yprojection = sum(img,2);
yprojection = filter(ones(1,line_thickness),1,yprojection); % reduce impact of 'double peaks' (curvy lines)
max_project = max(yprojection);
staffLines = [];
for i=1:h
    if (yprojection(i) > .80*max_project)    %delete staff line, twiddle with the 85% later
       staffLines = [staffLines i];
    end
end
STAFFLINES = group(staffLines,3);

last_stafflines = STAFFLINES;


% LOOP THRU VERTICAL CUTS
shift_variable=0;
for vertSplice = 1:numCuts
    fixThatImage = img(:,beginCut:endCut);

    % pretty up staff lines
    [img(:,beginCut:endCut),shift_variable,stafflines] = ...
        fix_lines_and_remove_smart(fixThatImage,params,last_stafflines,shift_variable,vertSplice);
    if (vertSplice==1)
        STAFFLINES = stafflines;
    end


    beginCut = endCut + 1;
    endCut = endCut + floor(w/numCuts);
    if (endCut > w)
        endCut = w;
    end
    
    last_stafflines = stafflines;
end




result = [zeros(2, w); img; zeros(2, w)];
result = [zeros(h+4, 2) result zeros(h+4, 2)];

STAFFLINES = STAFFLINES + 2;

end