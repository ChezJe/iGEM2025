classdef Cat < bioinfo.pipeline.Block

    properties (SetObservable)
        Dimension (1,1) double = 1
    end

    properties (Dependent, SetObservable)
        InputNames
        OutputName
    end

    methods
        function obj = Cat(propArgs)
            arguments
                propArgs.?Cat
            end

            obj.createInput("Input1");
            obj.createInput("Input2");
            obj.createOutput("Output");
            obj.setBlockProperties(propArgs);
        end

        function outputStruct = eval(obj, inputStruct)
            in = struct2cell(inputStruct);
            outputStruct = struct();
            outputStruct.(obj.OutputName) = cat(obj.Dimension, in{:});
        end

        function set.InputNames(obj, val)
            arguments
                obj
                val (:,1) string {bioinfo.pipeline.internal.Validation.mustBeUnique, mustBeValidVariableName}
            end

            % Assume that overlapping positions in the new value are
            % renamed Inputs, rather than new Inputs
            newInputs = struct();
            numRenamedInputs = min(numel(obj.InputNames), numel(val));

            for ra = 1:numRenamedInputs
                % Move existing Input ports.
                newInputs.(val(ra)) = obj.Inputs.(obj.InputNames(ra));
            end

            % Add any extra Inputs
            for na = numRenamedInputs+1:numel(val)
                newInputs.(val(na)) = bioinfo.pipeline.Input;
            end
            obj.Inputs = newInputs;
        end

        function vars = get.InputNames(obj)
            vars = string(fieldnames(obj.Inputs));
        end

        function set.OutputName(obj, val)
            arguments
                obj
                val (1,1) string {mustBeValidVariableName}
            end

            obj.Outputs = cell2struct(struct2cell(obj.Outputs), val);
        end

        function vars = get.OutputName(obj)
            vars = string(fieldnames(obj.Outputs));
        end
    end
end

%   Copyright 2024 The MathWorks, Inc.