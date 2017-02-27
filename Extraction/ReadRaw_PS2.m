
function ReadRaw_PS2(Filepath)

%% Reading ps2 data from the dataset
folders = GetFolderSet(Filepath);  %read dir of all folders
filename = 'ps2';

for i = 1 : length(folders)
    
PS2Folder = fullfile(folders{i},filename);
if(exist(PS2Folder, 'file')) % check if the folder exist
   
subFolder = GetSubFolderSet(folders{i}); % seperate each folder dir to cell
    
subFldr = dir(folders{i});
indx = strmatch(filename, {subFldr.name}); % find index of folder name = ndvi

nFile =  GetFolderDir(subFolder{indx(1)}); % read ndvi folder dir

fullPath = nFile{1}; 

fprintf('Extracting Zip file from %s\n', fullPath);

[pathstr,nFile,extent] = fileparts(nFile{1}); % read filename and dir of ndvi folder
     
%%== convert Rawx & Raw files to Zip files and Unzip
[Dataset_ps2, pathXML] = ProcessPS2Files(pathstr);

%% Create Dataset folder and save data
DataSetFolder = fullfile(subFolder{1}, 'Dataset');

if ~exist(DataSetFolder, 'file')
    mkdir(DataSetFolder); %create Dataset folder if it doesn't exist
end
 
%%=== create a dir and file name to store a Dataset
pth = fullfile(folders{i}, 'info.txt');
fileID = fopen(pth);
ID = textscan(fileID,'%s %s');
fclose(fileID);

%%==== add plot ID to xml file
movefile([fullfile(pathXML, 'info') '.xml' ],[fullfile(pathXML, strcat('ps2-info','_', ID{1,2}{1,1})) '.xml' ]);

%== move info.xml to Dataset folder
movefile([fullfile(pathXML, strcat('ps2-info','_', ID{1,2}{1,1})) '.xml' ], DataSetFolder);

%=== save PS2 as bil format
% multibandwrite(Dataset_ps2,[fullfile(DataSetFolder,strcat('ps2-Multiband','_',ID{1,2}{1,1})),'data.bsq'],'bsq');

%==== save as .tif file
t = Tiff([fullfile(DataSetFolder,strcat('ps2-Multiband','_',ID{1,2}{1,1})),'.tif'],'w');
t.setTag('Photometric',Tiff.Photometric.LinearRaw);
t.setTag('Compression',Tiff.Compression.None);
t.setTag('BitsPerSample',16);
t.setTag('SamplesPerPixel',25);
t.setTag('SampleFormat',Tiff.SampleFormat.UInt);
t.setTag('ExtraSamples',Tiff.ExtraSamples.Unspecified);
t.setTag('ImageLength',1038);
t.setTag('ImageWidth',1388);
t.setTag('TileLength',32);
t.setTag('TileWidth',32);
t.setTag('PlanarConfiguration',Tiff.PlanarConfiguration.Chunky);
t.write(Dataset_ps2);
t.close();
 
clear Dataset_ps2;

%%== remove folders after extracting features
rmdir(subFolder{indx(1)},'s')
rmdir(subFolder{indx(2)},'s')

end % exist folder
end % exist folder


