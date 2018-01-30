	n = 400;
	load('../data/carseq.mat');
	load('carseqrects.mat');
	rect = [60, 117, 146, 152]';
	It = frames(:,:,1);
	It1 = frames(:,:,n);
	curr_rect = saveit(n,:)';
	[dp_x,dp_y] = LucasKanade_special(It, It1, rect, curr_rect);
	
	k = curr_rect(1)+dp_x;
	q = curr_rect(2)+dp_y;
	r = curr_rect(3)+dp_x;
	s = curr_rect(4)+dp_y;
	
	subplot(1,1,1);
	imshow(It1);
	rectangle('Position', [curr_rect(1), curr_rect(2), curr_rect(3)-curr_rect(1), curr_rect(4)-curr_rect(2)], 'LineWidth', 2, 'EdgeColor', 'g');
	rectangle('Position', [k, q, r-k, s-q], 'LineWidth', 2, 'EdgeColor', 'y');
	name = strcat("Frame ",string(n));