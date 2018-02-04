% Part i). Detection of Scene Cuts
function detect_scene_cuts(image_data)
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