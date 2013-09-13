function [staffLocations, minLocations] = projectVertical(currIMG)
projVertical = sum(currIMG,2);

filterSize_size = 20; 
for i=filterSize_size+1:length(projVertical)-filterSize_size
    projVertical_blur(i) = sum(projVertical(i-filterSize_size:i+filterSize_size))/(2*filterSize_size+1);
end


maxVal = max(projVertical_blur);
minVal = min(projVertical_blur);
thresh = minVal + (maxVal - minVal)/2; 

[peaks,staffLocations_temp] = findpeaks(projVertical_blur);
maxVal(1:length(projVertical_blur)) = max(projVertical_blur);
flipProjVertical = maxVal - projVertical_blur;
[valleys,minLocations_temp] = findpeaks(flipProjVertical);
for i=1:length(valleys)
    valleys(i) = -(valleys(i)-max(projVertical_blur)); 
end

maxVal = max(projVertical_blur);
minVal = min(projVertical_blur);
thresh = minVal + (maxVal - minVal)/2;

count = 1;
for i=1:length(peaks)
    if(peaks(i) > thresh)
        staffLocations(count) = staffLocations_temp(i);
        count = count+1;
    end
end

count = 1;
for i=1:length(valleys)
    if(valleys(i) <= thresh)
        minLocations(count) = minLocations_temp(i);
        count = count+1;
    end
end