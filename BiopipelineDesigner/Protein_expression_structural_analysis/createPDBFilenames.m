function filenames = createPDBFilenames(ID)

pdbfolder = 'C:\Users\jhuard\OneDrive - MathWorks\Demos\bioinfo\BiopipelineDesigner\Protein_expression_structural_analysis\pdbFiles';

filenames = fullfile(pdbfolder,ID+".pdb");

end