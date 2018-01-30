function [h] = getImageFeaturesSPM(layerNum, wordMap, dictionarySize)
% Compute histogram of visual words using SPM method
% Inputs:
%   layerNum: Number of layers (L+1)
%   wordMap: WordMap matrix of size (h, w)
%   dictionarySize: the number of visual words, dictionary size
% Output:
%   h: histogram of visual words of size {dictionarySize * (4^layerNum - 1)/3} (l1-normalized, ie. sum(h(:)) == 1)

    % TODO Implement your code here
	divisionsInOneDimension = [];
	weights = [];
	L = layerNum - 1;
	for layerId = 0:L
		divisionsInOneDimension = [divisionsInOneDimension; 2^(layerId)];
		if layerId == 0 || layerId == 1
			temp_weight = 2^(L*(-1));
		else
			temp_weight = 2^(layerId-L-1);
		end
		weights = [weights;temp_weight];
	end
	[m,n] = size(wordMap);

	h = [];
	for j = 1:size(divisionsInOneDimension,1)
		divisionsInOneDimension_curr = divisionsInOneDimension(j);
		weight_curr = weights(j);
		
		hist_cell = [];
		row_vals = floor(linspace(0,m,divisionsInOneDimension_curr+1));
		col_vals = floor(linspace(0,n,divisionsInOneDimension_curr+1));

		for i = 1:divisionsInOneDimension_curr
			for k = 1:divisionsInOneDimension_curr
				row1 = row_vals(i)+1;
				row2 = row_vals(i+1);
				col1 = col_vals(k)+1;
				col2 = col_vals(k+1);
				currentImage = wordMap(row1:row2,col1:col2);
				curr_hist = getImageFeatures(currentImage, dictionarySize);
				hist_cell = cat(1, hist_cell, curr_hist.*weight_curr);
			end
		end
		h = cat(1, h, hist_cell);
	end
	h = h./sum(h(:));
end