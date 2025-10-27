function [files, status] = predictStructureAlphafoldEBI(ids)
% Downloads a structure prediction from the alphaFold DB hosted by EBI.
% It takes UniProt accession numbers and saves files with the 
% accession number as name and the extension '.pdb'

url = "https://alphafold.ebi.ac.uk/api/prediction/";
key = "AIzaSyCeurAJz7ZGjPQUtEaerUkBZ3TaBkXrY94";

try
    files = strings(numel(ids),1);
    for idx=1:numel(ids)
        currentID = ids(idx);

        % send request
        pred = webread(url + currentID,'key',key);

        % download resulting PDB file
        outfilename = websave(currentID + ".pdb",pred.pdbUrl);

        files(idx) = outfilename;
    end
    status = "success";
catch
    status = "error for " + currentID;
    files = string(missing);
end

predStructure = struct;
predStructure.Status = status;
predStructure.Files = files;

if nargout == 1
    files = predStructure;
end

end
