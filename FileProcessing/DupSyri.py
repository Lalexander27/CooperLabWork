import sys

def Compare(file1, file2, strain):
	with open(file1) as input1:
		title = "ConservedDuplications_" + strain + ".vcf"
		with open(title, "w") as output:
			numOutput = 0
			numF1 = 0

			for line in input1:
				if line.startswith("#"):
					if line.startswith("#CHROM"): 
						output.write(line)
					else:
						continue
				else:
					line = line.split("\t")
					position = int(line[1])
					numF1 += 1
					Chr1 = int(line[7].split(";")[1].lstrip("ChrB=Chr").rstrip("_RagTag"))
					startPos1 = int(line[7].split(";")[2].lstrip("StartB="))

					with open(file2) as input2:
						numF2 = 0

						for lineCompare in input2:
							if not lineCompare.startswith("#"):
								numF2 += 1
								lineCompare = lineCompare.split("\t")
								posCompare = int(lineCompare[1])
								upperCompare = posCompare + 100
								lowerCompare = posCompare - 100
								Chr2 = int(lineCompare[7].split(";")[1].lstrip("ChrB=Chr").rstrip("_RagTag"))
								startPos2 = int(lineCompare[7].split(";")[2].lstrip("StartB="))
								startUpper = startPos2 + 1000000
								startLower = startPos2 - 1000000

								
								if position <= upperCompare and position >= lowerCompare and Chr1 == Chr2 and startPos1 <= startUpper and startPos1 >= startLower:
									numOutput += 1
									#output.write("\t".join(line)) Write out this line if you want to compare nucmer and minimap outputs.
									output.write("\t".join(lineCompare)) #keep the minimap outputs and then use them later

	print(f'Duplications in File 1: {numF1}, Duplications in File 2: {numF2}, Output Duplications: {numOutput}.')

def main():
	#user sys.argv to pull arguments from the command line.  Note that arguments are all strings and index 0 is just the file name.  I designed this so that the first argument is the file name and second argument is the number 
	#Command line order should be as follows: python3 <.py file> <.vcf output file from Syri, filtered for duplications> <integer value used to check proximity of duplications>
	try:
		file1 = sys.argv[1]
		file2 = sys.argv[2]
		strain = sys.argv[3]
		if not file1.endswith("vcf") or not file2.endswith("vcf"):
			raise ValueError
		
	except ValueError:
		print(f'Please ensure files are syri vcf outputs.')
	else:
		Compare(file1, file2, strain)

if __name__ == '__main__':
	main()
