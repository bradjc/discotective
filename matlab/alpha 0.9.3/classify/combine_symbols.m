function [ o_symbols ] = combine_symbols( symbols, parameters, img )
% combine symbols that are close together (aka split whole notes, sharps...
% symbols - array of symbol structs

% note: symbol order must always be left to right

line_spacing = parameters.spacing; 

i=1;
while (i<=size(symbols,2))
    % look for symbol directly to the right
    right1 = symbols(i).rig;
    height1 = symbols(i).bot - symbols(i).top + 1;
    top1 = symbols(i).top;
    
    
    minDist = 1000000;
    closestSymb = 0;
    
    for j = 1:size(symbols,2)
        if(j~=i)          
            left2 = symbols(j).lef;
            height2 = symbols(j).bot - symbols(j).top + 1;
            top2 = symbols(j).top;

            currDist = sqrt(((top1+height1/2)-(top2+height2/2)).^2 + (right1-left2).^2);

            if ( left2-right1 > 0 && currDist < minDist)   % symbol2 is located just to the right

                minDist = currDist;
                closestSymb = j;
            end
        end
    end
    if(closestSymb)
        height2 = symbols(closestSymb).bot - symbols(closestSymb).top + 1;
        top2 = symbols(closestSymb).top;

        %  WORK WITH THESE THRESHOLDS vvv
        if (minDist<1.5*line_spacing && abs(height1-height2) < (6) && abs(top1-top2) < (line_spacing))
            %figure,subplot(211),imagesc(1-symbols(i).img),subplot(212),imagesc(1-symbols(closestSymb).img);
            lefN = symbols(i).lef;
            rigN = symbols(closestSymb).rig;
            topN = min([symbols(i).top symbols(closestSymb).top]);
            botN = max([symbols(i).bot symbols(closestSymb).bot]);
            imgN = img(topN:botN, lefN:rigN);
            symbolN = struct('top',topN,'bot',botN,'lef',lefN,'rig',rigN,'img',imgN);
            
            if(closestSymb>i)
                symbols(i) = [];
                symbols(closestSymb) = symbolN;
            else
                symbols(closestSymb) = [];
                symbols(i) = symbolN;
            end
            i=i-1;
        end
    end
    i = i + 1;
end % end inner for

o_symbols = symbols;

end

