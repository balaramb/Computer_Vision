function [ F ] = eightpoint( pts1, pts2, M )
% eightpoint:
%   pts1 - Nx2 matrix of (x,y) coordinates
%   pts2 - Nx2 matrix of (x,y) coordinates
%   M    - max (imwidth, imheight)

% Q2.1:
%     Implement the eightpoint algorithm
%     Generate a matrix F from some '../data/some_corresp.mat'
%     Save F, M, pts1, pts2 to q2_1.mat

%     Write F and display the output of displayEpipolarF in your writeup

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
	F = V(:,end);
	F = reshape(F,[3,3]);
	
	%NORMALIZE F????
	
	%Rank 2 constraint enforcement
	[U2, S2, V2] = svd(F);
	S2(3, 3) = 0;
	F = U2*S2*V2';
	
	%Call provided refineF function
	F = refineF(F, pts1, pts2);
	
	%Create scaling matrix & unscale
	T = [1/M 0 0; 0 1/M 0; 0 0 1];
	F = T'*F*T;

end