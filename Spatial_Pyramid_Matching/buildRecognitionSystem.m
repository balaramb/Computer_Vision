function buildRecognitionSystem()
% Creates vision.mat. Generates training features for all of the training images.

	load('dictionary.mat');									%dictionary loaded
	load('../data/traintest.mat');
	
	% TODO create train_features
	layerNum = 3;
	train_features = [];
	dictionarySize = size(dictionary,2);
	for i = 1:size(train_imagenames,1)
		%disp(i);
		currImageName = strcat('../data/',train_imagenames{i});
		currImageWordmap = strrep(currImageName,'.jpg','.mat');
		load(currImageWordmap);
		hist = getImageFeaturesSPM(layerNum,wordMap,dictionarySize);
		train_features = [train_features, hist];
	end
	
	filterBank = createFilterBank();						%filterBank loaded
	train_labels = train_labels';							%size 1 x 1440
	save('vision.mat', 'filterBank', 'dictionary', 'train_features', 'train_labels');
end