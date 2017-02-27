
function [Dataset_sort] = ProcessHyperSpecFiles(DirName, PlotID, sensorID)

name = GetRawSet(DirName);
totalSize = size(name,2);
cnt = 1;
for k = 1:totalSize
           
if exist(name{k}, 'file')
    fullPath = name{k} ;
else
    fullPath = fullfile('data',[name{k} '.*\.(rawx|raw)$']);
end

[pathstr,FrameName,ext] = fileparts(name{k}); 
     
    if ~(strcmp(FrameName,'0_0_0') || strcmp(FrameName,'1_0_0'))

    movefile(name{k},[fullfile(pathstr, FrameName) '.zip' ]);    % to replace the rawx with zip 
%     copyfile(name{k},[fullfile(pathstr, FrameName) '.zip' ]);   % to keep both rawx and zip

    if exist(fullfile(pathstr, FrameName), 'file')
%     fullPath = name{k} ;
    else
    unzip(fullfile(pathstr, FrameName), fullfile(pathstr, FrameName)); 
    end

    %% Uzip the sub-folder
    name2(k) = GetRawSet(fullfile(pathstr, FrameName));
    fprintf('Extracting Zip file from %s\n', name2{k});

    [pathstr2,FrameName2,ext2] = fileparts(name2{k}); 

    %%=== No need To unzip twice
%     copyfile(name2{k},[fullfile(pathstr2, FrameName2) '.zip' ]);
%     unzip(fullfile(pathstr2, FrameName2), pathstr2);    
%     [I, col, row, BandIndx, Wavelength]  = ReadRawImg_HyperSpec(pathstr2);
     
   [I, col, row]  = ReadRawImg_HyperSpec(pathstr2);
    
   Dataset{cnt,1} = FrameName;
   Dataset{cnt,2} = I;
%    Dataset{cnt,3} = BandIndx;
%    Dataset{cnt,4} = round(Wavelength);

   cnt = cnt + 1;
   
    end
 
    
    %% extract the wavelength from the first rawx file (new part)
    if (strcmp(FrameName,'1_0_0'))
        movefile(name{k},[fullfile(pathstr, FrameName) '.zip' ]);    % to replace the rawx with zip 
        unzip(fullfile(pathstr, FrameName), fullfile(pathstr, FrameName)); 
        %%== Uzip the sub-folder
        name2(k) = GetRawSet(fullfile(pathstr, FrameName));
        fprintf('Extracting Zip file from %s\n', name2{k});
        [pathstr2,FrameName2,ext2] = fileparts(name2{k}); 
        copyfile(name2{k},[fullfile(pathstr2, FrameName2) '.zip' ]);
        unzip(fullfile(pathstr2, FrameName2), pathstr2);      
        WavelengthInfo = envihdrread(fullfile(pathstr2, 'raw.hdr'), sensorID); % extract wavelength value
    end
   
        
end  % k = 1:totalSize

%%=== sort dataset based on filename
[cs,index] = sort_nat(Dataset(:,1));
% Dataset_sort = Dataset(index,1:4);  %old

%%=== new
    Dataset_sort = Dataset(index,1:2); 
   try
    for ss = 1:size(Dataset,1)
        Dataset_sort{ss,3} = WavelengthInfo(ss, 1);
        Dataset_sort{ss,4} = WavelengthInfo(ss, 2);
    end
   catch
        msgbox(PlotID, 'Hyperspectral Failed!', 'warn');
   end

end  %end of function