* 3-input Pass-transistor XOR with 1ns delay time
.lib 'cic018.l' tt
.global vdd gnd

* Inverter subcircuit
.subckt inv in out
mp   out  in   vdd  vdd  P_18  l=0.18u  w=1u
mn   out  in   gnd  gnd  N_18  l=0.18u  w=0.5u
.ends

* Pass-transistor XOR3 subcircuit
.subckt pt_xor3 a b c out
xinv1 a a_ inv
xinv2 b b_ inv
xinv3 c c_ inv
xinv4 n1 n1_ inv
xinv5 n2 n2_ inv
xinv6 out out_ inv

* First stage: XOR(a,b)
mn1  vdd  a    n1   gnd  N_18  l=0.18u  w=1u
mn2  gnd  a_   n1   gnd  N_18  l=0.18u  w=1u
mn3  n1_  b    n2   gnd  N_18  l=0.18u  w=1u
mn4  n1   b_   n2   gnd  N_18  l=0.18u  w=1u

* Second stage: XOR(XOR(a,b),c)
mn5  vdd  n2   out  gnd  N_18  l=0.18u  w=1u
mn6  gnd  n2_  out  gnd  N_18  l=0.18u  w=1u
mn7  out_ c    out  gnd  N_18  l=0.18u  w=1u
mn8  out  c_   out  gnd  N_18  l=0.18u  w=1u
.ends

* Main circuit
xpt_xor3 a b c out pt_xor3

* Load capacitance (1pF as specified)
cload out gnd 1p

* Supply voltage
vvdd vdd 0 1.8
vgnd gnd 0 0

* Input signals with 0.5ns rise/fall time
va a 0 pulse(0 1.8 0 0.5n 0.5n 10n 20n)
vb b 0 pulse(0 1.8 0 0.5n 0.5n 20n 40n)
vc c 0 pulse(0 1.8 0 0.5n 0.5n 40n 80n)

* Measurements for delay verification
.meas tran delay_rise trig v(a) val=0.9 rise=1
+                     targ v(out) val=0.9 rise=1
.meas tran delay_fall trig v(a) val=0.9 fall=1
+                     targ v(out) val=0.9 fall=1

* Transient analysis
.tran 0.1n 100n

.end