function [locs,desc] = computeBrief(im, GaussianPyramid, locsDoG, k, ...
                                        levels, compareA, compareB)
%%Compute BRIEF feature
% INPUTS
% im      - a grayscale image with values from 0 to 1
% locsDoG - locsDoG are the keypoint locations returned by the DoG detector
% levels  - Gaussian scale levels that were given in Section1
% compareA and compareB - linear indices into the patchWidth x patchWidth image 
%                         patch and are each n x 1 vectors
%
% OUTPUTS
% locs - an m x 3 vector, where the first two columns are the image coordinates 
%		 of keypoints and the third column is the pyramid level of the keypoints
% desc - an m x n bits matrix of stacked BRIEF descriptors. m is the number of 
%        valid descriptors in the image and will vary

	patchWidth = 9;

	semiPatchWidth = ceil(patchWidth / 2);	%semiPatchWidth = 5;
	m_size = size(GaussianPyramid, 1);	
	n_size = size(GaussianPyramid, 2);
	check_matrix = locsDoG(:,1)>=semiPatchWidth & locsDoG(:,1)<=(n_size-semiPatchWidth) & locsDoG(:,2)>=semiPatchWidth & locsDoG(:,2)<=(m_size-semiPatchWidth);
	locs = locsDoG(check_matrix, :);				% still in the form of co-ordinates (98 x 139) for an image 139 x 98
	
	m = size(locs,1);	% m=325
	n = size(compareA,1);	%n=256
	desc = zeros(m,n);
	
	DoGPyramid = GaussianPyramid(:,:,2:end) - GaussianPyramid(:,:,1:end-1);
	
	for i = 1:m
		%these are from DoGPyramid
		coord1 = locs(i,1);
		coord2 = locs(i,2);
		actualLevelNum = locs(i,3);
		LevelNum = locs(i,3);
		curr_patch = GaussianPyramid(coord2-semiPatchWidth+1:coord2+semiPatchWidth-1,coord1-semiPatchWidth+1:coord1+semiPatchWidth-1, find(actualLevelNum == levels));
		%curr_patch = DoGPyramid(coord2-semiPatchWidth+1:coord2+semiPatchWidth-1,coord1-semiPatchWidth+1:coord1+semiPatchWidth-1, LevelNum);
		for j = 1:n
			desc(i,j) = curr_patch(compareA(j)) > curr_patch(compareB(j));
		end
	end
end