	load('../data/some_corresp.mat');
	M = 640;

	curr_best_error = 10000000;
	for i = 1:5000
		disp(i);
		pick_points = randperm(size(pts1,1),7);
		p1 = pts1(pick_points,:);
		p2 = pts2(pick_points,:);
		[F] = sevenpoint( p1, p2, M );
		
		for t = 1:size(F,2)
			F_curr = F{t};
			
			%error = 0;
			%for j = 1:size(pts1,1)
			%	X = [pts1(j,:),1];
			%	X1 = [pts2(j,:),1];
			%	error = error + abs(X*F_curr*X1');
			%end
			
			X = [pts1,ones(size(pts1,1),1)];
			X1 = [pts2,ones(size(pts2,1),1)];
			error = (X*F_curr).*X1;
			error = sum(abs(sum(error,2)));
			
			if error<curr_best_error
				curr_best_error = error;
				best_F = F_curr;
			end
		end
	end
	F = best_F;
	% check with epipolarF
	I1 = imread('../data/im1.png');
	I2 = imread('../data/im2.png');
	displayEpipolarF(I1, I2, F);
	
	% save workspace variables
	%save('q2_2.mat', 'pts1', 'pts2', 'M', 'F');