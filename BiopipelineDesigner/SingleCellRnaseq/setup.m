%% Tools
% seqtk
mkdir("tools/seqtk");
websave("tools/seqtk/seqtk-1.4.zip","https://github.com/lh3/seqtk/archive/refs/tags/v1.4.zip");
unzip("tools/seqtk/seqtk-1.4.zip", "tools/seqtk/");
system("cd tools/seqtk/seqtk-1.4; make");

% STAR
mkdir("tools/STAR");
websave("tools/STAR/STAR_2.7.11b.zip","https://github.com/alexdobin/STAR/releases/download/2.7.11b/STAR_2.7.11b.zip");
unzip("tools/STAR/STAR_2.7.11b.zip", "tools/STAR/");

%% Data
% genome and gtf
mkdir("data");
websave("data/Mus_musculus.GRCm38.dna.primary_assembly.fa.gz","http://ftp.ensembl.org/pub/release-98/fasta/mus_musculus/dna/Mus_musculus.GRCm38.dna.primary_assembly.fa.gz");
gunzip("data/Mus_musculus.GRCm38.dna.primary_assembly.fa.gz", "data/");

websave("data/gencode.vM23.primary_assembly.annotation.gtf.gz","http://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_mouse/release_M23/gencode.vM23.primary_assembly.annotation.gtf.gz");
gunzip("data/gencode.vM23.primary_assembly.annotation.gtf.gz", "data/");

% barcodes
websave("data/3M-february-2018-master.zip","https://github.com/f0t1h/3M-february-2018/archive/refs/heads/master.zip");
unzip("data/3M-february-2018-master.zip", "data/");
gunzip("data/3M-february-2018-master/3M-february-2018.txt.gz", "data/");