function [conf] = evaluateRecognitionSystem()
% Evaluates the recognition system for all test-images and returns the confusion matrix

	load('vision.mat');
	load('../data/traintest.mat');

	% TODO Implement your code here
	C = zeros(size(mapping,2),size(mapping,2));
	for i = 1:size(test_imagenames,1)
		%disp(i);
		currImageName = strcat('../data/',test_imagenames{i});
		currImageNameSplit = strsplit(currImageName,'/');
		currImageType = currImageNameSplit(end-1);
		
		myGuess = guessImage(currImageName);
		index1 = find(ismember(mapping,currImageType));
		index2 = find(ismember(mapping,myGuess));
		
		C(index1,index2) = C(index1,index2)+1;
	end
	%disp('Confusion matrix: ');
	%disp(C);
	conf = C;
	accuracy = (trace(C)./sum(C(:)))*100;
	%disp('Accuracy is: ');
	%disp(accuracy*100);
end