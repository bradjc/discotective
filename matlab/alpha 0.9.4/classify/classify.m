function [output, count, notes, params] = classify(staff_img, params, count, out)

[h w] = size(staff_img);

% parameters:
numCuts = 30;

% debugging output
if (out.staff_dbg)
    binplot(staff_img);
    titlestr = ['Staff ' num2str(count.st)];
    title(titlestr);
end


% remove staff-lines:
[lineless_img staff_lines] = remove_lines(staff_img, params, numCuts);
staff_lines = round((staff_lines(:,1) + staff_lines(:,2))/2);



% find locations of measures and stems:
[measures stems] = find_lines(lineless_img, params, count.st, out);

% classify notes with stems:
notes = classify_stem_notes(lineless_img, stems, params, staff_lines);

% remove notes and measures from image:
noteless_img = remove_notes_measures(lineless_img, stems, measures, params, staff_lines, out);

% output if necessary:
if (out.st)
    figure
    subplot(311)
    imagesc(1 - staff_img), colormap(gray)
    title(sprintf('staff %d', count.st))
    subplot(312)
    imagesc(1 - lineless_img), colormap(gray)
    title(sprintf('lineless staff %d', count.st))
    subplot(313)
    imagesc(1 - noteless_img), colormap(gray)
    title(sprintf('lineless, noteless staff %d', count.st))
end

% these comments were if we went measure by measure
% (hopefully in C?)
% cur_w = 1;
% while (cur_w < w)

% [notes cur_w] = get_notes(lineless_img, params, cur_w);

% format for notes :
%        | midi number | duration | x-cor | y-cor
% note 1 | ...
% note 2 | ...

if (count.st == 1) % && measure == 1)
    % params.ks = get_key_signature(lineless_img, params, out);
    % format for key signature:
    % -2 = B flat, -1 = F, 0 = C, 1 = G, 2 = D, etc...
    % may change later depending on desired format
end


if(out.cl)
    figure
end



% find and classify remaining symbols:
[h w] = size(noteless_img);
symbol_bounds = disconnect(noteless_img, 6);
symbols = [];

for symbol = 1:length(symbol_bounds),
    top2 = symbol_bounds(symbol, 1);
    bot2 = symbol_bounds(symbol, 2);
    lef2 = symbol_bounds(symbol, 3);
    rig2 = symbol_bounds(symbol, 4);
    symbol_img = noteless_img(top2:bot2, lef2:rig2);
    symbol_struct = struct('top',top2,'bot',bot2,'lef',lef2,'rig',rig2,'img',symbol_img);
    symbols = [symbols symbol_struct];
end

com_symbols = combine_symbols(symbols, params, noteless_img);
num_symbols = length(com_symbols);
    
for symbol = 1:num_symbols,
    
    % isolate symbol:
    % we're adding padding and then removing any black
    % symbols from the edges - the hope is to remove any
    % other symbol pieces that might be the frame
%     top = max(1, symbol_bounds(symbol, 1)-3);
%     bot = min(h, symbol_bounds(symbol, 2)+3);
%     lef = max(1, symbol_bounds(symbol, 3)-3);
%     rig = min(w, symbol_bounds(symbol, 4)+3);
%     cur_img = noteless_img(top:bot, lef:rig);
%     cur_img = blob_kill(cur_img, 1, 1);
%     symb_img = w_crop(cur_img, 1); % (1 => strict)
    count.sym = count.sym + 1;

    if (out.cl)
        % output current symbol:
        if (count.sbplt > 12)
            figure
            count.sbplt = 1;
        end
        subplot(3, 4, count.sbplt)
        imagesc(1-com_symbols(symbol).img), colormap(gray) 
        title(sprintf('symbol %d', count.sym))
        count.sbplt = count.sbplt + 1;
    end
    
    if (out.sv)
        % save tif image of current symbol:
        file_name = sprintf('symbol%d.tif', count.sym);
        path_name = strcat(count.out_pth, file_name);
        imwrite(1-com_symbols(symbol).img, path_name, 'tif');
        
        % save mat file of current symbol:
        file_name = sprintf('symbol%d.mat', count.sym);
        path_name = strcat(count.out_pth, file_name);
        save(path_name, 'symb_img');
    end
    
end


% notes = update_with_key_signature(notes, params.ks);

output = [];
for i = 1:length(notes)
    output = [output [notes(i).midi+notes(i).mod; notes(i).dur]];
end

end