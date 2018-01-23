function output = labs3(path, prefix, first, last, digits, suffix)

%
% Read a sequence of images and correct the film defects. This is the file 
% you have to fill for the coursework. Do not change the function 
% declaration, keep this skeleton. You are advised to create subfunctions.
% 
% Arguments:
%
% path: path of the files
% prefix: prefix of the filename
% first: first frame
% last: last frame
% digits: number of digits of the frame number
% suffix: suffix of the filename
%
% This should generate corrected images named [path]/corrected_[prefix][number].png
%
% Example:
%
% mov = labs3('../images','myimage', 0, 10, 4, 'png')
%   -> that will load and correct images from '../images/myimage0000.png' to '../images/myimage0010.png'
%   -> and export '../images/corrected_myimage0000.png' to '../images/corrected_myimage0010.png'
%

% Your code here

% labs3('footage', 'footage_', 1, 657, 3, 'png')
images = load_sequence(path, prefix, first, last, digits, suffix);
images = im2double(images);

% Part i). Detection of Scene Cuts
n = 1;
for i=1:last-1
    curr = images(:,:,i);
    next = images(:,:,i+1);
    sqr_err = immse(curr, next);
    if (sqr_err > 0.1)
        fprintf("Image %i: %d \n", n, sqr_err);
    end
    n = n + 1;
end