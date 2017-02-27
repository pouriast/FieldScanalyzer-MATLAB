
function [totalSize, name] = ZipRowxFiles(DirName)

name = GetImageSet(DirName);
totalSize = size(name,2);
for k = 1:totalSize
             
if exist(name{k}, 'file')
fullPath = name{k} ;
else
    fullPath = fullfile('data','images',[name{k} '.rawx']);
end
fprintf('Extracting Zip file from %s\n', fullPath);

[pathstr,FileName,ext] = fileparts(name{k}); 
     
number = sscanf(name{k},'%f.zip',1);   
cd(DirName);
movefile(name{k},[FileName num2str(number) '.zip' ]);   

end

end  %end of function