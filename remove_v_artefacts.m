function corrected = remove_v_artefacts(imgs, start_frame, end_frame)
    corrected = imgs;
    for img = start_frame: end_frame
        for r = 1 : size(imgs,1)
            corrected(r,:,img) = medfilt1(corrected(r,:,img),5);
        end
    end
end