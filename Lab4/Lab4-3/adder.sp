* Lab 6-2-a: Full Adder Voltage Analysis
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

* Main circuit - 1-bit full adder for voltage analysis
xfa1 a b ci s co fa

* Load capacitances
cload_s s gnd 0.1p
cload_co co gnd 0.1p

* Supply voltage parameter
.param SUPPLY=1.8

* Power supply (parameterized)
vvdd vdd 0 {SUPPLY}
vgnd gnd 0 0

* Input patterns with parameterized timing
.param base_period=40n
* .param scale_factor=1

* Scaled input patterns
VA A 0 pulse({SUPPLY} 0 1n 0.1n 0.1n '19.9n*scale_factor' '40n*scale_factor')
VB B 0 pulse({SUPPLY} 0 1n 0.1n 0.1n '39.9n*scale_factor' '80n*scale_factor')
VC CI 0 pulse({SUPPLY} 0 1n 0.1n 0.1n '79.9n*scale_factor' '160n*scale_factor')

* Analysis and measurements
.tran 0.05n '200n*scale_factor'

.meas tran delay_s trig v(a) val='SUPPLY/2' rise=1
+                  targ v(s) val='SUPPLY/2' rise=1
.meas tran delay_co trig v(a) val='SUPPLY/2' rise=1
+                   targ v(c0) val='SUPPLY/2' rise=1
.meas tran power avg p(vvdd)
.meas tran pdp param='power*max(delay_s,delay_co)'

* Voltage sweeps with corresponding timing adjustments
.alter
.param SUPPLY=1.6
.param scale_factor=1

.alter
.param SUPPLY=1.4
.param scale_factor=10

.alter
.param SUPPLY=1.2
.param scale_factor=10

.alter
.param SUPPLY=1.0
.param scale_factor=100

.alter
.param SUPPLY=0.8
.param scale_factor=100

.alter
.param SUPPLY=0.6
.param scale_factor=1000

.end