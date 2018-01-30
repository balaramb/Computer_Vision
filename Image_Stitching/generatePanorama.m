function [img3] = generatePanorama(img1, img2)

[locs1, desc1] = briefLite(img1);
[locs2, desc2] = briefLite(img2);

matches = briefMatch(desc1, desc2);

p1 = locs1(matches(:, 1), 1:2);
p2 = locs2(matches(:, 2), 1:2);

H2to1 = ransacH(matches, locs1, locs2);
load('temp.mat');

img3 = imageStitching_noClip(img1, img2, H2to1);
imshow(img3);