function [mini_img topCut leftCut rightCut] = mini_img_cut(img,top,bottom,xbegin,xend,parameters)
% cuts out small image around stem/measure marker

line_spacing = round(parameters.spacing);

extend = round(1.6*line_spacing);

left = xbegin - line_spacing;
right = xend + line_spacing;

extUp = 1;
count = 0;
while(extUp < line_spacing)
    if(sum(img(top-extUp,left:right)) == 0)
        count = count + 1;
    end
    if(count > 2)
        break;
    end
    extUp = extUp + 1;
end
topCut = top - extUp + count;

extDown = 1;
count = 0;
while(extDown < line_spacing)
    if(sum(img(bottom+extDown,left:right)) == 0)
        count = count + 1;
    end
    if(count > 2)
        break;
    end
    extDown = extDown + 1;
end
bottomCut = bottom + extDown - count;

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