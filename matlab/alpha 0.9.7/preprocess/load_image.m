function [img] = load_image(image_name, output, count)

% this function loads an image
% it also creates a directory for saving symbols if necessary

% load image (note that it must be in the samples directory)
image_file = strcat('samples/', image_name);
image_file = strcat(image_file, '.jpg');
img = imread(image_file);

% create directory for saving symbols if necessary:
if (output.sv)
    out_directory = strcat('../symbol_output/', image_name);
    count.out_pth = strcat(out_directory, '/');
    if (exist(count.out_pth, 'dir') == 0)
        mkdir(count.out_pth);
    end
end

end