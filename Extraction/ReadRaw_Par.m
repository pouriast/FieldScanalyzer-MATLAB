%%=======================================================
%%=== Copyright  © 2015-2016 Pouria Sadeghi-Tehran %%====
%%=======================================================
function ReadRaw_Par(Filepath)

%% Reading Par data from the dataset
folders = GetFolderSet(Filepath);  %read dir of all folders
filename = 'par';

for i = 1: length(folders)
    
ParFolder = fullfile(folders{i},filename);
if(exist(ParFolder, 'file')) % check if the folder exist
   
subFolder = GetSubFolderSet(folders{i}); % seperate each folder dir to cell
    
subFldr = dir(folders{i});
indx = strmatch(filename, {subFldr.name}); % find index of folder name

nFile =  GetFolderDir(subFolder{indx(1)}); % read Par folder dir

fullPath = nFile{1}; 

fprintf('Extracting Zip file from %s\n', fullPath);

[DirName,nFile,extent] = fileparts(nFile{1}); % read filename and dir of Par folder
     
%%== convert Rawx & Raw files to Zip files and Unzip
%%== convert Rawx & Raw files to Zip files and Unzip
[xmlOutput] = ProcessStringFiles(DirName, filename, folders{i});

  %% Create Dataset folder and save data
   DataSetFolder = fullfile(subFolder{1}, 'Dataset');

  if ~exist(DataSetFolder, 'file') 
      mkdir(DataSetFolder); %create Dataset folder if it doesn't exist
  end
    
  
movefile(xmlOutput, DataSetFolder); 
 
   %%== remove temp and temp_position folders after extracting features
   if uimatlab % to find if it's Matlab or Octave
    rmdir(subFolder{indx(1)},'s')
    rmdir(subFolder{indx(2)},'s')
   end

end % exist folder
end % length folder


