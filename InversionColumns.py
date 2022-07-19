import sys

def addColumns(filename, strainName):
	#This is intended to open a file of Duplications from processed SyRI VCF files
	outFirst = filename.rstrip().split(".")[0] + "_Mergable.vcf"

	with open(filename) as inputFile:
		with open(outFirst, "w") as outputFile:

			for count, line in enumerate(inputFile):
				line = line.rstrip()
				listColumns = line.split("\t")

				if count == 0:
					#If the informational headers have been removed, then reprint them
					if listColumns[0].startswith("#CHROM"):
						outputFile.write("##fileformat=VCFv4.3\n##fileDate=20220320\n##source=syri\n##ALT=<ID=SYN,Description='Syntenic region'>\n##ALT=<ID=INV,Description='Inversion'>\n##ALT=<ID=TRANS,Description='Translocation'>\n##ALT=<ID=INVTR,Description='Inverted Translocation'>\n##ALT=<ID=DUP,Description='Duplication'>\n##ALT=<ID=INVDP,Description='Inverted Duplication'>\n##ALT=<ID=SYNAL,Description='Syntenic alignment'>\n##ALT=<ID=INVAL,Description='Inversion alignment'>\n##ALT=<ID=TRANSAL,Description='Translocation alignment'>\n##ALT=<ID=INVTRAL,Description='Inverted Translocation alignment'>\n##ALT=<ID=DUPAL,Description='Duplication alignment'>\n##ALT=<ID=INVDPAL,Description='Inverted Duplication alignment'>\n##ALT=<ID=HDR,Description='Highly diverged regions'>\n##ALT=<ID=INS,Description='Insertion in non-reference genome'>\n##ALT=<ID=DEL,Description='Deletion in non-reference genome'>\n##ALT=<ID=CPG,Description='Copy gain in non-reference genome'>\n##ALT=<ID=CPL,Description='Copy loss in non-reference genome'>\n##ALT=<ID=SNP,Description='Single nucleotide polymorphism'>\n##ALT=<ID=TDM,Description='Tandem repeat'>\n##ALT=<ID=NOTAL,Description='Not Aligned region'>\n##INFO=<ID=END,Number=1,Type=Integer,Description='End position on reference genome'>\n##INFO=<ID=ChrB,Number=1,Type=String,Description='Chromoosme ID on the non-reference genome'>\n##INFO=<ID=StartB,Number=1,Type=Integer,Description='Start position on non-reference genome'>\n##INFO=<ID=EndB,Number=1,Type=Integer,Description='End position on non-reference genome'>\n##INFO=<ID=Parent,Number=1,Type=String,Description='ID of the parent SR'>\n##INFO=<ID=VarType,Number=1,Type=String,Description='Start position on non-reference genome'>\n##INFO=<ID=DupType,Number=1,Type=String,Description='Copy gain or loss in the non-reference genome'>\n##FORMAT=<ID=GT,Number=1,Type=String,Description='Genotype'>\n")
					
					strainName += "\n"
					#Add Format and strain to column headers
					listColumns.append("Format")
					listColumns.append(strainName)
					outputFile.write("\t".join(listColumns))
					continue

				else:
					#For each line, add "GT" for genotype and "1/1" indicating that the allele is present in the strain
					listColumns.append("GT")
					listColumns.append("1/1\n")
					outputFile.write("\t".join(listColumns))
def main():
	#user sys.argv to pull arguments from the command line.  Note that arguments are all strings and index 0 is just the file name.  I
	#index 1 should be the file to process and index 2 should be the name of sorghum strain (e.g. "CA" or "leoti") 
	fileName = sys.argv[1]
	strainName = sys.argv[2]
	addColumns(fileName, strainName)

if __name__ == '__main__':
	main()
