function [ E ] = essentialMatrix( F, K1, K2 )
% essentialMatrix:
%    F - 3x3 Fundamental Matrix
%    K1 - 3x3 Camera Matrix 1
%    K2 - 3x3 Camera Matrix 2

% Q3.1:
%       Compute the 3x3 essential matrix 
%
%       Write the computed essential matrix in your writeup
	
	%load('../data/some_corresp.mat');
	%I1 = imread('../data/im1.png');
	%I2 = imread('../data/im2.png');
	%M = max(size(I1,1),size(I1,2));
	%F = eightpoint( pts1, pts2, M );
	%load('../data/intrinsics.mat')

	E = K2'*F*K1;
end