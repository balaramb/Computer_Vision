% your code here
load('../data/sylvbases.mat');
load('../data/sylvseq.mat');

curr_rect_lk = [102, 62, 156, 108]';
curr_rect = [102, 62, 156, 108]';
frame_num = size(frames,3);
rects = zeros(frame_num,4);
n=0;
for i = 1:frame_num-1
	%disp(i)
	rects(i,:) = curr_rect;
	It = frames(:,:,i);
	It1 = frames(:,:,i+1);

	p = curr_rect(1);
	q = curr_rect(2);
	r = curr_rect(3);
	s = curr_rect(4);
	
	p_lk = curr_rect_lk(1);
	q_lk = curr_rect_lk(2);
	r_lk = curr_rect_lk(3);
	s_lk = curr_rect_lk(4);

	[dp_x_lk,dp_y_lk] = LucasKanade(It, It1, curr_rect_lk);
	[dp_x,dp_y] = LucasKanadeBasis(It, It1, curr_rect, bases);
	curr_rect = [p+dp_x, q+dp_y, r+dp_x, s+dp_y]';
	curr_rect_lk = [p_lk+dp_x_lk, q_lk+dp_y_lk, r_lk+dp_x_lk, s_lk+dp_y_lk]';
	if i==1 | i==200 | i==300 | i==350 | i==400
		n=n+1;
		subplot(1,5,n);
		imshow(It);
		rectangle('Position', [p, q, r-p, s-q], 'LineWidth', 2, 'EdgeColor', 'y');
		rectangle('Position', [p_lk, q_lk, r_lk-p_lk, s_lk-q_lk], 'LineWidth', 2, 'EdgeColor', 'g');
		name = strcat("Frame ",string(i));
		title(name);
	end
end
rects(frame_num,:) = curr_rect;
save('sylvseqrects.mat','rects');