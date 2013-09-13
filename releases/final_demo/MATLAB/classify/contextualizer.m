function [notes wholeFound] = contextualizer(notes, measures, symbols, ks)
% make modification to notes based on classification of all other symbols
%
% input structs:
%%% symbols struct:
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
%
%%% notes struct:
%  .begin           - beginning of stem (left)
%  .end             - end of stem (right)
%  .position        - either 'left' or 'right' depending which side notehead_img is on
%  .center_of_mass  - y position of center of notehead_img
%  .top             - top of stem
%  .bottom          - bottom of stem
%  .dur             - duration of note in beats (0.5,1,2,4 etc)
%  .eighthEnd       - 1 if it is the last eighth note in a group (or single eighth)
%  .midi            - midi number (field modified later)
%  .letter          - letter (ie 'G3') (not necessary for C)
%  .mod             - modifier (+1 for sharp, -1 for flat, 0 for natural)


wholeFound = 0;

% loop thru each symbol
for i = 1:length(symbols)
    
    switch (symbols(i).class)
        case 3, % dot
            note_num = 1;
            for n=2:length(notes) % find closest note to the left of the dot
                if (notes(n).end - symbols(i).rig > 0) % note is to the right
                    break;
                end
                note_num = n;
            end

            %increase duration of dot
            if (notes(note_num).dur == 0.5 || notes(note_num).dur == 1 || notes(note_num).dur == 2)
                notes(note_num).dur = notes(note_num).dur * 1.5;
        end
        
        case 10, % whole note
            wholeFound = 1;
            center_of_mass = (symbols(i).top + symbols(i).bot)/2;
            note_struct = struct('begin',symbols(i).lef,'end',symbols(i).rig,'position','',...
              'center_of_mass',center_of_mass,'top',symbols(i).top,'bottom',symbols(i).bot,...
              'dur',4,'eighthEnd',0,...
              'midi',0,'letter','','mod',0);
            note_struct = update_with_key_signature(note_struct,ks); % update mod to key signature

            % find closest note to the left
            note_num = 1;
            for n=2:length(notes) % find closest note to the left of the dot
                if (notes(n).end - symbols(i).rig > 0) % note is to the right
                    break;
                end
                note_num = n;
            end

            % insert whole note into notes struct array at correct location
            notes = [notes(1:note_num); note_struct; notes(note_num+1:end)];

        case {1,5,6,11},
            % rest found
            switch (symbols(i).class)
                case 1,
                    duration = 1;
                case 5,
                    duration = 2;
                case 6,
                    duration = 4; 
                case 11,
                    duration = 0.5;
            end

            note_struct = struct('begin',symbols(i).lef,'end',symbols(i).rig,'position','',...
              'center_of_mass',0,'top',symbols(i).top,'bottom',symbols(i).bot,...
              'dur',duration,'eighthEnd',0,...
              'midi',0,'letter','','mod',0);

            % find closest note to the left
            note_num = 1;
            for n=2:length(notes) % find closest note to the left of the dot
                if (notes(n).end - symbols(i).rig > 0) % note is to the right
                    break;
                end
                note_num = n;
            end

            % insert whole note into notes struct array at correct location
            notes = [notes(1:note_num); note_struct; notes(note_num+1:end)];



        case {7,8,9}, % accidental
            switch (symbols(i).class)
                case 7, %sharp
                    mod = 1;
                case 8, %flat
                    mod = -1;
                case 9, %natural
                    mod = 0;
            end            
            
            % find closest note on right
            note_num = length(notes);
            for n=length(notes)-1:-1:1 % find closest note to the left of the dot
                if (symbols(i).lef - notes(n).begin > 0) % note is to the left
                    break;
                end
                note_num = n;
            end
            
            % find left & right measure markers that enclose found note
            leftMM = 1;
            rightMM = 1;
            for mm = 1:length(measures)
                if (measures(mm).begin < symbols(i).lef)
                    leftMM = mm;
                end
                if (rightMM==1 && measures(mm).end > symbols(i).rig)
                    rightMM = mm;
                end
            end
            
            % loop thru notes again, modify all notes within measure with
            % same pitch as accidental's partner note
            midi_2_mod = notes(note_num).midi;
            for n = 1:length(notes)
                if (notes(n).end > measures(leftMM).begin && notes(n).begin < measures(rightMM).end)
                    if (notes(n).midi == midi_2_mod)
                        notes(n).mod = mod;
                    end
                end
            end
            
            
            
        otherwise,

        end
    
end




end