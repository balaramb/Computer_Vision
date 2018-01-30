% Q4.2:
% Integrating everything together.
% Loads necessary files from ../data/ and visualizes 3D reconstruction
% using scatter3

img1 = imread('../data/im1.png');
img2 = imread('../data/im2.png');

% Load given data
load('../data/templeCoords.mat');		%Gives x1 & y1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%FROM FIND M2 function%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%FROM FIND M2%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
x2 = zeros(size(x1,1),1);
y2 = zeros(size(y1,1),1);
for i = 1: size(x1, 1)
    [x2(i), y2(i)] = epipolarCorrespondence(img1, img2, F, x1(i), y1(i));
end

pts1 = [x1, y1]; 
pts2 = [x2, y2];
[P, ~] = triangulate(C1, pts1, C2, pts2);

% generate 3D visualization 
scatter3(P(:,1), P(:,2), P(:,3),'filled');
%save('q4_2.mat', 'F', 'M1', 'M2', 'C1', 'C2');