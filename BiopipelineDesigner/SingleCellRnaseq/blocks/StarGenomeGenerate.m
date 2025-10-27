classdef StarGenomeGenerate < bioinfo.pipeline.Block
    % generate STAR indices
    %
    % example:
    % b = StarGenomeGenerate(runThreadN=2);
    % b.eval(struct("GenomeFastaFiles", "Dmel_chr4.fa"))
    properties (SetObservable)
        runThreadN double {mustBeScalarOrEmpty}
        sjdbGTFfile string {mustBeScalarOrEmpty}
        sjdbOverhand double {mustBeScalarOrEmpty}
        BinLoc string {mustBeScalarOrEmpty}
    end
    
    methods
        function obj = StarGenomeGenerate(NVPArgs)
            arguments
                NVPArgs.runThreadN (1,1) double
                NVPArgs.sjdbGTFfile (1,1) string
                NVPArgs.sjdbOverhand (1,1) double
                NVPArgs.BinLoc (1,1) string
            end
            
            obj.createInput('GenomeFastaFiles');
            obj.createInput('GenomeDir', Required=false);

            obj.createOutput('GenomeDir');

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

            % Run STAR genomeGenerate sample
            if isfield(inputStruct, "GenomeDir")
                genomeDir = starGenomeGenerate(inputStruct.GenomeFastaFiles, inputStruct.GenomeDir, nvpArgs{:});
            else
                genomeDir = starGenomeGenerate(inputStruct.GenomeFastaFiles, nvpArgs{:});
            end

            % Create output struct
            outputStruct.GenomeDir = genomeDir;
        end
    end
end
% Copyright 2021-2024 The MathWorks, Inc.

