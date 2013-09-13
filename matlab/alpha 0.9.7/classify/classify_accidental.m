function [class] = classify_accidental(img)
% classifies accidentals into:
%   class 7 - sharp
%   class 8 - flat
%   class 9 - natural

[h,w] = size(img);

xproj = sum(img,1);

% find how many peaks (flat has just 1)
[maxPk loc1] = max(xproj);
leftCut = max([1 loc1-3]);
rightCut = min([w loc1+3]);
xproj(leftCut:rightCut) = 0; % erase so we dont find same peak twice

% look for a second
[secPk loc2] = max(xproj);
if (secPk < 0.85*maxPk)
    class = 8; % flat determined
    return;
end

% now find where two peaks begin vertically
peaks = sort([loc1 loc2]);
starts = [1 1];
for pk = 1:2    
    for row = 1:h
        if (img(row,peaks(pk)))
            starts(pk) = row;
            break;
        end
    end
end

% sharp's second peak should start about the same or slightly higher than
% the first. A natural's should start lower.

if (starts(2) <= starts(1)+2)
    class = 7; % sharp
else
    class = 9; % natural
end



end