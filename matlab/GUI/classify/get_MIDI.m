function [notes] = get_MIDI(img,notes,parameters,stafflines)
% fills in .midi and .letter fields for note struct
%
% output is struct NOTE
% notes.begin           - beginning of stem (left)
% notes.end             - end of stem (right)
% notes.position        - either 'left' or 'right' depending which side notehead is on
% notes.center_of_mass  - y position of center of notehead
% notes.top             - top of stem
% notes.bottom          - bottom of stem
% notes.eighthEnd       - 1 if it is the last eighth note in a group (or single eighth)
% notes.midi            - midi number
% notes.letter          - letter (ie 'G3') (not necessary for C)
% notes.mod             - modifier (+1 for sharp, -1 for flat, 0 for
%                         natural)


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


for i = 1:length(notes)
    
    if (notes(i).midi == 0 && notes(i).center_of_mass ~= 0)
        COM = notes(i).center_of_mass;   

        if (COM == 0) % note is actually a rest
            note_letter = 'rest';
            note_midi = 0;
        else

            dif = abs(lines_spaces - COM); % value closest to zero will be where its located
            [dummy closest] = min(dif);

            note_letter = allNotes(closest,:);
            note_midi = allMIDI(closest);
        end

        % modify notes struct
        notes(i).midi = note_midi;
        notes(i).letter = note_letter;
        
    end
   
    
end % end FOR each stem





end