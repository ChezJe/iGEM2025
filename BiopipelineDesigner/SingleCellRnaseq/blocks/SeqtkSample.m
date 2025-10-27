classdef SeqtkSample < bioinfo.pipeline.Block
    % downsample fastq/fastq files
    %
    % example:
    % b = SeqtkSample(RngSeed=10);
    % b.eval(struct("InputFile", "SRR6008575_10k_1.fq"))
    properties (SetObservable)
        TwoPassMode logical {mustBeScalarOrEmpty}
        RngSeed double {mustBeScalarOrEmpty}
        BinLoc string {mustBeScalarOrEmpty}
    end
    
    methods
        function obj = SeqtkSample(NVPArgs)
            arguments
                NVPArgs.TwoPassMode (1,1) logical
                NVPArgs.RngSeed (1,1) double
                NVPArgs.BinLoc (1,1) string
            end
            
            obj.createInput('InputFile');
            obj.Inputs.InputFile.SplitDimension = "all";
            obj.createInput('DownSampleNum');
            obj.createInput('OutputFileName', Required=false);

            obj.createOutput('SampledFile');

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

            % Run seqtk sample
            if isfield(inputStruct, "OutputFileName")
                outputFileFullPath = seqtkSample(inputStruct.InputFile, inputStruct.DownSampleNum, inputStruct.OutputFileName, nvpArgs{:});
            else
                outputFileFullPath = seqtkSample(inputStruct.InputFile, inputStruct.DownSampleNum, nvpArgs{:});
            end

            % Create output struct
            outputStruct.SampledFile = bioinfo.pipeline.datatypes.File(outputFileFullPath);
        end
    end
end
% Copyright 2021-2024 The MathWorks, Inc.

