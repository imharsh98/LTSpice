* Cascaded Dynamic NAND/AND Circuit
.lib 'cic018.l' tt
.global vdd gnd

* Inverter subcircuit
.subckt inv in out
mp   out  in   vdd  vdd  P_18  l=0.18u  w=1u
mn   out  in   gnd  gnd  N_18  l=0.18u  w=0.5u
.ends

* Dynamic NAND subcircuit
.subckt dyn_nand2 a b ck out
* Pre-charge PMOS
mp1  out  ck_  vdd  vdd  P_18  l=0.18u  w=1u

* Evaluation network
mn1  out  ck   n1   gnd  N_18  l=0.18u  w=1u
mn2  n1   a    n2   gnd  N_18  l=0.18u  w=1u
mn3  n2   b    gnd  gnd  N_18  l=0.18u  w=1u

* Clock inverter
xinv_ck ck ck_ inv
.ends

* Main circuit with cascade
xnand1 a b    ck out1 dyn_nand2
xnand2 c d    ck out2 dyn_nand2
xnand3 out1 e ck out3 dyn_nand2
xnand4 out2 e ck out4 dyn_nand2

* Fan-out loading capacitances
c1 out1 gnd 0.02p
c2 out2 gnd 0.02p
c3 out3 gnd 0.02p
c4 out4 gnd 0.02p

* Supply voltage
vvdd vdd 0 1.8
vgnd gnd 0 0

* Input patterns
va  a  0 pulse(1.8 0 0.1n 0.1n 0.1n 9.9n 20n)
vb  b  0 1.8
vc  c  0 1.8
vd  d  0 1.8
ve  e  0 1.8
vck ck 0 pulse(0 1.8 2.1n 0.1n 0.1n 1.9n 4n)

* Measurements for each output
.meas tran delay1 trig v(a) val=0.9 fall=1
+                    targ v(out1) val=0.9 rise=1
.meas tran delay2 trig v(a) val=0.9 fall=1
+                    targ v(out2) val=0.9 rise=1
.meas tran delay3 trig v(a) val=0.9 fall=1
+                    targ v(out3) val=0.9 rise=1
.meas tran delay4 trig v(a) val=0.9 fall=1
+                    targ v(out4) val=0.9 rise=1

* Transient analysis
.tran 0.1n 40n

.end