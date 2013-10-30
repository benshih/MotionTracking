% Benjamin Shih
% 16720f13 Computer Vision
% Assignment 4 Tracking
% 10/22/2013
% 1.3 Track the speeding car

close all

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

width = abs(rect(1)-rect(3));
height = abs(rect(2)-rect(4));


figure;
pause on;

for iFrame = 1:n-1
    Itcurr = rgb2gray(im2double(sequence(:,:,:,iFrame)));
    Itnext = rgb2gray(im2double(sequence(:,:,:,iFrame+1)));
    [u, v] = LucasKanade(Itcurr, Itnext, rect);
    rect = [x1+u, y1+v, x2+u, y2+v]
    
    imshow(Itnext);
    hold on;
    rectangle('Position',[rect(1),rect(2),width,height], 'LineWidth',2, 'EdgeColor', 'r')    
    hold off;
    pause(0.0333); % 30 fps
end

close

% bs notes:
% rgb2gray for images because transpose of a m x n x k does not make sense
% can use videowriter to record video