function output = labs3(path, prefix, first, last, digits, suffix)

% labs3('footage', 'footage_', 1, 657, 3, 'png')
image_data = load_sequence(path, prefix, first, last, digits, suffix);
image_data = im2double(image_data);

%detectSceneCuts(image_data);
 
% first_frame = image_data(:,:,1);
% var1 = var(first_frame(:));
% var2 = cov(first_frame(:))/size(first_frame(:),1);
% fprintf("first: %d, second: %d\n", var1, var2);

% part ii). flicker
corrected_data = zeros(size(image_data));
var_n = 100/(370*476);

for i=2:size(image_data,3)-1
    curr = image_data(:,:,i);
    prev = image_data(:,:,i-1);
    
    exp_Y = mean(curr(:));
    var_Y = var(curr(:));
    
    exp_I = mean(prev(:));
    var_I = var(prev(:));
    
    alpha = sqrt((var_Y - var_n)/var_I);
    beta = (exp_Y - (alpha * exp_I));
    
    a = ((var_Y - var_n)/var_Y)*(1/alpha);
    b = (-beta/alpha) + ((var_n/var_Y)*(exp_Y/alpha));
    
    corrected_data(:,:,i) = (a * curr) + b;
end

implay(image_data);
implay(corrected_data);

% corrected_data = load_sequence(path, prefix, first, last, digits, suffix);
% implay(corrected_data);

%implay(image_data);

end

% Part i). Detection of Scene Cuts
function detectSceneCuts(image_data)
    n = 1;
    
    for i=1:size(image_data,3)-1
        curr = image_data(:,:,i);
        next = image_data(:,:,i+1);
        sqr_err = immse(curr, next);
        
        if (sqr_err > 0.1)
            % add text here
            fprintf("Image %i: %d \n", n, sqr_err);
        end
        n = n + 1;
    end
end

