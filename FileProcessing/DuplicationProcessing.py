import sys

def pullOutDuplicates(inF, outF, distance):
	#distance represents desired range to pull features (in bp).  0 looks for exact matches, while 30 looks for other features that have a start position within 30 bp of the given line
	#This is intended to open a file of Duplications from processed SyRI VCF files
	
	
	outFirst = outF.rstrip().split(".")[0] + "_DuplicatedFeatures.vcf"
	outSecond = outF.rstrip().split(".")[0] + "_NoOverlap.vcf"

	with open(inF) as inputFile:
		with open(outFirst, "w") as outputFile1:
			with open(outSecond, "w") as outputFile2:
				#Use this variable to address 3 or more consecutive lines with similar positions.  Should flag True if it hits a third consecutive line with similar position
				consecutiveLine = False

				#enumerate gives the loop number (count) and line gives the line contents
				#We want to write the header line to the output, but then skip to the next line
				for count, line in enumerate(inputFile):

					#listColumns is a list of the contents of each line that is normally separated by a tab
					listColumns = line.split("\t")

					if count == 0:
						outputFile1.write(line)
						outputFile2.write(line)
						continue

					elif count > 1:
						#this should only be accessed after the second line, after previous position info has been stored
						#check if the current line's position is the same as the previous position
						if int(listColumns[1]) >= previousLowerBound and int(listColumns[1]) <= previousUpperBound:
							#If this is the first position being written, then report the previous line that matched.
							#If three or more sequential lines have very similar positions, then we don't want to duplicate info.
							#The consecutiveLines variable is true if a line enters this loop immediately after an overlap was recorded, so we skip reporting the previous line.
							if not consecutiveLine:
								outputFile1.write("\t".join(previousColumns))

							outputFile1.write("\t".join(listColumns))

							#tag this as true so that if the next line immediately enters this loop, the previous line isn't copied
							consecutiveLine = True

						else: 
							#If a line is not overlapping with the previous line, then we want to report this line as a "non-duplicate":
							if not consecutiveLine:
								outputFile2.write("\t".join(previousColumns))

							#If a line is not overlapping with the previous line, then we want the next matching pair to be reported:
							consecutiveLine = False


					#Last, save the desired lower and upper bounds based on the feature position.  These bounds will be used to see if the next feature position is close
					previousLowerBound = int(listColumns[1]) - distance
					previousUpperBound = int(listColumns[1]) + distance
					previousColumns = listColumns

				#when parsing the file is finished, make sure to keep the last line.  If the last lines are duplicates, they're printed above and consecutiveLine is True.  If not, then consecutiveLine is False and the line should be printed here.
				if not consecutiveLine: 
					outputFile2.write("\t".join(previousColumns))

def main():
	#user sys.argv to pull arguments from the command line.  Note that arguments are all strings and index 0 is just the file name.  I designed this so that the first argument is the file name and second argument is the number 
	#Command line order should be as follows: python3 <.py file> <.vcf output file from Syri, filtered for duplications> <desired output file name> <integer value used to check proximity of duplications>
	try:
		fileName = sys.argv[1]
		outputFileName = sys.argv[2]
		bpDist = int(sys.argv[3])
		if fileName.split(".")[1] != "vcf":
			raise ValueError
			
		#If the output file name already has ".vcf", then save the name without ".vcf"
		if outputFileName.split(".")[1] == "vcf":
			outputFileName = outputFileName.split(".")[0]
		
	except ValueError:
		print(f'Please type input file, output file name, and desired distance (in bp) to check for duplicated features. Input file should be a .vcf, and the distance should be an integer value.')
	else:
		pullOutDuplicates(fileName, outputFileName, bpDist)

if __name__ == '__main__':
	main()
