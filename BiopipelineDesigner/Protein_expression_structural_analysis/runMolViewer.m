function h = runMolViewer(molstructcell, options)

arguments
    molstructcell cell
    options.N (1,1) double = 1
end

h = molviewer(molstructcell{options.N});

evalrasmolscript(h, ['spacefill off; wireframe off; ' ...
                      'restrict protein; cartoon on; color structure; ' ...
                      'center selected;']);


end