include myg-csv.g

create compartment /cc
create compartment /dd
create compartment /dd/ee

setfield /cc Vm 44
setfield /cc initVm 33
setfield /cc inject 22
setfield /dd Vm 55
setfield /dd inject 11
setfield /dd/ee Vm 66
setfield /dd/ee initVm 77
setfield /dd/ee inject 88

save_tree_state_csv compartments0.csv "/" compartment "Vm initVm inject" ",	"

delete /cc
delete /dd
create compartment /cc
create compartment /dd
create compartment /dd/ee

save_tree_state_csv compartments1.csv "/" compartment "Vm initVm inject" ":"

load_state_csv compartments0.csv ",	"

save_tree_state_csv compartments2.csv "/" compartment "Vm initVm inject" ",	"

exit
