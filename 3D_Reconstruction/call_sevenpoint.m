	load('../data/some_corresp.mat');

	I1 = imread('../data/im1.png');
	I2 = imread('../data/im2.png');

	r = randi([1,110],7,1);
	pts1 = pts1(r,:);
	pts2 = pts2(r,:);
	
	M = max(size(I1,1),size(I1,2));
	
	F = sevenpoint( pts1, pts2, M );

	% check with epipolarF
	%displayEpipolarF(I1, I2, F{1});
	
	% save workspace variables
	%save('q2_2.mat', 'pts1', 'pts2', 'M', 'F');