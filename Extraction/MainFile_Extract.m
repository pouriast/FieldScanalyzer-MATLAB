%%=======================================================
%%=== Copyright  © 2015-2016 Pouria Sadeghi-Tehran %%====
%%=======================================================

clear all; close all; clc;
%%=======  Run all the sensors =======
addpath(genpath('./LibExtraction'));
addpath(genpath('./export_fig'));

% for OCTAVE (add java lib to read xml file)
% change the path based on your dir
if uioctave
    javaaddpath ('/home/pouria/Documents/Codes/xerces-2_11_0/xercesImpl.jar');
    javaaddpath ('/home/pouria/Documents/Codes/xerces-2_11_0/xml-apis.jar');
    pkg load io
end

tic


%% Change the path based on your dir
Filepath = 'D:\2016-2017\04-Jan-2017\Vnir\Dataset_vnir\20-Jan-2017-calib';


%%==  TEMP from the .rawx file
ReadRaw_Temp(Filepath)

%%== PAR from the .rawx file
ReadRaw_Par(Filepath)

%%==  RELH from the .rawx file
ReadRaw_RelH(Filepath)

%%==  NDVI from the .rawx file
% ReadRaw_NDVI(Filepath)

%%==  WEATHER data from the .rawx file
ReadRaw_Weather(Filepath)


%%== VISIBLE image from the .rawx file
% ImgPathVis = 'C:\Users\Pouria\Desktop\PngVis';
% ReadRaw_Vis(Filepath)


%{
%%=== THERMAL image
% ImgPathFlir = 'C:\Users\Pouria\Desktop\New folder (3)';
% ReadRaw_flir(Filepath)
%}

%%===  3D data
% ReadRaw_3D(Filepath)

%%==  PS2 from the .rawx file
% ReadRaw_PS2(Filepath);

%%==== vnir hyperspec =====
% Filepath = 'D:\2016-2017\04-Jan-2017\Vnir\Dataset_vnir\20-Jan-2017-vnir';
% ReadRaw_Vnir(Filepath, 'vnir');


toc





