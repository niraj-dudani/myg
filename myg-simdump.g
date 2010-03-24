/*
 * These functions save the state of a model in simdump format.
 * 
 * Note that only the model state is stored, and not the model itself. This
 * means that when restoring the state, the model should be loaded already, at
 * the same path from where it was saved.
 */

/*
 * Lists of fields that will be saved if calling the simdump_neuronal_state
 * function. Can be customized from calling script (see function's
 * documentation below).
 */
str SIMDUMP_NEUTRAL_FIELDS = ""
str SIMDUMP_COMPARTMENT_FIELDS = "x0 y0 z0 activation Vm previous_state Im Em Rm Cm Ra inject dia len initVm"
str SIMDUMP_SYMCOMPARTMENT_FIELDS = "x0 y0 z0 activation Vm previous_state Im Em Rm Cm Ra inject dia len initVm coeff coeff2"
str SIMDUMP_TABCHANNEL_FIELDS = "activation Ik Gk Ek Gbar X Y Z Xpower Ypower Zpower instant X_alloced Y_alloced Z_alloced surface Z_conc"
str SIMDUMP_CACONCEN_FIELDS = "activation Ca C Ca_base tau B thick"

/*
 * Format string for writing numbers.
 */
str SIMDUMP_FLOAT_FORMAT = "%0.10g"

/*
 * Internal flags to choose if simdump header and footer should be written.
 */
int __SIMDUMP_HEADER = 1
int __SIMDUMP_FOOTER = 1

/*
 * Internal function to save simdump file header.
 */
function __simdump_header( file )
	str file
	
	if ( __SIMDUMP_HEADER == 0 )
		return
	end
	
	openfile { file } w
	writefile { file } "// genesis"
	writefile { file }
	writefile { file } "initdump -version 3"
	writefile { file }
	closefile { file }
end

/*
 * Internal function to save simdump file footer.
 */
function __simdump_footer( file )
	str file
	
	if ( __SIMDUMP_FOOTER == 0 )
		return
	end
	
	openfile { file } a
	writefile { file } "enddump"
end

/*
 * This function saves the state of objects of a single type into a file, in
 * simdump format.
 * 
 * Takes:
 * 		file:	File to save simdump script into.
 * 		wildcard:	Wildcard string used to search for elements.
 * 		type:	Type of elements.
 * 		fields:	String containing fields which should be saved.
 * 
 * Example:
 * 		save_state_simdump reac.g /kinetics/##[TYPE=pool] pool "CoInit Co nInit n"
 */
function save_state_simdump( file, wildcard, type, fields )
	str file
	str wildcard
	str type
	str fields
	
	__simdump_header { file }
	
	floatformat { SIMDUMP_FLOAT_FORMAT }
	openfile { file } a
	
	writefile { file } "//========================================"
	writefile { file } "// "{ type }
	writefile { file } "//========================================"
	writefile { file } "simobjdump "{ type }" "{ fields }
	
	str e
	str f
	foreach e ( { el { wildcard } } )
		// 'simundump' needs an extra parameter before all the state values,
		// for some reason. Putting 00 here for this.
		writefile { file } "simundump "{ type }" "{ e }" 00" -n
		foreach f ( { arglist { fields } } )
			writefile { file } { getfield { e } { f } } -n -f " %s"
		end
		writefile { file }
	end
	
	writefile { file }
	closefile { file }
	
	__simdump_footer { file }
end

/*
 * This function is like the simdump_state function. Instead of taking a
 * wildcard string, it takes a root path, and saves the state of all elements
 * under it (deep search) of the given type.
 * 
 * Takes:
 * 		file:	File to save simdump script into.
 * 		root:	Path under which elements will be searched.
 * 		type:	Type of elements.
 * 		fields:	String containing fields which should be saved.
 * 
 * Example:
 * 		save_tree_state_simdump reac.g /kinetics pool "CoInit Co nInit n"
 */
function save_tree_state_simdump( file, root, type, fields )
	str file
	str root
	str type
	str fields
	
	str wildcard = { root } @ "/##[TYPE=" @ { type } @ "]"
	save_state_simdump { file } { wildcard } { type } { fields }
end

/*
 * This function saves the state of a neuronal model in simdump format. It saves
 * the state of neutrals, compartments, symcompartments, tabchannels and
 * Ca_concens. Rate tables are currently not stored.
 * 
 * To customize the fields to be saved, set the appropriate SAVE_*_FIELDS
 * string variable in your calling script, just before calling this function.
 * By default, all the fields will be saved.
 * 
 * Takes:
 * 		file:	File to save simdump script into.
 * 		root:	Path under which elements will be searched.
 * 
 * Example:
 * 		include myg-simdump.g
 * 		SAVE_COMPARTMENT_FIELDS = "Vm dia len"
 * 		save_neuronal_state_simdump cell.g /cell
 */
function save_neuronal_state_simdump( file, root )
	str file
	str root
	
	__SIMDUMP_HEADER = 1
	__simdump_header { file }
	__SIMDUMP_HEADER = 0
	__SIMDUMP_FOOTER = 0
	
	save_tree_state_simdump { file } { root } "neutral" { SIMDUMP_NEUTRAL_FIELDS }
	save_tree_state_simdump { file } { root } "compartment" { SIMDUMP_COMPARTMENT_FIELDS }
	save_tree_state_simdump { file } { root } "symcompartment" { SIMDUMP_SYMCOMPARTMENT_FIELDS }
	save_tree_state_simdump { file } { root } "tabchannel" { SIMDUMP_TABCHANNEL_FIELDS }
	save_tree_state_simdump { file } { root } "Ca_concen" { SIMDUMP_CACONCEN_FIELDS }
	
	__SIMDUMP_FOOTER = 1
	__simdump_footer { file }
	__SIMDUMP_HEADER = 1
end
