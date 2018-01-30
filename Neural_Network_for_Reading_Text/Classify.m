function [outputs] = Classify(W, b, data)
% [predictions] = Classify(W, b, data) should accept the network parameters 'W'
% and 'b' as well as an DxN matrix of data sample, where D is the number of
% data samples, and N is the dimensionality of the input data. This function
% should return a vector of size DxC of network softmax output probabilities.
[D,N] = size(data);
C = size(b{end},1);
assert(size(W{1},2) == N, 'W{1} must be of size [H,N]');
assert(size(b{1},2) == 1, 'W{end} must be of size [H,1]');
assert(size(W{end},1) == C, 'W{end} must be of size [C,H]');

outputs = zeros(D,C);
% Your code here
for i = 1:D
	X = data(i, :)';
	[output, act_h, act_a] = Forward(W, b, X);
	outputs(i,:) = output';
end

assert(all(size(outputs) == [D,C]), 'output must be of size [D,C]');
end
