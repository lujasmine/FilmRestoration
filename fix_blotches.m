function [blotches, corrected] = fix_blotches(imgs, start_frame, end_frame, b)
    corrected = imgs;
    blotches = b;
        
    for n = start_frame+2 : end_frame-2
        [neigh_start, neigh_end] = get_start_end_frames(n, start_frame,...
            end_frame, 5);
        
        [neigh_start_2, ~] = get_start_end_frames(n, start_frame,...
            end_frame, 4);
        
        for r = 2 : size(imgs,1)-1
           for col = 1 : size(imgs,2) 
               if (check_blotch(corrected,r,col,n, 0.1) && check_blotch_2(corrected, r, col, n, neigh_start, neigh_end))
                   blotches(r,col,n) = 1;
                   corrected(r,col,n) = correct_blotch(corrected,r,col,neigh_start_2,n);
                   corrected(r,col,n-1) = correct_blotch(corrected,r,col,neigh_start_2,n-1);
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
%     if ((diff_prev_2 > T1) && (diff_next > T1) && (abs(two_bef - one_aft) > T1)) || ...
%             ((diff_next_2 > T1) && (diff_prev > T1) && (abs(one_bef - two_aft) > T1))
%        is_blotch = true; 
%     end
    
    % filters out some of the false alarms from moving objects
    if ((abs(one_aft - one_bef) > T1) && (abs(two_aft - two_bef) > T1))
        is_blotch = false;
    end
end

function is_blotch = check_blotch_2(imgs, row, col, n, neigh_start, neigh_end)
    is_blotch = false;
    T1 = 0.1;
    diff_count = 0;

    for frame_num = neigh_start : neigh_end
        if abs((imgs(row,col,frame_num) - imgs(row,col,n)) > T1)
            diff_count = diff_count + 1;
        end
    end
    if (diff_count >= (neigh_start - neigh_end - 1))
       is_blotch = true;
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


function correct_pixel = correct_blotch(corrected,r,col,avg_start,img_num)
    ref_pixel = mean(corrected(r,col,avg_start:img_num-1));
    correct_pixel = ref_pixel;
end
