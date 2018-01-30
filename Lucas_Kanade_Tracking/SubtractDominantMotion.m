function mask = SubtractDominantMotion(image1, image2)

% input - image1 and image2 form the input image pair
% output - mask is a binary image of the same size
	%image1 = im2double(image1);
	%image2 = im2double(image2);
	
	%Find M and subsequently W
	M = LucasKanadeAffine(image1, image2);
	W = M(1:2,:);
	
	top_left_x = 1;
	top_left_y = 1;
	bottom_right_x = size(image1,2);
	bottom_right_y = size(image1,1);
	
	[x1,y1] = meshgrid(round(top_left_x,4):round(bottom_right_x,4), round(top_left_y,4):round(bottom_right_y,4));
	
	%Warp It into It+1
	%temp1 = [x1(:), y1(:), ones(size(x1(:),1),1)]*W';
	%x = temp1(:,1);
	%y = temp1(:,2);
	%temp2 = interp2(image1, x, y);
	%Warped_image1 = reshape(temp2,size(image1));
	Warped_image1 = warpH(image1, M, size(image2), NaN);
	
	%Make out-of-frame numbers 0
	in_frame = ~isnan(Warped_image1);
	Warped_image1(isnan(Warped_image1)) = 0;
	
	%Find error image
	mask = abs(image2 - Warped_image1)>20;
	
	%Error_I may show high values at out-of-frame pixels that were set to 0
	mask(~in_frame) = 0;
	%mask = medfilt2(mask);
	
	%SE = strel('disk', 9);
	%mask = imdilate(mask, SE);
	%mask = imerode(mask, SE);
    %
    %
	SE = strel('line',2,90);
	mask = imerode(mask, SE);
	%
	SE = strel('disk', 7);
	mask = imdilate(mask, SE);	
	mask = mask - bwareaopen(mask, 1300);	%fix this.. don't change
	%SE = strel('line', 3, 180);
	%mask = imerode(mask, SE);

end