function [notes] = classify_stem_notes_eighths(img,stems,parameters,stafflines)
% output is struct NOTE
% notes.midi    - midi number
% notes.letter  - letter (ie 'G3')
% notes.dur     - duration in beats
% notes.mod     - modifier (+1 for sharp, -1 for flat)
% notes.xloc    - x location of the note's stem


notes = [];

[h,w] = size(img);

line_thickness = round(parameters.thickness);
line_spacing = round(parameters.spacing);

line = stafflines(1);
aboveLines = [];
while(1)
    line = line - line_spacing - line_thickness;
    if(line < 0)
        break;
    end
    aboveLines = [line aboveLines];  
end
aboveLength = 2*length(aboveLines);

belowLines = [];
for i=1:4
    belowLines = [belowLines (stafflines(5) + i*(line_spacing+line_thickness))];
end

staffLines = [aboveLines stafflines' belowLines];
numLines = length(staffLines);
lines_spaces = [];

%add spaces in between each line
for i = 1:numLines
    lines_spaces = [lines_spaces, staffLines(i), staffLines(i) + line_spacing/2 + line_thickness/2];
end

                                             %first space
trebleNotes= ['F2';'E2';'D2';'C2';'B2';'A2';'G3';'F3';'E3';'D3';'C3';'B3';'A3';'G4';'F4';'E4'];  
trebleMIDI = [  77;  76;  74;  72;  71;  69;  67;  65;  64;  62;  60;  59;  57;  55;  53;  52];
aboveNotes = ['C0';'B0';'A0';'G1';'F1';'E1';'D1';'C1';'B1';'A1';'G2'];
aboveMIDI =  [  96;  95;  93;  91;  89;  88;  86;  84;  83;  81';  79];



if (aboveLength==0)
    allNotes = trebleNotes;
    allMIDI = trebleMIDI;
else
    allNotes = [aboveNotes(end-aboveLength+1:end,:); trebleNotes];
    allMIDI = [aboveMIDI(end-aboveLength+1:end,:); trebleMIDI];
end


for i = 1:length(stems)
    
    COM = stems(i).center_of_mass;

    position = stems(i).position; % 'left' or 'right'
    left = stems(i).begin;
    right = stems(i).end;
    bottom = stems(i).bottom;
    top = stems(i).top;    
    
    dif = abs(lines_spaces - COM); % value closest to zero will be where its located
    [dummy closest] = min(dif);

    note_letter = allNotes(closest,:);
    note_midi = allMIDI(closest);
    
    
    if(strcmp(position,'left')) %head on left side
        bottomCut = bottom + line_spacing;
        if (bottomCut > h)
            bottomCut = h;
        end
        topCut = bottom - line_spacing;
        if (topCut < 1)
            topCut = 1;
        end
        rightCut = left-1;
        extend = round(1.7 * line_spacing);
        leftCut = left - extend;
        head_img = img(topCut:bottomCut, leftCut:rightCut);
        
    else %head on right side
        bottomCut = top + line_spacing;
        if (bottomCut > h)
            bottomCut = h;
        end
        topCut = top - line_spacing;
        if (topCut < 1)
            topCut = 1;
        end
        extend = round(1.8 * line_spacing);
        rightCut = right + extend;
        leftCut = right + 1;
        head_img = img(topCut:bottomCut, leftCut:rightCut);
    end

    % determine if note head is filled or open ('fill', 'open');
    type = determine_filled_open(head_img);
    if(strcmp(type,'fill'))
        note_dur = 1;
    else
        note_dur = 2;
    end
    notes = [notes, struct('midi',note_midi,'letter',note_letter,'dur',note_dur,'mod',0,'xloc',left)];
    
    
end % end FOR each stem





end