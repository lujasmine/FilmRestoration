function [blotches, correct] = fix_blotches(imgs, start_frame, end_frame, b)
    correct = imgs;
    blotches = b;
        
    for n = start_frame+2 : end_frame-2

        % get neighbouring frames for blotch check
        [n_start, n_end] = get_start_end_frames(n, start_frame,end_frame, 5);

        % get neighbouring frames for blotch removal
        [n_start_2, ~] = get_start_end_frames(n, start_frame,end_frame, 4);

        for r = 2 : size(imgs,1)-1
           for col = 1 : size(imgs,2) 
               % check whether the pixel is part of a blotch
               if (check_blotch(correct,r,col,n, 0.1) && ...
                       check_blotch_2(correct, r, col, n, n_start, n_end))
                   blotches(r,col,n) = 1; % update blotches

                   % correct pixel in this frame and prev frame
                   correct(r,col,n) = correct_blotch(correct,r,col,n_start_2,n); 
                   correct(r,col,n-1) = correct_blotch(correct,r,col,n_start_2,n-1);
               end
           end
        end 
    end
end

function is_blotch = check_blotch(imgs, row, col, n, T)
    T1 = T;
    curr = imgs(row,col,n);
    is_blotch = false;
    
    one_bef = imgs(row,col,n-1);
    two_bef = imgs(row,col,n-2);
    one_aft = imgs(row,col,n+1);
    two_aft = imgs(row,col,n+2);

    diff_prev = abs(curr - one_bef);
    diff_prev_2 = abs(curr - two_bef);
    diff_next = abs(curr - one_aft);
    diff_next_2 = abs(curr - two_aft);
    
    if ((diff_prev_2 > T1) && (diff_prev > T1))
        is_blotch = true;
    end

    % filters out some of the false alarms from moving objects
    if ((abs(one_aft - one_bef) > T1) && (abs(two_aft - two_bef) > T1))
        is_blotch = false;
    end
end

function is_blotch = check_blotch_2(imgs, row, col, n, n_start, n_end)
    is_blotch = false;
    T1 = 0.1;
    diff_count = 0;

    for frame_num = n_start : n_end
        if abs((imgs(row,col,frame_num) - imgs(row,col,n)) > T1)
            diff_count = diff_count + 1;
        end
    end
    if (diff_count >= (n_start - n_end - 1))
       is_blotch = true;
    end
end

function [start_frame, end_frame] = get_start_end_frames(curr, first, last, nbours)
    start_frame = first;
    end_frame = last;

    if ((curr - nbours) > first)
        start_frame = curr - nbours;
    end

    if ((curr + nbours) < last)
        end_frame = curr + nbours;
    end
end


function correct_pixel = correct_blotch(correct,r,col,avg_start,img_num)
    ref_pixel = mean(correct(r,col,avg_start:img_num-1));
    correct_pixel = ref_pixel;
end
