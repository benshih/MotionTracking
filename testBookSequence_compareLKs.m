% Benjamin Shih
% 16720f13 Computer Vision
% Assignment 4 Tracking
% 10/22/2013
% 1.3 Track the speeding car

clc
close all

load('bookSequence.mat')

rect1=[247 102 285 161];
rect2=[247 102 285 161];
[m,n,channels,frames] = size(sequence);

width = abs(rect1(1)-rect1(3));
height = abs(rect1(2)-rect1(4));
coordinates=zeros(frames-1,4);

for i=1:frames-1
    img = im2double(sequence(:,:,:,i));

    imshow(img);
    hold on;
    rectangle('Position',[rect1(1),rect1(2),width,height], 'LineWidth',2, 'EdgeColor', 'r')    
    rectangle('Position',[rect2(1),rect2(2),width,height], 'LineWidth',2, 'EdgeColor', 'b')    
    hold off;
    pause(0.01); % 30 fps
    
    Itcurr = rgb2gray(im2double(sequence(:,:,:,i)));
    Itnext = rgb2gray(im2double(sequence(:,:,:,i+1)));
    [u1,v1] = LucasKanadeBasis(Itcurr,Itnext,rect1,basis);
    rect1=[rect1(1)+u1 rect1(2)+v1 rect1(3)+u1 rect1(4)+v1];
    [u2,v2] = LucasKanade(Itcurr,Itnext,rect2);
    rect2=[rect2(1)+u2 rect2(2)+v2 rect2(3)+u2 rect2(4)+v2];
    coordinates1(i,:) = rect1;
    coordinates2(i,:) = rect2;
    %disp(['Frame ',num2str(i)]);
    
    rect1 = round(coordinates1(i,:));
    rect2 = round(coordinates2(i,:));
end



close