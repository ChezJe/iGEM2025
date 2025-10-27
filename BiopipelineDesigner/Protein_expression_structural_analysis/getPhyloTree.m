function [phylotree, f] = getPhyloTree(distances, IDs)

arguments
    distances double
    IDs (1,:) string
end

phylotree = seqlinkage(distances,'average',IDs);
plot(phylotree);
f = gcf;
end