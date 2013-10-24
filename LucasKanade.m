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
    
    
    % Initial warp.
    warp = [0 0]';
    
    epsilon = 0.03;
    
    Itcurr = It;
    Itnext = It1;
    
    while (p > epsilon)
        % 1. Warp It.
        tform = affine2d([1 0 warp(1); 0 1 warp(2); 0 0 1]);
        Itwarp = imwarp(Itnext, tform);
        
        % 2. Compute the error image T(x) - I(W(x;p))
        template = Itcurr(x1:x2, y1:y2);
        It_template = Itwarp(x1:x2, y1:y2);
        
        % 3. Warp the gradient with W(x;p)
        [ix iy] = gradient(Itwarp);
        ixNew = imwarp(ix, tform);
        iyNew = imwarp(iy, tform);
        
        % 4. Evaluate the Jacobian at (x; p). In this case it's the identity
        % matrix because we only have a transform. How to genralize this?
        jacob = eye(2);
        
        % 5. Compute the steepest descent images.
        ixSteep = ixNew * jacob;
        iySteep = iyNew * jacob;
        
        % Compute the Hessian matrix.
        steepJacob = [ixSteep; 
    
    % Compute the n x n (Gauss-Newton approximation to the) Hessian matrix.
    H = gradient(It);
    end



    % algorithm flow chart: http://www.cse.psu.edu/~rcollins/CSE598G/LKintroContinued.pdf