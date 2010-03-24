function setup_hsolve( cell, chanmode )
	str cell
	int chanmode
	
	str solve = { cell } @ "/solve"
	if ( { exists { solve } } )
		delete { solve }
	end
	
	create hsolve { solve }
	setfield { solve } \
		path { cell }/##[TYPE=compartment],##[TYPE=symcompartment] \
		comptmode 1 \
		chanmode { chanmode }
	
	call { solve } SETUP
	setmethod 11
end
