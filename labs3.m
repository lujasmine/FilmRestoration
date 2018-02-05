function output = labs3(path, prefix, first, last, digits, suffix)

% labs3('footage', 'footage_', 1, 657, 3, 'png')
image_data = load_sequence(path, prefix, first, last, digits, suffix);
image_data = im2double(image_data);

% detectSceneCuts(image_data); % part i

% part ii
corrected_data = correct_flicker(image_data, 1, 100);
corrected_data = correct_flicker(corrected_data, 257, 496);
corrected_data = correct_flicker(corrected_data, 497, 657);

% part iii remove blotches
b = zeros(size(image_data));
% [b, corrected_data] = fix_blotches(image_data, 29, 29, b);
[b, corrected_data] = fix_blotches(corrected_data, 1, 256, b);
% [b, corrected_data] = fix_blotches(corrected_data, 257, 496, b);
% [b, corrected_data] = fix_blotches(corrected_data, 497, 657, b);

% part iv
% corrected_data = remove_v_artefacts(corrected_data, 497, 657); 

% plot(1:476, image_data(200,:,657), 1:476, corrected_data(200,:,657));

% corrected_data = camera_shake(corrected_data); % part v

implay([image_data, b, corrected_data]);

% figure
% subplot(1,2,1)
% plot(1:476, image_data(200,:,510))
% subplot(1,2,2)
% plot(1:476, corrected_data(200,:,510))

end