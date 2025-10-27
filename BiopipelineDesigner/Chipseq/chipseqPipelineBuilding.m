%% Example of a Chip-seq analysis pipeline defined programmatically

%% Set up
addpath("helperFunctions/")

%% Create Blocks
fasterqDumpBlock = bioinfo.pipeline.block.SRAFasterqDump;
fasterqDumpBlock.Inputs.SRRID.Value = ["SRR576933", "SRR576938"];

seqqcplotBlock = bioinfo.pipeline.block.UserFunction(@seqqcplot, RequiredArguments="FastqFile", OutputArguments="Seqqcplot");
seqqcplotBlock.Inputs.FastqFile.SplitDimension = "all";

refGenomeFileBlock = bioinfo.pipeline.block.FileChooser;
refGenomeFileBlock.Files = "https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2/GCF_000005845.2_ASM584v2_genomic.fna.gz";

bwaIndexBlock = bioinfo.pipeline.block.BwaIndex;
bwaMemBlock = bioinfo.pipeline.block.BwaMEM;
bwaMemBlock.Inputs.Reads1File.SplitDimension = "all";

sam2bamBlock = bioinfo.pipeline.block.UserFunction(@sam2bam, RequiredArguments="SAMFile", OutputArguments="BAMFile");
sam2bamBlock.Inputs.SAMFile.SplitDimension = "all";
splitBlock = bioinfo.pipeline.block.UserFunction(@splitFQs, RequiredArguments="Files", OutputArguments=["SplitFile1", "SplitFile2"]);

macs3Block = bioinfo.pipeline.block.UserFunction(@myMACS3, RequiredArguments=["Treatment", "Control"], OutputArguments="BedFile");

gunzipBlock = bioinfo.pipeline.block.UserFunction(@gunzip, RequiredArguments="ZippedFile", OutputArguments="UnzippedFile");
geneTracksFileBlock = bioinfo.pipeline.block.FileChooser;
geneTracksFileBlock.Files = pwd+"/localFiles/ASM584v1RefSeq.gtf";
fileJoinerBlock = bioinfo.pipeline.block.UserFunction(@(x,y,z) vertcat(x,y,z), RequiredArguments=["File1", "File2", "File3"], OutputArguments="JoinedFiles");
genomicsViewerBlock = bioinfo.pipeline.block.GenomicsViewer;

motifCoverageBlock = bioinfo.pipeline.block.UserFunction(@motifCoverage, RequiredArguments=["BAMFile", "ReferenceFASTAFile"], NameValueArguments=["motif", "range"], OutputArguments=["CoveragePlot", "MotifLocations"]);

%% Build Pipeline
p = bioinfo.pipeline.Pipeline;
p.addBlock([fasterqDumpBlock, refGenomeFileBlock, bwaIndexBlock, bwaMemBlock, macs3Block, genomicsViewerBlock, splitBlock, gunzipBlock, geneTracksFileBlock, fileJoinerBlock, seqqcplotBlock, sam2bamBlock, motifCoverageBlock],...
    ["fasterqDump", "refGenome", "bwaIndex", "bwaMem", "macs3UF", "genomicsViewer", "fileSplitterUF", "gunzipBlockUF", "geneTracks", "fileJoinerUF", "seqqcplotUF", "sam2bamUF", "motifCoverageUF"]);

p.connect(fasterqDumpBlock, bwaMemBlock, ["Reads", "Reads1File"]);
p.connect(fasterqDumpBlock, seqqcplotBlock, ["Reads", "FastqFile"]);

p.connect(refGenomeFileBlock, bwaIndexBlock, ["Files", "ReferenceFASTAFile"]);
p.connect(bwaIndexBlock, bwaMemBlock, ["IndexBaseName", "IndexBaseName"]);

p.connect(bwaMemBlock, sam2bamBlock, ["SAMFile", "SAMFile"]);
p.connect(sam2bamBlock, splitBlock, ["BAMFile", "Files"]);
p.connect(splitBlock, macs3Block, ["SplitFile1", "Treatment"]);
p.connect(splitBlock, macs3Block, ["SplitFile2", "Control"]);

p.connect(macs3Block, fileJoinerBlock, ["BedFile", "File1"]);
p.connect(geneTracksFileBlock, fileJoinerBlock, ["Files", "File2"]);
p.connect(splitBlock, fileJoinerBlock, ["SplitFile1", "File3"]);
p.connect(fileJoinerBlock, genomicsViewerBlock, ["JoinedFiles", "Tracks"]);

p.connect(refGenomeFileBlock, gunzipBlock, ["Files", "ZippedFile"]);
p.connect(gunzipBlock, genomicsViewerBlock, ["UnzippedFile", "Reference"]);

p.connect(splitBlock, motifCoverageBlock, ["SplitFile1", "BAMFile"]);
p.connect(gunzipBlock, motifCoverageBlock, ["UnzippedFile", "ReferenceFASTAFile"]);

biopipelineDesigner(p)

