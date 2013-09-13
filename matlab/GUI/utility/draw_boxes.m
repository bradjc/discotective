function [ img ] = draw_boxes( img, symbols )
% draw colored boxes around nontrash symbols
%
% symbols struct:
%   .top
%   .bot
%   .lef
%   .rig
%   .img
%   .class (-1 coming in)
%
% CLASSES
%  0 - trash
%  1 - 1/4 rest (squiggly)          1
%  2 - wide things (ties)
%  3 - dot                          2   
%  4 - measure marker
%  5 - 1/2 rest (hat w/ company)    3
%  6 - full rest (lonely hat)       4
%  7 - sharp (#)                    5
%  8 - flat (b)                     6
%  9 - natural (box badly drawn)    7
%  10 - whole notes                 8
%  11 - 1/8 rest                    9

[h,w] = size(img);

% color lookup
r = [1 0 0 1  1 0  1  1  0];
g = [0 1 0 1 .2 1 .5 .2 .4];
b = [0 0 1 0  1 1  0 .5  0];
%           [1 2 3 4 5 6 7 8 9 10 11
color_ind = [1 0 2 0 3 4 5 6 7  8  9];
for i=1:length(symbols)
    class = symbols(i).class;
    if (class == -1 || class == 0 || class == 2 || class == 4)
        px = cat(3,.5,.5,.5);
    else
        x = color_ind(class);
        px = cat(3,r(x),g(x),b(x));
    end
    
    top = symbols(i).top;
    bot = symbols(i).bot;
    lef = symbols(i).lef;
    rig = symbols(i).rig;
    
    top2 = max([1 top-4]);
    bot2 = min([h bot+4]);
    lef2 = max([1 lef-4]);
    rig2 = min([w rig+4]);
    
    %top line
    for a = top2:top-2
        for b2 = lef2:rig2
            img(a,b2,:) = px;
        end
    end
    % bot line
    for a = bot+2:bot2
        for b2 = lef2:rig2
            img(a,b2,:) = px;
        end
    end    
    %lef line
    for a = top2:bot2
        for b2 = lef2:lef-2
            img(a,b2,:) = px;
        end
    end
    %rig line
    for a = top2:bot2
        for b2 = rig+2:rig2
            img(a,b2,:) = px;
        end
    end
    
    
    
    
    
    
end


end

