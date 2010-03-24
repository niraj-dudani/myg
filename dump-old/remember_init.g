/* Stores initial state of compartments, channels, and calcium concentration objects */

floatformat %0.17g
openfile dump/recall_half.g w
writefile dump/recall_half.g "/* Restores initial state of compartments, channels, and calcium concentration objects */"

str c
foreach c ( { el {cell}/##[TYPE=symcompartment],{cell}/##[TYPE=compartment] } )
	writefile dump/recall_half.g
	writefile dump/recall_half.g "/*"  {c}  "*/"
	writefile dump/recall_half.g "setfield "{c} "initVm" {getfield {c} initVm}
	writefile dump/recall_half.g "setfield "{c} "Em" {getfield {c} Em}
	writefile dump/recall_half.g "setfield "{c} "Cm" {getfield {c} Cm}
	writefile dump/recall_half.g "setfield "{c} "Rm" {getfield {c} Rm}
	writefile dump/recall_half.g "setfield "{c} "Ra" {getfield {c} Ra}
	writefile dump/recall_half.g "setfield "{c} "inject" {getfield {c} inject}
end

foreach c ( { el {cell}/##[CLASS=channel] } )
	writefile dump/recall_half.g
	writefile dump/recall_half.g "/*"  {c}  "*/"
	writefile dump/recall_half.g "setfield "{c} "Gbar" {getfield {c} Gbar}
	writefile dump/recall_half.g "setfield "{c} "Ek" {getfield {c} Ek}
	
	// Not really needed
	// writefile dump/recall_half.g "setfield "{c} "X" {getfield {c} X}
	// writefile dump/recall_half.g "setfield "{c} "Y" {getfield {c} Y}
	// writefile dump/recall_half.g "setfield "{c} "Z" {getfield {c} Z}
end

foreach c ( { el {cell}/##[TYPE=Ca_concen] } )
	writefile dump/recall_half.g
	writefile dump/recall_half.g "/*"  {c}  "*/"
	writefile dump/recall_half.g "setfield "{c} "B" {getfield {c} B}
	writefile dump/recall_half.g "setfield "{c} "Ca" {getfield {c} Ca}
	writefile dump/recall_half.g "setfield "{c} "Ca_base" {getfield {c} Ca_base}
	writefile dump/recall_half.g "setfield "{c} "tau" {getfield {c} tau}
end

closefile dump/recall_half.g


openfile dump/recall_init.g w
writefile dump/recall_init.g "/* Restores initial state of all biophysical objects */"
writefile dump/recall_init.g
writefile dump/recall_init.g "/* Gates */"

str chan
str chanfile
int ndivs
int i
foreach c ( { el /library/#[CLASS=channel] } )
	chan = {strsub {c} "/library/" ""}
	chanfile = "dump/recall_" @ {chan} @ ".g"
	writefile dump/recall_init.g "include "{chanfile}
	
	openfile {chanfile} w
	
	if ( {getfield {c} Xpower} > 0 )
		ndivs = {getfield {c} X_A->xdivs}
		
		for ( i = 0; i <= ndivs; i = i + 1 )
			writefile {chanfile} "setfield "{c} "X_A->table["{i}"] " \
				{getfield {c} X_A->table[{i}]}
		end
		
		for ( i = 0; i <= ndivs; i = i + 1 )
			writefile {chanfile} "setfield "{c} "X_B->table["{i}"] " \
				{getfield {c} X_B->table[{i}]}
		end
	end
	
	if ( {getfield {c} Ypower} > 0 )
		ndivs = {getfield {c} Y_A->xdivs}
		
		for ( i = 0; i <= ndivs; i = i + 1 )
			writefile {chanfile} "setfield "{c} "Y_A->table["{i}"] " \
				{getfield {c} Y_A->table[{i}]}
		end
		
		for ( i = 0; i <= ndivs; i = i + 1 )
			writefile {chanfile} "setfield "{c} "Y_B->table["{i}"] " \
				{getfield {c} Y_B->table[{i}]}
		end
	end
	
	if ( {getfield {c} Zpower} > 0 )
		ndivs = {getfield {c} Z_A->xdivs}
		
		for ( i = 0; i <= ndivs; i = i + 1 )
			writefile {chanfile} "setfield "{c} "Z_A->table["{i}"] " \
				{getfield {c} Z_A->table[{i}]}
		end
		
		for ( i = 0; i <= ndivs; i = i + 1 )
			writefile {chanfile} "setfield "{c} "Z_B->table["{i}"] " \
				{getfield {c} Z_B->table[{i}]}
		end
	end
	
	closefile {chanfile}
end

writefile dump/recall_init.g
writefile dump/recall_init.g "/* Compartments, Channels, Calcium concentration objects */"
writefile dump/recall_init.g "include dump/recall_half.g"

closefile dump/recall_init.g
