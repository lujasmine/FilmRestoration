function corrected = correct_flicker(imgs, start_frame, end_frame)
    corrected = imgs;
    n_neighbours = 5;
    
    for img_num = start_frame:end_frame
        [avg_start, avg_end] = get_start_end_frames(img_num, ...
            start_frame, end_frame, n_neighbours);
        
        frames_sum_pix = sum(corrected(:,:,avg_start:avg_end),3);        
        frames_avg_pix = frames_sum_pix / (avg_end - avg_start + 1);       
        corrected(:,:,img_num) = histeq(corrected(:,:,img_num), imhist(frames_avg_pix)); 
    end
end

function [start_frame, end_frame] = get_start_end_frames(curr, first, last, neighbours)
    start_frame = first;
    end_frame = last;

    if ((curr - neighbours) > first)
        start_frame = curr - neighbours;
    end

    if ((curr + neighbours) < last)
        end_frame = curr + neighbours;
    end
end