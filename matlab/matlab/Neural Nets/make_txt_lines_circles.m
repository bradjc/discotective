%%% LINE=1, CIRCLE=-1

load lines_circles.mat

fid = fopen('lines_circles.txt','w');

for i=1:10
    tmp = line(:,:,i);
    tmp = [tmp(1,:) tmp(2,:) tmp(3,:)];   %concatenate row-wise
    
    for j=1:9
        fprintf(fid, '%f ', tmp(j));
    end
    fprintf(fid, '%f\n', 1);
    
    tmp = circle(:,:,i);
    tmp = [tmp(1,:) tmp(2,:) tmp(3,:)];   %concatenate row-wise
    
    for j=1:9
        fprintf(fid, '%f ', tmp(j));
    end
    fprintf(fid, '%f\n', -1);
    
end

fclose(fid);