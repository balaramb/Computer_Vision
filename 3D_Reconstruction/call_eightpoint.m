	load('../data/some_corresp.mat');

	I1 = imread('../data/im1.png');
	I2 = imread('../data/im2.png');

	M = max(size(I1,1),size(I1,2));
	
	F = eightpoint( pts1, pts2, M );

	% check with epipolarF
	%displayEpipolarF(I1, I2, F);
	
	% save workspace variables
	%save('q2_1.mat', 'pts1', 'pts2', 'M', 'F');