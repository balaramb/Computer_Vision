function [dp_x,dp_y] = LucasKanadeBasis(It, It1, rect, bases)
	It = im2double(It);
	It1 = im2double(It1);
	
	top_left_x = rect(1);
	top_left_y = rect(2);
	bottom_right_x = rect(3);
	bottom_right_y = rect(4);
	
	m_bases = size(bases,1);
	n_bases = size(bases,2);
	p_bases = size(bases,3);

	bases_reshaped = reshape(bases,m_bases*n_bases,p_bases);
	
	p = [0,0]';	%shift in x and y directions
	
	%first_rect = [60, 117, 146, 152]';
	x_gap = rect(3)-rect(1);	%87
	y_gap = rect(4)-rect(2);	%36
	
	delta_p = [100,100]';
	tol = 0.001;
	
	%Evaluate Jacobian; constant in this case
	Jacobian = [1 0; 0 1];
	
	% find Template
	[x1,y1] = meshgrid(round(top_left_x,4):round(bottom_right_x,4), round(top_left_y,4):round(bottom_right_y,4));
	Template = interp2(It,x1,y1);

	%find gradient of 2nd frame
	[grad_x,grad_y] = gradient(It1);
	
	while norm(delta_p)>tol
		%Warp I with W(x; p) to compute I(W(x; p))
		%[x, y] = meshgrid(round(top_left_x+p(1),4):round(bottom_right_x+p(1),4), round(top_left_y+p(2),4):round(bottom_right_y+p(2),4));
		x = x1+p(1);
		y = y1+p(2);
		Warped_I = interp2(It1, x, y);
				
		%Compute error image T(x) - I(W(x;p))
		Error_I = Template - Warped_I;
		
		%Warp grad(I) with W(x; p) ... Calling a part of the gradient
		grad_x1 = interp2(grad_x,x,y);
		grad_y1 = interp2(grad_y,x,y);
				
		%Compute steepest descent images
		steep_grad_desc = [grad_x1(:),grad_y1(:)]*Jacobian;
		
		total = zeros(size(steep_grad_desc));
		for i=1:size(bases_reshaped,2)
			total = total + (sum(bases_reshaped(:,i).*steep_grad_desc).*bases_reshaped(:,i));
		end
		steep_grad_desc = steep_grad_desc - total;
		
		%Compute Hessian
		Hessian = steep_grad_desc' * steep_grad_desc;
		
		%Compute b
		b = steep_grad_desc'*Error_I(:);
		
		%Compute delta_p
		delta_p = Hessian\b;
		
		%Update p
		p = p+delta_p;
		%disp(delta_p);
	end
	dp_x = p(1);
	dp_y = p(2);
end