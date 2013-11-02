% Benjamin Shih
% 16720f13 Computer Vision
% Assignment 4 Tracking
% 10/31/2013
% 3.1 Lucas-Kanade Affine


function [M] = LucasKanadeAffine(It, It1)
    It = medfilt2(It/255);
    It1 = medfilt2(It1/255);
    
    [m, n] = size(It);
    [X, Y] = meshgrid(1:n, 1:m);
    X = X(:);
    Y = Y(:);

    [Ix, Iy] = gradient(It);
    deltaI = It1 - It;

    count = 0;
    p = zeros(6,1);

    while(count < 100)
        count = count + 1;
        Ix = Ix(:);
        Iy = Iy(:);
        deltaI = deltaI(:);

        % Compute the steepest descent images. 
        A = [X.*Ix Y.*Ix Ix X.*Iy Y.*Iy Iy]; 

        % Compute the optimized solution for the minimization
        % which yields the change in position.
        deltaP = -(A'*A)\A'*deltaI;

        % Update the warp points. 
        p = p + deltaP;
        
        % Conclude that the change in position is below some arbitrary
        % threshold.
        if (norm(deltaP) < 0.0001)
            break
        end
        
        % Compute the affine matrix for the warp.
        M = [1+p(1)   p(2)    p(3); 
             p(4)     1+p(5)  p(6); 
             0        0       1];

        % Warp the next image to the current template.
        ItWarp = medfilt2(warpH(It,M,[size(It1,1) size(It1,2)]));

        % Find the error image - difference between the next frame
        % warped to the image and the template itself.
        deltaI = (It1 - ItWarp);
        [Ix, Iy] = gradient(ItWarp, 1/n, 1/m);
        

    end
end
