function [class] = classify_accidental(img)
% classifies accidentals into:
%   class 7 - sharp
%   class 8 - flat
%   class 9 - natural

% note to self: we made this smarter on the board. Instead of deleting 3
% pixels each way from a peak, we should detect all points of the x-proj
% greater than a threshold and then use the group function. Something like
% the following (not yet tested in MATLAB)
%
% thresh = 0.7 * max(xproj);
% all_peaks = find(xproj > thresh);
% groupings = group(all_peaks,2);
% if length(groupings) == 1
%     if groupings(1,2)-groupings(1,1)+1 > w/2
%         % return sharp
%         class = 7;
%         return;
%     else 
%         % return flat
%         class = 8;
%         return;
%     end
% elseif length(groupings) == 2
%     loc1 = (groupings(1,1) + groupings(1,2)) / 2;
%     loc2 = (groupings(2,1) + groupings(2,2)) / 2;
%     % etc etc for sharp vs natural detection
% else
%     % return trash
%     class = 0; 
%     return;
% end


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