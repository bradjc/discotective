function [notes wholeFound] = contextualizer_notes_rests(notes, symbols)
% make modification to notes based on classification of whole notes and
% rests
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
        
        case 10, % whole note
            wholeFound = 1;
            center_of_mass = (symbols(i).top + symbols(i).bot)/2;
            note_struct = struct('begin',symbols(i).lef,'end',symbols(i).rig,'position','',...
              'center_of_mass',center_of_mass,'top',symbols(i).top,'bottom',symbols(i).bot,...
              'dur',4,'eighthEnd',0,...
              'midi',0,'letter','','mod',0);

            % find closest note to the left
            note_num = 0;
            for n=1:length(notes) % find closest note to the left of the dot
                if (notes(n).end - symbols(i).rig > 0) % note is to the right
                    break;
                end
                note_num = n;
            end

            % insert whole note into notes struct array at correct location
            if (note_num == 0)
                notes = [note_struct; notes];
            else
                notes = [notes(1:note_num); note_struct; notes(note_num+1:end)];
            end

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
              'midi',0,'letter','rest','mod',0);

            % find closest note to the left
            note_num = 0;
            for n=1:length(notes) % find closest note to the left of the dot
                if (notes(n).end - symbols(i).rig > 0) % note is to the right
                    break;
                end
                note_num = n;
            end

            % insert whole note into notes struct array at correct location
            if (note_num == 0)
                notes = [note_struct; notes];
            else
                notes = [notes(1:note_num); note_struct; notes(note_num+1:end)];
            end
            
    end
            
            

    
end




end