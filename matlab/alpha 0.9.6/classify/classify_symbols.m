function [ o_symbols ] = classify_symbols( symbols, parameters,widthOfStaff,heightOfStaff,notes)

minToWidth = widthOfStaff;
measureMarkSymb = 0;

for i=1:size(symbols,2)
    
    top = symbols(i).top;
    bot = symbols(i).bot;
    lef = symbols(i).lef;
    rig = symbols(i).rig;
    
    
    sH = bot-top+1;
    sW = rig-lef+1;
    
    blackCnt = sum(sum(symbols(i).img));
    BWratio = blackCnt./(sH*sW - blackCnt);
    HWratio = sH./sW;
    
    if(HWratio>1.5)
        if(sH < 2*parameters.spacing)
            nextToNote = 0;
            for note=1:size(notes,1)
                if((((strcmp('left', notes(note).position)) && abs((top+bot)/2 - notes(note).bottom)<0.3*(notes(note).bottom - notes(note).top + 1)) ||...
                        ((strcmp('right', notes(note).position)) && abs((top+bot)/2 - notes(note).top)<0.3*(notes(note).bottom - notes(note).top + 1)))&&...
                        ((top+bot)/2>notes(note).top-5 && (top+bot)/2<notes(note).bottom)+5&&...
                        ((symbols(i).rig-notes(note).end)>0 && (symbols(i).rig-notes(note).end)<0.05*widthOfStaff))
                    nextToNote = 1;
                end
            end
            
            if(nextToNote == 1)
                symbols(i).class = 3;
            else
                symbols(i).class = 0;
            end
        else
            if(top>((heightOfStaff-parameters.height)/3) && bot<(heightOfStaff-(heightOfStaff-parameters.height)/3))
                symbols(i).class = 1;
            else
                symbols(i).class = 0;
            end
        end
    elseif(HWratio <.5)
        symbols(i).class = 2;
    else
        nextToNote = 0;
        for note=1:size(notes,1)
            if((((strcmp('left', notes(note).position)) && abs((top+bot)/2 - notes(note).bottom)<0.3*(notes(note).bottom - notes(note).top + 1)) ||...
                    ((strcmp('right', notes(note).position)) && abs((top+bot)/2 - notes(note).top)<0.3*(notes(note).bottom - notes(note).top + 1)))&&...
                    ((top+bot)/2>notes(note).top-5 && (top+bot)/2<notes(note).bottom)+5&&...
                    ((symbols(i).rig-notes(note).end)>0 && (symbols(i).rig-notes(note).end)<0.05*widthOfStaff))
                nextToNote = 1;
            end
        end
        
        if(nextToNote == 1)
            symbols(i).class = 3;
        else
            symbols(i).class = 0;
        end
    end
    
    distToWidth = widthOfStaff - rig;
    if(distToWidth < minToWidth && symbols(i).class == 1 && distToWidth<.1*widthOfStaff)
        measureMarkSymb = i;
    end
    
end

if(measureMarkSymb ~=0)
    symbols(measureMarkSymb).class = 4;
end

o_symbols = symbols;