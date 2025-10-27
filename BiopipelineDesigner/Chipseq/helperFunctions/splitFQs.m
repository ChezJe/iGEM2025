function [out1, out2] = splitFQs(files)
    numFiles = numel(files);
    out1 = files(1:numFiles/2);
    out2 = files((numFiles/2)+1:end);
end