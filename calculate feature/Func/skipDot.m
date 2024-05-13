% skip "." and ".." in "dir()"
function skip = skipDot(str)
    dot1 = (str == ".");
    dot2 = (str == "..");
    if (dot1 || dot2)
        skip = true;
    else
        skip = false;
    end
end

