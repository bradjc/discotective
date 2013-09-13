function [breakPt] = findBreakPts(currIMG)

[height width] = size(currIMG);

[staffLoc, minLocations] = projectVertical(currIMG);

minMaxMatrix = [staffLoc' ones(length(staffLoc),1); ...
                minLocations' zeros(length(minLocations),1)];
sortedMinMaxMatrix=quicksort(minMaxMatrix,1);


count = 1;
breakPt(count) = height;

i=1;
ON = 0;
BETWEEN = 0;

breakPt(1) = height;
count = 1;
while(i<=size(sortedMinMaxMatrix,1))
    if(sortedMinMaxMatrix(i,2) == 1 && ON==0)
        ON = 1;
        sum = 0;
    end
    if(sortedMinMaxMatrix(i,2) == 1 && ON==1 && BETWEEN~=0)
        count = count + 1;
        breakPt(count) = round(sum/BETWEEN);
        
        ON = 1;
        BETWEEN = 0;
        sum = 0;
    end
    if(ON ==1 && sortedMinMaxMatrix(i,2)==0)
        sum = sum + sortedMinMaxMatrix(i,1);
        BETWEEN = BETWEEN + 1;
    end
    i = i + 1;
end
count = count + 1;
breakPt(count) = 1;