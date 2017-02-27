function img = ReadRawImage_PS2(filename, row, col)
% Read a RAW DATA format image 
% The raw image data is written as a series of signed short integers in row first order.

%INPUT = filename, Image Rows, Image Columns
%OUTPUT : I = 16 bit Grey Image


img=multibandread(filename,[row col 1],'*uint16',0,'bip','ieee-le');

% img1 = bitand(img, 255);
% I = bitsra(img, 8);  % commented in 1/11/2016

% figure
% imshow(I, []);

end % end of function