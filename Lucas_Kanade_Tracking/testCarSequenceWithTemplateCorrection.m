% your code here
load('../data/carseq.mat');
curr_rect = [60, 117, 146, 152]';

%use this for reference
first_rect = [60, 117, 146, 152]';

frame_num = size(frames,3);
rects = zeros(frame_num,4);
n=0;
for i = 1:frame_num-1
	rects(i,:) = curr_rect;
	disp(i);
	It = frames(:,:,i);
	It1 = frames(:,:,i+1);

	%Call Lukas_Kanade
	[u_lk,v_lk] = LucasKanade_redo(It, It1, curr_rect);
	
	%Find the predicted location
	predicted_rect_lk = [curr_rect(1)+u_lk, curr_rect(2)+v_lk, curr_rect(3)+u_lk, curr_rect(4)+v_lk]';
	
	%Correct with first tenplate
	[u_lk_star, v_lk_star] = LucasKanade_special(frames(:,:,1),It1,first_rect,predicted_rect_lk);
	
	x1 = u_lk_star+predicted_rect_lk(1);
	y1 = v_lk_star+predicted_rect_lk(2);
	x2 = u_lk_star+predicted_rect_lk(3);
	y2 = v_lk_star+predicted_rect_lk(4);
	
	curr_rect = [x1,y1,x2,y2]';
	
	if i==1 | rem(i,100) == 0
		n=n+1;
		subplot(1,5,n);
		imshow(It);
		rectangle('Position', [x1, y1, x2-x1, y2-y1], 'LineWidth', 2, 'EdgeColor', 'g');
		rectangle('Position', [predicted_rect_lk(1), predicted_rect_lk(2), predicted_rect_lk(3)-predicted_rect_lk(1), predicted_rect_lk(4)-predicted_rect_lk(2)], 'LineWidth', 2, 'EdgeColor', 'y');
		name = strcat("Frame ",string(i));
		title(name);
	end
end
rects(frame_num,:) = curr_rect;
save('carseqrects-wcrt.mat','rects');