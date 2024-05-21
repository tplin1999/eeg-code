%% clear
clear; clc; close all;
%% main
% add function path
funcPath = cd; funcPath = fullfile(funcPath, "..\files");
addpath(genpath(funcPath));

load("Keto_FCPW.mat");

labelPath = 'M3M6Label.xlsx';
T_label = readtable(labelPath, 'VariableNamingRule', 'preserve');

FCPW = addLabel(FCPW, T_label);

comType1 = ["PLV", "PLI", "wPLI", "AP", "RP", ...
    "PLV_AP", "PLV_RP", "PLI_AP", "PLI_RP", "wPLI_AP", "wPLI_RP", ...
    "PLV_PLI_wPLI", "AP_RP", "PLV_PLI_wPLI_AP_RP"];

no = 1;
for label = ["M3", "M6"]
    trainData(no).label = label;

    for com = comType1
        data = getDataWithLable(label, com, FCPW);
        trainData(no).(com) = data;
    end

    no = no + 1;
end
% save
save("Keto_TrainData.mat", "trainData");
%% function
% add label to FCPW array
function feat = addLabel(feat, T_label)
    for ii = 1 : size(feat, 2)
        for jj = 1 : size(T_label, 1)
            if string(feat(ii).name) == string(T_label(jj,:).name)
                feat(ii).label_M3 = T_label(jj,:).label_M3;
                feat(ii).label_M6 = T_label(jj,:).label_M6;
            end
        end
    end
end % end function
% get training data with label
function data = getDataWithLable(label, com, FCPW)
    data = [];
    
    featArr = split(com, '_');
    featArr = featArr';

    for pt = FCPW
        onePt = [];
        noClinical = false;
        noLabel = false;
        for element = featArr
            if size(pt.(element), 2) ~= 0
                onePt = cat(2, onePt, pt.(element));
            else
                noClinical = true;
            end
        end
        if ~isnan(pt.(append("label_", label)))
            onePt = cat(2, onePt, pt.(append("label_", label)));
        else
            noLabel = true;
        end

        if ~(noClinical || noLabel)
           data = cat(1, data, onePt);
        end   
    end
end % end function