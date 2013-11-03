% Benjamin Shih
% 16720f13 Computer Vision
% Assignment 4 Tracking
% 10/22/2013
% 2.3 Track the moving book

clc
close all

load('bookSequence.mat')

rect = [247 102 285 161];
[m,n,channels,frames] = size(sequence);

width = abs(rect(1)-rect(3));
height = abs(rect(2)-rect(4));
box = zeros(frames-1,4);

for i=1:frames-1
    img = im2double(sequence(:,:,:,i));

    % Display the template box for tracking on top of the current frame.
    imshow(img);
    hold on;
    rectangle('Position',[rect(1),rect(2),width,height], 'LineWidth',2, 'EdgeColor', 'r')    
    hold off;
    pause(0.01);
    
    % Convert to a grayscale, double image. 
    Itcurr = rgb2gray(im2double(sequence(:,:,:,i)));
    Itnext = rgb2gray(im2double(sequence(:,:,:,i+1)));
    
    % Estimate the position change between two frames using LucasKanade
    % Tracker. 
    [u,v] = LucasKanadeBasis(Itcurr,Itnext,rect,basis);
    rect = [rect(1)+u rect(2)+v rect(3)+u rect(4)+v];
    rect = round(rect);
    box(i,:) = rect;
end

% Save the tracking results.
save('bookPosition.mat', 'box');
close