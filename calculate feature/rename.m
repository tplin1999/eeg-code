%% clear
clc; clear; close all;
%% main
folderPath = 'C:\Users\123\Desktop\DepressionData\4Band\H';

allFileInfo = dir(folderPath)';

for fileInfo = allFileInfo
    filePath = append(fileInfo.folder, "\", fileInfo.name);
    
    if contains(filePath, "Band 1")
        newFilePath = strrep(filePath, 'Band 1', 'band1');
        movefile(filePath, newFilePath);

    elseif contains(filePath, "Band 2")
        newFilePath = strrep(filePath, 'Band 2', 'band2');
        movefile(filePath, newFilePath);

    elseif contains(filePath, "Band 3")
        newFilePath = strrep(filePath, 'Band 3', 'band3');
        movefile(filePath, newFilePath);

    elseif contains(filePath, "Band 4")
        newFilePath = strrep(filePath, 'Band 4', 'band4');
        movefile(filePath, newFilePath);
    
    elseif contains(filePath, "band 1")
        newFilePath = strrep(filePath, 'band 1', 'band1');
        movefile(filePath, newFilePath);

    elseif contains(filePath, "band 2")
        newFilePath = strrep(filePath, 'band 2', 'band2');
        movefile(filePath, newFilePath);

    elseif contains(filePath, "band 3")
        newFilePath = strrep(filePath, 'band 3', 'band3');
        movefile(filePath, newFilePath);

    elseif contains(filePath, "band 4")
        newFilePath = strrep(filePath, 'band 4', 'band4');
        movefile(filePath, newFilePath);

    end
end