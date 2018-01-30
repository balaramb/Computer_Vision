function [text] = extractImageText(fname)
% [text] = extractImageText(fname) loads the image specified by the path 'fname'
% and returns the next contained in the image as a string.
im = imread(fname);

[lines, bw] = findLetters(im);
for i =1:length(lines)
	temp = lines{i};
	temp = [temp(:,1), temp(:,2), temp(:,3)-temp(:,1), temp(:,4)-temp(:,2)];
	lines{i} = temp;
end

load('nist36_model_1.mat');

% bring together all data
data = [];
for i=1:length(lines)
	for j = 1:length(lines{i})
		curr_bb = lines{i}(j,:);
		curr_char = bw(round(curr_bb(2)):round(curr_bb(2)+curr_bb(4)), round(curr_bb(1)):round(curr_bb(1)+curr_bb(3)));
		not_curr_char = ~curr_char;
		not_curr_char = imclearborder(not_curr_char);
		curr_char = ~not_curr_char;

		[dim1,dim2] = size(curr_char);
		curr_char = [ones(dim1,30) curr_char ones(dim1,30)];
		[dim1,dim2] = size(curr_char);
		curr_char = [ones(30,dim2); curr_char; ones(30,dim2)];

		%[dim1,dim2] = size(curr_char);
		%if dim1>dim2
		%	diff = round((dim1 - dim2)/2);
		%	curr_char = [ones(dim1,diff) curr_char ones(dim1,diff)];
		%elseif dim2>dim1
		%	diff = round((dim2 - dim1)/2);
		%	curr_char = [ones(diff,dim2); curr_char; ones(diff,dim2)];
		%end
		curr_char = imresize(curr_char,[32 32]);
		data = [data;curr_char(:)'];
	end
end

% classify data
[outputs] = Classify(W, b, data);
prediction = '';
letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
for i = 1:size(data,1)
	curr_output = outputs(i,:);
	[~,predict] = max(curr_output);
	prediction = strcat(prediction,letters(predict));
end

% find gaps between letters
gaps = {};
is_end = {};
maxima = [];
minima = [];
for i=1:length(lines)
	curr_line = lines{i};
	x_coord_top_left = curr_line(:,1);
	x_coord_top_right = curr_line(:,1)+curr_line(:,3);
	gaps{i} = x_coord_top_left(2:end) - x_coord_top_right(1:end-1);
	maxima = [maxima; max(gaps{i})];
	minima = [minima; min(gaps{i})];
end

min_of_max = min(maxima);
max_of_min = max(minima);

for i=1:length(lines)
	is_end{i} = gaps{i} > (min_of_max - max_of_min+10);
end

% incorporate spacing and get predicted lines
spacey = ' ';
predicted_lines = {};
low = 1;
for i = 1:length(lines)
	high = low+length(lines{i})-1;
	predicted_lines{i} = prediction(low:high);
	temp = '';
	for j = 1:length(predicted_lines{i})-1
		if is_end{i}(j) == 1
			temp = [temp predicted_lines{i}(j) spacey];
		else
			temp = [temp predicted_lines{i}(j)];
		end
	end
	temp = [temp predicted_lines{i}(end)];
	predicted_lines{i} = temp;
	low = high+1;
end

% place everything in text
text = predicted_lines{1};
for i=2:length(predicted_lines)
	text = [text newline predicted_lines{i}];
end

end