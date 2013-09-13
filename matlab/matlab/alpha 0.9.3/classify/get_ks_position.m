function [x_pos] = get_ks_position(pp_img, staff_bounds, params)

debug = 1;

threshold = params.height/2.5;
x_pos = 0;

[h w] = size(pp_img);
tst_l = round(w/3);

% isolate staff:
top = round(staff_bounds(1, 1));
bot = round(staff_bounds(1, 2));
staff1_img = pp_img(top:bot, :);

% trim staff:
staff1_img = trim_staff(staff1_img);

num_staffs = size(staff_bounds, 1);

if (num_staffs == 1)
    
    [cur_img staff_lines] = remove_lines_smart(staff1_img, params, 30);
    symbol_bounds = disconnect(cur_img, 5);

    % find a tall symbol:
    % this should be the time signature, but it
    % probably won't work if we're in C time.
    % will have to think of something better later.

    % crappy fix for milestone 1:
    sb = symbol_bounds;
    i = 2;
    while (i <= size(sb, 1))

        sml_sz = min(sb(i, 4)-sb(i, 3), sb(i-1, 4)-sb(i-1, 3));
        strt = max(sb(i, 3), sb(i-1, 3));
        stp = min(sb(i, 4), sb(i-1, 4));
        overlap = stp - strt;
        if (overlap >= min(sml_sz, 8))
            sb(i-1, 1) = min(sb(i-1, 1), sb(i, 1));
            sb(i-1, 2) = max(sb(i-1, 2), sb(i, 2));
            sb(i, :) = [];
        else 
            i = i+1;
        end

    end
    symbol_bounds = sb;

    symbol = 1;
    height = 0;
    while (height < 0.9 * params.height)
        symbol = symbol + 1;
        height = symbol_bounds(symbol, 2) - symbol_bounds(symbol, 1);
    end

    x_cor = symbol_bounds(symbol, 3) - 10;
    
else
    
    proj_staff1 = sum(staff1_img, 1);
    proj_staff1 = proj_staff1(1:tst_l);
    if (debug)
        figure
        subplot(num_staffs, 1, 1), imagesc(1-staff1_img), colormap(gray)
    end

    
    proj_dif = zeros(1, tst_l);
    
    for staff=2:num_staffs
        
        top = round(staff_bounds(staff, 1));
        bot = round(staff_bounds(staff, 2));
        cur_img = pp_img(top:bot, :);
        cur_img = trim_staff(cur_img);
        
        proj_onto_x = sum(cur_img, 1);
        proj_dif = proj_dif + abs(proj_onto_x(1:tst_l) - proj_staff1(1:tst_l));
        
        if (debug)
            subplot(num_staffs, 1, staff), imagesc(1-cur_img), colormap(gray)
        end
        
    end
    
    proj_dif = round(proj_dif/(num_staffs - 1));
    
    i = 1;
    while(x_pos < 0.55 * params.height)
        the_goods = find(proj_dif > threshold);
        x_pos = the_goods(i);
        i = i + 1; 
    end
   
    x_pos = x_pos - 10;
    
    if (debug)
        figure
        plot(proj_dif)
    end

end