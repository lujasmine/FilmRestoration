function output = labs3(path, prefix, first, last, digits, suffix)

% labs3('footage', 'footage_', 1, 657, 3, 'png')
image_data = load_sequence(path, prefix, first, last, digits, suffix);
image_data = im2double(image_data);

% detectSceneCuts(image_data); % part i

corrected_data = flickerCorrection(image_data, 1, 257); % part ii

% corrected_data = verticalArtefacts(image_data, 497, 657); % part iv
% corrected_data = cameraShake(image_data); % part v

implay([image_data, corrected_data]);

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

function corrected = flickerCorrection(imgs, start_frame, end_frame)
    corrected = imgs;
    n_frames = 5;
    
    for img_num = start_frame:end_frame
        
        avg_start = img_num;
        avg_end = img_num;
        
        if ((img_num-n_frames) > start_frame)
            avg_start = img_num - n_frames;
        end
        
        if ((img_num+n_frames) < end_frame)
            avg_end = img_num + n_frames;
        end
        
        frames_sum = sum(corrected(:,:,avg_start:avg_end),3);
        
        frames_avg = frames_sum / (avg_end - avg_start + 1);
        
        corrected(:,:,img_num) = imhistmatch(corrected(:,:,img_num), frames_avg); 
    end
    
end

function corrected = verticalArtefacts(imgs, start_frame, end_frame)
    corrected = imgs;
    
    for img = start_frame: end_frame
        for r = 1 : size(imgs,1)
           for k = 1:4
              corrected(r,:,img) = medfilt1(imgs(r,:,img));
           end
        end
    end
end

function corrected = cameraShake(imgs)
    corrected = imgs;
    threshold = 0.1;
    
    for img = 1:size(imgs,3)-1
       imgA = corrected(:,:,img)
       imgB = corrected(:,:,img+1)
        
       pointsA = detectFASTFeatures(imgA, 'MinContrast', threshold);
       pointsB = detectFASTFeatures(imgB, 'MinContrast', threshold); 
       
       [featuresA, pointsA] = extractFeatures(imgA, pointsA);
       [featuresB, pointsB] = extractFeatures(imgB, pointsB);
       
       indexPairs = matchFeatures(featuresA, featuresB);
       pointsA = pointsA(indexPairs(:, 1), :);
       pointsB = pointsB(indexPairs(:, 2), :);
       
       [tform, pointsBm, pointsAm] = estimateGeometricTransform(pointsB, pointsA, 'affine');
       imgBp = imwarp(imgB, tform, 'OutputView', imref2d(size(imgB)));
       pointsBmp = transformPointsForward(tform, pointsBm.Location);
       
       H = tform.T;
       R = H(1:2,1:2); 
       
       theta = mean([atan2(R(2),R(1)) atan2(-R(3),R(4))]);
       scale = mean(R([1 4])/cos(theta));
       
       translation = H(3, 1:2);
        
       HsRt = [[scale*[cos(theta) -sin(theta); sin(theta) cos(theta)]; ...
                translation], [0 0 1]'];
       tformsRT = affine2d(HsRt);

       imgBold = imwarp(imgB, tform, 'OutputView', imref2d(size(imgB)));
       imgBsRt = imwarp(imgB, tformsRT, 'OutputView', imref2d(size(imgB)));
       
       corrected(:,:,img) = imgBsRt;
    end
    
end


