function corrected = remove_blotches(imgs)    
%     blotches_marked = detect_blotches(imgs, 1, 256);
%     corrected = correct_blotches(blotches_marked, imgs);
    corrected = detect_blotches(imgs, 1, 256);
%     corrected = correct_blotches(imgs, blotches);
    
%     disp(blotches2(:,:,34));
    
%     figure
%     subplot(1,2,1)
%     imshow(imgs(:,:,34))
%     subplot(1,2,2)
%     imshow(blotches(:,:,34))

%     disp(blotches(:,:,34))
    
end

function blotches = detect_blotches(imgs, start_frame, end_frame)

%     blotches = zeros(size(imgs));
    blotches = imgs;
    T1 = 0.1;
    
    for n = start_frame+5 : end_frame
        for r = 2 : size(imgs,1)-1
           for col = 1 : size(imgs,2)
               if (abs(imgs(r,col,n) - imgs(r,col,n+5)) > T1)
                   if (abs(imgs(r,col,n) - imgs(r,col,n-5)) > T1)
                       blotches(r,col,n) = (imgs(r,col,n-2)+imgs(r,col,n+2))/2;
                   end
               end
           end
        end   
    end
end