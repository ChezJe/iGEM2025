classdef StarSolo < bioinfo.pipeline.Block
    % align single-cell RNA-seq
    %
    % examples:
    % starSolo()
    properties (SetObservable)
        runThreadN double
        sjdbGTFfile string
        sjdbOverhand double
        soloUMIlen double {mustBePositive}
        soloCBstart double {mustBePositive}
        soloCBlen double {mustBePositive}
        soloUMIstart double {mustBePositive}
        soloStrand string {mustBeMember(soloStrand, ["Unstranded", "Forward", "Reverse"])}
        soloFeatures string {mustBeMember(soloFeatures, ["Gene", "SJ"])}
        soloUMIdedup string {mustBeMember(soloUMIdedup, ["1MM_All", "1MM_Directional", "1MM_NotCollapsed"])}
        soloOutFileNamesstring % [file name prefix, barcode sequences, , gene IDs and names, cell/gene counts matrix, cell/splice junction counts matrix]
        outSAMtypestring % e.g. ["BAM" "Unsorted" "SortedByCoordinate"]
        % BinLoc string = "/System/Volumes/Data/mathworks/devel/bat/filer/batfs0503-0/biostore/tools/STAR/STAR_2.7.11b/MacOSX_x86_64" % custom NVP
        BinLoc string = "/Users/sronquis/tools/STAR_pre_releases-2.7.11b_alpha_2024-02-09/source" % custom NVP
    end

    methods
        function obj = StarSolo(NVPArgs)
            arguments
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
                NVPArgs.BinLoc (1,1) string = "/Users/sronquis/tools/STAR_pre_releases-2.7.11b_alpha_2024-02-09/source" % custom NVP
            end

            obj.createInput('GenomeDir');
            obj.createInput('ReadFilesIn');
            obj.createInput('SoloCBwhitelist');
            obj.createInput('SoloType', Required=false);

            obj.createOutput('AlignmentFile');
            obj.createOutput('GeneTableFiltered');
            obj.createOutput('GeneTableRaw');
            obj.createOutput('SummaryTable');

            nvpFields = string(fieldnames(NVPArgs));
            for i = 1:numel(nvpFields)
                obj.(nvpFields(i)) = NVPArgs.(nvpFields(i));
            end
        end

        function outputStruct = eval(obj, inputStruct)
            % get block-specific properties
            mc = metaclass(obj);
            isBlockSpecificProp = arrayfun(@(x) strcmp(x.DefiningClass.Name, mc.Name), mc.PropertyList);
            nvpArgNames = string({mc.PropertyList(isBlockSpecificProp).Name});

            nvpArgs = {};
            for i = 1:numel(nvpArgNames)
                if ~isempty(obj.(nvpArgNames(i)))
                    nvpArgs{end+1} = nvpArgNames(i);
                    nvpArgs{end+1} = obj.(nvpArgNames(i));
                end
            end

            % Run STAR SOLO
            if isfield(inputStruct, "soloType")
                [alignmentFile, geneTableFiltered, geneTableRaw, summaryTable] = starSolo(inputStruct.GenomeDir, inputStruct.ReadFilesIn, inputStruct.SoloCBwhitelist, inputStruct.SoloType, nvpArgs{:});
            else
                [alignmentFile, geneTableFiltered, geneTableRaw, summaryTable] = starSolo(inputStruct.GenomeDir, inputStruct.ReadFilesIn, inputStruct.SoloCBwhitelist, nvpArgs{:});
            end

            % Create output struct
            outputStruct.AlignmentFile = alignmentFile;
            outputStruct.GeneTableFiltered = geneTableFiltered;
            outputStruct.GeneTableRaw = geneTableRaw;
            outputStruct.SummaryTable = summaryTable;
        end
    end
end
% Copyright 2021-2024 The MathWorks, Inc.

