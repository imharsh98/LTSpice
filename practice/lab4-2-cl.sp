* LAB 6-1-b: 8-bit Ripple Carry Adder Analysis
.lib 'cic018.l' tt
.global vdd gnd

* Inverter subcircuit
.subckt inv in out
mp   out  in   vdd  vdd  P_18  l=0.18u  w=2u
mn   out  in   gnd  gnd  N_18  l=0.18u  w=1u
.ends

* NAND2 subcircuit
.subckt nand2 a b out
mp1  out  a   vdd  vdd  P_18  l=0.18u  w=2u
mp2  out  b   vdd  vdd  P_18  l=0.18u  w=2u
mn1  out  a   n1   gnd  N_18  l=0.18u  w=2u
mn2  n1   b   gnd  gnd  N_18  l=0.18u  w=2u
.ends

* XOR subcircuit
.subckt xor a b out
xinv1 a a_ inv
xinv2 b b_ inv
xinv3 n1 out inv

mn1  vdd    a     n1   gnd  N_18  l=0.18u  w=2u
mn2  gnd    a_    n1   gnd  N_18  l=0.18u  w=2u
mn3  n1_    b     n1   gnd  N_18  l=0.18u  w=2u
mn4  n1     b_    n1   gnd  N_18  l=0.18u  w=2u
.ends

* 1-bit Full Adder subcircuit
.subckt fa a b ci s co
xxor1 a b n1 xor
xxor2 n1 ci s xor

xnand1 a b n2 nand2
xnand2 b ci n3 nand2
xnand3 a ci n4 nand2
xnand4 n2 n3 n5 nand2
xnand5 n5 n4 co nand2
.ends

* 8-bit Ripple Carry Adder
.subckt rca8 a7 a6 a5 a4 a3 a2 a1 a0 
+           b7 b6 b5 b4 b3 b2 b1 b0 
+           ci
+           s7 s6 s5 s4 s3 s2 s1 s0 co7

xfa0 a0 b0 ci     s0 c0 fa
xfa1 a1 b1 c0     s1 c1 fa
xfa2 a2 b2 c1     s2 c2 fa
xfa3 a3 b3 c2     s3 c3 fa
xfa4 a4 b4 c3     s4 c4 fa
xfa5 a5 b5 c4     s5 c5 fa
xfa6 a6 b6 c5     s6 c6 fa
xfa7 a7 b7 c6     s7 co7 fa
.ends

* Main circuit - 8-bit RCA test
xrca8 a7 a6 a5 a4 a3 a2 a1 a0 
+     b7 b6 b5 b4 b3 b2 b1 b0 
+     ci
+     s7 s6 s5 s4 s3 s2 s1 s0 co7 rca8

* Load capacitances (0.1p for all outputs)
cload_s0 s0 gnd 0.1p
cload_s1 s1 gnd 0.1p
cload_s2 s2 gnd 0.1p
cload_s3 s3 gnd 0.1p
cload_s4 s4 gnd 0.1p
cload_s5 s5 gnd 0.1p
cload_s6 s6 gnd 0.1p
cload_s7 s7 gnd 0.1p
cload_co7 co7 gnd 0.1p

* Power supply
vvdd vdd 0 1.8
vgnd gnd 0 0

* Input patterns (similar timing as 1-bit but for all 8 bits)
* A inputs
VA0 A0 0 pulse(1.8 0 1n 0.1n 0.1n 19.9n 40n)
VA1 A1 0 pulse(1.8 0 1n 0.1n 0.1n 19.9n 40n)
VA2 A2 0 pulse(1.8 0 1n 0.1n 0.1n 19.9n 40n)
VA3 A3 0 pulse(1.8 0 1n 0.1n 0.1n 19.9n 40n)
VA4 A4 0 pulse(1.8 0 1n 0.1n 0.1n 19.9n 40n)
VA5 A5 0 pulse(1.8 0 1n 0.1n 0.1n 19.9n 40n)
VA6 A6 0 pulse(1.8 0 1n 0.1n 0.1n 19.9n 40n)
VA7 A7 0 pulse(1.8 0 1n 0.1n 0.1n 19.9n 40n)

* B inputs
VB0 B0 0 pulse(1.8 0 1n 0.1n 0.1n 39.9n 80n)
VB1 B1 0 pulse(1.8 0 1n 0.1n 0.1n 39.9n 80n)
VB2 B2 0 pulse(1.8 0 1n 0.1n 0.1n 39.9n 80n)
VB3 B3 0 pulse(1.8 0 1n 0.1n 0.1n 39.9n 80n)
VB4 B4 0 pulse(1.8 0 1n 0.1n 0.1n 39.9n 80n)
VB5 B5 0 pulse(1.8 0 1n 0.1n 0.1n 39.9n 80n)
VB6 B6 0 pulse(1.8 0 1n 0.1n 0.1n 39.9n 80n)
VB7 B7 0 pulse(1.8 0 1n 0.1n 0.1n 39.9n 80n)

* Carry in
VCI CI 0 pulse(1.8 0 1n 0.1n 0.1n 79.9n 160n)

* Analysis commands
.tran 0.05n 200n

* Measurements for worst-case delay (through all 8 bits)
.meas tran delay_s7 trig v(a0) val=0.9 rise=1 
+                   targ v(s7) val=0.9 rise=1
.meas tran delay_co7 trig v(a0) val=0.9 rise=1 
+                    targ v(co7) val=0.9 rise=1
.meas tran power avg p(vvdd)
.meas tran pdp param='power*max(delay_s7,delay_co7)'

.end