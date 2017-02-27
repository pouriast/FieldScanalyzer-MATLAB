%%=======================================================
%%=== Copyright  © 2015-2016 Pouria Sadeghi-Tehran %%====
%%=======================================================
function ReadRaw_Vis(Filepath, SavedImgPath)

%% Reading visible data from the dataset
folders = GetFolderSet(Filepath);  %read dir of all folders
filename = 'vis';

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

ImageVis = ReadRawImage_Vis(fullfile(pathstr, 'image.raw'), rows, cols);

% Another way to read XML
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
ID = textscan(fileID,'%s %s');
fclose(fileID);

%%==== add plot ID to image.raw name
movefile([fullfile(pathstr, 'image') '.raw' ],[fullfile(pathstr, strcat('vis-raw','_', ID{1,2}{1,1})) '.raw' ]);

%%==== add plot ID to xml file
movefile([fullfile(pathstr, 'info') '.xml' ],[fullfile(pathstr, strcat('vis-info','_', ID{1,2}{1,1})) '.xml' ]);

%== move image.raw to Dataset folder
movefile([fullfile(pathstr, strcat('vis-raw','_', ID{1,2}{1,1})) '.raw' ], DataSetFolder); 

%== move info.xml to Dataset folder
movefile([fullfile(pathstr, strcat('vis-info','_', ID{1,2}{1,1})) '.xml' ], DataSetFolder);
 
if nargin > 1
    if uimatlab % matlab
        [PlotNum,matches] = strsplit(ID{1,2}{1,1},{'-'});
        for side = 1:2
         if (strncmp(PlotNum{1,1}, '7', 3) || strncmp(PlotNum{1,1}, '8', 3) || strncmp(PlotNum{1,1}, '21', 3) || strncmp(PlotNum{1,1}, '22', 3) || strncmp(PlotNum{1,1}, '35', 3) || ...
            strncmp(PlotNum{1,1}, '36', 3) || strncmp(PlotNum{1,1}, '49', 3)|| strncmp(PlotNum{1,1}, '50', 3) || strncmp(PlotNum{1,1}, '63', 3) || strncmp(PlotNum{1,1}, '64', 3) || ...
            strncmp(PlotNum{1,1}, '77', 3) || strncmp(PlotNum{1,1}, '78', 3) || strncmp(PlotNum{1,1}, '91', 3) || strncmp(PlotNum{1,1}, '92', 3) || strncmp(PlotNum{1,1}, '105', 3) || ...
            strncmp(PlotNum{1,1}, '106', 3) || strncmp(PlotNum{1,1}, '119', 3) || strncmp(PlotNum{1,1}, '120', 3) || strncmp(PlotNum{1,1}, '133', 3) || strncmp(PlotNum{1,1}, '134', 3) || ...
            strncmp(PlotNum{1,1}, '147', 3) || strncmp(PlotNum{1,1}, '148', 3) || strncmp(PlotNum{1,1}, '161', 3) || strncmp(PlotNum{1,1}, '162', 3) || strncmp(PlotNum{1,1}, '175', 3) || ...
            strncmp(PlotNum{1,1}, '176', 3) || strncmp(PlotNum{1,1}, '189', 3) || strncmp(PlotNum{1,1}, '190', 3) || strncmp(PlotNum{1,1}, '203', 3) || strncmp(PlotNum{1,1}, '204', 3) || ...
            strncmp(PlotNum{1,1}, '217', 3) || strncmp(PlotNum{1,1}, '218', 3) || strncmp(PlotNum{1,1}, '231', 3) || strncmp(PlotNum{1,1}, '232', 3) || strncmp(PlotNum{1,1}, '245', 3))      

            [vis_cropped] = CreateMask_VisExtraction (ImageVis, ID, side);
            h = figure('Toolbar','none','Menubar','none', 'visible', 'off');
            imshow(vis_cropped);
            Plotname = strcat(PlotNum{1},'-',PlotNum{2},'-',PlotNum{3},'-Left');
            export_fig(h, fullfile(SavedImgPath,Plotname), '-png', '-native');
            break
         end
            [vis_cropped] = CreateMask_VisExtraction (ImageVis, ID, side);
            h = figure('Toolbar','none','Menubar','none', 'visible', 'off');
            imshow(vis_cropped);
            if (side == 1)
                Plotname = strcat(PlotNum{1},'-',PlotNum{2},'-',PlotNum{3},'-Left');
            elseif (side == 2)
                Plotname = strcat(PlotNum{1},'-',PlotNum{2},'-',PlotNum{4},'-Right');
            end
            export_fig(h, fullfile(SavedImgPath,Plotname), '-png', '-native');
        end
    else % octave (Linux)
        % save image file
        imwrite(ImageVis, fullfile(DataSetFolder,strcat(ID{1,2}{1,1},'.gif')));
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
