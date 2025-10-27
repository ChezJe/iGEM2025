function [alignmentFile, geneTableFiltered, geneTableRaw, summaryTable] = starSolo(genomeDir, readFilesIn, soloCBwhitelist, soloType, NVPArgs)
% align single-cell RNA-seq
%
% examples:
% starSolo()

% /path/to/STAR --genomeDir /path/to/genome/dir/ --readFilesIn ...  [...other parameters...] --soloType ... --soloCBwhitelist ...
arguments
    genomeDir (1,1) string
    readFilesIn (:,:) string % first row = reads1, second row (if applicable) = reads2
    soloCBwhitelist (1,1) string
    soloType (1,1) string = "CB_UMI_Simple" % Droplet?
    NVPArgs.runThreadN (1,1) double
    NVPArgs.sjdbGTFfile (1,1) string
    NVPArgs.sjdbOverhand (1,1) double
    NVPArgs.soloUMIlen (1,1) double {mustBePositive}
    NVPArgs.soloCBstart (1,1) double {mustBePositive}
    NVPArgs.soloCBlen (1,1) double {mustBePositive}
    NVPArgs.soloUMIstart (1,1) double {mustBePositive}
    NVPArgs.soloStrand (1,1) string {mustBeMember(NVPArgs.soloStrand, ["Unstranded", "Forward", "Reverse"])}
    NVPArgs.soloFeatures (1,1) string {mustBeMember(NVPArgs.soloFeatures, ["Gene", "SJ"])}
    NVPArgs.soloUMIdedup (1,1) string {mustBeMember(NVPArgs.soloUMIdedup, ["1MM_All", "1MM_Directional", "1MM_NotCollapsed"])}
    NVPArgs.soloOutFileNames (1,:) string % [file name prefix, barcode sequences, , gene IDs and names, cell/gene counts matrix, cell/splice junction counts matrix]
    NVPArgs.outSAMtype (1,:) string % e.g. ["BAM" "Unsorted" "SortedByCoordinate"]
    % NVPArgs.BinLoc (1,1) string = "/System/Volumes/Data/mathworks/devel/bat/filer/batfs0503-0/biostore/tools/STAR/STAR_2.7.11b/MacOSX_x86_64" % custom NVP
    NVPArgs.BinLoc (1,1) string = "/Users/sronquis/tools/STAR_pre_releases-2.7.11b_alpha_2024-02-09/source"
end

% get binary loc (if available)
fullexe = fullfile(NVPArgs.BinLoc, "STAR");
if ~isfile(fullexe)
    error("Binaries not found. Download here: https://github.com/alexdobin/STAR/releases/download/2.7.11b/STAR_2.7.11b.zip");
end
NVPArgs = rmfield(NVPArgs, "BinLoc");

% Contruct args
NVPArgs.genomeDir = genomeDir;
NVPArgs.readFilesIn = readFilesIn;
NVPArgs.soloCBwhitelist = soloCBwhitelist;
NVPArgs.soloType = soloType;
args = "";
fields = string(fieldnames(NVPArgs));
for i = 1:numel(fields)
    switch fields(i)
        case "readFilesIn"
            reads = strings(height(NVPArgs.(fields(i))), 1);
            for ii = 1:height(NVPArgs.(fields(i)))
                reads(ii) = strjoin(bioinfo.internal.getCanonicalFilepath(NVPArgs.(fields(i))(ii,:)), ",");
            end
            args = args + sprintf(" --%s %s", fields(i), strjoin(reads, " "));

        case {'runThreadN', 'sjdbOverhand', 'soloUMIlen', 'soloCBstart', 'soloCBlen', 'soloUMIstart'} % int
            args = args + sprintf(" --%s %i", fields(i), NVPArgs.(fields(i)));

        otherwise % string and strings
            args = args + sprintf(" --%s %s", fields(i), strjoin(NVPArgs.(fields(i)), " "));
    end
end

% run function
cmd = strjoin([fullexe, args], " "); % --soloType Droplet turns on SOLO mode
[status,cmdout] = system(cmd);
if status
    error(cmdout);
end

% get outputs
d = dir(".");
allFullFilenames = string(fullfile({d.folder}, {d.name}))';

% alignment file
alignmentFilesIdx = endsWith(allFullFilenames, (".bam"|"sam"));
alignmentFile = allFullFilenames(alignmentFilesIdx);

% summary table
geneTableFiltered = [];
geneTableRaw = [];
summaryTable = [];
if isfolder("Solo.out/Gene")
    summaryTable = readtable("Solo.out/Gene/Summary.csv");

    filteredData = readtable("Solo.out/Gene/filtered/matrix.mtx", FileType="text",ReadVariableNames=true);
    filteredFeatures = readtable("Solo.out/Gene/filtered/features.tsv", FileType="text", ReadVariableNames=false);
    filteredBarcode = readtable("Solo.out/Gene/filtered/barcodes.tsv", FileType="text", ReadVariableNames=false);
    geneTableFiltered = array2table(full(sparse(filteredData{:,1}, filteredData{:,2}, filteredData{:,3})), RowNames=string(filteredFeatures{:,1}), VariableNames=string(filteredBarcode{:,1}));

    rawData = readtable("Solo.out/Gene/raw/matrix.mtx", FileType="text",ReadVariableNames=true);
    rawFeatures = readtable("Solo.out/Gene/raw/features.tsv", FileType="text", ReadVariableNames=false);
    rawBarcode = readtable("Solo.out/Gene/raw/barcodes.tsv", FileType="text", ReadVariableNames=false);
    % geneTableRaw = array2table(full(sparse(rawData{:,1}, rawData{:,2}, rawData{:,3})), RowNames=string(rawFeatures{:,1}), VariableNames=string(rawBarcode{:,1}));
    geneTableRaw = table.empty; % Too big
end

end