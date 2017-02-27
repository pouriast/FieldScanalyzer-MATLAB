%%=======================================================
%%=== Copyright  © 2015-2016 Pouria Sadeghi-Tehran %%====
%%=======================================================
function ReadRaw_flir(Filepath, SavedImgPath)

%% Reading visible data from the dataset
folders = GetFolderSet(Filepath);  %read dir of all folders
filename = 'flir';

for i = 1:length(folders)
    
VisFolder = fullfile(folders{i},filename);
if(exist(VisFolder, 'file')) % check if the folder exist
   
subFolder = GetSubFolderSet(folders{i}); % seperate each folder dir to cell
    
subFldr = dir(folders{i});
indx = strmatch(filename, {subFldr.name}); % find index of folder name

nFile =  GetFolderDir(subFolder{indx(1)}); % read visible folder dir

fullPath = nFile{1}; 

fprintf('Extracting Zip file from %s\n', fullPath);

[pathstr,FileName,ext] = fileparts(nFile{1}); % read filename and dir of visible folder
     
% movefile(nFile{1},[fullfile(pathstr, FileName) '.zip' ]); % to replace the .rawx with .zip
copyfile(nFile{1},[fullfile(pathstr, FileName) '.zip' ]); % to keep both .zip and .rawx file

try
    if uimatlab
        unzip(fullfile(pathstr, FileName), pathstr); % for matlab
    else
        unzip(fullfile(pathstr, strcat(FileName, '.zip'))); % for octave
    end
    
 %%== read xml and raw files
xml = parseXML(fullfile(pathstr, 'info.xml'));
rows = str2double(xml.Children(6).Attributes.Value);
cols = str2double(xml.Children(4).Attributes.Value);   

ImageFlir = ReadRawImage_Flir(fullfile(pathstr, 'image.raw'), rows, cols);
    
    
%== Another way to read XML
%{
xml = xml2struct(fullfile(pathstr, 'info.xml')); 
cols = str2double(xml.rawImage.width.Attributes.value);
rows = str2double(xml.rawImage.height.Attributes.value);
%}

%% Create Dataset folder and save data
DataSetFolder = fullfile(subFolder{1}, 'Dataset');

if ~exist(DataSetFolder, 'file')
    mkdir(DataSetFolder); %create Dataset folder if it doesn't exist
end

%%=== create a dir and file name to store a Dataset
pth = fullfile(folders{i}, 'info.txt');
fileID = fopen(pth);
PlotID = textscan(fileID,'%s %s');

%%==== add plot ID to image.raw name
movefile([fullfile(pathstr, 'image') '.raw' ],[fullfile(pathstr, strcat('flir-raw','_', PlotID{1,2}{1,1})) '.raw' ]);

%%==== add plot ID to image.raw name
movefile([fullfile(pathstr, 'info') '.xml' ],[fullfile(pathstr, strcat('flir-info','_', PlotID{1,2}{1,1})) '.xml' ]);

%== move image.raw to Dataset folder
movefile([fullfile(pathstr, strcat('flir-raw','_', PlotID{1,2}{1,1})) '.raw' ], DataSetFolder); 

%== move info.xml to Dataset folder
movefile([fullfile(pathstr, strcat('flir-info','_', PlotID{1,2}{1,1})) '.xml' ], DataSetFolder);
 
if nargin > 1
    if uimatlab % matlab 
        h = figure('Toolbar','none','Menubar','none', 'visible', 'off');
        imshow(ImageFlir);
        export_fig(h, fullfile(SavedImgPath,PlotID{1,2}{1,1}), '-png', '-native');
    else % octave (Linux)
        % save image file
        imwrite(ImageFlir, fullfile(DataSetFolder,strcat(PlotID{1,2}{1,1},'.gif')));
    end
end

fclose('all');
 
catch
    fprintf('Cannot Unzip: %s\n', fullPath);
end
 
   %%== remove temp and temp_position folders after extracting features
   if uimatlab % to find if it's Matlab or Octave
    rmdir(subFolder{indx(1)},'s')
    rmdir(subFolder{indx(2)},'s')
   end

end % exist folder
end % length folder
