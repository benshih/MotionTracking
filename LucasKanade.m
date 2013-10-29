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
    [Itx, Ity, ~] = size(It); % same size as It1
    
    [X, Y] = meshgrid(1:Itx, 1:Ity);
    X = im2double(X');
    Y = im2double(Y');
    [Xq, Yq] = meshgrid(x1:x2, y1:y2);
    % These values represent the interpolated intensities corresponding to
    % values in the Xq, Yq meshgrid.
    Vqt = interp2(X, Y, It, Xq, Yq);
    Vqt1 = interp2(X, Y, It1, Xq, Yq);
 
    % Make large matrix.
    [ix, iy] = gradient(Vqt);
    deltaI = Vqt(:) - Vqt1(:);
    A = [ix(:) iy(:)];
    
    % Compute the optimized solution for the minimization.
    a = (A'*A)^-1*A'*deltaI;
    
    u = a(1);
    v = a(2);
end



% algorithm flow chart: http://www.cse.psu.edu/~rcollins/CSE598G/LKintroContinued.pdf

%     while (p > epsilon)
%         % 1. Warp It.
%         tform = affine2d([1 0 warp(1); 0 1 warp(2); 0 0 1]);
%         Itwarp = imwarp(Itnext, tform);
%         
%         % 2. Compute the error image T(x) - I(W(x;p))
%         template = Itcurr(x1:x2, y1:y2);
%         It_template = Itwarp(x1:x2, y1:y2);
%         
%         % 3. Warp the gradient with W(x;p)
%         [ix iy] = gradient(Itwarp);
%         ixNew = imwarp(ix, tform);
%         iyNew = imwarp(iy, tform);
%         
%         % 4. Evaluate the Jacobian at (x; p). In this case it's the identity
%         % matrix because we only have a transform. How to genralize this?
%         jacob = eye(2);
%         
%         % 5. Compute the steepest descent images.
%         ixSteep = ixNew * jacob;
%         iySteep = iyNew * jacob;
%         
%         % 6. Compute the Hessian matrix.
%         steepJacob = [ixSteep; iySteep];
%         
%         % 7. Compute the sum_x(gradientI*jacobian)'*(T(x) - I(W(x;p))).
%         
%         
%         % 8. Compute change in parameters.
%         
%         
%         % 9. Update the parameters.
%     end