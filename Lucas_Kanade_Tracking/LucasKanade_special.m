function [dp_x,dp_y] = LucasKanade_special(It, It1, rect, curr_rect)
	It = im2double(It);
	It1 = im2double(It1);
	
	p = [0,0]';	%shift in x and y directions
	
	delta_p = [100,100]';
	tol = 1;
	
	%first_rect = [60, 117, 146, 152]';
	x_gap = rect(3)-rect(1);	%87
	y_gap = rect(4)-rect(2);	%36
	
	%Take the template from rect
	[x1,y1] = meshgrid(rect(1):rect(1)+x_gap, rect(2):rect(2)+y_gap);
	Template = interp2(It,x1,y1,'nearest');
	
	Jacobian = [1 0; 0 1];
	[grad_x,grad_y] = gradient(It1);
	
	while norm(delta_p)>tol
		%Take the Warped_I from curr_rect
		[x, y] = meshgrid(curr_rect(1)+p(1):curr_rect(1)+p(1)+x_gap, curr_rect(2)+p(2):curr_rect(2)+p(2)+y_gap);
		Warped_I = interp2(It1, x, y,'nearest');
		
		Error_I = Template - Warped_I;
		grad_x1 = interp2(grad_x,x,y,'nearest');
		grad_y1 = interp2(grad_y,x,y,'nearest');

		steep_grad_desc = ([grad_x1(:),grad_y1(:)]*Jacobian);
		Hessian = steep_grad_desc' * steep_grad_desc;
		hold = steep_grad_desc'*Error_I(:);
		delta_p = Hessian\hold;
		p = p+delta_p;
		%disp(delta_p);
	end
	dp_x = p(1);
	dp_y = p(2);
end