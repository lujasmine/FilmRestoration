function corrected = camera_shake(imgs)
    corrected = imgs;

    for n = 2: size(imgs,3)
        
        curr_frame = uint8(corrected(:,:,n));
        prev_frame = uint8(corrected(:,:,n-1));
        
        % detect corners of prev and curr frame
        curr_pts = detectFASTFeatures(curr_frame, 'MinContrast', 0.1);
        prev_pts = detectFASTFeatures(prev_frame, 'MinContrast', 0.1);
        
        % Extract FREAK descriptors for the corners
        [curr_feats, curr_pts] = extractFeatures(curr_frame, curr_pts);
        [prev_feats, prev_pts] = extractFeatures(prev_frame, prev_pts);
        
        indexPairs = matchFeatures(curr_feats, prev_feats);
        curr_pts = curr_pts(indexPairs(:, 1), :);
        prev_pts = prev_pts(indexPairs(:, 2), :);
        
        if size(curr_pts, 1) >= 3
            tform = estimateGeometricTransform(prev_pts, curr_pts, 'affine');
            
            % Extract scale and rotation part sub-matrix.
            H = tform.T;
            R = H(1:2,1:2);

            % Compute theta from mean of two possible arctangents
            theta = mean([atan2(R(2),R(1)) atan2(-R(3),R(4))]);

            % Compute scale from mean of two stable mean calculations
            scale = mean(R([1 4])/cos(theta));

            % Translation remains the same:
            translation = H(3, 1:2);

            % Reconstitute new s-R-t transform:
            HsRt = [[scale*[cos(theta) -sin(theta); sin(theta) cos(theta)]; ...
              translation], [0 0 1]'];
            tformsRT = affine2d(HsRt);

            corrected(:,:,n) = imwarp(prev_frame, tformsRT, 'OutputView',imref2d(size(curr_frame)));
        end
    end

end