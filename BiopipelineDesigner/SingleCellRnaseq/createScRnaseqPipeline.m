%% Set-up
% uncomment this line if the tools are not installed
% setup

% addpaths
addpath("blocks/");
addpath("functions/");
addpath("data/");
addpath(genpath("tools/"));

%% create blocks
% SRA
sraB = bioinfo.pipeline.block.SRAFasterqDump(NumThreads=8);
sraB.Options.SplitType = "SplitFiles";
sraB.Options.IncludeTechnical = true;
sraB.Inputs.SRRID.Value = "ERR11871103"; % Read3 = barcode, Read4 = cDNA

% cat
catB = Cat;

% seqtk
seqtkB = SeqtkSample();
seqtkB.Inputs.InputFile.SplitDimension = "all";
seqtkB.RngSeed = 100;
seqtkB.BinLoc = fullfile(pwd, "tools/seqtk/seqtk-1.4");
seqtkB.Inputs.DownSampleNum.Value = .1; % 10% of reads

% STAR genome generate
mm10GTF = which("data/gencode.vM23.primary_assembly.annotation.gtf");
mm10Fa = which("data/Mus_musculus.GRCm38.dna.primary_assembly.fa");

if ismac
    if ~isempty(getenv('MWE_INSTALL'))
        starBinLoc = "/System/Volumes/Data/mathworks/devel/bat/filer/batfs0503-0/biostore/tools/STAR/STAR_pre_releases-2.7.11b_alpha_2024-02-09"; % fixed version of STAR for arm mac
    else
        starBinLoc = fullfile(pwd, "tools/STAR/STAR_2.7.11b/MacOSX_x86_64");
    end
elseif isunix
    starBinLoc = fullfile(pwd, "tools/STAR/STAR_2.7.11b/Linux_x86_64_static");
else
    error("STAR does not run on Windows (and this pipeline is not set up for WSL)")
end

starGenomeGenerateB = StarGenomeGenerate(sjdbGTFfile=mm10GTF, runThreadN=8);
starGenomeGenerateB.Inputs.GenomeFastaFiles.Value = mm10Fa;
starGenomeGenerateB.BinLoc = starBinLoc;

% STARSOLO
barcodeFile = which("data/3M-february-2018.txt");

starSoloB = StarSolo(runThreadN=8);
starSoloB.Inputs.SoloCBwhitelist.Value = barcodeFile;
starSoloB.soloUMIlen = 12;
starSoloB.BinLoc = starBinLoc;

% kmeans t-SNE
tSneClusteringB = bioinfo.pipeline.block.UserFunction(@kmeansTsne, RequiredArguments=["dataTable", "k", "seed"], OutputArguments="fig");
tSneClusteringB.Inputs.k.Value = 4;
tSneClusteringB.Inputs.seed.Value = 1;

%% Construct pipeline
p = bioinfo.pipeline.Pipeline;
p.addBlock([sraB, catB, seqtkB, starGenomeGenerateB, starSoloB, tSneClusteringB], ["sra", "cat", "seqtk", "starGenomeGenerate", "starSolo", "tSneClustering"]);

p.connect(sraB, catB, ["Reads_4","Input1"]);
p.connect(sraB, catB, ["Reads_3","Input2"]);
p.connect(catB, seqtkB, ["Output","InputFile"]);
p.connect(seqtkB, starSoloB, ["SampledFile","ReadFilesIn"]);
p.connect(starGenomeGenerateB, starSoloB, ["GenomeDir","GenomeDir"]);
p.connect(starSoloB, tSneClusteringB, ["GeneTableFiltered","dataTable"]);

%% Open in app
biopipelineDesigner(p)

%%