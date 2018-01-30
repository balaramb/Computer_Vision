function [ x2, y2 ] = epipolarCorrespondence( im1, im2, F, x1, y1 )
% epipolarCorrespondence:
%       im1 - Image 1
%       im2 - Image 2
%       F - Fundamental Matrix between im1 and im2
%       x1 - x coord in image 1
%       y1 - y coord in image 1

% Q4.1:
%           Implement a method to compute (x2,y2) given (x1,y1)
%           Use F to only scan along the epipolar line
%           Experiment with different window sizes or weighting schemes
%           Save F, pts1, and pts2 used to generate view to q4_1.mat
%
%           Explain your methods and optimization in your writeup
	
	%im1 = im2double(imread('../data/im1.png'));
	%im2 = im2double(imread('../data/im2.png'));

	%load('../data/some_corresp.mat');
	%M = 640;
	%F = eightpoint( pts1, pts2, M );
	
	%x1 = 241;
	%y1 = 158;
	%x2 = 240;
	%y2 = 155;
	
	%Find temp
	temp = F*[x1; y1; 1];				%3x3 * 3x1 gives 3x1
	%temp = temp/norm(temp);
	
	%temp1*u + temp2*v + temp3 = 0 is the equation of the line
	temp1 = temp(1,:);
	temp2 = temp(2,:);
	temp3 = temp(3,:);
	
	m = size(im1,1);
	n = size(im1,2);
	
	%Using a 5x5 patch and using Gaussian filter to prioritize the central pixel
	semi_patch_width = 2;
	im1_patch = double(im1(y1-semi_patch_width:y1+semi_patch_width,x1-semi_patch_width:x1+semi_patch_width));
	filt = fspecial('gaussian',[2*semi_patch_width + 1, 2*semi_patch_width + 1],1);

	%Span along x-direction and find corresponding y-coordinates within the frame
	a1 = 1+semi_patch_width:n-semi_patch_width;
	b1 = round((-temp1*a1 - temp3) / temp2);
	hold1 = b1 > semi_patch_width & b1 + semi_patch_width <= m;
	
	%Span along y-direction and find corresponding x-coordinates within the frame
	b2 = 1+semi_patch_width:m-semi_patch_width;
	a2 = round((-temp2*b2 - temp3) / temp1);
	hold2 = a2 > semi_patch_width & a2 + semi_patch_width <= n;

	%Whichever direction leaves more pairs, pick it
	if size(find(hold1)) >= size(find((hold2)))
		a = a1;
		b = b1;
		hold = hold1;
	else
		a = a2;
		b = b2;
		hold = hold2;
	end
	hold = find(hold);

	curr_best_eucl_error = 100000;
	for i = hold
		x2_temp = a(i);
		y2_temp = b(i);
		% Look for the correspondence only within 15*15
		if (x1-x2_temp)^2 + (y1-y2_temp)^2 < 15*15
			% Calculate the patch on the second image
			im2_patch = double(im2((y2_temp-semi_patch_width):(y2_temp+semi_patch_width),(x2_temp-semi_patch_width):(x2_temp+semi_patch_width)));
			
			% Find weighted error
			error = (abs(im1_patch - im2_patch)) .* filt;
			error = sum(error(:));
			
			% Update best matches
			if error < curr_best_eucl_error
				curr_best_eucl_error = error;
				hold_u = x2_temp;
				hold_v = y2_temp;
			end
		end
	end
	x2 = hold_u;
	y2 = hold_v;
end

%[coordsIM1, coordsIM2] = epipolarMatchGUI(im1, im2, F);
%pts1 = coordsIM1;
%pts2 = coordsIM2;
%save('q2_6.mat', 'F', 'pts1', 'pts2');
%save('q4_1.mat', 'F', 'pts1', 'pts2');