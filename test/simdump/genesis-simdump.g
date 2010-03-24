//genesis

initdump -version 3
simobjdump compartment x0 y0 z0 activation Vm previous_state Im Em Rm Cm Ra \
  inject dia len initVm
simobjdump symcompartment x0 y0 z0 activation Vm previous_state Im Em Rm Cm \
  Ra inject dia len initVm coeff coeff2
simobjdump tabchannel activation Ik Gk Ek Gbar X Y Z Xpower Ypower Zpower \
  instant X_alloced Y_alloced Z_alloced surface Z_conc
simobjdump Ca_concen activation Ca C Ca_base tau B thick
simundump compartment /cc 0 0 0 0 0 22 0 0 0 1 1 0 0 0 0 0
simundump symcompartment /cc/dd 0 0 0 0 0 0 0 0 0 1 1 0 0 0 0 44 0 0
simundump tabchannel /cc/chan 0 0 0 0 0 202 0 27 0 0 0 0 4 0 0 0 0 1
simundump Ca_concen /cc/calcium 0 0 0 0 1010 2020 3030 4040
enddump
// End of dump

