% Q3.3:
	%function [M2] = findM2()
%       1. Load point correspondences
%       2. Obtain the correct M2
%       3. Save the correct M2, p1, p2, R and P to q3_3.mat

	%for pts1 and pts2
	load('../data/some_corresp.mat');
	
	%for M
	I1 = imread('../data/im1.png');
	I2 = imread('../data/im2.png');
	M = max(size(I1,1),size(I1,2));
	
	%find fundamental matrix
	F = eightpoint( pts1, pts2, M);
	
	%for K1 and K2
	load('../data/intrinsics.mat');

	%find essential matrix
	E = essentialMatrix(F, K1, K2);

	%M1 in canonical form; find M2
	M1 = [1,0,0,0; 0,1,0,0; 0,0,1,0];
	M2s = camera2(E);
	%Initialize flags
	flag = [0,0,0,0];
	
	%just for this
	p1 = pts1;
	p2 = pts2;
	
	%initialize P
	corresp_num = size(p1,1);
	P = zeros(corresp_num,3);
	for q = 1:4
		
		M2 = M2s(:,:,q);
		%find Cs
		C1 = K1*M1;
		C2 = K2*M2;
		[ P_keep, err_keep ] = triangulate( C1, p1, C2, p2 );
		
		%flag an M2 matrix as irrelevant if it results in negative z-coordinates
		for t = 1:size(P_keep,1)
			if P_keep(t,3)<0
			flag(q) = 1;
			end
		end
		
		%keep the unflagged M2
		if flag(q) == 0
			P = P_keep;
			err = err_keep;
			M2_keep = M2s(:,:,q);
		end
	end
	
	%finalize M2,corresponding C2, triangulated 3D points
	M2 = M2_keep;
	C2 = K2*M2;
	C1 = K1*M1;
	[ P, err ] = triangulate( C1, p1, C2, p2 );
	
	%save content
	%save('q3_3.mat', 'M2', 'C2', 'p1', 'p2', 'P');