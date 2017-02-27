
function [PS2, pathstr2] = ProcessPS2Files(DirName)

name = GetRawSet(DirName);
totalSize = size(name,2);

for k = 1:totalSize
           
if exist(name{k}, 'file')
    fullPath = name{k} ;
else
    fullPath = fullfile('data',[name{k} '.*\.(rawx|raw)$']);
end
% fprintf('Extracting Zip file from %s\n', fullPath);

[pathstr,FileName,ext] = fileparts(name{k});
fprintf('Extracting Zip file from %s\n', name{k});

    movefile(name{k},[fullfile(pathstr, FileName) '.zip' ]);   % to replace the rawx with zip 
%     copyfile(name{k},[fullfile(pathstr, FileName) '.zip' ]);   % to keep both rawx and zip

    if exist(fullfile(pathstr, FileName), 'file')
%     fullPath = name{k} ;
    else
    unzip(fullfile(pathstr, FileName), fullfile(pathstr, FileName)); 
    end
    
    pathstr2 = fullfile(pathstr, FileName);
    
    xml = xml2struct(fullfile(pathstr2, 'info.xml'));
    cols = str2double(xml.rawImage.width.Attributes.value);
    rows = str2double(xml.rawImage.height.Attributes.value);

    
   Img_PS2 = ReadRawImage_PS2(fullfile(pathstr2, 'image.raw'), rows, cols);
   
   Image_PS2{k,1} = Img_PS2;
   Image_PS2{k,2} = FileName;
end  % k = 1:totalSize

%%=== sort the dataset based on filename
[cs,index] = sort_nat(Image_PS2(:,2));
% PS2 = Image_PS2(index,1);

for i = 1:size(index,1)
    PS2(:,:,i) = Image_PS2{index(i),1};
end

end  %end of function