function imageCORRECT(fileName)

origIMG =imread(fileName);
[height width colors] = size(origIMG);


%%%%%%%%%%%%%%%%%%%%CONVERT TO GRAYSCALE%%%%%%%%%%%%%%%%%%%%%%%%%%%%
grayIMG = 0.2126.*origIMG(:,:,1) + 0.7152.*origIMG(:,:,2) + 0.0722.*origIMG(:,:,3);

%%%%%%%%%%%%%MANUALLY ROTATE IMAGE%%%%%%%%%%%%%%%%%%%%

[rotatedIMG] = rotateIMG(grayIMG, 5);
%%%%%%%%%%%%%MANUALLY SKEW IMAGE%%%%%%%%%%%%%%%%%%%%

currIMG = rotatedIMG;
udata = [0 1];  vdata = [0 1];
square = [ 38 25;  489  25; 489  389; 38 389];
pts = [ 38 25;  489  49; 489  364; 38 389];

maxX = max(square(:,1));
maxY = max(square(:,2));

square(:,1) = square(:,1)./maxX;
square(:,2) = square(:,2)./maxY;

pts(:,1) = pts(:,1)./maxX;
pts(:,2) = pts(:,2)./maxY;

tform = projective_katie(square,pts);
[skewIMG,xdata,ydata] = imtransform(currIMG, tform, 'bilinear', ...
                              'udata', udata,...
                              'vdata', vdata,...
                              'size', size(currIMG),...
                              'fill', 255);

%%%%%%%%%%%%%%%%%%BINARIZATION%%%%%%%%%%%%%%%%%%%%%%
currIMG = skewIMG;
[binIMG] = binarization2(currIMG);
%[binIMG] = binarization(currIMG);

% %%%%%%%%%%%%%%%%SKELETONIZATION%%%%%%%%%%%%%%%%%%%%%
currIMG = binIMG;
skelIMG  = bwmorph(currIMG,'skel',Inf);

%%%%%%%%%%%%%%%%HOUGH%%%%%%%%%%%%%%%%%%%%%
currIMG = skelIMG;
[H,T,R] = hough(currIMG,'RhoResolution',0.5,'Theta',-90:0.5:89.5);

[part1 maxR] = max(H);
[part2 maxT] = max(part1);

angSlope = 270-T(maxT)

%%%%%%%%%%%%%%%%%%%%CORRECT ROTATION%%%%%%%%%%%%%%%%%%%
currIMG = skewIMG;
[rotatedIMG2] = rotateIMG(currIMG, angSlope);

%%%%%%%%%%%%%%%%%%BINARIZATION%%%%%%%%%%%%%%%%%%%%%%
currIMG = rotatedIMG2;
[binIMG] = binarization2(currIMG);
%[binIMG] = binarization(currIMG);

% %%%%%%%%%%%%%%%%SKELETONIZATION%%%%%%%%%%%%%%%%%%%%%
currIMG = binIMG;
skelIMG  = bwmorph(currIMG,'skel',Inf);


%%%%%%%%%%%%%%%%FIND BREAKPOINTS%%%%%%%%%%%%%%%%%%%%%
currIMG = skelIMG;
[breakPt] = findBreakPts(currIMG);

%%%%%%%%%%%%%%%%HOUGH%%%%%%%%%%%%%%%%%%%%%

topSTAFF = currIMG(breakPt(length(breakPt)):breakPt(length(breakPt)-1),:);
bottomSTAFF = currIMG(breakPt(2):breakPt(1),:);

[H_top,T_top,R_top] = hough(topSTAFF,'RhoResolution',0.5,'Theta',-90:0.5:89.5);
[part1_top maxR_top] = max(H_top);
[part2_top maxT_top] = max(part1_top);
angSlope_top = 270-T_top(maxT_top)


[H_bot,T_bot,R_bot] = hough(bottomSTAFF,'RhoResolution',0.5,'Theta',-90:0.5:89.5);
[part1_bot maxR_bot] = max(H_bot);
[part2_bot maxT_bot] = max(part1_bot);
angSlope_bot = 270-T_bot(maxT_bot)

%%%%%%%%%%%%%DE-SKEW IMAGE%%%%%%%%%%%%%%%%%%%%

currIMG = rotatedIMG2;
topStaff_avgH = (length(breakPt)+breakPt(length(breakPt)-1))/2;
botStaff_avgH = (breakPt(2)+breakPt(1))/2;

square(1,:) = [width/4 topStaff_avgH];
square(2,:) = [3*width/4 (-tand(angSlope_top)*(1/2)*width + topStaff_avgH)];
square(4,:) = [width/4 botStaff_avgH];
square(3,:) = [3*width/4 (-tand(angSlope_bot)*(1/2)*width + botStaff_avgH)];

pts(1,:) = [width/4 topStaff_avgH];
pts(2,:) = [3*width/4 topStaff_avgH ];
pts(4,:) = [width/4 botStaff_avgH];
pts(3,:) = [3*width/4 botStaff_avgH];


udata = [0 1];  vdata = [0 1];


maxX = max(square(:,1));
maxY = max(square(:,2));

square(:,1) = square(:,1)./maxX;
square(:,2) = square(:,2)./maxY;

pts(:,1) = pts(:,1)./maxX;
pts(:,2) = pts(:,2)./maxY;

tform = projective_katie(square,pts);
[deskewIMG,xdata,ydata] = imtransform(currIMG, tform, 'bilinear', ...
                              'udata', udata,...
                              'vdata', vdata,...
                              'size', size(currIMG),...
                              'fill', 255);
                          
%%%%%%%%%%%%%%%%%%%%%%%%%PLOT IMAGES%%%%%%%%%%%%%%%%%%%%%%%%%


subplot(2,2,1);
imagesc(origIMG);
title('original image');
subplot(2,2,2);
imagesc(skewIMG);
title('added distortions');
colormap gray
subplot(2,2,3);
imagesc(rotatedIMG2);
title('while processing - skeleton');
colormap gray
subplot(2,2,4);
imagesc(deskewIMG);
title('deskewed image');
colormap gray