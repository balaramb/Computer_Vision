function [panoImg] = imageStitching_noClip(img1, img2, H2to1)

	width = 2000;

	img1_bottom_left_coord = [1;size(img1,1);1];
	img1_bottom_right_coord = [size(img1,2);size(img1,1);1];
	img1_top_left_coord = [1;1;1];
	img1_top_right_coord = [size(img1,2);1;1];

	m = size(img2,1);
	n = size(img2,2);

	img2_bottom_left_coord = H2to1 * [1;m;1];
	img2_bottom_right_coord = H2to1 * [n;m;1];
	img2_top_left_coord = H2to1 * [1;1;1];
	img2_top_right_coord = H2to1 * [n;1;1];
	
	img2_bottom_left_coord = img2_bottom_left_coord./img2_bottom_left_coord(3);
	img2_bottom_right_coord = img2_bottom_right_coord./img2_bottom_right_coord(3);
	img2_top_left_coord = img2_top_left_coord./img2_top_left_coord(3);
	img2_top_right_coord = img2_top_right_coord./img2_top_right_coord(3);

	master_matrix = [img1_bottom_left_coord';img1_bottom_right_coord';img1_top_left_coord';img1_top_right_coord';img2_bottom_left_coord';img2_bottom_right_coord';img2_top_left_coord';img2_top_right_coord'];

	mxi = max(master_matrix);
	mni = min(master_matrix);

	outsize_temp = ceil(mxi-mni);	% [1734 827 0]
	%required_width = outsize_temp(1);
	height = ceil(width * outsize_temp(2)/outsize_temp(1));
	outsize = [height width];
	scale = width/outsize_temp(1);
	
	dx = 0;
	dy = ceil(-mni(2));
	M = [scale 0 0; 0 scale 0; 0 0 1]*[1 0 dx; 0 1 dy; 0 0 1];

	warp_im1 = warpH(img1, M, outsize);
	warp_im2 = warpH(img2, M*H2to1, outsize);
	
	mask1 = warp_im1(:,:,1)>0;
	mask2 = warp_im2(:,:,1)>0;
	
	final_mask = (mask1 == mask2);
	%final_mask = ones(size(final_mask)) - final_mask;
	
	%panoImg = im2double(warp_im1)./2+im2double(warp_im2)./2;
	panoImg = im2double(warp_im1)+im2double(warp_im2);
	panoImg = panoImg - panoImg.*(0.5*final_mask);
	%panoImg = panoImg + panoImg.*(2*final_mask);
	
	%imshow(panoImg);
	
end