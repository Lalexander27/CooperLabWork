import sys

def geneIntervals(intervals, geneLoci, annotation):
	with open(intervals) as inter:
		#prepare list of tuples for intervals
		keyIntervals = []
		for count, line in enumerate(inter):
			#pull out chromosomes and intervals that were significant
			if count > 0:
				line = line.rstrip().split(",")
				keyIntervals.append((line[0], line[1]))

	with open("GenesInIntervalsTEST.txt", "w") as genes:
	#header for tsv
		genes.write("Chromosome\tFeature\tStart\tEnd\tGene ID\tPac ID\tTranscript ID\tGO\tArabidopsis Gene\tArabi. Symbol\tArabi. Description\tRice Gene\tRice Symbol\tRice Description\n")
	
		print(keyIntervals)
		for interval in keyIntervals:
			print(interval)
			startIntv = (int(interval[1])) * 1000000
			endIntv = int(startIntv) + 1000000

			with open(geneLoci) as loci:
				#this is the gff file that has gene loci

				for lineLoci in loci:
					#skip headers with #
					if not lineLoci.startswith("#"):
						lineLoci = lineLoci.rstrip().split("\t")

						#check that it's the same chromosome
						if lineLoci[0] == interval[0] and int(lineLoci[3]) >= startIntv and int(lineLoci[4]) <= endIntv and lineLoci[2] in ("gene"):
							#if the gene has an ID, list it

							if lineLoci[8].find("ID=") != -1:
								fullID = lineLoci[8].split("ID=")[1].split(";")[0]
								geneID = fullID.split(".")[0] + "." + fullID.split(".")[1]
							
								if not (fullID.split(".")[2].startswith("v3")):
									geneID += "." + fullID.split(".")[2]

							else:
								geneID = "-"

							#if the gene has a pac id, list it 
	
							if lineLoci[8].find("pacid=") != -1:
								pacID = lineLoci[8].split("pacid=")[1]
							else:
								pacID = "-"

							with open(annotation) as annot:
								for line in annot:
									if not line.startswith("#"):
										line = line.rstrip().split("\t")

										if pacID == line[0] or geneID == line[1] or geneID == line[2]:

											transcriptID, GO, arabiNam, arabiSym, arabiDef, riceNam, riceSym, riceDef = line[2], line[9], line[10], line[11], line[12], line[13], line[14], line[15] + "\n"
											if pacID == "-":
												pacID = line[0]
											break
										else:
											transcriptID, GO, arabiNam, arabiSym, arabiDef, riceNam, riceSym, riceDef = "-", "-", "-", "-", "-", "-", "-", "-\n"

							#write out all parts of header
							newLine = [lineLoci[0], lineLoci[2], lineLoci[3], lineLoci[4], geneID, pacID, transcriptID, GO, arabiNam, arabiSym, arabiDef, riceNam, riceSym, riceDef]
							genes.write("\t".join(newLine))
						
def main():
	#user sys.argv to pull arguments from the command line.  Note that arguments are all strings and index 0 is just the file name.  I designed this so that the first argument is the file name and second argument is the number 
	try:
		intervalFile = sys.argv[1]
		print(intervalFile.split(".")[1])
		geneLocations = sys.argv[2]
		print(geneLocations.split(".")[1])
		annotationText = sys.argv[3]
		print(annotationText.split(".")[1])
		if intervalFile.split(".")[1] != "csv" or geneLocations.split(".")[1] not in ("gff", "gff3"):
			raise ValueError
	except ValueError:
		print(f'Please check extensions of files.')
	else:
		geneIntervals(intervalFile, geneLocations, annotationText)

if __name__ == '__main__':
	main()
