% clears all output files, to avoid svn conflicts

clear
save pp_img.mat

fp = fopen('output/results.txt','w');
fclose(fp);
clear