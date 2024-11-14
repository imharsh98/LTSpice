* 3-input Dynamic XOR Circuit
.lib 'cic018.l' tt
.global vdd gnd

* Inverter subcircuit
.subckt inv in out
mp   out  in   vdd  vdd  P_18  l=0.18u  w=1u
mn   out  in   gnd  gnd  N_18  l=0.18u  w=0.5u
.ends

* Dynamic XOR3 subcircuit
.subckt dyn_xor3 a b c ck out
* Pre-charge PMOS
mp1  out  ck_  vdd  vdd  P_18  l=0.18u  w=2u

* Evaluation network
mn1  out   ck   n1   gnd  N_18  l=0.18u  w=1u
mn2  n1    a    n2   gnd  N_18  l=0.18u  w=1u
mn3  n2    b    gnd  gnd  N_18  l=0.18u  w=1u
mn4  n1    a_   n3   gnd  N_18  l=0.18u  w=1u
mn5  n3    b_   gnd  gnd  N_18  l=0.18u  w=1u
mn6  n1    c    n4   gnd  N_18  l=0.18u  w=1u
mn7  n4    n5   gnd  gnd  N_18  l=0.18u  w=1u
mn8  n1    c_   n6   gnd  N_18  l=0.18u  w=1u
mn9  n6    n7   gnd  gnd  N_18  l=0.18u  w=1u

* Inverters for input signals
xinv_a  a    a_   inv
xinv_b  b    b_   inv
xinv_c  c    c_   inv
xinv_ck ck   ck_  inv
xinv_n5 n2   n5   inv
xinv_n7 n3   n7   inv
.ends

* Main circuit
xdyn_xor3 a b c ck out dyn_xor3

* Load capacitance (parameterized for sweep)
cload out gnd 'c_load'
.param c_load=0.1p

* Supply voltage
vvdd vdd 0 1.8
vgnd gnd 0 0

* Input patterns with parametric frequency scaling
.param freq_mult=1
va  a  0 pulse(1.8 0 0.1n 0.1n 0.1n '3.9n/freq_mult' '8n/freq_mult')
vb  b  0 pulse(1.8 0 0.1n 0.1n 0.1n '7.9n/freq_mult' '16n/freq_mult')
vc  c  0 pulse(1.8 0 0.1n 0.1n 0.1n '15.9n/freq_mult' '32n/freq_mult')
vck ck 0 pulse(0 1.8 2.1n 0.1n 0.1n '1.9n/freq_mult' '4n/freq_mult')

* Measurements
.meas tran delay trig v(a) val=0.9 fall=1
+                   targ v(out) val=0.9 rise=1
.meas tran power avg v(vdd)*i(vvdd)*-1
.meas tran pdp param='power*delay'

* Transient analysis
.tran 0.1n '40n/freq_mult'

* For capacitance sweep (uncomment when needed)
*.step param c_load 0.05p 0.5p 0.05p

* For frequency sweep (uncomment when needed)
*.step param freq_mult list 1 2 4 8

.end