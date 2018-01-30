function H2to1 = computeH(p1,p2)
% INPUTS:
% p1 and p2 - Each are size (2 x N) matrices of corresponding (x, y)'  
%             coordinates between two images
%
% OUTPUTS:
% H2to1 - a 3 x 3 matrix encoding the homography that best matches the linear 
%         equation

x1 = p2(1,:);	%x1 is 1xN matrix
y1 = p2(2,:);	%y1 is 1xN matrix

x2 = p1(1,:);	%x2 is 1xN matrix
y2 = p1(2,:);	%y2 is 1xN matrix

N = size(p1,2);
A = zeros(2*N,9);

for i = 1:N
	A(2*i-1,:) = [-x1(i) -y1(i) -1 0 0 0 x1(i)*x2(i) y1(i)*x2(i) x2(i)];
	A(2*i, : ) = [0 0 0 -x1(i) -y1(i) -1 x1(i)*y2(i) y1(i)*y2(i) y2(i)];
end

[U,S,V] = svd(A);
H2to1 = reshape(V(:,end),3,3)';
H2to1 = H2to1./H2to1(3,3);