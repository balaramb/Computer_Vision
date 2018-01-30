function locsDoG = getLocalExtrema(DoGPyramid, DoGLevels, ...
                        PrincipalCurvature, th_contrast, th_r)
%%Detecting Extrema
% INPUTS
% DoG Pyramid - size (size(im), numel(levels) - 1) matrix of the DoG pyramid
% DoG Levels  - The levels of the pyramid where the blur at each level is
%               outputs
% PrincipalCurvature - size (size(im), numel(levels) - 1) matrix contains the
%                      curvature ratio R
% th_contrast - remove any point that is a local extremum but does not have a
%               DoG response magnitude above this threshold
% th_r        - remove any edge-like points that have too large a principal
%               curvature ratio
%
% OUTPUTS
% locsDoG - N x 3 matrix where the DoG pyramid achieves a local extrema in both
%           scale and space, and also satisfies the two thresholds.

	islocal_extrema = zeros(size(DoGPyramid));
	
	topDuplicate = DoGPyramid(:,:,1);
	bottomDuplicate = DoGPyramid(:,:,size(DoGPyramid,3));
	
	bigDoGPyramid = cat(3,topDuplicate,DoGPyramid,bottomDuplicate);
	
	scaleExtrema_max = (DoGPyramid(:,:,:)>=bigDoGPyramid(:,:,1:size(DoGPyramid,3)) & DoGPyramid(:,:,:)>=bigDoGPyramid(:,:,3:size(DoGPyramid,3)+2));
	scaleExtrema_min = (DoGPyramid(:,:,:)<=bigDoGPyramid(:,:,1:size(DoGPyramid,3)) & DoGPyramid(:,:,:)<=bigDoGPyramid(:,:,3:size(DoGPyramid,3)+2));
	
	trimmedCurrentLayer_max = zeros(size(DoGPyramid));
	trimmedCurrentLayer_min = zeros(size(DoGPyramid));
	
	for i=1:size(DoGPyramid,3)
		currentLayer = DoGPyramid(:,:,i);
		trimmedCurrentLayer = currentLayer(2:size(DoGPyramid,1)-1,2:size(DoGPyramid,2)-1,1);
		A1 = trimmedCurrentLayer >= currentLayer(3:end,2:end-1,1);
		A2 = trimmedCurrentLayer >= currentLayer(1:end-2,2:end-1,1);
		A3 = trimmedCurrentLayer >= currentLayer(2:end-1,3:end,1);
		A4 = trimmedCurrentLayer >= currentLayer(2:end-1,1:end-2,1);
		A5 = trimmedCurrentLayer >= currentLayer(1:end-2,1:end-2,1);
		A6 = trimmedCurrentLayer >= currentLayer(3:end,3:end,1);
		A7 = trimmedCurrentLayer >= currentLayer(3:end,1:end-2,1);
		A8 = trimmedCurrentLayer >= currentLayer(1:end-2,3:end,1);
		
		A11 = trimmedCurrentLayer <= currentLayer(3:end,2:end-1,1);
		A12 = trimmedCurrentLayer <= currentLayer(1:end-2,2:end-1,1);
		A13 = trimmedCurrentLayer <= currentLayer(2:end-1,3:end,1);
		A14 = trimmedCurrentLayer <= currentLayer(2:end-1,1:end-2,1);
		A15 = trimmedCurrentLayer <= currentLayer(1:end-2,1:end-2,1);
		A16 = trimmedCurrentLayer <= currentLayer(3:end,3:end,1);
		A17 = trimmedCurrentLayer <= currentLayer(3:end,1:end-2,1);
		A18 = trimmedCurrentLayer <= currentLayer(1:end-2,3:end,1);
		
		k = A1 & A2 & A3 & A4 & A5 & A6 & A7 & A8;
		p = A11 & A12 & A13 & A14 & A15 & A16 & A17 & A18;
		
		k1 = horzcat(zeros(size(k,1),1),k,zeros(size(k,1),1));
		p1 = horzcat(zeros(size(p,1),1),p,zeros(size(p,1),1));

		trimmedCurrentLayer_max(:,:,i) = vertcat(zeros(1,size(k1,2)),k1,zeros(1,size(k1,2)));
		trimmedCurrentLayer_min(:,:,i) = vertcat(zeros(1,size(p1,2)),p1,zeros(1,size(p1,2)));
	end

	islocal_extrema = (trimmedCurrentLayer_max & scaleExtrema_max) | (trimmedCurrentLayer_min & scaleExtrema_min);
	
	minORmax = islocal_extrema & (abs(DoGPyramid)>th_contrast) & (PrincipalCurvature<th_r) & (PrincipalCurvature>0);	%DoGPyramid and PrincipalCurvature have same dims
	s = size(DoGPyramid);
	[x, y, levelNum] = ind2sub(s, find(minORmax));
	actualLevelNum = DoGLevels(levelNum);
	locsDoG = [y, x, actualLevelNum'];
%	locsDoG = [y, x, levelNum];
end