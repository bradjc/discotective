% the discotective
% 
% eecs 452 digital signal processing design laboratory
% university of michigan
% winter 2011
%
% katie bouman, brad campbell, mike hand, tyler johnson, joe kurleto

clear;
close all;
addpath classify output preprocess samples segment trim utility;

% load image:
image_name = 'dmaj';

% load option:
LOAD = 1;

% output choices:
preprocess_o = 0;
save_o = 0;
staff_o = 1;
staff_dbg_o = 0; %initial staff
stems_o = 0;
class_o = 0;
sound_o = 1;
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

% load image:
img = load_image(image_name, out, count);

% output file for saving notes,durations
fp = fopen('output\results.txt','w');
fprintf(fp,'%s   (midi, note, beats)\n\n',image_name);

% get preprocessed image:
if (LOAD)
%     load('pp_img.mat');
    eval(['load(''preprocessed_images.mat'', ''' image_name ''');']);
    eval(['pp_img = ' image_name ';']);
else
    % preprocess image:
    pp_img = preprocess(img, out);

    % optional save (for skipping previous steps):
    save('pp_img.mat', 'pp_img');
    eval([image_name '= pp_img;']); eval(['save(''preprocessed_images.mat'',''' image_name ''',''-append'')']);
end

% split staffs:
[staff_bounds params] = staff_segment(pp_img, params);

% line width and spacing:
params.thickness = get_line_width(pp_img);
params.spacing = params.height/4 - params.thickness;

% key signature:
params = get_key_sig(pp_img, staff_bounds, params);

% initialize output:
out_data = [];

% loop through staffs:
for staff = 1:size(staff_bounds, 1)
    
    % update count:
    count.st = staff;
    
    % isolate staff:
    staff_img = get_staff(pp_img, staff_bounds, params, count, out);
    
    % classify staff:
    [tmp count notes params] = classify(staff_img, params, count, out);  
    
    % add output:
    out_data = [out_data tmp];
    
    % output to file
    for i = 1:length(notes)
%         fprintf(fp, '%s,%.1f ', notes(i).letter, notes(i).midi);
        fprintf(fp, '%s,%d,%.1f ', notes(i).letter,notes(i).midi, notes(i).center_of_mass);
%         fprintf(fp, '(%d, %s, %.1f, %d) ',notes(i).midi, notes(i).letter, notes(i).dur, notes(i).mod);
    end
    fprintf(fp,'\n');
 
end

% output music:
output(out_data, out);

% close note output file:
fclose(fp);
