function [s] = sigmoid(x)
	s = 1.0./(exp(-x)+1.0);
end