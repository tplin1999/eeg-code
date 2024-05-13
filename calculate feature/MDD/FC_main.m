%{
    this program used to calculate PLV, PLI, wPLI for dpression
    1.read pre-processed set file
    2.calculate PLV,PLI,wPLI (formula was written by myself)
    3.store data
%}
%% clear
clc; clear; close all;
%% main
% add function path
funcPath = cd; funcPath = fullfile(funcPath, "..\Func");
addpath(genpath(funcPath));
% .set file folder
allFilePath = 'C:\Users\123\Desktop\DepressionData\4Band\H';
allFileInfo = dir(allFilePath)';
% target sample rate
fsTarget = 256;
% time windows for all
stTime = 2; edTime = 58;
% create FC data structure
num_folder = (length(allFileInfo)-2) / 2 / 4;
temp = cell(1, num_folder);
FC = struct('name', '', 'week', '', 'PLV', temp, 'PLI', temp, 'wPLI', temp);
% Pt's number
ptNo = 0;

% calculate FC
for oneFileInfo = allFileInfo
    % skip "." and ".." and ".fdt"
    if (~contains(oneFileInfo.name,'band1.set'))
        continue;
    end
    ptNo = ptNo + 1;
    fprintf('Now start NO.%i!!!\n', ptNo);
    
    % get file path
    deltaPath = append(oneFileInfo.folder,'\', oneFileInfo.name);
    thetaPath = strrep(deltaPath, 'band1', 'band2');
    alphaPath = strrep(deltaPath, 'band1', 'band3');
    betaPath = strrep(deltaPath, 'band1', 'band4');
    % read set file and calculate FC
    [PLV_delta, PLI_delta, wPLI_delta] = readSetCalFC(deltaPath, fsTarget, stTime, edTime);
    [PLV_theta, PLI_theta, wPLI_theta] = readSetCalFC(thetaPath, fsTarget, stTime, edTime);
    [PLV_alpha, PLI_alpha, wPLI_alpha] = readSetCalFC(alphaPath, fsTarget, stTime, edTime);
    [PLV_beta, PLI_beta, wPLI_beta] = readSetCalFC(betaPath, fsTarget, stTime, edTime);
    % save name and week
    nameArr = strsplit(oneFileInfo.name, "_");
    FC(1, ptNo).name = nameArr(1, 1);
    if contains(nameArr(1,1), 'C')
        FC(1, ptNo).week = nameArr(1, 3);
    else
        FC(1, ptNo).week = nameArr(1, 2);
    end
    % merge 4 band
    FC(1, ptNo).PLV = cat(2, PLV_delta, PLV_theta, PLV_alpha, PLV_beta);
    FC(1, ptNo).PLI = cat(2, PLI_delta, PLI_theta, PLI_alpha, PLI_beta);
    FC(1, ptNo).wPLI = cat(2, wPLI_delta, wPLI_theta, wPLI_alpha, wPLI_beta);
end
% remove function path
rmpath(funcPath);
% save result
save('FC.mat', 'FC');