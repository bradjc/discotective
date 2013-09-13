function [staff_img] = get_staff(pp_img, staff_bounds, params, count, out)

% isolate staff:
cur_img = pp_img;
top = round(staff_bounds(count.st, 1));
bot = round(staff_bounds(count.st, 2));
initial_staff = cur_img(top:bot, :);

% trim staff:
cur_img = initial_staff;
staff_img = trim_staff(cur_img);
staff_img = staff_img(:, params.key_sig_x:end);

end