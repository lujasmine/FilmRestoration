function corrected = remove_blotches(imgs)
    corrected = imgs;
    
%     blotches_marked = detect_blotches(imgs, 1, 256);
    detect_blotches(imgs, 1, 200);
end

% Blotch detection as outlined by Biemond in 'biemond1.pdf'
function blotches_marked = detect_blotches(imgs, start_frame, end_frame)

    blotches_marked = imgs;
    T1 = 0;
    
    for n = start_frame+1 : end_frame
               
%         p = zeros(size(imgs,1)-2,size(imgs,2),6);
        for r = 2:size(imgs,1)-1
           for col = 1:size(imgs,2)
               p1 = imgs(r-1,col,n-1);
               p2 = imgs(r,col,n-1);
               p3 = imgs(r+1,col,n-1);
               p4 = imgs(r-1,col,n+1);
               p5 = imgs(r,col,n+1);
               p6 = imgs(r+1,col,n+1);
               
               p = [p1,p2,p3,p4,p5,p6];
               I = imgs(r,col,n);
               d = 0;
               
               if ((min(p) - I) > 0)
                   d = min(p) - I;
               elseif ((I - max(p)) > 0)
                   d = I - max(p);
               end
               
               if (d > T1)
                   blotches_marked(r, col, n) = 1;
               end
           end
        end   
    end
    
%     figure
%     subplot(1,2,1)
%     imshow(imgs(:,:,start_frame+1))
%     subplot(1,2,2)
%     imshow(blotches_marked(:,:,start_frame+1))
   
end