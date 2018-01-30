function [s] = softmax(x)
	s = exp(x)./sum(exp(x));
end