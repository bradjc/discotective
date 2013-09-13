function [mini_img topCut leftCut rightCut] = mini_img_cut(img,top,bottom,xbegin,xend,parameters)
% cuts out small image around stem/measure marker

[h,w] = size(img);

line_spacing = round(parameters.spacing);

extend = round(1.6*line_spacing);


% top and bottom cuts

left = xbegin - line_spacing;
right = xend + line_spacing;

extUp = 1;
count = 0;
while(extUp < line_spacing && top-extUp>0)
    if(sum(img(top-extUp, left:right)) == 0)
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
while(extDown < line_spacing && bottom+extDown<h+1)
    if(sum(img(bottom+extDown, left:right)) == 0)
        count = count + 1;
    end
    if(count > 2)
        break;
    end
    extDown = extDown + 1;
end
bottomCut = bottom + extDown - count;




% left and right cuts

extLeft = 1;
count = 0;
while(extLeft < extend && xbegin-extLeft>0)
    if(sum(img(topCut:bottomCut, xbegin-extLeft)) == 0)
        count = count + 1;
    end
    if(count > 2)
        break;
    end
    extLeft = extLeft + 1;
end
leftCut = xbegin - extLeft + count;

extRight = 1;
count = 0;
while(extRight < extend && xend+extRight<w+1)
    if(sum(img(topCut:bottomCut, xend+extRight)) == 0)
        count = count + 1;
    end
    if(count > 2)
        break;
    end
    extRight = extRight + 1;
end
rightCut = xend + extRight - count;



if (topCut < 1)
    topCut = 1;
end
if (bottomCut > size(img,2))
    bottomCut = size(img,2);
end

mini_img = img(topCut:bottomCut, leftCut:rightCut);





end