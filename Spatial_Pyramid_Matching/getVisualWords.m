function [wordMap] = getVisualWords(img, filterBank, dictionary)
% Compute visual words mapping for the given image using the dictionary of visual words.

% Inputs:
% 	img: Input RGB image of dimension (h, w, 3)
% 	filterBank: a cell array of N filters
% Output:
%   wordMap: WordMap matrix of same size as the input image (h, w)

    % TODO Implement your code here
	%wordMap = zeros(size(img,1),size(img,2));
	filterResponses = extractFilterResponses(img, filterBank);
	
	rearragedFilterResponses = permute(filterResponses,[1 3 2]);
	
	temp = [];
	for i = 1:size(rearragedFilterResponses,3)
		temp = [temp; rearragedFilterResponses(:,:,i)];
	end
	rearragedFilterResponses = temp;
	
	distance = pdist2(rearragedFilterResponses, dictionary');		% M*N x 60   and dictionary is 60 x 100
	
	[~,wordMap] = min(distance, [], 2);								% row-wise minimum's indices
	wordMap = reshape(wordMap,size(img,1),size(img,2));
end