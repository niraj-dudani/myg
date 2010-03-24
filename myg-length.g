str MODEL_PATH = $1
str outfile = $2

setenv SIMPATH {getenv SIMPATH} {MODEL_PATH}

include load_model.g

int MOOSE
int GENESIS
if ( {version} < 3.0 )
	MOOSE = 0
	GENESIS = 1
else
	MOOSE = 1
	GENESIS = 0
end

if ( GENESIS )
	create neutral /library
	disable /library
	pushe /library
		create compartment compartment
		create symcompartment symcompartment
	pope
end

load_model /model

str i
str name
float Rm
float Ra
float diameter
float length
float lambda
float electrotonic

//~ From readcell input file:
//~ *set_global RM 7.0      //ohm*m^2
//~ *set_global RA 0.15      //ohm*m
//~ float RM = 7.0
//~ float RA = 0.15

openfile { outfile } w
writefile { outfile } "#Compartment_name Physical_length Lambda Electrotonic_length"
foreach i ( { el /model/##[TYPE=compartment] } )
	name = { getpath { i } -tail }
	diameter = { getfield { i } dia }
	length = { getfield { i } len }
	Rm = { getfield { i } Rm }
	Ra = { getfield { i } Ra }
	
	lambda = length * { sqrt { Rm / Ra } }
	//~ Also correct is:
	//~ lambda = { sqrt { diameter * RM / RA / 4.0 } }
	
	electrotonic = length / lambda
	//~ Also correct is:
	//~ electrotonic = { sqrt { Ra / Rm } }
	
	writefile { outfile } { name } { length } { lambda } { electrotonic }
end
closefile { outfile }

quit
