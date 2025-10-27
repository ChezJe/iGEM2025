function [seqs, ID] = filterSeqs(seqs, ID)

arguments
    seqs string
    ID string
end

[seqs,TF] = rmmissing(seqs);
ID(TF) = [];

idxl = strlength(seqs) <= 10;
r = regexp(seqs,'[^A-Z]','once');
idxr = cellfun(@length,r) > 0;

idx = idxl | idxr;
seqs(idx) = [];
ID(idx) = [];


end