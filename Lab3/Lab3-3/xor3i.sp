* 3-input Pass-transistor XOR (frequency sweep with fixed c=0.05p)
.lib 'cic018.l' tt
.global vdd gnd

.subckt inv in out
mp   out  in   vdd  vdd  P_18  l=0.18u  w=1u
mn   out  in   gnd  gnd  N_18  l=0.18u  w=0.5u
.ends

.subckt xor3 a b c out
xinv1 a a_ inv
xinv2 b b_ inv
xinv3 c c_ inv
xinv4 n1 n1_ inv
xinv5 n2 n2_ inv
xinv6 out out_ inv

* First stage: XOR(a,b)
* NMOS pass transistors for first XOR
mn1  vdd    a     n1   gnd  n_18  l=0.18u  w=1u
mn2  gnd    a_    n1   gnd  n_18  l=0.18u  w=1u
mn3  n1_    b     n2   gnd  n_18  l=0.18u  w=1u
mn4  n1     b_    n2   gnd  n_18  l=0.18u  w=1u

* Second stage: XOR(XOR(a,b),c)
* NMOS pass transistors for second XOR
mn5  vdd    n2    out  gnd  n_18  l=0.18u  w=1u
mn6  gnd    n2_   out  gnd  n_18  l=0.18u  w=1u
mn7  out_   c     out  gnd  n_18  l=0.18u  w=1u
mn8  out    c_    out  gnd  n_18  l=0.18u  w=1u
.ends

* Main circuit
xxor3 a b c out xor3

* Fixed load capacitance
cload out gnd 0.05p

* Supply voltage sources
vvdd vdd 0 1.8
vgnd gnd 0 0

* Input signals with parametric frequency scaling
* Base frequency pattern (multiplied by freq_mult parameter):
* va: period = 80n   -> duty = 39.9n
* vb: period = 160n  -> duty = 79.9n
* vc: period = 320n  -> duty = 159.9n

va a 0 pulse(1.8 0 0.1n 0.1n 0.1n 'duty_a/freq_mult' '80n/freq_mult')
vb b 0 pulse(1.8 0 0.1n 0.1n 0.1n 'duty_b/freq_mult' '160n/freq_mult')
vc c 0 pulse(1.8 0 0.1n 0.1n 0.1n 'duty_c/freq_mult' '320n/freq_mult')

* Base duty cycles
.param duty_a = 39.9n
.param duty_b = 79.9n
.param duty_c = 159.9n

* Measurements
.meas tran delay trig v(a) val=0.9 fall=1
+                   targ v(out) val=0.9 rise=1

.meas tran power avg v(vdd)*i(vvdd)*-1

.meas tran pdp param='power*delay'

* Transient analysis - adjust total time based on frequency
.tran 0.1n '640n/freq_mult'

* Parameter sweep for frequency multiplication
* freq_mult = 1 (base freq), 2, 4, 8, 16
.step param freq_mult list 1 2 4 8 16

.end