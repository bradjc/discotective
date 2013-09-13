function [result, STAFFLINES] = remove_lines(img, params, numCuts)
% returns staff without lines, and STAFFLINES as a 5x2 array

line_thickness = round(params.thickness);
line_spacing = round(params.spacing);
[h,w] = size(img);
beginCut = 1;
endCut = 1 + floor(w/numCuts);

% get inital staff line estimates
yprojection = sum(img,2);
yprojection = filter(ones(1,line_thickness),1,yprojection); % reduce impact of 'double peaks' (curvy lines)

<<<<<<< .mine

=======
>>>>>>> .r179
linesFound = 0;
staffLines = [];
while(linesFound < 5)
    [max_project loc] = max(yprojection);
    linesFound = linesFound + 1;
    staffLines = [staffLines loc];
    yprojection(loc-round(line_spacing/2):loc+round(line_spacing/2)) = 0;
end

STAFFLINES = sort(staffLines);
STAFFLINES = [STAFFLINES' STAFFLINES'];

last_stafflines = STAFFLINES;


% LOOP THRU VERTICAL CUTS
shift_variable=0;
for vertSplice = 1:numCuts
    fixThatImage = img(:,beginCut:endCut);

    % pretty up staff lines
    [img(:,beginCut:endCut),shift_variable,stafflines] = ...
        fix_lines_and_remove(fixThatImage,params,last_stafflines,shift_variable,vertSplice);
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