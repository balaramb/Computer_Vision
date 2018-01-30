function [ P, err ] = triangulate( C1, p1, C2, p2 )
% triangulate:
%       C1 - 3x4 Camera Matrix 1
%       p1 - Nx2 set of points
%       C2 - 3x4 Camera Matrix 2
%       p2 - Nx2 set of points

%       P - Nx3 matrix of 3D coordinates
%       err - scalar of the reprojection error

% Q3.2:
%       Implement a triangulation algorithm to compute the 3d locations
%
	%initialize P
	corresp_num = size(p1,1);
	P = zeros(corresp_num,3);

	err = 0;
	for i = 1:corresp_num
		x1 = p1(i,1);
		y1 = p1(i,2);
		x2 = p2(i,1);
		y2 = p2(i,2);
		
		%find Ax = 0 and take SVD
		A = [x1*C1(3,:) - C1(1,:); y1*C1(3,:) - C1(2,:); x2*C2(3,:) - C2(1,:); y2*C2(3,:) - C2(2,:)];
		[U,S,V] = svd(A);
		X = V(:,end);
		
		%find 3D world point
		P(i,:) = [X(1)/X(4), X(2)/X(4), X(3)/X(4)];
		
		temp_P = [P(i,:), 1]';
		temp1 = C1*temp_P;
		temp2 = C2*temp_P;
		
		%find reprojection
		x1_approx = temp1(1)/temp1(3);
		y1_approx = temp1(2)/temp1(3);
		x2_approx = temp2(1)/temp2(3);
		y2_approx = temp2(2)/temp2(3);
		err = err + (y1-y1_approx).^2 + (x1-x1_approx).^2 + (y2-y2_approx).^2 + (x2-x2_approx).^2;
	end
end