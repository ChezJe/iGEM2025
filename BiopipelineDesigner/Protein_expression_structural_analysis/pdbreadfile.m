function s = pdbreadfile(file)

if ~ismissing(file)
    s = pdbread(file);
else
    s = struct;
end

end