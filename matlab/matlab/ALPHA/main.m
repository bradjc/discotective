% THE DISCOTECTIVE
%
% includes output for stemmed notes



% add paths
addpath functions output preprocessing utility samples


clear;
close all;



% output choices:
save = 0;
preprocess_output = 1;
staff_output = 0;
staff_output_no_stems = 0;


% load image:
image_name = 'jingle';
img = load_image(image_name, save);

% output file for saving notes,durations
fp = fopen('output\results.txt','w');
fprintf(fp,'%s   (midi, note, beats)\n\n',image_name);


% PARAMETERS
bin_fudge = -20;
staff_range = 2.5;


% preprocess image:
pp_img = preprocess(img, preprocess_output);


% optional save (for skipping previous steps):
% save('pp_img.mat', 'pp_img');
% load('pp_img.mat');


% split staffs:
[staff_lines_holder staff_bounds params] = staff_segment(pp_img);



%loops through the staffs
for staff = 1:size(staff_bounds,1)
    
    % isolate staff:
    cur_img = pp_img;
    top = round(staff_bounds(staff, 1));
    bot = round(staff_bounds(staff, 2));
    initial_staff = cur_img(top:bot, :);
    
    
    % trim staff:
    cur_img = initial_staff;
    cur_img = blob_kill(cur_img, 0, 1); % only from top
    trimmed_staff = trim_staff(cur_img);
    [staff_h staff_w] = size(trimmed_staff);
    
    
    % remove staff-lines:
    cur_img = trimmed_staff;
    numCuts = 10;
    [lineless_staff,staff_lines] = remove_lines(trimmed_staff, params, numCuts, staff_output);    
    staff_lines = round(staff_lines(:,1) + staff_lines(:,2))/2; % average
    
    % get measure markers and notes with stems
    [measures stems] = find_lines(lineless_staff, params, staff);
    
    
    % remove measure markers and notes from original staff image
    no_notes_img = remove_notes_measures(lineless_staff, stems, measures, params, staff_lines, staff_output_no_stems);
    

    % determine note duration and note pitch
    notes = classify_stem_notes(lineless_staff,stems,params,staff_lines);
   

    
    
    
    % output to file
    for i = 1:length(notes)
        fprintf(fp, '(%d, %s, %d) ',notes(i).midi, notes(i).letter, notes(i).dur);
    end
    fprintf(fp,'\n');
    
    
    % create audio output
    outputIn=[];
    for i = 1:length(notes)
        outputIn = [outputIn [notes(i).midi; notes(i).dur]];
    end
    output(outputIn);
    
    
%     keyboard
  
end

fclose(fp);
