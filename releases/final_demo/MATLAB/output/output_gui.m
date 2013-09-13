function [song f_s] = output(notes, BPM, key)

%%% OVERVIEW %%%

% this is a simple script for output
% it also defines an input vector format

% Format for output:
% [ midi_number_1  midi_number_2 ... ]
% [ duration_1     duration_2    ... ]
%
% MIDI numbers:
% 52 E  164.81
% 53 F  174.61
% 54 F# 185.00
% 55 G  196.00
% 56 G# 207.65
% 57 A  220.00
% 58 A# 233.08
% 59 B  246.94
% 60 C  261.63
% 61 C# 277.18
% 62 D  293.67
% 63 D# 311.13
% 64 E  329.63
% 65 F  349.23
% 66 F# 369.99
% 67 G  392.00
% 68 G# 415.30
% 69 A  440.00
% 70 A# 466.16
% 71 B  493.88
% 72 C  523.25
% 73 C# 554.37
% 74 D  587.33
% 75 D# 622.25
% 76 E  659.26
% 77 F  698.46
% 78 F# 739.99
% 79 G  783.99
% 80 G# 830.61
% 81 A  880.00
% 82 A# 932.33
% 83 B  987.77
% 84 C  1046.5

% durations:
%  1 = eigth note, 2 = quarter note, 4 = half note, 8 = whole note

midi_base = -51;
freqs = [164.81 174.61 185 196 207.65 220 233.08 246.94 261.63 277.18 ...
    293.67 311.13 329.63 349.23 369.99 392.00 415.30 440.00 466.16 ...
    493.88 523.25 554.37 587.33 622.25 659.26 698.46 739.99 783.99 ...
    830.61 880.00 932.33 987.77 1046.5];
f_s = 8192;
bpm = BPM; %BPM
beat_length = (f_s * 60)/bpm;
eigth_length = beat_length / 2;

sl = round(eigth_length/5);
% smooth attack:
attack = (1-cos(pi*(0:sl-1)/sl))/2;
% stronger attack:
% attack = (1-cos(pi*(0:sl-1)/sl))/2.*exp((1:sl)/sl);
finish = (1+cos(pi*(0:sl-1)/sl))/2;

song = [];

for i=1:length(notes)
    
    try
        if (notes(1, i) == 0) % rest
            duration = round(eigth_length * notes(2, i));
            rest = zeros(1,duration);
            song = [song rest];
            
        else
            f_index = midi_base + notes(1, i);
            freq = freqs(f_index);
            midi = notes(1,i) + key;
            freq = 2^((midi-52)/12)*164.81;
            duration = round(eigth_length * notes(2, i));

            tone = 0.03 * sin(2*pi*freq*(1:duration)/f_s);
            % harmonics:
            tone = tone + 0.06 * sin(2*pi*2*freq*(1:duration)/f_s);
            tone = tone + 0.003 * sin(2*pi*3*freq*(1:duration)/f_s);

            tone(1:sl) = tone(1:sl) .* attack;
            tone(end-sl+1:end) = tone(end-sl+1:end) .* finish;

            song = [song tone];
        end
    catch
       %fprintf('Error: Note exceeded MIDI limits\nMIDI = %d, NOTE = %d\n',notes(i),i);
    end
  
end





end
