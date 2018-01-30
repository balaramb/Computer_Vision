% your code here
load('../data/carseq.mat');
curr_rect = [60, 117, 146, 152]';
frame_num = size(frames,3);
rects = zeros(frame_num,4);
n=0;
for i = 1:frame_num-1
	rects(i,:) = curr_rect;
	It = frames(:,:,i);
	It1 = frames(:,:,i+1);

	p = curr_rect(1);
	q = curr_rect(2);
	r = curr_rect(3);
	s = curr_rect(4);

	[dp_x,dp_y] = LucasKanade(It, It1, curr_rect);
	curr_rect = [p+dp_x, q+dp_y, r+dp_x, s+dp_y]';
	if i==1 | rem(i,100) == 0
		n=n+1;
		subplot(1,5,n);
		imshow(It);
		rectangle('Position', [p, q, r-p, s-q], 'LineWidth', 2, 'EdgeColor', 'y');
		name = strcat("Frame ",string(i));
		title(name);
	end
end
rects(frame_num,:) = curr_rect;
save('carseqrects.mat','rects');