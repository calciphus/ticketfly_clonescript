require 'json'
require 'yaml'

file = File.read(ARGV[0])
masterfile = JSON.parse(file)
# masterfile = Hash.new
# masterfile['sections'] = []
# masterfile['holds'] = []

if masterfile != nil

	puts "Found #{masterfile['sections'].size} sections."
	puts "Found #{masterfile['holds'].size} holds."

	keepgoing = true
	section_output = masterfile["sections"]
	hold_output = masterfile["holds"]
	startingSections = masterfile["sections"].dup
	
	puts "This script will generate a 'results.json' file in this directory with the output of your request, based on the file you supplied: #{ARGV[0]}"

	# Create held seat prototype
	heldSeatPrototype = Hash.new
	heldSeatPrototype["sectionName"] = "Full Name "
	heldSeatPrototype["seatLabel"] = "Row Number"

	while keepgoing == true do

		# Show sections to clone from
		
		sectNumber = 0
		startingSections.each do |s|
			puts "#{sectNumber}.\t#{s['publicName']}"
			sectNumber += 1
		end
		puts "Which Section do you want to clone? Enter the number only: "
		targetSection = STDIN.gets
		prototype = startingSections[targetSection.to_i]

		puts "How many clones do you want to make? "
		sectionCount = STDIN.gets

		puts "What should each section name start with? "
		namePre = STDIN.gets

		puts "What number do you want to count from?"
		countFrom = STDIN.gets


		# Clean up inputs
		namePre = namePre.gsub("\n","")
		sectionCount = sectionCount.to_i
		countFrom = countFrom.to_i

		puts "Cloning #{prototype['publicName']} #{sectionCount} times"
		puts "--------------------------------------------------------"

		# Loop through Sections
		i = 0
		while i < sectionCount do
			newSection = prototype.dup
			newSection["internalName"] = "#{namePre} #{i+countFrom}"
			newSection["publicName"] = "#{namePre} #{i+countFrom}"
			newSection["displayOrder"] = i+countFrom
			newSection["sellingPriority"] = newSection["sellingPriority"].to_i+i+1
			section_output << newSection
			# Add each held seat to the appropriate holds section
			newSection["seats"].each do |seat|
				targetHold = hold_output.select{|hold| hold["name"] == seat['venueHoldName']}[0]
				newHeldSeat = heldSeatPrototype.dup
				newHeldSeat["sectionName"] = "#{namePre} #{i+countFrom}"
				newHeldSeat["seatLabel"] = "#{seat['rowLabel']} #{seat['label']}"
				targetHold["seats"] << newHeldSeat
			end
			i += 1
			newSection = nil
		end

		# Check to see if we should loop again?
		puts "Do you want to create another section? Type 'done' to finish, or hit enter to make more sections."
		loopq = STDIN.gets
		if loopq == "done\n"
			keepgoing = false
		end
	end


	puts "OK! Writing output..."
	# Prepare file
	#filein = JSON.parse(masterfile)
	filein = masterfile
	filein["sections"] = section_output
	filein["holds"] = hold_output
	# puts output.to_yaml
	#filein = output

	# Write file
	fileout = File.open( "results.json","w" )
	fileout << JSON.pretty_generate(filein)
	fileout.close

else 
	puts "You must supply a valid, JSON of a layout. The correct use of this script is:"
	puts "ruby ./generator.rb ./sourceFilename.json"
end