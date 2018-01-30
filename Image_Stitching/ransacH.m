function [bestH] = ransacH(matches, locs1, locs2, nIter, tol)
% INPUTS
% locs1 and locs2 - matrices specifying point locations in each of the images
% matches - matrix specifying matches between these two sets of point locations
% nIter - number of iterations to run RANSAC
% tol - tolerance value for considering a point to be an inlier
%
% OUTPUTS
% bestH - homography model with the most inliers found during RANSAC

%locs is tx3; t being different for each image - x-coord,y-coord,layernumber
%matches - px2 - 1st is index into desc1(each row corresponds to each of locs); 2nd is index into desc2

if ~exist('nIter', 'var') || isempty(nIter)
    nIter = 800;
end

if ~exist('tol', 'var') || isempty(tol)
    tol = 1;
end

p1 = locs1(matches(:,1),1:2)';
p2 = locs2(matches(:,2),1:2)';
run_over = size(p1,2);

highest_inlier_num = 0;
for i=1:nIter
	p1_temp = zeros(2,4);
	p2_temp = zeros(2,4);
	%pick 4 random pairs for initial computation of homography
	random_matches_indices = randperm(size(matches,1),4);
	random_matches = matches(random_matches_indices,:);

	first_point_set = locs1(random_matches(:,1),1:2)';
	second_point_set = locs2(random_matches(:,2),1:2)';	

	%compute homography
	H_temp = computeH(first_point_set,second_point_set);

	%look for homography distance
	inlier_num = 0;
	for j=1:run_over
		original_point = [p2(:,j);1];
		reflection = H_temp*original_point;
		actual_correspondece = [p1(:,j);1];
		distance = sqrt((reflection(1)-actual_correspondece(1))^2 + (reflection(2)-actual_correspondece(2))^2);
		%disp(distance);
		if distance<tol
			inlier_num = inlier_num +1;
		end
	end
	%disp(inlier_num);
	if inlier_num>highest_inlier_num
		highest_inlier_num = inlier_num;
		bestH = H_temp;
		%disp('Updated H \n');
	end
end

end