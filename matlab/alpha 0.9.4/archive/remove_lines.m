function [result, STAFFLINES] = remove_lines(img, params, numCuts)
% returns staff without lines, and STAFFLINES as a 1x5 array


[h,w] = size(img);
beginCut = 1;
endCut = 1 + floor(w/numCuts);

shift_variable=0;
for vertSplice = 1:numCuts
    fixThatImage = img(:,beginCut:endCut);

    % pretty up staff lines
    [img(:,beginCut:endCut),shift_variable,stafflines] = ...
        fix_lines_and_remove(fixThatImage,params,shift_variable);
    if (vertSplice==1)
        STAFFLINES = stafflines;
    end

    beginCut = endCut + 1;
    endCut = endCut + floor(w/numCuts);
    if (endCut > w)
        endCut = w;
    end
end

result = [zeros(2, w); img; zeros(2, w)];
result = [zeros(h+4, 2) result zeros(h+4, 2)];

STAFFLINES = STAFFLINES + 2;

end