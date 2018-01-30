%im1 = imread('../data/model_chickenbroth.jpg');
%im2 = imread('../data/chickenbroth_05.jpg');
%im1 = imread('../data/incline_L.png');
%im2 = imread('../data/incline_R.png');
im1 = imread('../data/pf_scan_scaled.jpg');
%im2 = imread('../data/pf_floor.jpg');
im2 = imread('../data/pf_desk.jpg');


if size(im1, 3) == 3
    im1 = rgb2gray(im1);
end
if size(im2, 3) == 3
    im2 = rgb2gray(im2);
end

im1 = im2double(im1);
im2 = im2double(im2);

[locs1, desc1] = briefLite(im1);
[locs2, desc2] = briefLite(im2);

matches = briefMatch(desc1, desc2);

plotMatches(im1, im2, matches, locs1, locs2);