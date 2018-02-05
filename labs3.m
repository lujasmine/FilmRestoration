function output = labs3(path, prefix, first, last, digits, suffix)

% labs3('footage', 'footage_', 1, 657, 3, 'png')
image_data = load_sequence(path, prefix, first, last, digits, suffix);
image_data = im2double(image_data);
corrected = image_data;

% part i. detect scene cuts
scene_cut_frames = detect_scene_cuts(image_data); % part i

start_frame = 1;
scene_2 = scene_cut_frames(1);
scene_3 = scene_cut_frames(2);
last_frame = size(image_data,3);

% part ii correct flicker
corrected = correct_flicker(corrected, start_frame, scene_2-1);
corrected = correct_flicker(corrected, scene_2, scene_3-1);
corrected = correct_flicker(corrected, scene_3, last_frame);

% part iii remove blotches
blotches = zeros(size(image_data));
[blotches, corrected] = fix_blotches(corrected, start_frame, scene_2-1, blotches);
[blotches, corrected] = fix_blotches(corrected, scene_2, scene_3-1, blotches);
[~, corrected] = fix_blotches(corrected, scene_3, last_frame, blotches);

% part iv correct vertical artefacts
corrected = remove_v_artefacts(corrected, scene_3, last_frame); 

% part v correct camera shake
corrected = camera_shake(corrected);

% add overlaying text to scene cuts
for n = 1 : size(scene_cut_frames,2)
    position = [10 20]; 
    for m = 0:15
        curr_frame = corrected(:,:,scene_cut_frames(n)+m);
        with_text = insertText(curr_frame,position,'Scene Cut!','FontSize',30); 
        corrected(:,:,scene_cut_frames(n)+m) = rgb2gray(with_text);
    end   
end

% save_sequence(corrected, 'new_footage', 'new_footage', start_frame, 3);
% implay([image_data, corrected]);

end