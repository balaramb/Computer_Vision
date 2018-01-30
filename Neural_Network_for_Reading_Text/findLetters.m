function [lines, bw] = findLetters(im)
% [lines, BW] = findLetters(im) processes the input RGB image and returns a cell
% array 'lines' of located characters in the image, as well as a binary
% representation of the input image. The cell array 'lines' should contain one
% matrix entry for each line of text that appears in the image. Each matrix entry
% should have size Lx4, where L represents the number of letters in that line.
% Each row of the matrix should contain 4 numbers [x1, y1, x2, y2] representing
% the top-left and bottom-right position of each box. The boxes in one line should
% be sorted by x1 value.

%Your code here
if size(im,3) == 3
	im = im(:,:,2);
end

% used to decide thresholding range
%[pixelCount grayLevels] = imhist(im);
%bar(pixelCount);
%grid on;
%title('Histogram of original image');
%xlim([0 grayLevels(end)]);

% thresholding
binaryImage = im < 100;
%imshow(binaryImage);

% connect blobs and remove small ones
binaryImage = imdilate(binaryImage, true(9));
binaryImage = bwareaopen(binaryImage,300);
%imshow(binaryImage);
bw = ~binaryImage;

% find bounding boxes
labeledImage = bwconncomp(binaryImage,8);
measurements = regionprops(labeledImage,'BoundingBox','Area','Centroid');

% stack up bounding boxes
temp = [];
for letter = 1:length(measurements)
	bb = measurements(letter).BoundingBox;
	bco = measurements(letter).Centroid;
	temp = [temp; [bb(1)-1, bb(2)-1, bb(3)+1, bb(4)+1]];
end

%sort according to top-left y-coordinates
temp = sortrows(temp,2);

% if y-range of 2 characters has an intersection, they lie on same line
curr_line_num = 1;
lines = {};
line_alloc = [1];
curr_line_y_range = round(temp(1,2)):round(temp(1,2)+temp(1,4));

for i = 2:length(measurements)
	curr_char_bb = temp(i,:);
	curr_char_y_range = round(temp(i,2)):round(temp(i,2)+temp(i,4));
	if length(intersect(curr_line_y_range,curr_char_y_range))>0
		line_alloc(i) = curr_line_num;
	else
		curr_line_num = curr_line_num +1;
		line_alloc(i) = curr_line_num;
		curr_line_y_range = curr_char_y_range;
	end
end

% find indices where line numbers change
line_change_indices = find(line_alloc(2:end) - line_alloc(1:end-1));
line_change_indices = [line_change_indices,length(measurements)];
num_lines = length(line_change_indices);
low = 1;
for i = 1:num_lines
	high = line_change_indices(i);
	lines{i} = sortrows(temp(low:high,:),1);	%sort each line wrt x-coordinate
	low = high+1;
end

imshow(im);
hold on;
for i=1:length(lines)
	for j = 1:length(lines{i})
		curr_line = lines{i};
		curr_bb = curr_line(j,:);
		rectangle('Position',curr_bb,'EdgeColor','r','LineWidth',2);
	end
end
hold off

%change lines to [top-left x, top-left y, bottom-right x, bottom-right y]
for i =1:length(lines)
	temp = lines{i};
	temp = [temp(:,1), temp(:,2), temp(:,1)+temp(:,3), temp(:,2)+temp(:,4)];
	lines{i} = temp;
end

%%%%%%%%%%%%%%OLD WAY OF DOING THIS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%temp = sortrows(temp,2);
%temp_1 = temp(1:end-1,:);
%temp_2 = temp(2:end,:);
%temp_3 = temp_2-temp_1;

%min_values = min(temp);
%min_height = min_values(4);
%max_values = max(temp);
%max_height = max_values(4);

%lines = {};
%line_change_indices = find(temp_3(:,2)>max_height-100);
%line_change_indices = [line_change_indices;length(measurements)];
%num_lines = length(line_change_indices);
%low = 1;
%for i = 1:num_lines
%	high = line_change_indices(i);
%	lines{i} = sortrows(temp(low:high,:),1);
%	low = high+1;
%end
%%%%%%%%%%%%%%OLD WAY OF DOING THIS%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

assert(size(lines{1},2) == 4,'each matrix entry should have size Lx4');
assert(size(lines{end},2) == 4,'each matrix entry should have size Lx4');
lineSortcheck = lines{1};
assert(issorted(lineSortcheck(:,1)) | issorted(lineSortcheck(end:-1:1,1)),'Matrix should be sorted in x1');

end