function [mm] = try_measure_marker(img,xbegin,xend,params)
% return mm=1 if measure marker found

line_thickness = round(params.thickness);
[h,w] = size(img);



middle = round(h/2);
top50 = sum(img(1:middle,:),1);
bot50 = sum(img(middle+1:end,:),1);

tips1 = 0;

% compare bottom50 to top50
for i = xbegin-1 : -1 : xbegin - 2*line_thickness
    if (bot50(i) > 0 && top50(i) == 0)
        tips1 = tips1 + 1;
    elseif (bot50(i)==0 && top50(i)==0)
        break;
    end
end

tips2 = 0;

% compare top50 to bottom50
for i = xend+1 : xend + 2*line_thickness
    if (top50(i) > 0 && bot50(i) == 0)
        tips2 = tips2 + 1;
    elseif (top50(i)==0 && bot50(i)==0)
        break;
    end
end


tips = max([tips1 tips2]);

if(tips < 2)
    mm1 = 1;
else
    mm1 = 0;
end


% next look to see if there is white space on both sides
zeroLeft = 0;
zeroRight = 0;
xproj = sum(img,1);
% left side
for i = 1:xbegin
    if (xproj(i) < params.thickness)
        zeroLeft = 1;
    end
end
% right side
for i = xend:w
    if (xproj(i) < params.thickness)
        zeroRight = 1;
    end
end

    
if (mm1 && zeroLeft && zeroRight)
    mm = 1;
else
    mm = 0;
end
    
end
