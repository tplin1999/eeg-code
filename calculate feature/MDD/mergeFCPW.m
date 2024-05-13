%% clear
clc; clear; close all;
%% main
load("MDD_FC.mat");
load("MDD_PW.mat");

for ii = 1 : size(FC, 2)
    fcName = FC(ii).name;
    fcWeek = FC(ii).week;
    feat(ii).name = FC(ii).name;
    feat(ii).week = FC(ii).week;
    feat(ii).PLV = FC(ii).PLV;
    feat(ii).PLI = FC(ii).PLI;
    feat(ii).wPLI = FC(ii).wPLI;
    
    for pw = PW
        if strcmpi(fcName, pw.name) && strcmpi(fcWeek, pw.week)
            feat(ii).AP = pw.AP;
            feat(ii).RP = pw.RP;
        end
    end
end

save("MDD_feat.mat", "feat");