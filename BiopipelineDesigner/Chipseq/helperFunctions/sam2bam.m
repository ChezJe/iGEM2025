function [bamFile] = sam2bam(samfile)
    arguments
        samfile (1,1) string
    end

    samtoolsDir = ""; %"/System/Volumes/Data/mathworks/devel/bat/filer/batfs0503-0/biostore/tools/samtools/mac/samtools-1.16.1/";
    [status,cmdout] = system(sprintf("%ssamtools view -bS %s > Aligned.bam", samtoolsDir, samfile));
    if status
        error("Native samtools error:\n\n%s", cmdout);
    end

    bamFile = bioinfo.pipeline.datatype.File(dir("*.bam").name);
end