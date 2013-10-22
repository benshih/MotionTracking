% Benjamin Shih
% 16720f13 Computer Vision
% Assignment 4 Tracking
% 10/22/2013
% 1.2 Lucas-Kanade

function [ u, v ] = LucasKanade( It, It1, rect )
    % Top left corner
    x1 = rect(1);
    y1 = rect(2);
    % Bottom right corner
    x2 = rect(3);
    y2 = rect(4);
    
    template = It(x1:x2, y1:y2);
    

end

