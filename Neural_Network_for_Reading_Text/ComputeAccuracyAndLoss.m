function [accuracy, loss] = ComputeAccuracyAndLoss(W, b, data, labels)
% [accuracy, loss] = ComputeAccuracyAndLoss(W, b, X, Y) computes the networks
% classification accuracy and cross entropy loss with respect to the data samples
% and ground truth labels provided in 'data' and labels'. The function should return
% the overall accuracy and the average cross-entropy loss.
[D,N] = size(data);
[~,C] = size(labels);
assert(size(W{1},2) == N, 'W{1} must be of size [~,N]');
assert(size(b{1},2) == 1, 'b{1} must be of size [~,1]');
assert(size(b{end},2) == 1, 'b{end} must be of size [~,1]');
assert(size(W{end},1) == C, 'W{end} must be of size [C,~]');

%Your code here
loss = 0;
right = 0;
[outputs] = Classify(W, b, data);

for i = 1:D
	curr_output = outputs(i, :)';
	[value, index1] = max(curr_output);
	curr_label = labels(i, :)';
	index2 = find(curr_label);
	
	if index1 == index2
		right = right + 1;
	end

	curr_loss = -log(curr_output' * curr_label);
	loss = loss + curr_loss;
end

accuracy = right/D;
%averaged over number of training examples
loss = loss/D;
end