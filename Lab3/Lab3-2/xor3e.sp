* 3-input Pseudo-NMOS XOR (loading c=0.05p to 0.5p sweep)
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

* Always-on PMOS (acts as pull-up resistor)
mp1  out   gnd   vdd   vdd  p_18  l=0.18u  w=0.5u

* NMOS network (pull-down) - implementing all XOR terms
mn1  out    a    net1   gnd  n_18  l=0.18u  w=2u
mn2  net1   b    net2   gnd  n_18  l=0.18u  w=2u
mn3  net2   c    gnd    gnd  n_18  l=0.18u  w=2u

mn4  out    a    net3   gnd  n_18  l=0.18u  w=2u
mn5  net3   b    net4   gnd  n_18  l=0.18u  w=2u
mn6  net4   c_   gnd    gnd  n_18  l=0.18u  w=2u

mn7  out    a_   net5   gnd  n_18  l=0.18u  w=2u
mn8  net5   b_   net6   gnd  n_18  l=0.18u  w=2u
mn9  net6   c    gnd    gnd  n_18  l=0.18u  w=2u

mn10 out    a_   net7   gnd  n_18  l=0.18u  w=2u
mn11 net7   b_   net8   gnd  n_18  l=0.18u  w=2u
mn12 net8   c_   gnd    gnd  n_18  l=0.18u  w=2u
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