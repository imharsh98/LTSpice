* Dynamic CMOS Full Adder with 1ns delay time
.lib 'cic018.l' tt
.global vdd gnd

* Inverter subcircuit
.subckt inv in out
mp   out  in   vdd  vdd  P_18  l=0.18u  w=1u
mn   out  in   gnd  gnd  N_18  l=0.18u  w=0.5u
.ends

* Dynamic Full Adder subcircuit
.subckt dyn_fa clk a b cin s co
* Precharge PMOS for Sum
mp1  s    clk_  vdd  vdd  P_18  l=0.18u  w=2u
* Precharge PMOS for Carry
mp2  co   clk_  vdd  vdd  P_18  l=0.18u  w=2u

* Evaluation network for Sum
mn1  s    clk   n1   gnd  N_18  l=0.18u  w=1u
mn2  n1   a     n2   gnd  N_18  l=0.18u  w=1u
mn3  n2   b     n3   gnd  N_18  l=0.18u  w=1u
mn4  n3   cin   gnd  gnd  N_18  l=0.18u  w=1u

* Evaluation network for Carry
mn5  co   clk   n4   gnd  N_18  l=0.18u  w=1u
mn6  n4   a     n5   gnd  N_18  l=0.18u  w=1u
mn7  n5   b     n6   gnd  N_18  l=0.18u  w=1u
mn8  n6   cin   gnd  gnd  N_18  l=0.18u  w=1u

* Inverters
xinv1 clk clk_ inv
.ends

* Main circuit
xdyn_fa clk a b cin s co dyn_fa

* Load capacitances (1pF as specified)
cs s gnd 1p
cco co gnd 1p

* Supply voltage
vvdd vdd 0 1.8
vgnd gnd 0 0

* Input signals with 0.5ns rise/fall time
vclk clk 0 pulse(0 1.8 0 0.5n 0.5n 5n 10n)
va   a   0 pulse(0 1.8 0 0.5n 0.5n 10n 20n)
vb   b   0 pulse(0 1.8 0 0.5n 0.5n 20n 40n)
vcin cin 0 pulse(0 1.8 0 0.5n 0.5n 40n 80n)

* Measurements for delay verification
.meas tran delay_s_rise trig v(clk) val=0.9 rise=1
+                       targ v(s) val=0.9 rise=1
.meas tran delay_co_rise trig v(clk) val=0.9 rise=1
+                        targ v(co) val=0.9 rise=1

* Transient analysis
.tran 0.1n 100n

.end