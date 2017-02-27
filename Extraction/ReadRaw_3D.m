
function ReadRaw_3D(Filepath)

%% Reading vnir hyperspectral data from the dataset
% Filepath = 'E:\Date22';
folders = GetFolderSet(Filepath);  %read dir of all folders
filename = '3d';

for i = 1:length(folders)
   
DFolder = fullfile(folders{i},filename);
if(exist(DFolder, 'file')) % check if the folder exist
    
%%=== create a dir and file name to store a Dataset
pth = fullfile(folders{i}, 'info.txt');
fileID = fopen(pth);
PlotID = textscan(fileID,'%s %s');
fclose(fileID);
    
subFolder = GetSubFolderSet(folders{i}); % seperate each folder dir to cell
    
subFldr = dir(folders{i});
indx = strmatch(filename, {subFldr.name}); % find index of folder name = ndvi

nFile =  GetFolderDir(subFolder{indx(1)}); % read ndvi folder dir

fullPath = nFile{1}; 

fprintf('Extracting Zip file from %s\n', fullPath);

[DirName,nFile,extent] = fileparts(nFile{1}); % read filename and dir of ndvi folder
     
%%== convert Rawx & Raw files to Zip files and Unzip

[path3D] = Process3DFiles(DirName);


%%  Save Dataset
DataSetFolder = fullfile(subFolder{1}, 'Dataset');

%%==== Create Dataset directory if it doesn't exist
if ~exist(DataSetFolder, 'file')
    mkdir(DataSetFolder);
end

%%==== add plot ID to sensor.ply name
movefile([fullfile(path3D, 'sensor0') '.ply' ],[fullfile(path3D, strcat('sensor0','_', PlotID{1,2}{1,1})) '.ply' ]);

movefile([fullfile(path3D, 'sensor1') '.ply' ],[fullfile(path3D, strcat('sensor1','_', PlotID{1,2}{1,1})) '.ply' ]);

%== move sensor.ply to Dataset folder
movefile([fullfile(path3D, strcat('sensor0','_', PlotID{1,2}{1,1})) '.ply' ], DataSetFolder); 

movefile([fullfile(path3D, strcat('sensor1','_', PlotID{1,2}{1,1})) '.ply' ], DataSetFolder); 

%%== remove folders after extracting features
rmdir(subFolder{indx(1)},'s')
rmdir(subFolder{indx(2)},'s')

end %if(exist(DFolder, 'file'))
end %for i = 1:length(folders)


