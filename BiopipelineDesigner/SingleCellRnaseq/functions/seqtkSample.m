function outputFileFullPath = seqtkSample(inputFile, downSampleNum, outputFileName, NVPArgs)
% downsample fastq/fastq files
%
% example:
% seqtkSample("SRR6008575_10k_1.fq", 4)
% seqtkSample("SRR6008575_10k_1.fq", .4, "SRR6008575_10k_1.downsample.4.fq")
arguments (Input)
    inputFile (1,1) string
    downSampleNum (1,1) double % fraction or scalar
    outputFileName string {mustBeScalarOrEmpty(outputFileName)} = string.empty; % if "", append ".seqtkSample" before inputFile extension
    NVPArgs.TwoPassMode (1,1) logical = false
    NVPArgs.RngSeed (1,1) double {mustBeScalarOrEmpty, mustBePositive} = 11
    NVPArgs.BinLoc (1,1) string = "/System/Volumes/Data/mathworks/devel/bat/filer/batfs0503-0/biostore/tools/seqtk/"
end

% get binary loc (if available)
fullexe = fullfile(NVPArgs.BinLoc, "seqtk");
if ~isfile(fullexe)
    error("Binaries not found. Download here: https://github.com/lh3/seqtk");
end
NVPArgs = rmfield(NVPArgs, "BinLoc");

% Contruct args
args = "";
fields = string(fieldnames(NVPArgs));
for i = 1:numel(fields)
    switch fields(i)
        case "TwoPassMode"
            if NVPArgs.(fields(i))
                args = args + " -2";
            end

        case "RngSeed"
            args = args + sprintf(" -s %i", NVPArgs.(fields(i)));
    end
end

% Contruct outputfilename
if isempty(outputFileName)
    [~,name,ext] = fileparts(inputFile);
    outputFileName = name + ".seqtkSample" + ext;
end

% Construct full input file name
fullPathInputFile = bioinfo.internal.getCanonicalFilepath(inputFile);
if isequal(fullPathInputFile, "")
    error("inputFile not found")
end

% run function
cmd = sprintf("%s sample %s %s %f > %s", fullexe, args, fullPathInputFile, downSampleNum, outputFileName);
[status,cmdout] = system(cmd);
if status
    error(cmdout);
end

% get outputs
outputFileFullPath = bioinfo.internal.getCanonicalFilepath(outputFileName);
end