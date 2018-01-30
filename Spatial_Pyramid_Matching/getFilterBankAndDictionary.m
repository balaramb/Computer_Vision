function [filterBank, dictionary] = getFilterBankAndDictionary(imPaths)
% Creates the filterBank and dictionary of visual words by clustering using kmeans.

% Inputs:
%   imPaths: Cell array of strings containing the full path to an image (or relative path wrt the working directory.
% Outputs:
%   filterBank: N filters created using createFilterBank()
%   dictionary: a dictionary of visual words from the filter responses using k-means.

    filterBank  = createFilterBank();
	
	alpha = 200;
	K = 300;
    
	% TODO Implement your code here
	filter_responses = [];
	for i=1:length(imPaths)
		currentPic = imread(imPaths{i});
		%disp(i);
		pixelNumber = size(currentPic,1)*size(currentPic,2);
		CurrentPicFilterResponse = extractFilterResponses(currentPic, filterBank);
		
		alphaPixels = randperm(pixelNumber,alpha);		% single row
		[index1, index2] = ind2sub([size(currentPic,1),size(currentPic,2)],alphaPixels);
		for p=1:alpha
			temp1 = CurrentPicFilterResponse(index1(p),index2(p),1:60);
			temp1 = permute(temp1,[1 3 2]);
			filter_responses = [filter_responses;temp1];
		end
	end
	
	[~, dictionary] = kmeans(filter_responses, K, 'EmptyAction', 'drop');
	dictionary = dictionary';

end