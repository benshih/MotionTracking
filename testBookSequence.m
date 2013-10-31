% Benjamin Shih
% 16720f13 Computer Vision
% Assignment 4 Tracking
% 10/22/2013
% 1.3 Track the speeding car

clc
close all

load('bookSequence.mat')

rect=[247 102 285 161];
[m,n,channels,frames] = size(sequence);

width = abs(rect(1)-rect(3));
height = abs(rect(2)-rect(4));
coordinates=zeros(frames-1,4);

for i=1:frames-1
    img = im2double(sequence(:,:,:,i));

    imshow(img);
    hold on;
    rectangle('Position',[rect(1),rect(2),width,height], 'LineWidth',2, 'EdgeColor', 'r')    
    hold off;
    pause(0.01); % 30 fps
    
    Itcurr = rgb2gray(im2double(sequence(:,:,:,i)));
    Itnext = rgb2gray(im2double(sequence(:,:,:,i+1)));
    [u,v] = LucasKanadeBasis(Itcurr,Itnext,rect,basis);
    rect=[rect(1)+u rect(2)+v rect(3)+u rect(4)+v];
    coordinates(i,:) = rect;
    %disp(['Frame ',num2str(i)]);
    
    rect = round(coordinates(i,:));
end



close