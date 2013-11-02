% Benjamin Shih
% 16720f13 Computer Vision
% Assignment 4 Tracking
% 10/22/2013
% 1.2 Lucas-Kanade


% convert images from rgb2gray and im2double before using, otherwise
% interp2 gets angry

function [u,v] = LucasKanadeBasis(It,It1,rect,basis)
    % Initialising u,v for motion estimate. 
    u = 0;
    v = 0;
    w = zeros(size(basis));
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

    numPix = numel(basis{1});
    vectorBasis = zeros(numPix, length(basis));

    while((count < 50))
        p=[u v w];
        count = count + 1;

        % Map pixels in template to pixels in It1
        % step 1
    %     Xq1 = (X1)+p(1);
    %     Yq1 = (Y1)+p(2);
    %     [Xq, Yq] = meshgrid(Xq1,Yq1);
    %     ItWarp = interp2(It1,Xq,Yq);
         
        ItWarp = warpImg(It1, rect, p);

        % Find the difference between the warped image and the template. 
        % step 2
        deltaI = double(template-ItWarp);
        deltaI = deltaI(:);

        % Warp the gradients. step 3
    %     dxWarp = interp2(dX,Xq,Yq); 
    %     dyWarp = interp2(dY,Xq,Yq);
%         dxWarp = warpImg(dX, rect, p);
%         dyWarp = warpImg(dY, rect, p);
%         dxWarp = dxWarp(:);
%         dyWarp = dyWarp(:);

        % Steepest descent images. step 5
        for iBasisIdx = 1:length(basis)
            currBasis = basis{iBasisIdx};
            vectorBasis(:,iBasisIdx) = currBasis(:);
        end
        warpedGrad = double([dX(:), dY(:), vectorBasis]);

        % Compute the optimized solution for the minimization.
        % step 6, 7, 8
        deltaP = (warpedGrad'*warpedGrad)\(warpedGrad'*deltaI);

        % step 9
        u = p(1) + deltaP(1);
        v = p(2) + deltaP(2);
        w = deltaP(3:10)';

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
