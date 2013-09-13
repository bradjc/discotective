function [notes] = update_with_key_signature(notes, ks)

% A  A# B  C  C# D  D# E  F  F# G  G#

note_lookup = zeros(1, 12);

accum = 9;
for i=1:ks,
    note_lookup(accum) = 1;
    accum = 1 + mod(accum + 6, 12);
end

accum = 3;
for i=-1:-1:ks,
    note_lookup(accum) = -1;
    accum = 1 + mod(accum + 4, 12);
end

for i=1:length(notes)
    ind = 1 + mod(notes(i).midi - 57, 12);
    if(notes(i).midi ~= 0)
        notes(i).mod = note_lookup(ind);
    end
end

% notes:
%       |    note1    |    note2    |
% .midi | 
% .dur  | 
% .mod  | -1 <= flat  | 1 <= sharp  |
% .xloc | 

end