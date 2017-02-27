function Ifinal = ReadRawImage_Vis(filename, row, col)
% Read a RAW DATA format image 
% The raw image data is written as a series of signed short integers in row first order.

%INPUT = filename, Image Rows, Image Columns
%OUTPUT : Ifinal = row*col*3 (BayerGR8)

if uioctave
    % load image package in octave
    pkg load image
end

% read image raw file
%{
fin = fopen(filename,'r');
I=fread(fin, [col row],'*uint8');
J = SGRBGtoRGB(I);
Ifinal = flip(imagerotate(J, -180),3);
fclose(fin);
%}


%== Matlab File for image processing toolbox
img=multibandread(filename,[row col 1],'*uint8',0,'bil','n');
I = demosaic(img,'grbg');
Ifinal = imrotate(I,-90);


end % end of function