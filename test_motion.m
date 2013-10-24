% function test_motion(path_to_images, numimages)

path_to_images = 'Sequence1';
numimages = 21;

% test_motion makes a movie (motion.avi) using the sequence of binary 
% images returned after every call of SubtractDominantMotion function

% add a trailing slash to the path if needed:
% if(path_to_images(end) ~= '/' & path_to_images(end) ~= '\')
%     path_to_images(end+1) = '/';
% end

% NOTE - you might have to change the path slashes depending on windows or unix.

fname = sprintf('%s//frame%d.pgm',path_to_images,0);

img1 = double(imread(fname));

% create movie object
mov=avifile('motion.avi','quality',100);

Fs = cell(1, numimages);

try
    for frame = 1 : numimages-1
        % Reads next image in sequence        
        fname = sprintf('%s//frame%d.pgm',path_to_images,frame);
        
		img2 = double(imread(fname));
        
        % Runs the function to estimate dominant motion
        disp(['Processing pair of image ' num2str(frame-1) ' and ' num2str(frame)]);
        save tmp.mat;
        [motion_img] = SubtractDominantMotion(img1, img2);
        % Superimposes the binary image on img2, and adds it to the movie
        currframe = repmat(img2 / 255.0, [1 1 3]);
        motion_img = double(motion_img);
        temp=img2/255.0; temp(motion_img~=0.0)=1.0;
        currframe(:,:,1)=temp;
        currframe(:,:,3)=temp;
        mov=addframe(mov,currframe);
        Fs{frame} = currframe;
        % Prepare for processing next pair
         imshow(uint8(currframe));
%         figure,imshow(uint8(img2));
%         figure
         img1 = img2;
%         imshow(uint8(motion_img))
    end
    mov = close(mov);
catch ME
    % In case an error occurs, it's a good idea to close the avi object
    % handle before exiting. Otherwise MATLAB complains when you try
    % to open the file again in future.
    disp(ME)
    mov=close(mov);
    return;
end

% Success!
disp('Done! Showing movie (motion.avi)...');
mov=aviread('motion.avi');
movie(mov,1,1);
