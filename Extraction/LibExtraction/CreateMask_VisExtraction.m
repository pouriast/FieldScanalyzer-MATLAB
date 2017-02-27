
function [Dataset_cropped] = CreateMask_VisExtraction (Dataset_mask, ID, side)

PlotID = ID{1,2}{1,1};
[dataID,matches] = strsplit(PlotID,{'-'});
%%=== folder directory to save cropped area
FolderDir = 'C:\Users\Pouria\Desktop\ps2Data';
    
    switch side
        case 1
            PlotName = strcat(dataID{1},'-',dataID{2},'-',dataID{3},'-','Left');
        case 2
            PlotName = strcat(dataID{1},'-',dataID{2},'-',dataID{4},'-','Right');
        otherwise 
            error('Error, Plot Not Found!');           
    end
    
    load(fullfile(FolderDir,PlotName));
    Dataset_cropped = imcrop(Dataset_mask,[rect(1) rect(2) rect(3) rect(4)]);
               
end % end of function