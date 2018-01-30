% Your code here.
im = imread('../images/01_list.jpg');
[lines, bw] = findLetters(im);
pause(3);

im = imread('../images/02_letters.jpg');
[lines, bw] = findLetters(im);
pause(3);

im = imread('../images/03_haiku.jpg');
[lines, bw] = findLetters(im);
pause(3);

im = imread('../images/04_deep.jpg');
[lines, bw] = findLetters(im);
pause(3);