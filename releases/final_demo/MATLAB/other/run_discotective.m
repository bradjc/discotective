function [out_data pp_img bin_img staff_imgs num_st keyS] = run_discotective(img)
% the discotective
% 
% eecs 452 digital signal processing design laboratory
% university of michigan
% winter 2011
%
% katie bouman, brad campbell, mike hand, tyler johnson, joe kurleto

clearvars -except img;
addpath classify output preprocess samples segment trim utility;



% output choices:
preprocess_o = 0;
save_o = 0;
staff_o = 0;
staff_dbg_o = 0; %initial staff
stems_o = 0;
class_o = 0;
sound_o = 0;
dbg_staff = 0;
dbg_xbegin = 0;

% output struct:
out = struct('pp', preprocess_o, 'sv', save_o, 'st', staff_o, 'staff_dbg',...
    staff_dbg_o, 'cl', class_o, 'sd', sound_o, 'stems', stems_o, 'dbg_s', dbg_staff, 'dbg_x',dbg_xbegin);


% counters:
count = struct('st', 1, 'sym', 1, 'sbplt', 99, 'out_pth', 1);

% parameters:
params = struct('thickness', 0, 'spacing', 0, ...
    'height', 0, 'key_sig', 0, 'key_sig_x', 0);


% preprocess
[pp_img bin_img] = preprocess(img, out);


% split staffs:
[staff_bounds params] = staff_segment(pp_img, params);

% line width and spacing:
params.thickness = get_line_width(pp_img);
params.spacing = params.height/4 - params.thickness;

% key signature:
params = get_key_sig(pp_img, staff_bounds, params);

% initialize output:
out_data = [];

% all staff images
num_st = size(staff_bounds, 1);
staff_imgs = cell(1,4*num_st); %hold all staff images

% loop through staffs:
for staff = 1:size(staff_bounds, 1)
    
    % update count:
    count.st = staff;
    
    % isolate staff:
    staff_img = get_staff(pp_img, staff_bounds, params, count, out);
    
%     if(staff == 5)
%         keyboard;
%     end
      
    % classify staff:
    [tmp count notes params staff_imgs] = classify(staff_img, params, count, out, staff_imgs,num_st);  
    
    % add output:
    out_data = [out_data tmp];
    

 
end

keyS = params.key_sig;

end

