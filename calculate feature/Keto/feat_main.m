%{
    this program used to calculate PLV, PLI, wPLI for ketogenic diet
    1.read pre-processed edf file
    2.calculate PLV,PLI,wPLI (formula was written by myself)
    3.store data
%}
%% clear
clc; clear; close all;
%% main
% add function path
funcPath = cd; funcPath = fullfile(funcPath, "..\Func");
addpath(genpath(funcPath));
% edf file folder
allFolderPath = 'C:\Users\123\Desktop\keto_mix\additional';
allFolderInfo = dir(allFolderPath);
% target sample rate
fsTarget = 125;
% time windows for all
stTime = 2; edTime = 58;
% create FC, PW data structure
folderSize = length(allFolderInfo)-2;
temp = cell(1, folderSize);
feat = struct('name', '',...
    'PLV', temp, 'PLI', temp, 'wPLI', temp, 'AP', temp, 'RP', temp);
% folder's number
folderNo = 0;
% calculate FC
for oneFolderInfo = allFolderInfo
    % skip "." and ".."
    skip = skipDot(oneFolderInfo.name);
    if (skip)
        continue;
    end
    folderNo = folderNo + 1;
    fprintf('Now start NO.%i!!!\n', folderNo);
    % get file path
    ptFolderPath = append(oneFolderInfo.folder,'\', oneFolderInfo.name);
    FC = FC_M(ptFolderPath, fsTarget, stTime, edTime);
    PW = PW_M(ptFolderPath, fsTarget, stTime, edTime);
    % save name
    feat(1,folderNo).name = oneFolderInfo.name;
    % ave FC, PW
    feat = mergeFCPW(feat, folderNo, FC, PW);
end
% delete 2nd file
%feat = del2ndFile(feat);
% remove function path
rmpath(genpath(funcPath));
% save result to "FC.mat"
save('feat_external.mat', 'feat');
%% function
% calculate FC
function FC = FC_M(ptFolderPath, fsTarget, stTime, edTime)
    % get file path
    deltaPath = append(ptFolderPath,'\EDF Filter Re ICA Delta.set');
    thetaPath = append(ptFolderPath,'\EDF Filter Re ICA Theta.set');
    alphaPath = append(ptFolderPath,'\EDF Filter Re ICA Alpha.set');
    betaPath = append(ptFolderPath,'\EDF Filter Re ICA Beta.set');
    % read eeg data and calculate FC
    [PLV_delta, PLI_delta, wPLI_delta] = readSetCalFC(deltaPath, fsTarget, stTime, edTime);
    [PLV_theta, PLI_theta, wPLI_theta] = readSetCalFC(thetaPath, fsTarget, stTime, edTime);
    [PLV_alpha, PLI_alpha, wPLI_alpha] = readSetCalFC(alphaPath, fsTarget, stTime, edTime);
    [PLV_beta, PLI_beta, wPLI_beta] = readSetCalFC(betaPath, fsTarget, stTime, edTime);
    % merge 4 band
    FC.PLV = cat(2, PLV_delta, PLV_theta, PLV_alpha, PLV_beta);
    FC.PLI = cat(2, PLI_delta, PLI_theta, PLI_alpha, PLI_beta);
    FC.wPLI = cat(2, wPLI_delta, wPLI_theta, wPLI_alpha, wPLI_beta);
end
% calculate PW
function PW = PW_M(ptFolderPath, fsTarget, stTime, edTime)
    % get file path
    fullPath = append(ptFolderPath,'\EDF Filter Re ICA.set');
    % read eeg data
    [data, fsOg, ~] = readSET(fullPath);
    % calculate PW
    [AP_delta, AP_theta, AP_alpha, AP_beta] = ...
        calAP(data, fsOg, fsTarget, 0.5, 30, 0.1, stTime, edTime);

    [RP_delta, RP_theta, RP_alpha, RP_beta] = ...
        calRP(AP_delta, AP_theta, AP_alpha, AP_beta);
    % merge 4 band
    PW.AP = cat(2, AP_delta, AP_theta, AP_alpha, AP_beta);
    PW.RP = cat(2, RP_delta, RP_theta, RP_alpha, RP_beta);
end
% merge FC and PW
function feat = mergeFCPW(feat, folderNo, FC, PW)
    fnArr = fieldnames(FC)';
    fnArr = string(fnArr);
    for fn = fnArr
        feat(1, folderNo).(fn) = FC.(fn);
    end

    fnArr = fieldnames(PW)';
    fnArr = string(fnArr);
    for fn = fnArr
        feat(1, folderNo).(fn) = PW.(fn);
    end
end