% Part i). Detection of Scene Cuts
function scene_changes = detect_scene_cuts(image_data)
    n = 1;
    num_scenes = 0;
    scene_changes = [];
    
    for i = 1 : size(image_data,3)-1
        curr = image_data(:,:,i);
        next = image_data(:,:,i+1);
        sqr_err = immse(curr, next);
        
        if (sqr_err > 0.1)
            num_scenes = num_scenes + 1;
            scene_changes(num_scenes) = n+1;
        end
        n = n + 1;
    end    
end