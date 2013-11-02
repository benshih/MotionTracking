% Benjamin Shih
% 16720f13 Computer Vision
% Assignment 4 Tracking
% 10/31/2013
% 3.2 Moving Object Detection by Subtracting Dominant Motion
% 3.3 Testing Algorithms on Real-World Data

function [moving_image] = SubtractDominantMotion(image1, image2)

    % Compute the transofmration matrix M relating an image pair It and
    % It1.
    M = LucasKanadeAffine(image1, image2);

    % Warp It using M so that it is registered to It1, and subtract it from
    % It1.
    ItWarp = medfilt2(warpH(image1,M,[size(image2,1) size(image2,2)]));
    deltaI = image2 - ItWarp;
    
    % The locations where the absolute difference exceeds an arbitrary
    % hysteresis threshold can then be declared as corresponding to
    % locations of moving objects.
    deltaI = abs(deltaI)/255;
    moving_image = medfilt2(hysthresh(deltaI, 0.3, 0.2));
    se = strel('disk', 8);
    
    % Any algorithm of my choice for estimating the moving_image following
    % the affine registration step:
    moving_image = imdilate(moving_image, se);
    moving_image = imerode(moving_image, se);
    moving_image = medfilt2(moving_image);
    moving_image = double(moving_image);
end