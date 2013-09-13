function [startSTAFF] = staffDETECTION(origIMG, N)

[height width] = size(origIMG);

%split image into N parts
splitWidth = floor(width/N);
for split=1:N
    splitIMG(split, :, :) = origIMG(:,(split-1)*(splitWidth)+1:splitWidth*split);
end

thresh = 10;
for split=1:N
    currIMG(:,:) = splitIMG(split,:,:);
    sumVertical= sum(currIMG,2);
    
    for i=1:length(sumVertical)
        if(sumVertical(i)>thresh)
            sumV_thresh(i,split) = 1;
        else
            sumV_thresh(i,split) = 0;
        end
    end
    
    subplot(N,2,2*split-1)
    plot(sumVertical)
    subplot(N,2,2*split)
    plot(sumV_thresh(:,split))
end

go = 1;
lockVal = 1;
staffCounter = 1;
while(go==1)
    for split=2:size(sumV_thresh,2)-1
        if(go==1)
            if(staffCounter>1 && split==2)
                lockVal = startSTAFF(split, staffCounter-1);
                prevVal = [1 1 1 1 1];
            else
                prevVal = [0 0 0 0 0];
            end
            
            for i=lockVal:size(sumV_thresh,1)
                if(sumV_thresh(i,split) == 1 && prevVal(1) == 0 && prevVal(2) == 0 && prevVal(3) == 0 && prevVal(4) == 0)
                    startSTAFF(split, staffCounter) = i;
                    lockVal = i;
                    break;
                end
                prevVal = [sumV_thresh(i,split) prevVal(1) prevVal(2) prevVal(3) prevVal(4)];

                if(i==size(sumV_thresh,1))
                    go = 0;
                end
            end
        end
    end
    staffCounter = staffCounter + 1;
end