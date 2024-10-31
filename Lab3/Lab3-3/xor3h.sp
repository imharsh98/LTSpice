* 3-input Pass-transistor XOR (loading c=0.05p to 0.5p sweep)
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

* Load capacitance (will be swept)
cload out gnd {cval}

* Supply voltage sources
vvdd vdd 0 1.8
vgnd gnd 0 0

* Input signals
va a 0 pulse(1.8 0 0.1n 0.1n 0.1n 39.9n 80n)
vb b 0 pulse(1.8 0 0.1n 0.1n 0.1n 79.9n 160n)
vc c 0 pulse(1.8 0 0.1n 0.1n 0.1n 159.9n 320n)

* Measurements
.meas tran delay trig v(a) val=0.9 fall=1
+                   targ v(out) val=0.9 rise=1

.meas tran power avg v(vdd)*i(vvdd)*-1

.meas tran pdp param='power*delay'

* Transient analysis
.tran 0.1n 640n

* Parameter sweep for load capacitance
.step param cval 0.05p 0.5p 0.05p

.end