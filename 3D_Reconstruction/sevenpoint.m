function [ F ] = sevenpoint( pts1, pts2, M )
% sevenpoint:
%   pts1 - 7x2 matrix of (x,y) coordinates
%   pts2 - 7x2 matrix of (x,y) coordinates
%   M    - max (imwidth, imheight)

% Q2.2:
%     Implement the eightpoint algorithm
%     Generate a matrix F from some '../data/some_corresp.mat'
%     Save recovered F (either 1 or 3 in cell), M, pts1, pts2 to q2_2.mat

%     Write recovered F and display the output of displayEpipolarF in your writeup
	%load('../data/some_corresp.mat');
	%M = 640;
	%pts1 = pts1(1:7,:);
	%pts2 = pts2(1:7,:);
	
	%Scale the coordinates
	pts1 = pts1./M;
	pts2 = pts2./M;
	
	%Use these for calculating the linear system of equations
	x_l = pts1(:,1);
	y_l = pts1(:,2);
	x_r = pts2(:,1);
	y_r = pts2(:,2);
	Q = [x_l.*x_r, x_l.*y_r, x_l, x_r.*y_l, y_l.*y_r, y_l, x_r, y_r, ones(size(x_l,1),1)];
	
	%SVD gives F in the last column of V
	[U, S, V] = svd(Q);
	F1 = V(:,end);
	F1 = reshape(F1,[3,3]);
	F2 = V(:,end-1);
	F2 = reshape(F2,[3,3]);
	
	%Solve for lamda that satisfies det(lamda*F1 +(1-lamda)*F2) = 0
	syms alph;
	DA = det(alph*F1 +(1-alph)*F2);
	p = sym2poly(DA);
	r = roots(p);
	
	%Pick the ones with non-imaginary roots
	alpha_opt = r(imag(r)==0);
	
	num_sol = size(alpha_opt,1);
	F = cell(1,num_sol);
	
	T = [1/M 0 0; 0 1/M 0; 0 0 1];
	for i=1:num_sol
		% Find the final fundamental matrix/matrices, refine and unscale them
		F{i} = alpha_opt(i)*F1 + (1-alpha_opt(i))*F2;
		F{i} = refineF(F{i}, pts1, pts2);
		F{i} = T' * F{i} * T;
	end
	
	%REFINE???
	
	% check with epipolarF
	%I1 = imread('../data/im1.png');
	%I2 = imread('../data/im2.png');
	%displayEpipolarF(I1, I2, F{2});

	%Undo the scaling as these are to be saved
	%pts1 = pts1.*M;
	%pts2 = pts2.*M;
	
	% save workspace variables
	%save('q2_2.mat', 'pts1', 'pts2', 'M', 'F');
end