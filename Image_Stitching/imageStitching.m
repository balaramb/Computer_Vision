function [panoImg] = imageStitching(img1, img2, H2to1)
%
% INPUT
% Warps img2 into img1 reference frame using the provided warpH() function
% H2to1 - a 3 x 3 matrix encoding the homography that best matches the linear
%         equation
%
% OUTPUT
% Blends img1 and warped img2 and outputs the panorama image

%needs rgb2gray and imdouble??
outsize = [800 2000];
img2_warped = warpH(img2, H2to1, outsize);

m = size(img1,1);
n = size(img1,2);

img2_warped = im2double(img2_warped);
img1 = im2double(img1);

%img2_warped(1:m,1:n,:) = img1/2 + img2_warped(1:m,1:n,:)/2;
panoImg = img2_warped;
%imshow(panoImg);

end