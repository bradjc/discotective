function [key_signature] = get_key_signature(img, params, out)

% resize for now... maybe make inputs better in future:
[h w] = size(img);
w = round(w/4);
img = img(:, 1:w);

% connected component:
symbol_bounds = disconnect(img, 5);

% find a tall symbol:
% this should be the time signature, but it
% probably won't work if we're in C time.
% will have to think of something better later.
symbol = 1;
height = 0;
while (height < 0.9 * params.height)
    symbol = symbol + 1;
    height = symbol_bounds(symbol, 2) - symbol_bounds(symbol, 1);
end

% segment key signature:
lef = symbol_bounds(1, 4);
rig = symbol_bounds(symbol, 3);
ks_img = img(:, lef:rig);
ks_img = blob_kill(ks_img, 1, 1);

% project onto x axis:
px = sum(ks_img, 1);

% output if necessary:
if (out.cl)
    figure
    subplot(211)
    imagesc(1 - ks_img), colormap(gray)
    title('key signature')
    
    subplot(212)
    plot(px)
    title('key signature x proj')
end

% travel along projection to classify
% sharps and flats as they come:
sharps = 0;
flats = 0;
l = length(px);
i = 1;
while (i <= l)
    % eat up zeros:
    while (i <= l && px(i) == 0)
        i = i + 1;
    end
    
    % find first peak (must be at least min pixels):
    peak1 = 0;
    min = 8;
    while (i <= l && peak1 <= min)
        while ( (i<l && px(i)<px(i+1)) || (i<(l-1) && px(i)<px(i+2)) )
            i = i + 1;
        end
        peak1 = px(i);
        i = i + 1;
    end
    
    % find dip:
    while ( (i<l && px(i)>px(i+1)) || (i<(l-1) && px(i)>px(i+2)) )
        i = i + 1;
    end
    if (i <= l)
        valley = px(i);
    end
    
    % find second peak:
    while ( (i<l && px(i)<px(i+1)) || (i<(l-1) && px(i)<px(i+2)) )
        i = i + 1;
    end
    if (i <= l)
        peak2 = px(i);
        i = i + 1;
        
       % discriminate:
       % (idk, i made this up... maybe make something better later)
        w1 = -0.75 * (abs(peak1 - peak2) - params.height/7);
        w2 = 0.25 * ((peak2 - valley) - params.height/10);
        s = w1 + w2;
    
        % classify sharp or flat:
        if (w1 > 0)
            sharps = sharps + 1;
        else
            flats = flats + 1;
        end
    end
    
    % eat up the remaining hump:
    while (i <= l && px(i) > 0)
        i = i + 1;
    end
end
 
% find key signature:
if (sharps >= flats)
    key_signature = sharps + flats;
else
    key_signature = -1 * (sharps + flats);
end

end