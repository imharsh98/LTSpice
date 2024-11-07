* 1-bit full adder analysis
.lib 'cic018.l' tt
.global vdd gnd

* Inverter subcircuit
.subckt inv in out
mp out in vdd vdd P_18 l=0.18u w=2u
mn out in gnd gnd N_18 l=0.18u w=1u
.ends

* NAND2 subcircuit
.subckt nand2 a b out
mp1 out a vdd vdd P_18 l=0.18u w=2u
mp2 out b vdd vdd P_18 l=0.18u w=2u
mn1 out a n1  gnd N_18 l=0.18u w=2u
mn2 n1  b gnd gnd N_18 l=0.18u w=2u
.ends

* XOR subcircuit using pass transistor logic
.subckt xor a b out
xinv1 a a_ inv
xinv2 b b_ inv
xinv3 n1 out inv

mn1 vdd a n1 gnd N_18 l=0.18u w=2u
mn2 gnd a_ n1 gnd N_18 l=0.18u w=2u
mn3 n1_ b n1 gnd N_18 l=0.18u w=2u
mn4 n1 b_ n1 gnd N_18 l=0.18u w=2u 
.ends

* 1-bit full adder subcircuit
.subckt fa a b ci s co
xxor1 a b n1 xor
xxor2 n1 ci s xor

xnand1 a b n2 nand2
xnand2 b ci n3 nand2
xnand3 a ci n4 nand2
xnand4 n2 n3 n5 nand2
xnand5 n5 n4 co nand2
.ends

* Main circuit - 1-bit full adder test
xfa1 a b ci s co fa

* Load capacitances (0.1p as specified)
cload_s s gnd 0.1p
cload_co co gnd 0.1p

* Power Supply
vvdd vdd 0 1.8
vgnd gnd 0 0

* Input patterns
VA A 0 pulse(1.8 0 1n 0.1n 0.1n 19.9n 40n)
VB B 0 pulse(1.8 0 1n 0.1n 0.1n 39.9n 80n)
VC CI 0 pulse(1.8 0 1n 0.1n 0.1n 79.9n 160n)

* Analysis commands
.tran 0.05n 200n

* Measurements for delay and power
.meas tran delay_s trig v(a) val=0.9 rise=1
+                  targ v(s) val=0.9 rise=1
.meas tran delay_co trig v(a) val=0.9 rise=1
+                  targ v(co) val=0.9 rise=1
.meas tran power avg p(vvdd)
.meas tran pdp param='power*max(delay_s,delay_co)'

.end