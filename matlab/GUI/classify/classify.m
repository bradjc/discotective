function [output, count, notes, params, staff_imgs] = classify(staff_img, params, count, out, staff_imgs, num_st)

[h w] = size(staff_img);

% parameters:
numCuts = 30;
line_spacing = round(params.spacing);

% remove staff-lines:
[lineless_img staff_lines] = remove_lines(staff_img, params, numCuts);
staff_lines = round((staff_lines(:,1) + staff_lines(:,2))/2);

% find locations of measures and stems:
[measures notes lineless_img] = find_lines(lineless_img, params, count.st, staff_lines, out);
lineless_img(:,w-3*line_spacing:end) = 0;

% classify notes with stems:
notes = get_MIDI(lineless_img, notes, params, staff_lines);



% remove notes and measures from image:
noteless_img = remove_notes_measures(lineless_img, notes, measures, params, staff_lines, out);



% add images to struct
% 1-init,2-nolines,3-stemsdetect,4-nonotes(symboldetect?)
tstaff_img = 1-staff_img; tstaff_img = cat(3,tstaff_img,tstaff_img,tstaff_img);
    staff_imgs{(count.st-1)*4+1} = tstaff_img;
tlineless_img = 1-lineless_img; tlineless_img = cat(3,tlineless_img,tlineless_img,tlineless_img);  
    staff_imgs{(count.st-1)*4+2} = tlineless_img;

% show where stems and measure markers are found (color them)
stem_img = tlineless_img;
for i=1:length(notes)
%     xstem = round((notes(i).begin + notes(i).end)/2);
%     here_left = max([1 xstem-2]);
%     here_right = min([size(stem_img,2) xstem+2]);
    here_left = max([1 notes(i).begin-2]);
    here_right = min([notes(i).end+2 size(stem_img,2)]);
    here_width = here_right - here_left + 1;
    stem_img(:,here_left:here_left+1,:) = cat(3,ones(size(stem_img,1),2),zeros(size(stem_img,1),2),zeros(size(stem_img,1),2)); %red
    stem_img(:,here_right-1:here_right,:) = cat(3,ones(size(stem_img,1),2),zeros(size(stem_img,1),2),zeros(size(stem_img,1),2)); %red
    stem_img(1:3,here_left:here_right,:) = cat(3,ones(3,here_width),zeros(3,here_width),zeros(3,here_width)); %red
    stem_img(end-2:end,here_left:here_right,:) = cat(3,ones(3,here_width),zeros(3,here_width),zeros(3,here_width)); %red
    %     width_here = here_right - here_left + 1;
%     stem_img(:,here_left:here_right,:) = cat(3,ones(size(stem_img,1),width_here),zeros(size(stem_img,1),width_here),zeros(size(stem_img,1),width_here)); %red
end
for i=1:length(measures)
%     xstem = round((measures(i).begin + measures(i).end)/2);
%     here_left = max([1 xstem-2]);
%     here_right = min([size(stem_img,2) xstem+2]);
    here_left = max([1 measures(i).begin-2]);
    here_right = min([measures(i).end+2 size(stem_img,2)]);
    here_width = here_right - here_left + 1;
    stem_img(:,here_left:here_left+1,:) = cat(3,zeros(size(stem_img,1),2),ones(size(stem_img,1),2),zeros(size(stem_img,1),2)); %red
    stem_img(:,here_right-1:here_right,:) = cat(3,zeros(size(stem_img,1),2),ones(size(stem_img,1),2),zeros(size(stem_img,1),2)); %red
    stem_img(1:3,here_left:here_right,:) = cat(3,zeros(3,here_width),ones(3,here_width),zeros(3,here_width)); %red
    stem_img(end-2:end,here_left:here_right,:) = cat(3,zeros(3,here_width),ones(3,here_width),zeros(3,here_width)); %red
    
%     width_here = here_right - here_left + 1;
%     stem_img(:,here_left:here_right,:) = cat(3,zeros(size(stem_img,1),width_here), ones(size(stem_img,1),width_here), zeros(size(stem_img,1),width_here)); %green
end
staff_imgs{(count.st-1)*4+3} = stem_img;







    
% these comments were if we went measure by measure
% (hopefully in C?)
% cur_w = 1;
% while (cur_w < w)

% [notes cur_w] = get_notes(lineless_img, params, cur_w);

% format for notes :
%        | midi number | duration | x-cor | y-cor
% note 1 | ...
% note 2 | ...

% find and classify remaining symbols:
[h w] = size(noteless_img);
symbol_bounds = disconnect(noteless_img, 6);
num_symbols = size(symbol_bounds, 1);
symbols = [];

for symbol = 1:size(symbol_bounds, 1),
    top2 = symbol_bounds(symbol, 1);
    bot2 = symbol_bounds(symbol, 2);
    lef2 = symbol_bounds(symbol, 3);
    rig2 = symbol_bounds(symbol, 4);
    symbol_img = noteless_img(top2:bot2, lef2:rig2);
    symbol_struct = struct('top',top2,'bot',bot2,'lef',lef2,'rig',rig2,'img',symbol_img,'class',-1);
    symbols = [symbols symbol_struct];
end

com_symbols = combine_symbols(symbols, params, noteless_img);
com_symbols = classify_symbols(com_symbols,params,notes,measures,staff_lines);

% make modifications to notes
[notes wholeFound] = contextualizer_notes_rests(notes,com_symbols);
if (wholeFound)
    notes = get_MIDI(lineless_img, notes, params, staff_lines); % once more to catch whole notes
end

% update with key signature
notes = update_with_key_signature(notes, params.key_sig);

% contextualizes dots and accidentals
notes = contextualizer_other(notes, measures, com_symbols);

num_symbols = length(com_symbols);

count.sbplt = 13;
for symbol = 1:num_symbols,
    
    % isolate symbol:
    % we're adding padding and then removing any black
    % symbols from the edges - the hope is to remove any
    % other symbol pieces that might be the frame
        
    symb_img = com_symbols(symbol).img;
    
    if (out.cl)
        % output current symbol:
        if (count.sbplt > 12)
            figure
            count.sbplt = 1;
        end
        subplot(3, 4, count.sbplt)
        imagesc(1-symb_img), colormap(gray) 
        title(sprintf('symbol %d  class:%d', count.sym, com_symbols(symbol).class))
        count.sym = count.sym + 1;
        count.sbplt = count.sbplt + 1;
    end
    
    if (out.sv)
        % save tif image of current symbol:
        file_name = sprintf('symbol%d.tif', count.sym);
        path_name = strcat(count.out_pth, file_name);
        imwrite(1-symb_img, path_name, 'tif');
        
        % save mat file of current symbol:
        file_name = sprintf('symbol%d.mat', count.sym);
        path_name = strcat(count.out_pth, file_name);
        save(path_name, 'symb_img');
    end
    
end


% lets put boxes around? SYMBOL BOXES
tnoteless_img = 1-noteless_img; tnoteless_img = cat(3,tnoteless_img,tnoteless_img,tnoteless_img);  

tnoteless_img = draw_boxes(tnoteless_img,com_symbols);

staff_imgs{(count.st-1)*4+4} = tnoteless_img;

    


output = [];
for i = 1:length(notes)
    output = [output [notes(i).midi+notes(i).mod; notes(i).dur]];
end

end