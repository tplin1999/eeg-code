%% clear
clear; clc; close all;
%% main
% add function path
funcPath = cd; funcPath = fullfile(funcPath, "..\files");
addpath(genpath(funcPath));

load("MDD_FC.mat");
load("MDD_PW.mat");
load("H_FC.mat");
load("H_PW.mat");

clinicalPath = 'diagnosisClinical.xlsx';
T_clinical = readtable(clinicalPath, 'VariableNamingRule', 'preserve');

MDD_FCPW = mergeFCPW(FC, PW);
H_FCPW = mergeFCPW(H_FC, H_PW);
FCPW = mergeMDD_H(MDD_FCPW, H_FCPW);
FCPW = addClinical(FCPW, T_clinical);
FCPW = addLabel(FCPW);

comType1 = ["PLV", "PLI", "wPLI", "AP", "RP", ...
    "PLV_AP", "PLV_RP", "PLI_AP", "PLI_RP", "wPLI_AP", "wPLI_RP", ...
    "PLV_PLI_wPLI", "AP_RP", "PLV_PLI_wPLI_AP_RP"];
comType2 = append(comType1, "_clinical");

for com = comType1
    data = getDataWithLable(com, FCPW);
    trainData.(com) = data;
end
for com = comType2
    data = getDataWithLable(com, FCPW);
    trainData.(com) = data;
end
% save
save("Diagnosis_TrainData.mat", "trainData");
%% function
% merge MDD_FCPW and H_FCPW
function FCPW = mergeMDD_H(MDD_FCPW, H_FCPW)
    FCPW = [];

    for pt = MDD_FCPW
        if pt.week == "W0"
            FCPW = cat(2, FCPW, pt);
        end
    end

    FCPW = cat(2, FCPW, H_FCPW);
end % end function
% add clinical to FCPW array
function FCPW = addClinical(FCPW, T_clinical)
    for ii = 1 : size(T_clinical, 1)
        for jj = 1 : size(FCPW, 2)
            if string(T_clinical(ii,:).name) == string(FCPW(jj).name)
                clinical = table2array(T_clinical(ii,2:end));
                FCPW(jj).clinical = clinical;     
            end
        end
    end
end % end function
% add label to FCPW array
function FCPW = addLabel(FCPW)
    for ii = 1 : size(FCPW, 2)
        if contains(FCPW(ii).name, "C")
            FCPW(ii).label = 1;
        else
            FCPW(ii).label = 0;
        end
    end
end % end function
% get training data with label
function data = getDataWithLable(com, FCPW)
    data = [];
    
    featArr = split(com, '_');
    featArr = featArr';

    for pt = FCPW
        onePt = [];
        noClinical = false;
        for element = featArr
            if size(pt.(element), 2) ~= 0
                onePt = cat(2, onePt, pt.(element));
            else
                noClinical = true;
            end
        end
        onePt = cat(2, onePt, pt.label);

        if ~noClinical
           data = cat(1, data, onePt);
        end   
    end
end % end function