function ids = preProcessID(ids, options)

arguments
    ids (:,1) string
    options.Nout (1,1) double = NaN
end

ids = strtrim(string(split(strtrim(ids), ',')));
if ~isnan(options.Nout)
    N = min(options.Nout,numel(ids));
    ids = ids(randperm(numel(ids), N));
end

end