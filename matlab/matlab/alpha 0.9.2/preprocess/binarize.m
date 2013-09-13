function [img] = binarize(img, fudge)

%%% OVERVIEW  %%%

% this code binarizes an image adaptively by first estimating
% y values as a function of x
%
% first use least squares problem to estimate bias
% X * B = Y
% where X contains explanatory features (indicies)
% and Y is the corresonding grayscale values
%
% then adjust grayscale image accordingly and binarize


%%% SET-UP %%%

[h w] = size(img);

% initial image:
% imagesc(img), colormap(gray), title('initial')

% vectors for least squares:
[x1 x2] = find(img > -1);
% x1 = rows of indices to image
% x2 = columns of indicies to image

% combine feature vectors
% (include intercept term):
x = double([ones(1, h*w)' x1 x2 x1.*x2 x1.^2 x2.^2]);
%x = double([ones(1, h*w)']);

% columnize y and avoid MATLAB error:
y = double(img(:));


%%% ALGORITHM %%%

[dummy d] = size(x);
% least squares:
B = inv(x'*x)*(x'*y);

% adjust image:
img_bias = x*B;
img_bias = reshape(img_bias, h, w);
img = img - img_bias;

% binarize:
img = 1 - (img > fudge);


%%% OPTIONAL OUPTUT %%%

% figure
% imagesc(img_bias), colormap(gray), title('bias')
% figure
% imagesc(1-img), colormap(gray), title('binarized image')

end