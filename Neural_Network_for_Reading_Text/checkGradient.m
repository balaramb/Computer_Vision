%LHS is actual Gradient value; RHS is obtained by Central Difference
%This program prints the difference between LHS and RHS which is of the order of e-12
% Your code here.
eps = 0.0001;
tol = 0.0001;
num_epoch = 30;
classes = 26;
layers = [32*32, 400, classes];
learning_rate = 0.01;

load('../data/nist26_train.mat', 'train_data', 'train_labels')
load('../data/nist26_test.mat', 'test_data', 'test_labels')
load('../data/nist26_valid.mat', 'valid_data', 'valid_labels')

[W, b] = InitializeNetwork(layers);

[D,N] = size(train_data);
[~,C] = size(train_labels);
rearranged = randperm(D);
train_data = train_data(rearranged,:);
train_labels = train_labels(rearranged,:);

%pick 5 linear indices of weights per hidden layer
check_W1 = randi([1,size(W{1},1)*size(W{1},2)],5,1);
check_W2 = randi([1,size(W{2},1)*size(W{2},2)],5,1);
%check_b1 = randi([1,size(b{1},1)*size(b{1},2)],20,1);
%check_b2 = randi([1,size(b{2},1)*size(b{2},2)],20,1);

%LHS is actual Gradient value; RHS is obtained by Central Difference
for i = 1:size(train_data,1)
	curr_X = train_data(i,:)';
	curr_label = train_labels(i,:)';
	[output, act_h, act_a] = Forward(W, b, curr_X);
	[grad_W, grad_b] = Backward(W, b, curr_X, curr_label, act_h, act_a);
	
	for j = 1:5
		%checking for 5 weights from first set of weights
		LHS = grad_W{1}(check_W1(j));
		W_pos = W;
		W_pos{1}(check_W1(j)) = W{1}(check_W1(j)) + eps;
		[~, loss_pos] = ComputeAccuracyAndLoss(W_pos, b, curr_X', curr_label');
		W_neg = W;
		W_neg{1}(check_W1(j)) = W{1}(check_W1(j)) - eps;
		[~, loss_neg] = ComputeAccuracyAndLoss(W_neg, b, curr_X', curr_label');
		RHS = (loss_pos - loss_neg)/(2*eps);
		
		disp(abs(LHS-RHS))
		
		%if abs(LHS-RHS) < tol
		%	disp('looks ok');
		%end
		
		%checking for 5 weights from second set of weights
		LHS = grad_W{2}(check_W2(j));
		W_pos = W;
		W_pos{2}(check_W2(j)) = W{2}(check_W2(j)) + eps;
		[~, loss_pos] = ComputeAccuracyAndLoss(W_pos, b, curr_X', curr_label');
		W_neg = W;
		W_neg{2}(check_W2(j)) = W{2}(check_W2(j)) - eps;
		[~, loss_neg] = ComputeAccuracyAndLoss(W_neg, b, curr_X', curr_label');
		RHS = (loss_pos - loss_neg)/(2*eps);
		
		disp(abs(LHS-RHS))
		
		%if abs(LHS-RHS) < tol
		%	disp('looks ok');
		%end
		
		%LHS = grad_b{1}(check_b1(j));
		%b_pos = b;
		%b_pos{1}(check_b1(j)) = b{1}(check_b1(j)) + eps;
		%[~, loss_pos] = ComputeAccuracyAndLoss(W, b_pos, curr_X', curr_label');
		%b_neg = b;
		%b_neg{1}(check_b1(j)) = b{1}(check_b1(j)) - eps;
		%[~, loss_neg] = ComputeAccuracyAndLoss(W, b_neg, curr_X', curr_label');
		%RHS = (loss_pos - loss_neg)/(2*eps);
		%
		%if abs(LHS-RHS) < tol
		%	disp('looks ok');
		%end
		%
		%LHS = grad_b{2}(check_b2(j));
		%b_pos = b;
		%b_pos{2}(check_b2(j)) = b{2}(check_b2(j)) + eps;
		%[~, loss_pos] = ComputeAccuracyAndLoss(W, b_pos, curr_X', curr_label');
		%b_neg = b;
		%b_neg{2}(check_b2(j)) = b{2}(check_b2(j)) - eps;
		%[~, loss_neg] = ComputeAccuracyAndLoss(W, b_neg, curr_X', curr_label');
		%RHS = (loss_pos - loss_neg)/(2*eps);
		%
		%if abs(LHS-RHS) < tol
		%	disp('looks ok');
		%end
	end

	%implementing SGD
	[W, b] = UpdateParameters(W, b, grad_W, grad_b, learning_rate);
	
end