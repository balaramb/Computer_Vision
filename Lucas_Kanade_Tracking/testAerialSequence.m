% your code here
load('../data/aerialseq.mat');

n=0;
for i = 1 : size(frames, 3)-1
	%call the images
	%disp(i);
	image1 = frames(:, :, i);
	image2 = frames(:, :, i+1);

	%subtract dominant motion
	mask = SubtractDominantMotion(image1, image2);

	%fuse images for display
	temp = zeros(size(image1,1), size(image1,2), 3);
	%temp(:,:,2) = mask;
	temp(:,:,1) = mask;
	%temp(:,:,3) = mask;
	combine = imfuse(image2, temp, 'blend','Scaling','joint');
	
	%imshow(combine);
	
	if i==30 | i==60 | i==90 | i==120
		n=n+1;
		subplot(1,4,n);
		imshow(combine);
		name = strcat("Frame ",string(i));
		title(name);
	end
end