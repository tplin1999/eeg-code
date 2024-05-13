%{
    this program used to calculate power(absolute) for depression
    1.read pre-processed .set file
    2.calculate power(absolute, relative)
    3.store data
%}
%% clear
clc; clear; close all;
%% main
% add function path
funcPath = cd; funcPath = fullfile(funcPath, "..\Func");
addpath(genpath(funcPath));
% .set file folder
allFilePath = 'C:\Users\123\Desktop\DepressionData\afterICA\H';
allFileInfo = dir(allFilePath)';
% target sample rate
fsTarget = 256;
% time windows for all
stTime = 2; edTime = 58;
% create FC data structure
num_folder = (length(allFileInfo)-2) / 2;
temp = cell(1, num_folder);
PW = struct('name', '', 'week', '', 'AP', temp, 'RP', temp);
% Pt's number
ptNo = 0;

% calculate FC
for oneFileInfo = allFileInfo
    % skip "." and ".." and ".fdt"
    if (~contains(oneFileInfo.name,'.set'))
        continue;
    end
    ptNo = ptNo + 1;
    fprintf('Now start NO.%i!!!\n', ptNo);
    
    % get file path
    setPath = append(oneFileInfo.folder,'\', oneFileInfo.name);
    % read eeg data
    [data, fsOg, ~] = readSET(setPath);
    % calculate PW
    [AP_delta, AP_theta, AP_alpha, AP_beta] = ...
        calAP(data, fsOg, fsTarget, 0.5, 30, 0.1, stTime, edTime);

    [RP_delta, RP_theta, RP_alpha, RP_beta] = ...
        calRP(AP_delta, AP_theta, AP_alpha, AP_beta);
    % save name and week
    nameArr = strsplit(oneFileInfo.name, "_");
    PW(1, ptNo).name = nameArr(1, 1);
    if contains(nameArr(1,1), 'C')
        PW(1, ptNo).week = nameArr(1, 3);
    else
        PW(1, ptNo).week = nameArr(1, 2);
    end
    % merge 4 band
    PW(1, ptNo).AP = cat(2, AP_delta, AP_theta, AP_alpha, AP_beta);
    PW(1, ptNo).RP = cat(2, RP_delta, RP_theta, RP_alpha, RP_beta);
end
% remove function path
rmpath(funcPath);
% save result
save('PW.mat', 'PW');