%img1 = im2double(rgb2gray(imread('../data/incline_L.png')));
%img2 = im2double(rgb2gray(imread('../data/incline_R.png')));

img1 = imread('../data/incline_L.png');
img2 = imread('../data/incline_R.png');

[locs1, desc1] = briefLite(img1);
[locs2, desc2] = briefLite(img2);

[matches] = briefMatch(desc1, desc2);

p1 = locs1(matches(:,1),1:2)';
p2 = locs2(matches(:,2),1:2)';

H2to1 = ransacH(matches, locs1, locs2);

outsize = [600 1200];
img2_warped = warpH(img2, H2to1, outsize);

img2_warped = im2double(img2_warped);
img1 = im2double(img1);

m = size(img1,1);
n = size(img1,2);
img2_warped(1:m,1:n,:) = img1/2 + img2_warped(1:m,1:n,:)/2;
panoImg = img2_warped;
imshow(panoImg);