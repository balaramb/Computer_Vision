function [dp_x,dp_y] = LucasKanade(It, It1, rect)
	It = im2double(It);
	It1 = im2double(It1);
	
	top_left_x = rect(1);
	top_left_y = rect(2);
	bottom_right_x = rect(3);
	bottom_right_y = rect(4);
	
	p = [0,0]';	%shift in x and y directions
	
	delta_p = [100,100]';
	tol = 0.1;
	
	%Evaluate Jacobian; constant in this case
	Jacobian = [1 0; 0 1];
	
	% find Template
	[x1,y1] = meshgrid(round(top_left_x,4):round(bottom_right_x,4), round(top_left_y,4):round(bottom_right_y,4));
	Template = interp2(It,x1,y1);

	%find gradient of 2nd frame
	[grad_x,grad_y] = gradient(It1);
	
	while norm(delta_p)>tol
		%Warp I with W(x; p) to compute I(W(x; p))
		[x, y] = meshgrid(round(top_left_x+p(1),4):round(bottom_right_x+p(1),4), round(top_left_y+p(2),4):round(bottom_right_y+p(2),4));
		Warped_I = interp2(It1, x, y);
		
		%if size(Template,1) ~= size(Warped_I,1) | size(Template,2) ~= size(Warped_I,2)
		%	delta = size(Template) - size(Warped_I);
		%	[x, y] = meshgrid(top_left_x+p(1):bottom_right_x+p(1)+delta(2), top_left_y+p(2):bottom_right_y+p(2)+delta(1));
		%	Warped_I = interp2(It1, x, y);
		%end

		%Compute error image T(x) - I(W(x;p))
		Error_I = Template - Warped_I;
		
		%Warp grad(I) with W(x; p) ... Calling a part of the gradient
		grad_x1 = interp2(grad_x,x,y);
		grad_y1 = interp2(grad_y,x,y);
		
		%Compute steepest descent images
		steep_grad_desc = [grad_x1(:),grad_y1(:)]*Jacobian;
		
		%Compute Hessian
		Hessian = steep_grad_desc' * steep_grad_desc;
		
		%Compute b
		b = steep_grad_desc'*Error_I(:);
		
		%Compute delta_p
		delta_p = Hessian\b;
		
		%Update p
		p = p+delta_p;
	end
	dp_x = p(1);
	dp_y = p(2);
end