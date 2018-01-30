function PrincipalCurvature = computePrincipalCurvature(DoGPyramid)
%%Edge Suppression
% Takes in DoGPyramid generated in createDoGPyramid and returns
% PrincipalCurvature,a matrix of the same size where each point contains the
% curvature ratio R for the corre-sponding point in the DoG pyramid
%
% INPUTS
% DoG Pyramid - size (size(im), numel(levels) - 1) matrix of the DoG pyramid
%
% OUTPUTS
% PrincipalCurvature - size (size(im), numel(levels) - 1) matrix where each 
%                      point contains the curvature ratio R for the 
%                      corresponding point in the DoG pyramid
	PrincipalCurvature = zeros(size(DoGPyramid));
	m = size(DoGPyramid, 3);
	for i = 1:m
		[Dx, Dy] = gradient(DoGPyramid(:, :, i));
		[Dxx, Dxy] = gradient(Dx);
		[Dyx, Dyy] = gradient(Dy);
		tracem = Dxx + Dyy;
		determ = Dxx.* Dyy - Dxy.^2;
		PrincipalCurvature(:, :, i) = (tracem).^2 ./ (determ);
	end
end