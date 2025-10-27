function [f, motifStartIdx] = motifCoverage(treatmentBam, refGenome, NVArgs)
arguments
    treatmentBam (1,1) string
    refGenome (1,1) string
    NVArgs.motif (1,1) pattern = "TTGAT"+wildcardPattern(4)+"ATCAA"
    NVArgs.range (1,1) double = 1000
end

% load treatment bam and ref genome
[~, name, ext] = fileparts(treatmentBam);
copyfile(treatmentBam, name + ext)

treatmentBioMapobj = BioMap(name + ext);
referenceFastaStruct = fastaread(refGenome);

% find motif locations within reference genome
motifOffset = 7; % TODO: how to find length of pattern?
motifStartIdx = strfind(referenceFastaStruct.Sequence, NVArgs.motif) + motifOffset;

% get coverage at motif locations
c = zeros(numel(motifStartIdx), NVArgs.range*2+1);
for i = 1:numel(motifStartIdx)
    c(i,:) = treatmentBioMapobj.getBaseCoverage(motifStartIdx(i)-1000, motifStartIdx(i)+1000);
end

% plot motif coverage
f = figure;
plot(-NVArgs.range:NVArgs.range, mean(c,1), LineWidth=1.5);
set(gca,XLimitMethod='padded',YLimitMethod='padded',XGrid='on',YGrid='on');
motifText = strsplit(formattedDisplayText(NVArgs.motif), newline);
xlabel(strip(motifText(2)));
ylabel("Mean Coverage");

end