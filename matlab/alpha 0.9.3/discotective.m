% the discotective

close all;
clear;
addpath(genpath(pwd));

LOAD = 0; % if you want to load from mat file

% output choices:
preprocess_o = 1;
save_o = 0;
staff_o = 1;
staff_dbg_o = 0; %initial staff
stems_o = 0;
class_o = 1;
sound_o = 1;

%debug
dbg_staff = 0;
dbg_xbegin = 0;

out = struct('pp', preprocess_o, 'sv', save_o, 'st', staff_o, 'staff_dbg',...
    staff_dbg_o, 'cl', class_o, 'sd', sound_o, 'stems', stems_o, 'dbg_s', dbg_staff, 'dbg_x',dbg_xbegin);



% counters:
count = struct('st', 1, 'sym', 1, 'sbplt', 99, 'out_pth', 1);

% LOAD IMAGE HERRRRRRRRRRR [][][][][][][][][][]][][][][][][][][][][][][][][
image_name = 'santa';
img = load_image(image_name, out, count); 
% [][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][][

% output file for saving notes,durations
fp = fopen('output\results.txt','w');
fprintf(fp,'%s   (midi, note, beats)\n\n',image_name);

if (~LOAD)
    % preprocess image:
    pp_img = preprocess(img, out);

    % optional save (for skipping previous steps):
    save('pp_img.mat', 'pp_img');
else
    load('pp_img.mat');
end

% split staffs:
[staff_bounds params] = staff_segment(pp_img);

% initialize output:
out_data = [];

% loop through staffs:
for staff = 1:size(staff_bounds, 1)
    
    % update count:
    count.st = staff;
    
    % isolate staff:
    staff_img = get_staff(pp_img, staff_bounds, count, out);
    
    %debug
%     if(staff==2)
%         keyboard
%     end
    
    % classify staff:
    [tmp count notes params] = classify(staff_img, params, count, out);  
    
    % add output:
    out_data = [out_data tmp];
    
    % output to file
    for i = 1:length(notes)
        fprintf(fp, '(%d, %s, %.1f, %d) ',notes(i).midi, notes(i).letter, notes(i).dur, notes(i).mod);        
        %fprintf(fp, '(%d, %s, %.1f) ',notes(i).midi, notes(i).letter, notes(i).dur);
    end
    fprintf(fp,'\n');
 
end

% output music:
output(out_data, out);

fclose(fp);

