function [W, b] = Train(W, b, train_data, train_label, learning_rate)
% [W, b] = Train(W, b, train_data, train_label, learning_rate) trains the network
% for one epoch on the input training data 'train_data' and 'train_label'. This
% function should returned the updated network parameters 'W' and 'b' after
% performing backprop on every data sample.
[D,N] = size(train_data);
[~,C] = size(train_label);
assert(size(W{1},2) == N, 'W{1} must be of size [~,N]');
assert(size(b{1},2) == 1, 'b{1} must be of size [~,1]');
assert(size(b{end},2) == 1, 'b{end} must be of size [~,1]');
assert(size(W{end},1) == C, 'W{end} must be of size [C,~]');

rearranged = randperm(D);
train_data = train_data(rearranged,:);
train_label = train_label(rearranged,:);

for i = 1:size(train_data,1)
	curr_X = train_data(i,:)';
	curr_label = train_label(i,:)';
	[output, act_h, act_a] = Forward(W, b, curr_X);
	[grad_W, grad_b] = Backward(W, b, curr_X, curr_label, act_h, act_a);
	%implementing SGD
	[W, b] = UpdateParameters(W, b, grad_W, grad_b, learning_rate);

	%if mod(i, 100) == 0
		%fprintf('\b\b\b\b\b\b\b\b\b\b\b\b\b')
	%	fprintf('Done %.2f %% \n', i/size(train_data,1)*100)
	%end
end
%fprintf('\b\b\b\b\b\b\b\b\b\b\b\b\b')
%[accuracy, loss] = ComputeAccuracyAndLoss(W, b, train_data, train_label);
%disp(loss);

end
