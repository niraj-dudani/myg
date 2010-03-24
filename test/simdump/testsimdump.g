include myg-simdump

create compartment /cc
create symcompartment /cc/dd
create tabchannel /cc/chan
create Ca_concen /cc/calcium

setfield /cc Vm 22
setfield /cc/dd initVm 44
setfield /cc/chan Gbar 202
setfield /cc/chan Y 27
setfield /cc/chan instant 4
setfield /cc/calcium Ca_base 1010
setfield /cc/calcium tau 2020
setfield /cc/calcium B 3030
setfield /cc/calcium thick 4040

str SIMDUMP_COMPARTMENT_FIELDS = "Vm previous_state Em Rm Cm Ra inject dia len initVm"
save_neuronal_state_simdump state.g /

rm genesis-simdump.g
simdump genesis-simdump.g -path /cc -path /cc/dd -path /cc/chan -path /cc/calcium

exit
