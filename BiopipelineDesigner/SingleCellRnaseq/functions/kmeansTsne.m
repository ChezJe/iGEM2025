function fig = kmeansTsne(dataTable, k, seed)
arguments
    dataTable 
    k (1,1) double
    seed double {mustBeScalarOrEmpty, mustBePositive, mustBeInteger} = []
end

if ~isempty(seed)
    rng(seed)
end
Y = tsne(dataTable{:,:}');
fig = figure;
gscatter(Y(:,1),Y(:,2), kmeans(Y, k));
end