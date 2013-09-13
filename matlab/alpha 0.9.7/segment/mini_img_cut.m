function [mini_img topCut leftCut] = mini_img_cut(img,top,bottom,xbegin,xend,parameters)
% cuts out small image around stem/measure marker

[h,w] = size(img);

extend = round(1.4*(parameters.spacing+parameters.thickness));

line_spacing = round(parameters.spacing);
line_w = parameters.spacing + parameters.thickness;


% left and right cuts
count_thresh = round(line_w * 0.4);

extLeft = 1;
count = 0;
while(extLeft < extend && xbegin-extLeft>0)
    if(sum(img(top:bottom, xbegin-extLeft)) == 0)
        count = count + 1;
    else
        count = 0;
    end
    if(count > count_thresh)
        break;
    end
    extLeft = extLeft + 1;
end
leftCut = xbegin - extLeft + count;

extRight = 1;
count = 0;
while(extRight < extend && xend+extRight<w+1)
    if(sum(img(top:bottom, xend+extRight)) == 0)
        count = count + 1;
    else
        count = 0;
    end
    if(count > count_thresh)
        break;
    end
    extRight = extRight + 1;
end
rightCut = xend + extRight - count;



% top and bottom cuts
count_thresh = 0;
sum_thresh = round(line_w / 6)+1;

extUp = 1;
count = 0;
while(extUp < line_spacing && top-extUp>0)
    if(sum(img(top-extUp, leftCut:rightCut))  <= sum_thresh )
        count = count + 1;
    end
    if(count > count_thresh)
        break;
    end
    extUp = extUp + 1;
end
topCut = top - extUp + count;

extDown = 1;
count = 0;
while(extDown < line_spacing && bottom+extDown<h+1)
    if(sum(img(bottom+extDown, leftCut:rightCut)) <= sum_thresh)
        count = count + 1;
    end
    if(count > count_thresh)
        break;
    end
    extDown = extDown + 1;
end
bottomCut = bottom + extDown - count;







% precautions to prevent segfaults:
if (topCut < 1)
    topCut = 1;
end
if (bottomCut > h)
    bottomCut = h;
end
if (leftCut < 1)
    leftCut = 1;
end
if (rightCut > w)
    rightCut = w;
end




% output - cut box
mini_img = img(topCut:bottomCut, leftCut:rightCut);





end