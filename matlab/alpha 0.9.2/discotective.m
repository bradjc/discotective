% the discotective

close all;
clear;
addpath(genpath(pwd));

% output choices:
preprocess_o = 0;
save_o = 0;
staff_o = 1;
stems_o = 0;
class_o = 0;
sound_o = 1;
out = struct('pp', preprocess_o, 'sv', save_o, 'st', staff_o, 'cl', class_o, 'sd', sound_o, 'stems', stems_o);

% counters:
count = struct('st', 1, 'sym', 1, 'sbplt', 99, 'out_pth', 1);

% load image:
image_name = 'kings';
img = load_image(image_name, out, count); 

% output file for saving notes,durations
fp = fopen('output\results.txt','w');
fprintf(fp,'%s   (midi, note, beats)\n\n',image_name);

% preprocess image:
pp_img = preprocess(img, out);

% optional save (for skipping previous steps):
save('pp_img.mat', 'pp_img');
% load('pp_img.mat');

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
%     if(staff==3)
%         keyboard
%     end
    
    % classify staff:
    [tmp count notes] = classify_eighths(staff_img, params, count, out);  
    
    % add output:
    out_data = [out_data tmp];
    
    % output to file
    for i = 1:length(notes)
        fprintf(fp, '(%d, %s, %.1f) ',notes(i).midi, notes(i).letter, notes(i).dur);
    end
    fprintf(fp,'\n');
 
end

% output music:
output(out_data, out);

fclose(fp);

