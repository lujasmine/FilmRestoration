% TODO try with pixels AFTER doing everything else
function corrected = correct_flicker(imgs, start_frame, end_frame)
    corrected = imgs;
    n_frames = 2;
    
    for img_num = start_frame:end_frame
        
        avg_start = img_num;
        avg_end = img_num;
        
        if ((img_num - n_frames) > start_frame)
            avg_start = img_num - n_frames;
        end
        
        if ((img_num + n_frames) < end_frame)
            avg_end = img_num + n_frames;
        end
        
        frames_sum = sum(corrected(:,:,avg_start:avg_end),3);
        frames_avg = frames_sum / (avg_end - avg_start + 1);
        corrected(:,:,img_num) = histeq(corrected(:,:,img_num), imhist(frames_avg)); 
    end
end