function ImgFlir = ReadRawImage_Flir(filename, row, col)
% Read a RAW DATA format image 
% The raw image data is written as a series of signed short integers in row first order.

%INPUT = filename, Image Rows, Image Columns
%OUTPUT : I = 16 bit Grey Image

%{
fin = fopen(filename,'r');
[I, count]=fread(fin,[row col],'*uint16', 'l');
% imagesc(I);
% % colormap(flipud(jet(256)));
% colormap('hot');
fclose(fin);
%}

img=multibandread(filename,[col row 1],'int16',0,'bip','n');
% img1 = bitand(img, 255);
% img1 = bitsra(img, 8);
% I = flipdim(imrotate(img1, -90),2);
ImgFlir = flipdim(img,1);

% imshow(img1, []);
% cmap = colormap('jet');

end % end of function