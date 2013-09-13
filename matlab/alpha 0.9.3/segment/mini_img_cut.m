function [mini_img topCut leftCut rightCut] = mini_img_cut(img,top,bottom,xbegin,xend,parameters)
% cuts out small image around stem/measure marker

line_spacing = round(parameters.spacing);

extend = round(1.6*line_spacing);

left = xbegin - line_spacing;
right = xend + line_spacing;

extUp = 1;
while(extUp < line_spacing)
    if(sum(img(top-extUp,left:right)) == 0)
        break;
    else
        extUp = extUp + 1;
    end
end
topCut = top - extUp;

extDown = 1;
while(extDown < line_spacing)
    if(sum(img(bottom+extDown,left:right)) == 0)
        break;
    else
        extDown = extDown + 1;
    end
end
bottomCut = bottom + extDown;

leftCut = xbegin - extend; 
rightCut = xend + extend;

if (topCut < 1)
    topCut = 1;
end
if (bottomCut > size(img,2))
    bottomCut = size(img,2);
end

mini_img = img(topCut:bottomCut, leftCut:rightCut);





end