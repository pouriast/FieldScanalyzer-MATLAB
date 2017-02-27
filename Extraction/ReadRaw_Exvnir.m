
function ReadRaw_Exvnir(Filepath, sensorID)
%% Reading exvnir hyperspectral data from the dataset
% Filepath = 'E:\Date22';
folders = GetFolderSet(Filepath);  %read dir of all folders
filename = 'exvnir';


for i = 1: length(folders)
    
ExvnirFolder = fullfile(folders{i},filename);
if(exist(ExvnirFolder, 'file')) % check if the folder exist
   
subFolder = GetSubFolderSet(folders{i}); % seperate each folder dir to cell
    
subFldr = dir(folders{i});
indx = strmatch(filename, {subFldr.name}); % find index of folder name = ndvi

nFile =  GetFolderDir(subFolder{indx(1)}); % read ndvi folder dir

fullPath = nFile{1}; 

fprintf('Extracting Zip file from %s\n', fullPath);

[DirName,nFile,extent] = fileparts(nFile{1}); % read filename and dir of ndvi folder
 
%%== extract the Plot ID
pth = fullfile(folders{i}, 'info.txt');
fileID = fopen(pth);
C = textscan(fileID,'%s %s');
txt = C{1,1}{8,1};
txt2 = strrep(txt,':','-');

%%== convert Rawx & Raw files to Zip files and Unzip
[Dataset_exvnir] = ProcessHyperSpecFiles(DirName, strcat(C{1,2}{1,1},'_',txt2), sensorID);

%% Save Dataset
DataSetFolder = fullfile(subFolder{1}, 'Dataset');
DataSetFolderVnir = fullfile(DataSetFolder, 'Dataset-exvnir');

if exist(DataSetFolder, 'file') && exist(DataSetFolderVnir, 'file')
   fullfile(subFolder{1}, 'Dataset-exvnir');
else
%    mkdir(DataSetFolder,'Dataset-exvnir');
    mkdir(DataSetFolder);
end
 
%  C = strsplit(folders{i},'\');
 
%%=== create a dir and file name to store a Dataset
pth = fullfile(folders{i}, 'info.txt');
fileID = fopen(pth);
C = textscan(fileID,'%s %s');
save([DataSetFolder,'/Dataset-exvnir_',C{1,2}{1,1},'.mat'],'Dataset_exvnir');
fclose('all');

%%=== save data in a seperate folder
% %  save([DataSetFolderVnir,'/Dataset-exvnir_',num2str(C{3}),'.mat'],'Dataset');
%%=== save data in the main folder
% %  save([DataSetFolder,'/Dataset-exvnir_',num2str(C{5}),'.mat'],'Dataset_exvnir');
 
 clear Dataset_exvnir
 
 %%== remove folders after extracting features
rmdir(subFolder{indx(1)},'s')
rmdir(subFolder{indx(2)},'s')
 
end  % if exist
end  % if length folder


