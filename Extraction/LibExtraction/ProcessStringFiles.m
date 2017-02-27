
function [xmlFile] = ProcessStringFiles(DirName,nFile, nPath)

  %%=== create a dir and file name to store a Dataset
  pth = fullfile(nPath, 'info.txt');
  fileID = fopen(pth);
  ID = textscan(fileID,'%s %s');
  fclose(fileID);

name = GetRawSet(DirName);
k = 1;        
if exist(name{k}, 'file')
fullPath = name{k} ;
else
fullPath = fullfile('data',[name{k} '.*\.(rawx|raw)$']);
end

[pathstr,FileName,ext] = fileparts(name{k}); 

% movefile(name{k},[fullfile(pathstr, FileName) '.zip' ]);   % to replace the .rawx with .zip 
  copyfile(name{k},[fullfile(pathstr, FileName) '.zip' ]);   % to keep both rawx and zip file

if ~exist(fullfile(pathstr, FileName), 'file')
    if uimatlab % to find if it's Matlab or Octave
        unzip(fullfile(pathstr, FileName), pathstr); % for Matlab
    else
        unzip(fullfile(pathstr, strcat(FileName, '.zip')));  % for octave
    end
      
end

% read image.raw file
name = fullfile(pathstr,'image.raw');
if exist(fullfile(name), 'file')
% change image.raw to image.xml    
movefile(name,[fullfile(pathstr, 'image') '.xml' ]); 
end

% read weather file
if(strmatch('weather',nFile))  
    %== change the image.xml to weather.xml
    movefile([fullfile(pathstr, 'image') '.xml' ],[fullfile(pathstr, strcat('weather','_', ID{1,2}{1,1})) '.xml' ]);
    xmlFile = [fullfile(pathstr, strcat('weather','_', ID{1,2}{1,1})) '.xml' ];
%{    
% read xml file      
xml = parseXML(fullfile(pathstr, 'image.xml'));
temp = {xml.Children(2).Attributes.Value};
wind = {xml.Children(4).Attributes.Value};
Dataset{1} = str2num(temp{3});
Dataset{2} = str2num(wind{3});
%}
    
% another way to read xml
%{    
xml = xml2struct(fullfile(pathstr, 'image.xml'));
windVel = xml.LemnaTecData.Entry{1, 2}.Attributes.value; % wind velocity
temp = xml.LemnaTecData.Entry{1, 1}.Attributes.value;   % temperature
Dataset{1} = str2num(temp);
Dataset{2} = str2num(windVel);
%}
end   

% read par file
if(strmatch('par',nFile))
    %== read image.xml to par.xml
    movefile([fullfile(pathstr, 'image') '.xml' ],[fullfile(pathstr, strcat('par','_', ID{1,2}{1,1})) '.xml' ]);
    xmlFile = [fullfile(pathstr, strcat('par','_', ID{1,2}{1,1})) '.xml' ];
%{    
xml = parseXML(fullfile(pathstr, 'image.xml'));
par = {xml.Children(2).Attributes.Value};
Dataset{1} = str2num(par{3});
%}
    
% another way to read xml file
%{
xml = xml2struct(fullfile(pathstr, 'image.xml'));
parm = xml.LemnaTecData.Entry.Attributes.value;
Dataset{1} = str2num(parm);
%}
end

% read temperature file
if(strmatch('temp',nFile))
    %== change image.xml to temp.xml
    movefile([fullfile(pathstr, 'image') '.xml' ],[fullfile(pathstr, strcat('temp','_', ID{1,2}{1,1})) '.xml' ]);
    xmlFile = [fullfile(pathstr, strcat('temp','_', ID{1,2}{1,1})) '.xml' ];
%{    
xml = parseXML(fullfile(pathstr, 'image.xml'));
temp = {xml.Children(2).Attributes.Value};
Dataset{1} = str2num(temp{3});  
 %} 
% another way to read xml file
%{
xml = xml2struct(fullfile(pathstr, 'image.xml'));  
temp = xml.LemnaTecData.Entry.Attributes.value;
Dataset{1} = str2num(temp);
%}
end

% read RelH file
if(strmatch('relh',nFile))
    %=== change image.xml to temp.xml
    movefile([fullfile(pathstr, 'image') '.xml' ],[fullfile(pathstr, strcat('relh','_', ID{1,2}{1,1})) '.xml' ]);
    xmlFile = [fullfile(pathstr, strcat('relh','_', ID{1,2}{1,1})) '.xml' ];
%{    
xml = parseXML(fullfile(pathstr, 'image.xml'));
relh = {xml.Children(2).Attributes.Value};
Dataset{1} = str2num(relh{3});
%}
% another way to read xml file
%{
xml = xml2struct(fullfile(pathstr, 'image.xml'));
relh = xml.LemnaTecData.Entry.Attributes.value;
Dataset{1} = str2num(relh);
%}
end

% read NDVI
if(strmatch('ndvi',nFile))
    %=== change image.xml to ndvi.xml
    movefile([fullfile(pathstr, 'image') '.xml' ],[fullfile(pathstr, strcat('ndvi','_', ID{1,2}{1,1})) '.xml' ]);
    xmlFile = [fullfile(pathstr, strcat('ndvi','_', ID{1,2}{1,1})) '.xml' ];
%{       
xml = parseXML(fullfile(pathstr, 'image.xml'));
ndvi = {xml.Children(2).Attributes.Value};
Dataset{1,1} = str2num(ndvi{3});

ch1Top = {xml.Children(4).Attributes.Value};
Dataset{1,2} = str2num(ch1Top{3});

ch4Top = {xml.Children(6).Attributes.Value}; 
Dataset{1,3} = str2num(ch4Top{3});

ch1Down = {xml.Children(8).Attributes.Value}; 
Dataset{1,4} = str2num(ch1Down{3});

ch4Down = {xml.Children(10).Attributes.Value}; 
Dataset{1,5} = str2num(ch4Down{3});
%}
    
end
    
