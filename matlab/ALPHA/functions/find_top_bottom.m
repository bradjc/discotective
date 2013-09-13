function [top, bottom] = find_top_bottom(img)
ln = length(img);

runs = [];
begins=[]; ends=[];
inLine = img(1);
if(inLine)
    begins = 1;
end
for i=2:ln
    if (inLine && ~img(i)) % black ends
        ends = [ends (i-1)];
        inLine = 0;
    elseif(img(i) && ~inLine) % black starts
        begins = [begins i];
        inLine = 1;
    end
    if(i == ln && img(i))
        ends = [ends ln];
    end
end

lengths = ends - begins;
[maximum loc] = max(lengths);

top = begins(loc);
bottom = ends(loc); 
    



end