* 3-input Pseudo nMOS XOR with 1ns delay time
.lib 'cic018.l' tt
.global vdd gnd

* Inverter subcircuit
.subckt inv in out
mp   out  in   vdd  vdd  P_18  l=0.18u  w=1u
mn   out  in   gnd  gnd  N_18  l=0.18u  w=0.5u
.ends

* Pseudo nMOS XOR3 subcircuit
.subckt pseudo_xor3 a b c out
* Pull-up PMOS network (always ON)
mp1  out  vdd  vdd  vdd  P_18  l=0.18u  w=0.5u

* Pull-down NMOS network for XOR3 function
mn1  out  a    n1   gnd  N_18  l=0.18u  w=2u
mn2  n1   b    gnd  gnd  N_18  l=0.18u  w=2u
mn3  out  a_   n2   gnd  N_18  l=0.18u  w=2u
mn4  n2   b_   gnd  gnd  N_18  l=0.18u  w=2u
mn5  out  c    n3   gnd  N_18  l=0.18u  w=2u
mn6  n3   c_   gnd  gnd  N_18  l=0.18u  w=2u

* Inverters for input signals
xinv1 a a_ inv
xinv2 b b_ inv
xinv3 c c_ inv
.ends

* Main circuit
xpseudo_xor3 a b c out pseudo_xor3

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