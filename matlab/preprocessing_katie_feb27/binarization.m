function [binIMG] = binarization(origIMG)

[height width] = size(origIMG);

minVal = min(min(origIMG));
maxVal = max(max(origIMG));
binaryThresh_scalar = minVal + round((maxVal - minVal)/2);
binIMG = zeros(height, width);
for i=1:height
    for j=1:width
        if origIMG(i,j)>binaryThresh_scalar
            binIMG(i,j) = 0;
        else
            binIMG(i,j) = 1;
        end
    end
end