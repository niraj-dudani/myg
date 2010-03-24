/*
 * These functions save the state of a model in csv format.
 * 
 * Note that only the model state is stored, and not the model itself.
 */

/*
 * Format string for writing numbers.
 */
str CSV_FLOAT_FORMAT = "%0.10g"

/*
 * This function saves the state of objects of a single type into a file, in
 * csv format.
 * 
 * Takes:
 * 		file:	File to save simdump script into.
 * 		wildcard:	Wildcard string used to search for elements.
 * 		fields:	String containing fields which should be saved.
 * 		separator:	string to separate fields in the csv.
 * 
 * Example:
 * 		save_state_csv reac.csv /kinetics/##[TYPE=pool] "CoInit Co nInit n" ",	"
 */
function save_state_csv( file, wildcard, fields, separator )
	str file
	str wildcard
	str fields
	str separator
	
	str e
	str f
	
	floatformat { CSV_FLOAT_FORMAT }
	openfile { file } w
	
	str format = { separator } @ "%s"
	
	writefile { file } "Element" -n
	foreach f ( { arglist { fields } } )
		writefile { file } { f } -n -f { format }
	end
	writefile { file }
	
	foreach e ( { el { wildcard } } )
		writefile { file } { e } -n
		foreach f ( { arglist { fields } } )
			writefile { file } { getfield { e } { f } } -n -f { format }
		end
		writefile { file }
	end
	
	closefile { file }
end

/*
 * This function is like the csv_state function. Instead of taking a wildcard
 * string, it takes a root path, and saves the state of all elements under it
 * (deep search) of the given type.
 * 
 * Takes:
 * 		file:	File to save simdump script into.
 * 		root:	Path under which elements will be searched.
 * 		type:	Type of elements.
 * 		fields:	String containing fields which should be saved.
 * 		separator:	string to separate fields in the csv.
 * 
 * Example:
 * 		save_tree_state_csv compartments.csv /cell compartment "Vm initVm inject" ",	"
 */
function save_tree_state_csv( file, root, type, fields, separator )
	str file
	str root
	str type
	str fields
	str separator
	
	str wildcard = { root } @ "/##[TYPE=" @ { type } @ "]"
	save_state_csv { file } { wildcard } { fields } { separator }
end

function load_state_csv( file, separator )
	str file
	str separator
	
	str farray = "/__fields"
	create neutral { farray }
	
	int row = 0
	int col
	str line
	str token
	str e
	str f
	
	openfile { file } r
	while ( ! { eof { file } } )
		line = { readfile { file } -linemode }
		line = { strsub { line } { separator } " " -all }
		
		col = 0
		foreach token ( { arglist { line } } )
			if ( row == 0 )
				if ( col > 0 )
					addfield { farray } { col }
					setfield { farray } { col } { token }
				end
			else
				if ( col == 0 )
					e = token
				else
					f = { getfield { farray } { col } }
					setfield { e } { f } { token }
				end
			end
			
			col = col + 1
		end
		
		if ( col > 1 )
			row = row + 1
		end
	end
	closefile { file }
	
	delete { farray }
end
