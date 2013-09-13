function [line_thickness line_spacing staff_thickness] = get_staff_parameters(img)
[height,width] = size(img);
blackRuns = [];
whiteRuns = [];

inBlack = img(1,1);
run = 1;
for col=1:width
    for row = 1:height
        if (~img(row,col) && ~inBlack) % white continues
            run = run + 1;
        elseif (img(row,col) && ~inBlack) % white run ends
            whiteRuns = [whiteRuns run];
            run = 1;
            inBlack = 1;
        elseif (~img(row,col) && inBlack) % black run ends
            blackRuns = [blackRuns run];
            run = 1;
            inBlack = 0;
        else % black continues
            run = run + 1;
        end
    end
end

[line_spacing] = hist(whiteRuns,1:max(whiteRuns));
[line_thickness] = hist(blackRuns,1:max(blackRuns));

[tmp, line_spacing] = max(line_spacing);
[tmp, line_thickness] = max(line_thickness);
staff_thickness=5*line_thickness+4*line_spacing;
% show histogram of black and white vertical runs found
% figure
% hist(whiteRuns,1:max(whiteRuns)); title('vertical white runs histogram (max is line spacing)');
% figure
% hist(blackRuns,1:max(blackRuns)); title('vertical black runs histogram (max is line thickness)');


end