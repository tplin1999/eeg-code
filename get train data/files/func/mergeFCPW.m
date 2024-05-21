% merge FC and PW
function FCPW = mergeFCPW(FC, PW)
    for ii = 1 : size(FC, 2)
        fcName = FC(ii).name;
        fcWeek = FC(ii).week;
        FCPW(ii).name = FC(ii).name;
        FCPW(ii).week = FC(ii).week;
        FCPW(ii).PLV = FC(ii).PLV;
        FCPW(ii).PLI = FC(ii).PLI;
        FCPW(ii).wPLI = FC(ii).wPLI;
        
        for pw = PW
            if strcmpi(fcName, pw.name) && strcmpi(fcWeek, pw.week)
                FCPW(ii).AP = pw.AP;
                FCPW(ii).RP = pw.RP;
            end
        end
    end 
end % end function
