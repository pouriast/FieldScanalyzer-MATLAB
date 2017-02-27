% function [I, col, row, BandIndx, Wavelength]  = ReadRawImg_HyperSpec(pathstr)
function [img, col, row]  = ReadRawImg_HyperSpec(pathstr)
% Read a RAW DATA format image 
% The raw image data is written as a series of signed short integers in row first order.


xml = xml2struct(fullfile(pathstr, 'info.xml'));
% col = str2double(xml.headwallOneBandMetaData.Attributes.sampleCount_dash_imgWidth);
% row = str2double(xml.headwallOneBandMetaData.Attributes.lineCount_dash_imgHeight);
% BandIndx = str2double(xml.headwallOneBandMetaData.Attributes.bandIndex);
% Wavelength = str2double(xml.headwallOneBandMetaData.Attributes.wavelength);

%%==== new part
col = str2double(xml.rawImage.width.Attributes.value);
row = str2double(xml.rawImage.height.Attributes.value);
filename = fullfile(pathstr, 'image.raw');
img = multibandread(filename,[row col 1],'*uint16',0,'bil','n');


% img  = imread(fullfile(pathstr, 'raw.png'));
% img = multibandread(filename,[row col 1],'*uint8',0,'bil','n');
% I = img(:,:,1);

end % end of function