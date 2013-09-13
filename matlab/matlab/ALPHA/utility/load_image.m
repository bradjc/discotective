function [img] = load_image(image_name, save)

% this function loads an image
% it also creates a directory for saving symbols if necessary

% load image (note that it must be in the samples directory)
image_file = strcat('samples/', image_name);
image_file = strcat(image_file, '.jpg');
img = imread(image_file);

% create directory for saving symbols if necessary:
if (save)
    out_directory = strcat('symbol_output/', image_name);
    out_directory = strcat(out_directory, '/');
    if (exist(out_directory, 'dir') == 0)
        mkdir(out_directory);
    end
end

end