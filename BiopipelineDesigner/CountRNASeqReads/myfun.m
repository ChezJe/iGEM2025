function myfun(inputArg1)

if ~isempty(inputArg1)
    rootFile = "C:\Users\jhuard\OneDrive - MathWorks\Demos\bioinfo\BiopipelineDesigner\CountRNASeqReadsWithBiopipelineDesignerExample";
    pyrunfile(fullfile(pwd,"plotQC.py"),filename=inputArg1);

    % seqqcplot(inputArg1,'QualityBoxplot');
    seqqcplot(inputArg1);
    title("MATLAB plot")
end

end
