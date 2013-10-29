% Benjamin Shih
% 16720f13 Computer Vision
% Assignment 4 Tracking
% 10/22/2013
% 1.3 Track the speeding car

% This variable "sequence" is of the dimension, h x w x m x n, where h and
% w are the frame height and width, m (=3) is the number of color channel,
% n is the number of frames.
load('carSequence.mat');

% Initial warp.
deltaP = [0 0]';

[h,w,m,n] = size(sequence);

% Initial rect values.
x1 = 328;
y1 = 213;
x2 = 419;
y2 = 265;
rect = [x1 y1 x2 y2];

% rgb2gray for images because transpose of a m x n x k does not make sense

for iFrame = 1:n
    [u, v] = LucasKanade(It, It1, rect);
    rect = [x1+u, y1+v, x2+u, y2+v];
end



% can use videowriter to record video