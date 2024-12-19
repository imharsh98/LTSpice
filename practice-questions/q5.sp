.lib 'cic018.l' tt
.global vdd gnd

.subckt inv in out
mp   out  in   vdd  vdd  P_18  l=0.18u  w=1u
mn   out  in   gnd  gnd  N_18  l=0.18u  w=0.5u
.ends

.subckt pass-transistor-logic a b c d e out
xinv1 a a_ inv
xinv2 b b_ inv
xinv3 c c_ inv
xinv4 d d_ inv
xinv5 e e_ inv

* NMOS pass transistors for logic function
mn1  vdd    a     n1   gnd  n_18  l=0.18u  w=1u
mn2  gnd    a_    n1   gnd  n_18  l=0.18u  w=1u
mn3  n1     b     n2   gnd  n_18  l=0.18u  w=1u
mn4  n1_    b_    n2   gnd  n_18  l=0.18u  w=1u
mn5  n2     c     out  gnd  n_18  l=0.18u  w=1u
mn6  n2_    c_    out  gnd  n_18  l=0.18u  w=1u
mn7  vdd    d     n3   gnd  n_18  l=0.18u  w=1u
mn8  gnd    d_    n3   gnd  n_18  l=0.18u  w=1u
mn9  n3     e     out  gnd  n_18  l=0.18u  w=1u
mn10 n3_    e_    out  gnd  n_18  l=0.18u  w=1u
.ends

* Main circuit
xlogic a b c d e out pass-transistor-logic

* Fixed load capacitance
cload out gnd 0.5p

* Supply voltage sources
vvdd vdd 0 1.8
vgnd gnd 0 0

* Input signals with parametric frequency scaling
va a 0 pulse(1.8 0 0.1n 0.1n 0.1n '39.9n/freq_mult' '80n/freq_mult')
vb b 0 pulse(1.8 0 0.1n 0.1n 0.1n '79.9n/freq_mult' '160n/freq_mult')
vc c 0 pulse(1.8 0 0.1n 0.1n 0.1n '79.9n/freq_mult' '160n/freq_mult')
vd d 0 pulse(1.8 0 0.1n 0.1n 0.1n '39.9n/freq_mult' '80n/freq_mult')
ve e 0 pulse(1.8 0 0.1n 0.1n 0.1n '39.9n/freq_mult' '80n/freq_mult')

* Measurements
.meas tran delay trig v(a) val=0.9 fall=1
+                   targ v(out) val=0.9 rise=1

.meas tran power avg v(vdd)*i(vvdd)*-1

.meas tran pdp param='power*delay'

* Transient analysis - adjust total time based on frequency
.tran 0.1n '160n/freq_mult'

* Parameter sweep for frequency multiplication
.step param freq_mult list 1 2 4 8 16

.end