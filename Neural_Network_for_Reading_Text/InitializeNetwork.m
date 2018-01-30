function [W, b] = InitializeNetwork(layers)
% InitializeNetwork([INPUT, HIDDEN, OUTPUT]) initializes the weights and biases
% for a fully connected neural network with input data size INPUT, output data
% size OUTPUT, and HIDDEN number of hidden units.
% It should return the cell arrays 'W' and 'b' which contain the randomly
% initialized weights and biases for this neural network.

% Your code here
%layers = [1024,400,26];
N = layers(1);
numHidden = length(layers)-2;

W = cell(numHidden+1, 1);
b = cell(numHidden+1, 1);

curr_layer_len = N;
for i = 1:numHidden+1
	next_layer_len = layers(i+1);
	W{i} = -0.1 + (0.2).*rand(next_layer_len,curr_layer_len);
	b{i} = zeros(next_layer_len,1);
	curr_layer_len = next_layer_len;
end

C = size(b{end},1);
assert(size(W{1},2) == N, 'W{1} must be of size [H,N]');
assert(size(b{end},2) == 1, 'b{end} must be of size [H,1]');
assert(size(W{end},1) == C, 'W{end} must be of size [C,H]');

end
