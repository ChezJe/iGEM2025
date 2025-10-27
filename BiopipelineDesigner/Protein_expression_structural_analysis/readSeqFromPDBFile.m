function seq = readSeqFromPDBFile(fn, status)

arguments
    fn (1,1) string
    status (1,1) logical = true
end

if status
    s = pdbread(fn);

    % grab longest chain
    l = [s.Sequence.NumOfResidues];
    [~,idx] = max(l);
    seq = string(s.Sequence(idx).Sequence);
else
    seq = string(missing);
end

end