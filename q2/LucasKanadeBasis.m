% Benjamin Shih
% 16720f13 Computer Vision
% Assignment 4 Tracking
% 10/22/2013
% 2.2 Lucas-Kanade Tracker with Appearance Basis: compute the optimal local
% motion from frame It to frame It1 while accounting for changes in the
% illumination between the two frames based on provided eigen-books
% (synonymous for "basis") derived from principal component analysis. This
% implementation is based on the Inverse Compositional Algorithm. 

% NTS: convert images from rgb2gray and im2double before using, otherwise
% interp2 gets angry

function [u,v] = LucasKanadeBasis(It,It1,rect,basis)
    % Initially no shift. 
    u = 0;
    v = 0;
    w = zeros(size(basis));
    % Limiting the number of iterations for convergence.
    count = 0;
    
    % Meshgrid for templates coordinates.
    y=rect(2):rect(4);
    x=rect(1):rect(3);
    
    % Interpolate the template values. 
    template = It(y,x);

    % Step 3: Gradient of the template.
    [dX, dY] = gradient(double(template));

    % Step 4: Jacobian dW/dp at (x;0) - the Jacobian is the identity for a
    % pure translation.
    
    % Before step 5: Compute and combine all of the eigen-books.
    numPix = numel(basis{1});
    vectorBasis = zeros(numPix, length(basis));
    for iBasisIdx = 1:length(basis)
        currBasis = basis{iBasisIdx};
        vectorBasis(:,iBasisIdx) = currBasis(:);
    end
    % Step 5: Compute the steepest descent images. 
    warpedGrad = double([dX(:), dY(:), vectorBasis]);
    
    % Step 6: Compute the Hessian matrix.
    H = warpedGrad'*warpedGrad;
    
    while((count < 50))
        p=[u v w];
        count = count + 1;
         
        % Step 1: Warp the next image to the current template.
        ItWarp = warpImg(It1, rect, p);

        % Step 2: Find the error image - difference between the next frame
        % warped to the image and the template itself.
        deltaI = double(template-ItWarp);
        deltaI = deltaI(:);

        % Step 7,8: Compute the optimized solution for the minimization
        % which yields the change in position.
        deltaP = H\(warpedGrad'*deltaI);

        % Step 9: Update the warp points and basis weights. 
        u = p(1) + deltaP(1);
        v = p(2) + deltaP(2);
        w = deltaP(3:10)';

        % Conclude that the change in position is below some arbitrary
        % threshold.
        if (norm(deltaP) < 0.01)
            continue
        end

    end
end

function [warpedImg] = warpImg(img, rect, p)  
    y=(rect(2)+p(2)):(rect(4)+p(2));
    x=(rect(1)+p(1)):(rect(3)+p(1));
    [X,Y]=meshgrid(x,y);

    warpedImg = interp2(img,X,Y);
end
