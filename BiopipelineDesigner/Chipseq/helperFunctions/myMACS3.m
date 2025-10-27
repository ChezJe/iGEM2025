function [narrowPeaksBedFile] = myMACS3(treatment, control)
    arguments
        treatment (1,1) string
        control (1,1) string
    end

    % macs3 callpeak
    macs3Dir = "/home/matlab/MACS3env/bin/";
    macs3Options = "--format BAM --gsize 4639675 --bw 400 --keep-dup 1 --bdg --nomodel --extsize 200 -n SRR576933";

    [status,cmdout] = system(sprintf("%smacs3 callpeak -t %s -c %s %s", macs3Dir, treatment, control, macs3Options));
    if status
        error("Native macs3 error:\n\n%s", cmdout);
    end

    % grab output narrowPeaks files (rename to bed file for genomics view)
    narrowPeaksFile = bioinfo.internal.getCanonicalFilepath(dir("*.narrowPeak").name);
    narrowPeaksBedFile = narrowPeaksFile+".bed";
    copyfile(narrowPeaksFile, narrowPeaksBedFile);
    narrowPeaksBedFile = bioinfo.pipeline.datatype.File(narrowPeaksBedFile);
end