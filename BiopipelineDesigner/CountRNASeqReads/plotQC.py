import pylab
from Bio import SeqIO

for i, record in enumerate(SeqIO.parse(filename, "fastq")):
    if i >= 50:
        break  # trick!
pylab.plot(record.letter_annotations["phred_quality"])
pylab.ylim(0, 45)
pylab.ylabel("PHRED quality score")
pylab.xlabel("Position")
pylab.title("Biopython plot")
pylab.show(block=False)