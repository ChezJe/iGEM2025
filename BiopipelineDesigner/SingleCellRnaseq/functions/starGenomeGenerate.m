function genomeDir = starGenomeGenerate(genomeFastaFiles, genomeDir, NVPArgs)
% generate STAR index files
%
% examples:
% starGenomeGenerate("Dmel_chr4.fa")
arguments
    genomeFastaFiles (:,1) string
    genomeDir (1,1) string = pwd
    NVPArgs.runThreadN (1,1) double
    NVPArgs.sjdbGTFfile (1,1) string
    NVPArgs.sjdbOverhand (1,1) double
    NVPArgs.BinLoc (1,1) string = "/System/Volumes/Data/mathworks/devel/bat/filer/batfs0503-0/biostore/tools/STAR/STAR_2.7.11b/MacOSX_x86_64" % custom NVP
end

% get binary loc (if available)
fullexe = fullfile(NVPArgs.BinLoc, "STAR");
if ~isfile(fullexe)
    error("Binaries not found. Download here: https://github.com/alexdobin/STAR/releases/download/2.7.11b/STAR_2.7.11b.zip");
end
NVPArgs = rmfield(NVPArgs, "BinLoc");

% Construct full input fasta file name
fullPathInputFile = bioinfo.internal.getCanonicalFilepath(genomeFastaFiles);
if any(strcmp(fullPathInputFile, ""))
    error("genomeFastaFiles not found")
end

% Contruct args
NVPArgs.genomeFastaFiles = genomeFastaFiles;
NVPArgs.genomeDir = genomeDir;
args = "";
fields = string(fieldnames(NVPArgs));
for i = 1:numel(fields)
    switch fields(i)
        case "genomeFastaFiles"
            args = args + sprintf(" --%s %s", fields(i), strjoin(bioinfo.internal.getCanonicalFilepath(NVPArgs.(fields(i))), " "));

        case {'runThreadN', 'sjdbOverhand'}
            args = args + sprintf(" --%s %i", fields(i), NVPArgs.(fields(i)));

        otherwise % string
            args = args + sprintf(" --%s %s", fields(i), NVPArgs.(fields(i)));
    end
end

% run function
cmd = strjoin([fullexe, "--runMode genomeGenerate", args], " ");
[status,cmdout] = system(cmd);
if status
    error(cmdout);
end

% get outputs
genomeDir = NVPArgs.genomeDir;
end