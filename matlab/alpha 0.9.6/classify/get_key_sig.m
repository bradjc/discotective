function [params] = get_key_sig(img, staff_bounds, params, out)

debug = 0;

% quick parameter fix (using RLA)
[line_thickness line_spacing] = get_staff_parameters(img);
params.thickness = line_thickness;
params.spacing = line_spacing;
params.height = 5*line_thickness + 4*line_spacing;

%%% SET UP STAFF %%%

% get first staff:
top0 = staff_bounds(1, 1);
bot0 = staff_bounds(1, 2);
middle = (top0 + bot0)/2;

% prepare to crop at a very specific height:
top = round(middle - params.height/1.3);
bot = round(middle + params.height/1.3);

% perform crop:
staff1 = img(top:bot, :);

% trim excess material:
staff1 = trim_staff(staff1);

% get size and trim:
[h w] = size(staff1);
fudge = round(params.height/3); % avoids a specific bug
staff1 = staff1(:, fudge:round(w/4));

if (debug)
    % output staff:
    figure
    subplot(311)
    imagesc(1-staff1), colormap(gray);
end


%%% ISOLATE KEY SIGNATURE %%%

% remove lines and find middle line:
[lineless_img sl] = remove_lines(staff1, params, 20);
middle = sl(3);

% project onto x-axis:
proj1 = sum(lineless_img, 1);

if (debug)   
    % output lineless staff:
    subplot(312)
    imagesc(1-lineless_img), colormap(gray)
    
    % output projection:
    subplot(313)
    plot(proj1)
end


% note: the following code uses the variable i to travel from left to
% right along the projection.  first it looks for whitespace, then
% the clef, then sharps or flats, then a key signature.  it detects
% the key signature by recognizing that a shape centered vertically
% on the staff.  if no key signature is detected, however, the algorithm
% can still recover later.

% find all whitespace to the left:
i = 1;
while (proj1(i) < 2 || proj1(i+2) < 2)
    i = i + 1;
end

% find cleff:
while (i < (length(proj1) - 1) && proj1(i) > 1 || proj1(i+2) > 1)
    % error check:
    if (i >= (length(proj1) - 2))
        error('error in staffline removal (key signature classification)')
    end
    i = i + 1;
end

% note start of key signature segment:
ks_x_begin = i + 5;

% find sharps or flats:
ks_x_end = 0;
while (ks_x_end == 0)
    
    % find next symbol:
    %   remove whitespace:
    while(proj1(i) < 2 || proj1(i+2) < 2)
        i = i + 1;
    end
    lef = i;
    %   remove non-whitespace:
    while (proj1(i) > 1 || proj1(i+2) > 1)
        i = i + 1;
    end
    rig = i;

    % isolate symbol:
    shape_img = lineless_img(:, lef:rig);
    
    % take projection onto y:
    projs = sum(shape_img, 2);
    
    % find top and bottom bounds:
    top = 1;
    while(projs(top) == 0 || projs(top+2) == 0)
        top = top + 1;
    end
    bot = h;
    while(projs(bot) == 0 || projs(bot-2) == 0)
        bot = bot - 1;
    end
    
    % test if bounds are centered about middle line;
    % if so, a key signature is detected:
    if (abs((bot+top)/2 - middle) < params.spacing/4)
        ks_x_end = lef - 8;
    end
    
end

% if key signature segment is very thin,
% they key must be c:
if (ks_x_end - ks_x_begin < 5)
    params.ks_x = ks_x_begin + fudge - 10;
    params.ks = 0;
    return
end

% isolate key signature section:
ks_img = lineless_img(:, ks_x_begin:ks_x_end);

% skip this...
%%% ALTERNATE METHOD FOR MULTIPLE LINES %%%
%{
else
    
    proj1 = sum(staff1, 1);
    [dummy s1_loc] = max(proj1(1:3*round(params.height)));
    staff_dif = zeros(1, round(w/4));
    
    for staff_ind = 2:num_staffs
        
        % get next staff:
        top0 = staff_bounds(staff_ind, 1);
        bot0 = staff_bounds(staff_ind, 2);
        middle = (top0 + bot0)/2;
        top = round(middle - params.height/1.5);
        bot = round(middle + params.height/1.5);
        staffn = img(top:bot, :);
        staffn = trim_staff(staffn);
        staffn = staffn(:, 1:round(w/4));
        
        projn = sum(staffn, 1);
        
        [dummy sn_loc] = max(projn(1:3*round(params.height)));
        
        offset = sn_loc - s1_loc;
        
        if (offset > 0)
            d = abs(proj1(1:end-offset) - projn(offset+1:end));
            staff_dif(1:end-offset) = staff_dif(1:end-offset) + d;
        else
            d = abs(proj1(-offset+1:end) - projn(1:end+offset));
            staff_dif(1:end+offset) = staff_dif(1:end+offset) + d;
        end
        
        % output staff:
        % subplot(num_staffs, 1, staff_ind)
        % imagesc(1-ks_img), colormap(gray);
        % plot(staff_dif)
        
    end
    
    staff_dif = staff_dif/(num_staffs - 1);
    findings = find(staff_dif > params.height/3);
    
    ks_x_end = 0;
    i = 1;
    while (ks_x_end < params.height)
        ks_x_end = findings(i);
        i = i + 1;
    end
    ks_x_end = ks_x_end - 8;
    
    % figure
    % subplot(211), plot(proj1)
    % subplot(212), imagesc(1-staff1), colormap(gray)
    
    findings = find(proj1 > params.height/2.5);
    
    l = length(findings);
    i = 1;
    while (i < l && findings(i+1) - findings(i) < 4)
        i = i + 1;
    end
    
    ks_x_begin = findings(i) + 5;
    
    if (ks_x_end - ks_x_begin < 5)
        params.ks = 0;
        params.ks_x = ks_x_end;
        return
    end
    
    ks_img = staff1(:, ks_x_begin:ks_x_end);
    ks_img = remove_lines(ks_img, params, 2);
    
end
%}

% figure
% imagesc(1-ks_img), colormap(gray)
% plot(proj1)


%%% CLASSIFY KEY SIGNATURE %%%

% take projection onto x:
px = sum(ks_img, 1);

if (debug)
    % plot key signature projection:
    figure
    plot(px)
end

% travel along projection to classify
% sharps and flats as they come:
sharps = 0;
flats = 0;
l = length(px);
i = 1;
while (i <= l)
    
    % eat up whitespace:
    while (i <= l && px(i) == 0)
        i = i + 1;
    end
    
    % find first peak (must be at least min pixels):
    peak1 = 0;
    minm = 8;
    while (i <= l && peak1 <= minm)
        while ( (i<l && px(i)<px(i+1)) || (i<(l-1) && px(i)<px(i+2)) )
            i = i + 1;
        end
        peak1 = px(i);
        p1_x = i;
        i = i + 1;
    end
    
    % find dip:
    while ( (i<l && px(i)>=px(i+1)) || (i<(l-1) && px(i)>=px(i+2)) )
        i = i + 1;
    end
    if (i <= l)
        valley = px(i);
    end
    
    % find second peak:
    while ( (i<l && px(i)<px(i+1)) || (i<(l-1) && px(i)<px(i+2)) )
        i = i + 1;
    end
    
    % complicated if statement to avoid bugs:
    if (i <= l && ((sharps + flats == 0) || ...
            (exist('valley', 'var') && exist('peak2', 'var') && ...
            abs(last_peak1 - peak1) < 10 && ... 
            abs(last_valley - valley) < 15 && ...
            abs(last_peak2 - peak2) < 10)))

        peak2 = px(i);
        p2_x = i;
        i = i + 2;
        lst_width = p2_x - p1_x;
        
        % discriminate:
        % (idk, i just made these up... maybe make something better later)
        w1 = -0.6 * ((peak1 - peak2) - params.height/10);
        w2 = 0.4 * ((peak2 - valley) - params.height/7);
        s = w1 + w2;
        
        % classify sharp or flat:
        if (s > 0)
            sharps = sharps + 1;
        else
            flats = flats + 1;
        end
    
    else
        
        if (i <= l)
            % error in classification of key signature;
            % reassign value for ks_x (used to trim staffs later):
            params.ks_x = max(i + fudge + round(params.height/2) - 10, 1);
            i = l + 1;

        else
            % no error; assign ks_x:
            params.ks_x = max(fudge + ks_x_end - 5, 1);
        end
        
    end
    
    % eat up the remaining hump:
    while (i <= l && px(i) > 0)
        i = i + 1;
    end
   
    last_peak1 = peak1;
    if (exist('valley', 'var') && exist('peak2', 'var'))
        last_valley = valley;
        last_peak2 = peak2;
    end
    
    % loops to next symbol if neccessary ^:
    
end

if (exist('valley', 'var') && exist('peak2', 'var'))

    % finish up:
    if (sharps >= flats)
        params.ks = sharps + flats;
    else
        params.ks = -1 * (sharps + flats);
    end

else
    
    params.ks = 0;
    
end
    
end