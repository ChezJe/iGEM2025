function out = plotCounts(fcCountsTable,cufflinksGenesFPKMFile)

    genesFPKMTable = readtable(cufflinksGenesFPKMFile, FileType="text");
    
    % Plot counts of genes identified by Cufflinks.
    f1 = figure;
    geneNames = categorical(fcCountsTable.ID,fcCountsTable.ID);
    stem(geneNames, log2(fcCountsTable.Aligned_sorted))
    xlabel("Cufflinks-identified genes")
    ylabel("log2 counts")
    
    % Plot counts along their respective genomic positions.
    geneStart = str2double(extractBetween(genesFPKMTable.locus,":","-"));

    f2 = figure;
    stem(geneStart, log2(fcCountsTable.Aligned_sorted))
    xlabel("Drosophila Chromosome 4 Genomic Position")
    ylabel("log2 counts")

    % keep figure handles as output to save them with the results
    out = [f1; f2];

end

