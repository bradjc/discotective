function [result, STAFFLINES] = remove_lines(img, params, numCuts)
% returns staff without lines, and STAFFLINES as a 5x2 array

% line_thickness = round(params.thickness);  % CHANGED
% line_spacing = round(params.spacing);
line_w = params.thickness + params.spacing;
[h,w] = size(img);
beginCut = 1;
endCut = 1 + floor(w/numCuts);

% get inital staff line estimates
yprojection = sum(img,2);
% yprojection = filter(ones(1,line_thickness),1,yprojection); % reduce impact of 'double peaks' (curvy lines)

linesFound = 0;
staffLines = [];
while(linesFound < 5)
    [max_project loc] = max(yprojection);
    linesFound = linesFound + 1;
    
    % all y coordinates of a line that is part of same staff line:
    eraseTop = loc-round(line_w/3);
    eraseBottom = loc+round(line_w/3);
    if (eraseTop < 1), eraseTop = 1; end % avoid segfault
    if (eraseBottom > h), eraseBottom = h; end % avoid segfault
    thisLineY = find(yprojection(eraseTop:eraseBottom) >= .9 * max_project) + eraseTop - 1; % all y-cord of line
    yprojection(eraseTop:eraseBottom) = 0; % erase to avoid line in further iterations
    
    
    staffLines = [staffLines; min(thisLineY) max(thisLineY)]; %update
end

STAFFLINES = sort(staffLines);

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



% zero padding
result = [zeros(2, w); img; zeros(2, w)];
result = [zeros(h+4, 2) result zeros(h+4, 2)];

STAFFLINES = STAFFLINES + 2; % shift because of zero padding above

end