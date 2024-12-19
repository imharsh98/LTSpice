.lib 'cic018.l' tt
.global vdd gnd

.subckt inv in out
mp   out  in   vdd  vdd  P_18  l=0.18u  w=1u
mn   out  in   gnd  gnd  N_18  l=0.18u  w=0.5u
.ends

.subckt pass-transistor-comp a b a_eq_b a_gt_b a_lt_b
xinv1 a a_ inv
xinv2 b b_ inv

* First stage: a == b
mn1  a_eq_b a  vdd  gnd  n_18  l=0.18u  w=1u
mn2  a_eq_b b  vdd  gnd  n_18  l=0.18u  w=1u
mn3  a_eq_b a_ gnd  gnd  n_18  l=0.18u  w=1u
mn4  a_eq_b b_ gnd  gnd  n_18  l=0.18u  w=1u

* Second stage: a > b
mn5  a_gt_b a  vdd  gnd  n_18  l=0.18u  w=1u
mn6  a_gt_b b_ vdd  gnd  n_18  l=0.18u  w=1u
mn7  a_gt_b a_ gnd  gnd  n_18  l=0.18u  w=1u
mn8  a_gt_b b  gnd  gnd  n_18  l=0.18u  w=1u

* Third stage: a < b
mn9  a_lt_b a_ vdd  gnd  n_18  l=0.18u  w=1u
mn10 a_lt_b b  vdd  gnd  n_18  l=0.18u  w=1u
mn11 a_lt_b a  gnd  gnd  n_18  l=0.18u  w=1u
mn12 a_lt_b b_ gnd  gnd  n_18  l=0.18u  w=1u
.ends

* Main circuit
xcomp a b a_eq_b a_gt_b a_lt_b pass-transistor-comp

* Fixed load capacitance
cload a_eq_b gnd 0.5p
cload a_gt_b gnd 0.5p
cload a_lt_b gnd 0.5p

* Supply voltage sources
vvdd vdd 0 1.8
vgnd gnd 0 0

* Input signals with parametric frequency scaling
va a 0 pulse(1.8 0 0.1n 0.1n 0.1n '39.9n/freq_mult' '80n/freq_mult')
vb b 0 pulse(1.8 0 0.1n 0.1n 0.1n '79.9n/freq_mult' '160n/freq_mult')

* Measurements
.meas tran delay_eq trig v(a) val=0.9 fall=1
+                    targ v(a_eq_b) val=0.9 rise=1
.meas tran delay_gt trig v(a) val=0.9 fall=1
+                    targ v(a_gt_b) val=0.9 rise=1
.meas tran delay_lt trig v(a) val=0.9 fall=1
+                    targ v(a_lt_b) val=0.9 rise=1

.meas tran power avg v(vdd)*i(vvdd)*-1

.meas tran pdp param='power*(delay_eq+delay_gt+delay_lt)/3'

* Transient analysis - adjust total time based on frequency
.tran 0.1n '160n/freq_mult'

* Parameter sweep for frequency multiplication
.step param freq_mult list 1 2 4 8 16

.end