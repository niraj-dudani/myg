function write_state( state_file, path, type )
	str state_file
	str path
	str type
	str e
	
	if ( { strcmp { type } "channel" } == 0 )
		openfile { state_file } w
		writefile { state_file } "#Element	Gbar	Ek	Xpower	Ypower	Zpower	instant"
		
		foreach e ( { el { path }/##[TYPE=tabchannel] }  )
			float Gbar = { getfield { e } Gbar }
			float Ek = { getfield { e } Ek }
			float Xpower = { getfield { e } Xpower }
			float Ypower = { getfield { e } Ypower }
			float Zpower = { getfield { e } Zpower }
			float instant = { getfield { e } instant }
			writefile { state_file } { e } -n
			writefile { state_file } { Gbar } { Ek } { Xpower } { Ypower } { Zpower } { instant } -f "	%s"
		end
		
		closefile { state_file }
	end
	
	if ( { strcmp { type } "compartment" } == 0 )
		openfile { state_file } w
		writefile { state_file } "#Element	diameter	length	Em	Cm	Rm	Ra	inject	initVm"
		
		foreach e ( { el { path }/##[TYPE=compartment] }  )
			float diameter = { getfield { e } dia }
			float length = { getfield { e } len }
			float Rm = { getfield { e } Rm }
			float Cm = { getfield { e } Cm }
			float Em = { getfield { e } Em }
			float Ra = { getfield { e } Ra }
			float inject = { getfield { e } inject }
			float initVm = { getfield { e } initVm }
			writefile { state_file } { e } -n
			writefile { state_file } { diameter } { length } { Em } { Cm } { Rm } { Ra } { inject } { initVm } -f "	%s"
		end
		
		closefile { state_file }
	end

	if ( { strcmp { type } "ca_conc" } == 0 )
		openfile { state_file } w
		writefile { state_file } "#Element	tau	CaBasal	B	thick"
		
		foreach e ( { el { path }/##[TYPE=Ca_concen] }  )
			float tau = { getfield { e } tau }
			float CaBasal = { getfield { e } Ca_base }
			float B = { getfield { e } B }
			float thick = { getfield { e } thick }
			writefile { state_file } { e } -n
			writefile { state_file } { tau } { CaBasal } { B }  { thick } -f "	%s"
		end
		
		closefile { state_file }
	end
end
