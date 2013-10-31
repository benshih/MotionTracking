% Benjamin Shih
% 16720f13 Computer Vision
% Assignment 4 Tracking
% 10/22/2013
% 1.2 Lucas-Kanade


% convert images from rgb2gray and im2double before using, otherwise
% interp2 gets angry

function [u,v] = LucasKanade(It,It1,rect)
    % Initialising u,v for motion estimate. 
    u = 0;
    v = 0;
    % Initialising u1,v1 which are updates for u,v in each iteration
    u1 = 0;
    v1 = 0;
    count = 0;

    % Meshgrid for X,Y for the entire range of image
%     [X,Y]=meshgrid(1:size(It,2),1:size(It,1));
    
    % Meshgrid for the coordinates in the template T
    y=rect(2):rect(4);
    x=rect(1):rect(3);
    
    % Calculating the values of the template using interpolation
%     template=interp2(It,XI,YI);
    template = It(y,x);

    % Calculating the X and Y derivaties for the templates
    [dX, dY] = gradient(double(template));
%     template = template(y,x);

    while((count < 50))
        p=[u v];
        count = count + 1;

        % Map pixels in template to pixels in It1
        % step 1
    %     Xq1 = (X1)+p(1);
    %     Yq1 = (Y1)+p(2);
    %     [Xq, Yq] = meshgrid(Xq1,Yq1);
    %     ItWarp = interp2(It1,Xq,Yq);
    %     
        ItWarp = warpImg(It1, rect, p);

        % Find the difference between the warped image and the template. 
        % step 2
        deltaI = double(template-ItWarp);
        deltaI = deltaI(:);

        % Warp the gradients. step 3
    %     dxWarp = interp2(dX,Xq,Yq); 
    %     dyWarp = interp2(dY,Xq,Yq);
        dxWarp = warpImg(dX, rect, p);
        dyWarp = warpImg(dY, rect, p);
        dxWarp = dxWarp(:);
        dyWarp = dyWarp(:);

        % Steepest descent images. step 5
        warpedGrad = double([dX(:), dY(:)]);

        % Compute the optimized solution for the minimization.
        % step 6, 7, 8
        deltaP = (warpedGrad'*warpedGrad)\(warpedGrad'*deltaI);

        % step 9
        u = p(1) + deltaP(1);
        v = p(2) + deltaP(2);

        if (norm(deltaP) < 0.01)
            continue
        end

    end
    count
end

function [warpedImg] = warpImg(img, rect, p)  
    y=(rect(2)+p(2)):(rect(4)+p(2));
    x=(rect(1)+p(1)):(rect(3)+p(1));
    [X,Y]=meshgrid(x,y);

%     [Xq, Yq] = meshgrid(X2,Y2);
%     img = double(img);
    warpedImg = interp2(img,X,Y);
end


% algorithm flow chart: http://www.cse.psu.edu/~rcollins/CSE598G/LKintroContinued.pdf
% 
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