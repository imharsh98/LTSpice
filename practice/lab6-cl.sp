* 8-bit Comparator SPICE file with Loading 0.1p
.lib 'cic018.l' tt
.global vdd gnd

* Basic Gate Subcircuits
.subckt inv in out
mp   out  in   vdd  vdd  P_18  l=0.18u  w=1u
mn   out  in   gnd  gnd  N_18  l=0.18u  w=0.5u
.ends

.subckt nand2 a b out
mp1  out  a   vdd  vdd  P_18  l=0.18u  w=2u
mp2  out  b   vdd  vdd  P_18  l=0.18u  w=2u
mn1  out  a   n1   gnd  N_18  l=0.18u  w=1u
mn2  n1   b   gnd  gnd  N_18  l=0.18u  w=1u
.ends

.subckt nor2 a b out
mp1  n1   a   vdd  vdd  P_18  l=0.18u  w=2u
mp2  out  b   n1   vdd  P_18  l=0.18u  w=2u
mn1  out  a   gnd  gnd  N_18  l=0.18u  w=0.5u
mn2  out  b   gnd  gnd  N_18  l=0.18u  w=0.5u
.ends

.subckt and2 a b out
xnand a b n1 nand2
xinv n1 out inv
.ends

.subckt or2 a b out
xnor a b n1 nor2
xinv n1 out inv
.ends

* 1-bit Comparator subcircuit
.subckt comp1bit a b altb aeqb agtb
xinv1 a a_inv inv
xinv2 b b_inv inv
xnor1 a b_inv altb nor2
xnand1 a b n1 nand2
xnand2 a_inv b_inv n2 nand2
xnand3 n1 n2 aeqb nand2
xnor2 a_inv b agtb nor2
.ends

* 2-bit Comparator subcircuit
.subckt comp2bit a1 a0 b1 b0 altb aeqb agtb
* Compare higher bits (a1,b1)
xcomp1 a1 b1 altb1 aeqb1 agtb1 comp1bit
* Compare lower bits (a0,b0)
xcomp0 a0 b0 altb0 aeqb0 agtb0 comp1bit

* Combine results
* A < B if: (A1 < B1) OR (A1 = B1 AND A0 < B0)
xand1 aeqb1 altb0 n1 and2
xor1 altb1 n1 altb or2

* A = B if: (A1 = B1) AND (A0 = B0)
xand2 aeqb1 aeqb0 aeqb and2

* A > B if: (A1 > B1) OR (A1 = B1 AND A0 > B0)
xand3 aeqb1 agtb0 n2 and2
xor2 agtb1 n2 agtb or2
.ends

* 4-bit Comparator subcircuit
.subckt comp4bit a3 a2 a1 a0 b3 b2 b1 b0 altb aeqb agtb
* Compare higher 2 bits
xcomp1 a3 a2 b3 b2 altb1 aeqb1 agtb1 comp2bit
* Compare lower 2 bits
xcomp0 a1 a0 b1 b0 altb0 aeqb0 agtb0 comp2bit

* Combine results using same logic as 2-bit
xand1 aeqb1 altb0 n1 and2
xor1 altb1 n1 altb or2

xand2 aeqb1 aeqb0 aeqb and2

xand3 aeqb1 agtb0 n2 and2
xor2 agtb1 n2 agtb or2
.ends

* 8-bit Comparator subcircuit
.subckt comp8bit a7 a6 a5 a4 a3 a2 a1 a0 b7 b6 b5 b4 b3 b2 b1 b0 altb aeqb agtb
* Compare higher 4 bits
xcomp1 a7 a6 a5 a4 b7 b6 b5 b4 altb1 aeqb1 agtb1 comp4bit
* Compare lower 4 bits
xcomp0 a3 a2 a1 a0 b3 b2 b1 b0 altb0 aeqb0 agtb0 comp4bit

* Combine results using same logic pattern
xand1 aeqb1 altb0 n1 and2
xor1 altb1 n1 altb or2

xand2 aeqb1 aeqb0 aeqb and2

xand3 aeqb1 agtb0 n2 and2
xor2 agtb1 n2 agtb or2
.ends

* Main circuit
xcomp8bit a7 a6 a5 a4 a3 a2 a1 a0 
+         b7 b6 b5 b4 b3 b2 b1 b0 
+         altb aeqb agtb comp8bit

* Load capacitances
cload1 altb gnd 0.1p
cload2 aeqb gnd 0.1p
cload3 agtb gnd 0.1p

* Supply voltage
vvdd vdd 0 1.8
vgnd gnd 0 0

* Input signals - example pattern testing different comparison cases
* A = 10101010 (binary)
va7 a7 0 pulse(1 1.8 0 0.1n 0.1n 10n 20n)
va6 a6 0 pulse(0 1.8 0 0.1n 0.1n 10n 20n)
va5 a5 0 pulse(1 1.8 0 0.1n 0.1n 10n 20n)
va4 a4 0 pulse(0 1.8 0 0.1n 0.1n 10n 20n)
va3 a3 0 pulse(1 1.8 0 0.1n 0.1n 10n 20n)
va2 a2 0 pulse(0 1.8 0 0.1n 0.1n 10n 20n)
va1 a1 0 pulse(1 1.8 0 0.1n 0.1n 10n 20n)
va0 a0 0 pulse(0 1.8 0 0.1n 0.1n 10n 20n)

* B = 10101011 (binary) - slightly larger than A
vb7 b7 0 pulse(1 1.8 0 0.1n 0.1n 10n 20n)
vb6 b6 0 pulse(0 1.8 0 0.1n 0.1n 10n 20n)
vb5 b5 0 pulse(1 1.8 0 0.1n 0.1n 10n 20n)
vb4 b4 0 pulse(0 1.8 0 0.1n 0.1n 10n 20n)
vb3 b3 0 pulse(1 1.8 0 0.1n 0.1n 10n 20n)
vb2 b2 0 pulse(0 1.8 0 0.1n 0.1n 10n 20n)
vb1 b1 0 pulse(1 1.8 0 0.1n 0.1n 10n 20n)
vb0 b0 0 pulse(1 1.8 0 0.1n 0.1n 10n 20n)

* Measurements for delay
.meas tran delay_altb trig v(a0) val=0.9 rise=1 
+                     targ v(altb) val=0.9 rise=1
.meas tran delay_aeqb trig v(a0) val=0.9 rise=1 
+                     targ v(aeqb) val=0.9 fall=1
.meas tran delay_agtb trig v(a0) val=0.9 rise=1 
+                     targ v(agtb) val=0.9 fall=1

* Power measurements
.meas tran power avg v(vdd)*i(vvdd)*-1
.meas tran pdp_altb param='power*delay_altb'
.meas tran pdp_aeqb param='power*delay_aeqb'
.meas tran pdp_agtb param='power*delay_agtb'

* Transient analysis
.tran 0.1n 40n

.end