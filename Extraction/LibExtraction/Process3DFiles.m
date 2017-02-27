
function [pathstr2] = Process3DFiles(DirName)

name = GetRawSet(DirName);
k = 1;
         
if exist(name{k}, 'file')
    fullPath = name{k} ;
else
    fullPath = fullfile('data',[name{k} '.*\.(rawx|raw)$']);
end
% fprintf('Extracting Zip file from %s\n', fullPath);

[pathstr,FrameName,ext] = fileparts(name{k}); 

    movefile(name{k},[fullfile(pathstr, FrameName) '.zip' ]);    % to replace the rawx with zip 
%     copyfile(name{k},[fullfile(pathstr, FrameName) '.zip' ]);   % to keep both rawx and zip

try
    if exist(fullfile(pathstr, FrameName), 'file')
    fullPath = name{k} ;
    else
    unzip(fullfile(pathstr, FrameName), fullfile(pathstr, FrameName)); 
    end

    %% Uzip the sub-folder
    name2(k) = GetRawSet(fullfile(pathstr, FrameName));
%     fprintf('Extracting Zip file from %s\n', name2{k});

    [pathstr2,FrameName2,ext2] = fileparts(name2{k}); 

    copyfile(name2{k},[fullfile(pathstr2, FrameName2) '.zip' ]);

    unzip(fullfile(pathstr2, FrameName2), pathstr2); 
    
      
catch
    fprintf('Cannot Unzip: %s\n', fullPath);
end
  

end  %end of function