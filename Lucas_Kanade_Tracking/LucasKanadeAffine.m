function M = LucasKanadeAffine(It, It1)

% input - image at time t, image at t+1 
% output - M affine transformation matrix

	It = im2double(It);
	It1 = im2double(It1);
	
	%initial guess for parameters
	p = [0,0,0,0,0,0]';
	
	top_left_x = 1;
	top_left_y = 1;
	bottom_right_x = size(It1,2);
	bottom_right_y = size(It1,1);
	
	delta_p = [100,100,100,100,100,100]';
	tol = 0.1;
	
	% find Template
	[x1,y1] = meshgrid(round(top_left_x,4):round(bottom_right_x,4), round(top_left_y,4):round(bottom_right_y,4));
	Template = It;
	
	[grad_x,grad_y] = gradient(It1);
	
	while norm(delta_p)>tol

		W = [1+p(1), p(3), p(5); p(2), 1+p(4), p(6)];
		%M = [1+p(1), p(3), p(5); p(2), 1+p(4), p(6); 0, 0, 1];
		
		%Warp I with W(x; p) to compute I(W(x; p))
		temp1 = [x1(:), y1(:), ones(size(x1(:),1),1)]*W';
		x = temp1(:,1);
		y = temp1(:,2);
		temp2 = interp2(It1, x, y);
		Warped_I = reshape(temp2,size(It1));
		%Warped_I = warpH(It, M, size(It1), NaN);
		
		%find that part of the image that didn't go out
		in_frame = ~isnan(Warped_I);
		%set the outgoing pixels to 0
		Warped_I(isnan(Warped_I)) = 0;
		
		%Compute error image T(x) - I(W(x;p))
		Error_I = Template - Warped_I;
		
		%find gradient of 2nd frame
		grad_x1 = interp2(grad_x, x', y');
		grad_x1(~in_frame) = 0;
		grad_y1 = interp2(grad_y, x', y');
		grad_y1(~in_frame) = 0;
		%grad_x1 = reshape(grad_x1,size(in_frame)).*in_frame;
		%grad_y1 = reshape(grad_y1,size(in_frame)).*in_frame;

		%Compute steepest descent images
		steep_grad_desc = [grad_x1(:) .* x1(:),		grad_y1(:) .* x1(:),	grad_x1(:) .* y1(:),	grad_y1(:) .* y1(:),	grad_x1(:),		grad_y1(:)];
		
		%Compute Hessian
		Hessian = steep_grad_desc' * steep_grad_desc;
		
		%Compute b
		b = steep_grad_desc'*Error_I(:);
		
		%Compute delta_p
		delta_p = Hessian\b;
		
		%Update p
		p = p+delta_p;
		
		%disp(norm(delta_p));
	end
	M = [1+p(1), p(3), p(5); p(2), 1+p(4), p(6); 0, 0, 1];
end