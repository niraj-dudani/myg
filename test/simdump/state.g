// genesis

initdump -version 3

//========================================
// neutral
//========================================
simobjdump neutral 
simundump neutral /proto 00
simundump neutral /output 00

//========================================
// compartment
//========================================
simobjdump compartment Vm previous_state Em Rm Cm Ra inject dia len initVm
simundump compartment /cc 00 22 0 0 1 1 0 0 0 0 0

//========================================
// symcompartment
//========================================
simobjdump symcompartment x0 y0 z0 activation Vm previous_state Im Em Rm Cm Ra inject dia len initVm coeff coeff2
simundump symcompartment /cc/dd 00 0 0 0 0 0 0 0 0 1 1 0 0 0 0 44 0 0

//========================================
// tabchannel
//========================================
simobjdump tabchannel activation Ik Gk Ek Gbar X Y Z Xpower Ypower Zpower instant X_alloced Y_alloced Z_alloced surface Z_conc
simundump tabchannel /cc/chan 00 0 0 0 0 202 0 27 0 0 0 0 4 0 0 0 0 1

//========================================
// Ca_concen
//========================================
simobjdump Ca_concen activation Ca C Ca_base tau B thick
simundump Ca_concen /cc/calcium 00 0 0 0 1010 2020 3030 4040

enddump
