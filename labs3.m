function output = labs3(path, prefix, first, last, digits, suffix)

% labs3('footage', 'footage_', 1, 657, 3, 'png')
image_data = load_sequence(path, prefix, first, last, digits, suffix);
image_data = im2double(image_data);

% detectSceneCuts(image_data); % part i

% corrected_data = correct_flicker(image_data, 1, 256); % part ii
% corrected_data = correct_flicker(corrected_data, 257, 496);
% corrected_data = correct_flicker(corrected_data, 497, 657);

% part iii) remove blotches
corrected_data = remove_blotches(image_data);

% corrected_data = remove_v_artefacts(image_data, 497, 657); % part iv

% plot(1:476, image_data(200,:,657), 1:476, corrected_data(200,:,657));

% corrected_data = cameraShake(image_data); % part v

% implay([image_data, corrected_data]);

% figure
% subplot(1,2,1)
% plot(1:476, image_data(200,:,510))
% subplot(1,2,2)
% plot(1:476, corrected_data(200,:,510))

end