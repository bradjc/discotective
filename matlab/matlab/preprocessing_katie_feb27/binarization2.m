function [img] = binarization2(img)
%tylers binarization alg

img = double(img);
[h w] = size(img);

% vectors for least squares:
[x1 x2] = find(img > -1);
% x1 = rows of indices to image
% x2 = columns of indicies to image

% add additional features:
% (intercept and higher degree terms)
x = double([ones(1, h*w)' x1 x2 x1.*x2 x1.^2 x2.^2]);

% avoid MATLAB error:
y = double(img(:));


%%% ALGORITHM %%%

% least squares:
B = inv(x'*x)*(x'*y);

% adjust image:
img_bias = x*B;
img_bias = reshape(img_bias, h, w);
img = img - img_bias;

% binarize:
fudge = -4;
img = (img < fudge);
% 
% 
% %%% OUPTUT %%%
% 
% imagesc(img_bias), colormap(gray), title('bias')
% figure
% imagesc(img), colormap(gray), title('binarized image')