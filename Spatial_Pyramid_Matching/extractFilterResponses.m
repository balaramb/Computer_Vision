function [filterResponses] = extractFilterResponses(img, filterBank)
% Extract filter responses for the given image.
% Inputs: 
%   img:                a 3-channel RGB image with width W and height H
%   filterBank:         a cell array of N filters
% Outputs:
%   filterResponses:    a W x H x N*3 matrix of filter responses


% TODO Implement your code here
%pic = im2double(imread(img));
pic = im2double(img);

%CHECK FOR GRAY-SCALE IMAGE, MAY BE YOU SHUD REPMAT THE FINAL RESPONSE
if size(pic,3) == 1
	pic = repmat(pic,[1,1,3]);
end

[pic_L,pic_a,pic_b] = RGB2Lab(pic(:,:,1),pic(:,:,2),pic(:,:,3));

pic = cat(3,pic_L,pic_a,pic_b);
%pic = cat(3,pic,pic_b);

filterResponses = [];

for i = 1:size(filterBank)
	filterResponses = cat(3,filterResponses,imfilter(pic,filterBank{i},'replicate'));
end

%temp = reshape(filterResponses, [size(pic,1), size(pic,2), 3, 20]);
%montage(temp, 'size', [4 nan])

end