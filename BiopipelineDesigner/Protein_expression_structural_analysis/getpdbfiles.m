function status = getpdbfiles(PDBFile, ID)

arguments
    PDBFile (1,1) string
    ID (1,1) string
end 

try
    getpdb(ID, ToFile=PDBFile);
    status = true;
catch
    status = false;
end

end