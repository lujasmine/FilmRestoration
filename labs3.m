function output = labs3(path, prefix, first, last, digits, suffix)

% labs3('footage', 'footage_', 1, 657, 3, 'png')
image_data = load_sequence(path, prefix, first, last, digits, suffix);
image_data = im2double(image_data);

% part i. detect scene cuts and add overlaying text
scene_cut_frames = detect_scene_cuts(image_data); % part i

% part ii
corrected_data = correct_flicker(image_data, 1, 100);
corrected_data = correct_flicker(corrected_data, 257, 496);
corrected_data = correct_flicker(corrected_data, 497, 657);

% part iii remove blotches
% blotches = zeros(size(image_data));
% [blotches, corrected_data] = fix_blotches(corrected_data, 1, 256, blotches);
% [blotches, corrected_data] = fix_blotches(corrected_data, 257, 496, blotches);
% [blotches, corrected_data] = fix_blotches(corrected_data, 497, 657, blotches);

% part iv
% corrected_data = remove_v_artefacts(corrected_data, 497, 657); 

% plot(1:476, image_data(200,:,657), 1:476, corrected_data(200,:,657));

% corrected_data = camera_shake(corrected_data); % part v

% add overlaying text to scene cuts
for n = 1 : size(scene_cut_frames,2)
    position = [10 20]; 
%     text_str = cell(1,1);
%     text_str{1} = 'Scene Cut!';
    for m = 0:15
        curr_frame = image_data(:,:,scene_cut_frames(n)+m);
        with_text = insertText(curr_frame,position,'Scene Cut!','FontSize',30); 
        image_data(:,:,scene_cut_frames(n)+m) = rgb2gray(with_text);
    end   
end

implay([image_data, corrected_data]);

% figure
% subplot(1,2,1)
% plot(1:476, image_data(200,:,510))
% subplot(1,2,2)
% plot(1:476, corrected_data(200,:,510))

end