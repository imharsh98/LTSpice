* 3-input Dynamic XOR with 1ns delay time
.lib 'cic018.l' tt
.global vdd gnd

* Inverter subcircuit
.subckt inv in out
mp   out  in   vdd  vdd  P_18  l=0.18u  w=1u
mn   out  in   gnd  gnd  N_18  l=0.18u  w=0.5u
.ends

* Dynamic XOR3 subcircuit
.subckt dyn_xor3 clk a b c out
* Precharge PMOS
mp1  out  clk_  vdd  vdd  P_18  l=0.18u  w=2u

* Evaluation network for XOR3 function
mn1  out   clk  n1   gnd  N_18  l=0.18u  w=1u
mn2  n1    a    n2   gnd  N_18  l=0.18u  w=1u
mn3  n2    b    gnd  gnd  N_18  l=0.18u  w=1u
mn4  n1    a_   n3   gnd  N_18  l=0.18u  w=1u
mn5  n3    b_   gnd  gnd  N_18  l=0.18u  w=1u

* Inverters for input signals
xinv1 clk clk_ inv
xinv2 a a_ inv
xinv3 b b_ inv
xinv4 c c_ inv
.ends

* Main circuit
xdyn_xor3 clk a b c out dyn_xor3

* Load capacitance (1pF as specified)
cload out gnd 1p

* Supply voltage
vvdd vdd 0 1.8
vgnd gnd 0 0

* Input signals with 0.5ns rise/fall time
vclk clk 0 pulse(0 1.8 0 0.5n 0.5n 5n 10n)
va   a   0 pulse(0 1.8 0 0.5n 0.5n 10n 20n)
vb   b   0 pulse(0 1.8 0 0.5n 0.5n 20n 40n)
vc   c   0 pulse(0 1.8 0 0.5n 0.5n 40n 80n)

* Measurements for delay verification
.meas tran delay_rise trig v(clk) val=0.9 rise=1
+                     targ v(out) val=0.9 fall=1
.meas tran delay_fall trig v(clk) val=0.9 fall=1
+                     targ v(out) val=0.9 rise=1

* Transient analysis
.tran 0.1n 100n

.end