function corrected = camera_shake(imgs)
    corrected = imgs;

    for n = 2: size(imgs,3)
        
        curr_frame = uint8(corrected(:,:,n));
        prev_frame = uint8(corrected(:,:,n-1));
        
        % detect corners of prev and curr frame
        curr_pts = detectFASTFeatures(curr_frame, 'MinContrast', 0.1);
        prev_pts = detectFASTFeatures(prev_frame, 'MinContrast', 0.1);
        
        % extract descriptors from corners
        [curr_feats, curr_pts] = extractFeatures(curr_frame, curr_pts);
        [prev_feats, prev_pts] = extractFeatures(prev_frame, prev_pts);
        
        % match features
        indexPairs = matchFeatures(curr_feats, prev_feats);
        curr_pts = curr_pts(indexPairs(:, 1), :);
        prev_pts = prev_pts(indexPairs(:, 2), :);
        
        if size(curr_pts, 1) >= 3
            tform = estimateGeometricTransform(prev_pts, curr_pts, 'affine');
            corrected(:,:,n) = imwarp(prev_frame, tform, 'OutputView',imref2d(size(curr_frame)));
        end
    end

end