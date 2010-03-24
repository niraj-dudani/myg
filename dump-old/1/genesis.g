// moose
// genesis


echo "
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Model: Traub's 1991 model for Hippocampal cell pyramidal cell.
Plots: Vm and [Ca++] from soma.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
"

include compatibility.g
int USE_SOLVER = 1


////////////////////////////////////////////////////////////////////////////////
// MODEL CONSTRUCTION
////////////////////////////////////////////////////////////////////////////////
float SIMDT = 10e-6
float IODT = 100e-6
float SIMLENGTH = 0.10
float INJECT = 2.0e-10
float EREST_ACT = -0.060
float ENA = 0.115 + EREST_ACT // 0.055  when EREST_ACT = -0.060
float EK = -0.015 + EREST_ACT // -0.075
float ECA = 0.140 + EREST_ACT // 0.080

include traub91proto.g

ce /library
	make_Na
	make_Ca
	make_K_DR
	make_K_AHP
	make_K_C
	make_K_A
	make_Ca_conc
ce /

setfield /library/K_C instant 0

//=====================================
//  Create cells
//=====================================
readcell ca1.p /cell
//~ readcell ca1-soma.p /cell
str target = "/cell"
/* float x,b
str name
str msg = ""
str comp
int id = 0
foreach comp ( { el { target }/##[TYPE=Compartment] }  )
	if ( { exists {comp}/K_C } )
		x = { getfield {comp}/K_C Gbar }
		b = { getfield {comp}/K_C Ek  }
		name = {getpath {comp} -tail}
		echo {name} {x} {b} 
		msg = { showmsg {comp}/K_C }
		echo msg
	end
	

           // <mml:segment id="2" name="basal_2"  parent="1" cable="1">
             //     <mml:distal x="0.0" y="110.0" z="0.0" diameter="3.84"/>
           // </mml:segment>

	/* echo "<mml:segment id=\""{id}"\" name=\""{name}"\"  parent=\""{parent}"\" cable=\"1\">"
	echo "    <mml:distal x=\""{x*1e6}"\" y=\""{y*1e6}"\" z=\""{z*1e6}"\" diameter=\""{d*1e6}"\"/>"
	echo "</mml:segment>"

	id = id + 1
	parent = name */
//end 

////////////////////////////////////////////////////////////////////////////////
// PLOTTING
////////////////////////////////////////////////////////////////////////////////
create neutral /data

create table /data/Vm
call /data/Vm TABCREATE {SIMLENGTH / IODT} 0 {SIMLENGTH}
setfield /data/Vm step_mode 3

create table /data/Ca
call /data/Ca TABCREATE {SIMLENGTH / IODT} 0 {SIMLENGTH}
setfield /data/Ca step_mode 3

/*create table /data/Vm1
call /data/Vm1 TABCREATE {SIMLENGTH / IODT} 0 {SIMLENGTH}
setfield /data/Vm1 step_mode 3

create table /data/Vm2
call /data/Vm2 TABCREATE {SIMLENGTH / IODT} 0 {SIMLENGTH}
setfield /data/Vm2 step_mode 3

create table /data/Ca1
call /data/Ca1 TABCREATE {SIMLENGTH / IODT} 0 {SIMLENGTH}
setfield /data/Ca1 step_mode 3

create table /data/Ca2
call /data/Ca2 TABCREATE {SIMLENGTH / IODT} 0 {SIMLENGTH}
setfield /data/Ca2 step_mode 3 */

//=====================================
//  Record from compartment
//=====================================
addmsg /cell/soma /data/Vm INPUT Vm
addmsg /cell/soma/Ca_conc /data/Ca INPUT Ca

/*addmsg /cell/basal_8 /data/Vm1 INPUT Vm
addmsg /cell/basal_8/Ca_conc /data/Ca1 INPUT Ca

addmsg /cell/apical_11 /data/Vm2 INPUT Vm
addmsg /cell/apical_11/Ca_conc /data/Ca2 INPUT Ca */
////////////////////////////////////////////////////////////////////////////////
// SIMULATION CONTROL
////////////////////////////////////////////////////////////////////////////////

//=====================================
//  Stimulus
//=====================================
setfield /cell/soma inject {INJECT}


//=====================================
//  Clocks
//=====================================
setclock 0 {SIMDT}
setclock 1 {SIMDT}
setclock 2 {IODT}

useclock /data/#[TYPE=table] 2

//=====================================
//  Solvers
//=====================================
// In Genesis, an hsolve object needs to be created.
//
// In Moose, hsolve is enabled by default. If USE_SOLVER is 0, we disable it by
// switching to the Exponential Euler method.

if ( USE_SOLVER )
	if ( GENESIS )
		create hsolve /cell/solve
		setfield /cell/solve \
			path /cell/##[TYPE=symcompartment],/cell/##[TYPE=compartment] \
			chanmode 1
		call /cell/solve SETUP
		setmethod 11
	end
else
	if ( MOOSE )
		setfield /cell method "ee"
	end
end

//=====================================
//  Simulation
//=====================================
reset

//
// Genesis integrates the calcium current (into the calcium pool) in a slightly
// different way from Moose. While the integration in Moose is sligthly more
// accurate, here we force Moose to imitate the Genesis method, to get a better
// match.
//
//~ if ( MOOSE && USE_SOLVER )
	//~ setfield /cell/solve/integ CaAdvance 0
//~ end

// step {SIMLENGTH} -time


////////////////////////////////////////////////////////////////////////////////
//  Write Plots
////////////////////////////////////////////////////////////////////////////////
str filename
str extension
if ( MOOSE )
	extension = ".moose.plot"
else
	extension = ".genesis.plot"
end

filename = "Vm" @ {extension}
openfile {filename} w
writefile {filename} "/newplot"
writefile {filename} "/plotname Vm"
closefile {filename}
tab2file {filename} /data/Vm table

filename = "Ca" @ {extension}
openfile {filename} w
writefile {filename} "/newplot"
writefile {filename} "/plotname Ca"
closefile {filename}
tab2file {filename} /data/Ca table

/* filename = "Vm1" @ {extension}
openfile {filename} w
writefile {filename} "/newplot"
writefile {filename} "/plotname Vm1"
closefile {filename}
tab2file {filename} /data/Vm1 table

filename = "Vm2" @ {extension}
openfile {filename} w
writefile {filename} "/newplot"
writefile {filename} "/plotname Vm2"
closefile {filename}
tab2file {filename} /data/Vm2 table

filename = "Ca1" @ {extension}
openfile {filename} w
writefile {filename} "/newplot"
writefile {filename} "/plotname Ca1"
closefile {filename}
tab2file {filename} /data/Ca1 table

filename = "Ca2" @ {extension}
openfile {filename} w
writefile {filename} "/newplot"
writefile {filename} "/plotname Ca2"
closefile {filename}
tab2file {filename} /data/Ca2 table */

/*tab2file dKdrX_A.txt /library/K_DR X_A
tab2file dKdrX_B.txt /library/K_DR X_B*/
/*tab2file dKCX_A.txt /library/K_C X_A
tab2file dKCX_B.txt /library/K_C X_B
tab2file dKCZ_A.txt /library/K_C Z_A
tab2file dKCZ_B.txt /library/K_C Z_B */
echo "
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Plots written to *.plot. Reference curves from GENESIS are in files named
*.genesis.plot.

If you have gnuplot, run 'gnuplot plot.gnuplot' to view the graphs.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
"

str e
str state_file

state_file = "state/channel-genesis.csv"
openfile { state_file } w
writefile { state_file } "#Element	Gbar	Ek	Xpower	Ypower	Zpower	instant"
foreach e ( { el /##[TYPE=HHChannel] }  )
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

state_file = "state/compartment-genesis.csv"
openfile { state_file } w
writefile { state_file } "#Element	Cm	Em	Rm	Ra	inject	initVm	diameter	length"
foreach e ( { el /##[TYPE=Compartment] }  )
	float Cm = { getfield { e } Cm }
	float Em = { getfield { e } Em }
	float Rm = { getfield { e } Rm }
	float Ra = { getfield { e } Ra }
	float inject = { getfield { e } inject }
	float initVm = { getfield { e } initVm }
	float diameter = { getfield { e } dia }
	float length = { getfield { e } len }
	writefile { state_file } { e } -n
	writefile { state_file } { Cm } { Em } { Rm } { Ra } { inject } { initVm } { diameter } { length } -f "	%s"
end
closefile { state_file }

state_file = "state/caconc-genesis.csv"
openfile { state_file } w
writefile { state_file } "#Element	thick	B	tau	CaBasal"
foreach e ( { el /##[TYPE=CaConc] }  )
	float thick = { getfield { e } thick }
	float B = { getfield { e } B }
	float tau = { getfield { e } tau }
	float CaBasal = { getfield { e } CaBasal }
	writefile { state_file } { e } -n
	writefile { state_file } { thick } { B } { tau } { CaBasal } -f "	%s"
end
closefile { state_file }

ce /cell/soma
quit
