%% clear
clear; clc; close all;
%% main
% add function path
funcPath = cd; funcPath = fullfile(funcPath, "..\files");
addpath(genpath(funcPath));

load("MDD_FC.mat");
load("MDD_PW.mat");

labelPath = 'W4W6W8Label.xlsx';
clinicalPath = 'predictClinical.xlsx';
T_label = readtable(labelPath, 'VariableNamingRule', 'preserve');
T_clinical = readtable(clinicalPath, 'VariableNamingRule', 'preserve');

FCPW = mergeFCPW(FC, PW);
FCPW = W1minusW0(FCPW);
FCPW = addClinical(FCPW, T_clinical);
FCPW = addLabel(FCPW, T_label);

Arg = getTrainArg();

comType1 = ["PLV", "PLI", "wPLI", "AP", "RP", ...
    "PLV_AP", "PLV_RP", "PLI_AP", "PLI_RP", "wPLI_AP", "wPLI_RP", ...
    "PLV_PLI_wPLI", "AP_RP", "PLV_PLI_wPLI_AP_RP"];
comType2 = append(comType1, "_clinical");

no = 1;
for arg = Arg
    trainData(no).week = arg.week;
    trainData(no).label = arg.label;
    for com = comType1
        data = getDataWithLable(arg.week, arg.label, com, FCPW);
        trainData(no).(com) = data;
    end

    for com = comType2
        data = getDataWithLable(arg.week, arg.label, com, FCPW);
        trainData(no).(com) = data;
    end

    no = no + 1;
end
% save
save("Predict_TrainData.mat", "trainData");
%% function
% add label to FCPW array
function FCPW = addLabel(FCPW, T_label)
    for ii = 1 : size(FCPW, 2)
        for jj = 1 : size(T_label, 1)
            if string(FCPW(ii).name) == string(T_label(jj,:).name)
                FCPW(ii).label_W4 = T_label(jj,:).label_W4;
                FCPW(ii).label_W6 = T_label(jj,:).label_W6;
                FCPW(ii).label_W8 = T_label(jj,:).label_W8;
            end
        end
    end
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
% add "W1 minus W0" to FCPW array
function FCPW = W1minusW0(FCPW)
    for featW0 = FCPW
        featW0Name = string(featW0.name);
        featW0Week = string(featW0.week);

        if featW0Week ~= "W0"
            continue;
        end
        
        for featW1 = FCPW
            featW1Name = string(featW1.name);
            featW1Week = string(featW1.week);

            if featW1Week ~= "W1"
                continue;
            end

            if featW0Name == featW1Name
                FCPW(1,end+1).name = featW0Name;
                FCPW(1,end).week = "W1-W0";

                featType = ["PLV", "PLI", "wPLI", "AP", "RP"];
                for feat = featType
                    FCPW(1,end).(feat) = featW1.(feat) - featW0.(feat);
                end
            end
        end
    end
end % end function
% get training data with label
function data = getDataWithLable(week, label, com, FCPW)
    data = [];
    
    featArr = split(com, '_');
    featArr = featArr';

    for pt = FCPW
        if pt.week == week
            onePt = [];
            noClinical = false;
            for element = featArr
                if size(pt.(element), 2) ~= 0
                    onePt = cat(2, onePt, pt.(element));
                else
                    noClinical = true;
                end
            end
            onePt = cat(2, onePt, pt.(append('label_', label)));

            if ~noClinical
               data = cat(1, data, onePt);
            end   
        end 
    end
end % end function