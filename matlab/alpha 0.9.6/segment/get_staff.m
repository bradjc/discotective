function [staff_img] = get_staff(pp_img, staff_bounds, params, count, out)

% isolate staff:
cur_img = pp_img;
top = round(staff_bounds(count.st, 1));
bot = round(staff_bounds(count.st, 2));
initial_staff = cur_img(top:bot, :);

% trim staff:
cur_img = initial_staff;
% cur_img = blob_kill(cur_img, 0, 1); % only from top
staff_img = trim_staff(cur_img);
staff_img = staff_img(:, params.ks_x:end);

end