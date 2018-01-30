% Script to test BRIEF under rotations
im1 = imread('../data/model_chickenbroth.jpg');
if size(im1, 3) == 3
    img1 = rgb2gray(im1);
end
im1 = im2double(im1);
[locs1, desc1] = briefLite(im1);

deg = 10;
match_num = zeros(18,1);

for i = 1:18
	im2 = imrotate(im1,deg);
	[locs2, desc2] = briefLite(im2);
	matches = briefMatch(desc1, desc2);
	match_num(i,1) = size(matches,1);
	deg = deg+10;
end

bar(10:10:180, match_num');
title('BRIEF feature matches: Rotated vs Original_image');
xlabel('Rotation Angle');
ylabel('Number of matched features');