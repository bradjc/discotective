function [ o_symbols ] = classify_symbols( symbols, parameters, notes, measures, staff_lines)
% classify all remaining symbols
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
%  1 - 1/4 rest (squiggly)
%  2 - wide things (ties)
%  3 - dot
%  4 - measure marker
%  5 - 1/2 rest (hat w/ company)
%  6 - full rest (lonely hat)
%  7 - sharp (#)
%  8 - flat (b)
%  9 - natural (box badly drawn)
%  10 - whole notes
%  11 - 1/8 rest

line_w = parameters.spacing + parameters.thickness * 2;



for i=1:size(symbols,2)
    
    top = symbols(i).top;
    bot = symbols(i).bot;
    lef = symbols(i).lef;
    rig = symbols(i).rig;
    
    
    sH = bot-top+1;
    sW = rig-lef+1;
    
    blackCnt = sum(sum(symbols(i).img));
    BWratio = blackCnt./(sH*sW - blackCnt+1);
    HWratio = sH./sW;
    
    
   
    rightOfNote = 0;
    leftOfNote = 0;
    for note=1:size(notes,1)
        
        % check for closeness of symbol to notes:

        
        % check to right of note
        if (strcmp('left', notes(note).position))
            vertClose = abs((top+bot)/2 - notes(note).bottom) < 0.4*(notes(note).bottom - notes(note).top) && notes(note).bottom - top + line_w/2 > 0; % close to notehead vertically
            horClose = (lef-notes(note).end) > 0 && (lef-notes(note).end) < line_w;
        else
            vertClose = abs((top+bot)/2 - notes(note).top) < 0.4*(notes(note).bottom - notes(note).top) && bot - notes(note).top + line_w/2 > 0;
            horClose = (lef-notes(note).end) > 0 && (lef-notes(note).end) < 2.5*line_w;
        end
  
        if (vertClose && horClose)
            rightOfNote = 1;
        end
        
        % check to left of a note
        if (strcmp('left', notes(note).position))
            vertClose = abs((top+bot)/2 - notes(note).bottom) < 0.3*(notes(note).bottom - notes(note).top + 1) && notes(note).bottom - top -1 > 0; % close to notehead vertically
            horClose = (rig-notes(note).begin) <= 0 && (notes(note).begin - rig) < 2.5*line_w;
        else
            vertClose = abs((top+bot)/2 - notes(note).top) < 0.3*(notes(note).bottom - notes(note).top + 1) && bot - notes(note).top -1 > 0;
            horClose = (rig-notes(note).begin) <= 0 && (notes(note).begin - rig) < line_w;
        end        
        
        if (vertClose && horClose)
            leftOfNote = 1;
        end
        
        
        

        
    end
    
    
    
   % if symbol is directly to right of a note
   if (rightOfNote && HWratio>.5 && sH <= line_w + 5 && sW < parameters.spacing)
       symbols(i).class = 3; % dot 
       
   % if symbol is directly to the left of a note
   elseif (leftOfNote && HWratio>.5 && sH > line_w && sW > line_w/2 )
       % accidental found
       symbols(i).class = classify_accidental(symbols(i).img);
       
   % else other symbol  (whole notes, 1/4 rest, 1/2 rest, full rest, eighth rest(?) )
   else
       
%         if(sH > 1.5*line_w && HWratio>1.5 && top >= staff_lines(1)-parameters.thickness*2 && bot <= staff_lines(5))
        if(sH > 2*line_w && HWratio>1.5 && top >= staff_lines(1)-parameters.thickness*2 && top <= staff_lines(2) && bot <= staff_lines(5))
            %squiggly
            symbols(i).class = 1; % quarter rest
            
        elseif (sH > 1.25*line_w && HWratio>1.5 && top >= staff_lines(2)+2 && bot <= staff_lines(5))
            symbols(i).class = 11; %eighth rest
            
        else  % 1/2 or full rest or whole note
            
            % find left & right measure markers
            leftMM = 1;
            rightMM = 1;
            for mm = 1:length(measures)
                if (measures(mm).begin < lef)
                    leftMM = mm;
                end
                if (rightMM==1 && measures(mm).end > rig)
                    rightMM = mm;
                end
            end
            
            % count how many notes found within current measure
            notesInMeasure = 0;
            for note = 1:length(notes)
                if (notes(note).end > measures(leftMM).begin && notes(note).begin < measures(rightMM).end)
                    notesInMeasure = notesInMeasure + 1;
                end
            end
            
            
            if (notesInMeasure == 0) % either a whole note or whole rest
                
                curDistToMid = abs((symbols(i).bot+symbols(i).top)/2 - staff_lines(3)); %distance of current symbol to middle of staff
                wrongNote = 0;
                % count how many other symbols are in current measure and are
                % closer to the middle of the staff
                for sym = 1:length(symbols)
                    if (sym ~= i && symbols(sym).rig > measures(leftMM).begin && symbols(sym).lef < measures(rightMM).end)
                        thisDistToMid = abs((symbols(sym).bot+symbols(sym).top)/2 - staff_lines(3));
                        if thisDistToMid < curDistToMid % other notes are closer to middle of staff line
                            wrongNote = 1;
                        end
                    end
                end
                if wrongNote
                    symbols(i).class = 0; %trash
                    continue;
                end
                
                
                if(strcmp('open',determine_filled_open(symbols(i).img)) && sH > .8*line_w && sH < 1.3*line_w && sW < 3*line_w)
                    % whole note found
                    symbols(i).class = 10;
                else
                    if (symbols(i).top > staff_lines(1) && symbols(i).bot < staff_lines(4)) % within staff lines
                        midOfMeasure = (measures(leftMM).begin + measures(rightMM).begin)/2;
                        midOfSym = (symbols(i).lef + symbols(i).rig)/2;
                        if (abs(midOfMeasure - midOfSym) < 2*line_w && sW > line_w && sW < 3*line_w) % in middle of measures
                            % whole rest found
                            symbols(i).class = 6;
                        end
                    end
                end
                
                
            else % half or eighth(?) rest
                if (top > staff_lines(1) && bot < staff_lines(4) && abs((top+bot)/2-staff_lines(3)) < line_w && sW > .8*line_w && sW < 3*line_w) % within middle of staff
                    if (BWratio > 1)
                        % half rest found
                        symbols(i).class = 5;
                    else
                        % eighth rest found
                        symbols(i).class = 11;
                    end
                end
                
            end
            
            
        end % end else 1/2 or full rest or whole note
            
   end % end else other symbol
   
%    if(symbols(i).class > -1)
%        binplot(symbols(i).img);
%        symbols(i).class
%        keyboard
%    end
   
end % end for loop
    
    
    
        
   

o_symbols = symbols;