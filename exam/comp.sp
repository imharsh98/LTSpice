
.lib 'cic018.l' tt
.global vdd gnd

* Inverter subcircuit
.subckt inv in out
mp out in vdd vdd P_18 l=0.18u w=1u
mn out in gnd gnd N_18 l=0.18u w=0.5u
.ends

* NAND2 subcircuit
.subckt nand2 a b out
mp1 out a vdd vdd P_18 l=0.18u w=1u
mp2 out b vdd vdd P_18 l=0.18u w=1u
mn1 out a n1 gnd N_18 l=0.18u w=0.5u
mn2 n1 b gnd gnd N_18 l=0.18u w=0.5u
.ends

* NAND3 subcircuit
.subckt nand3 a b c out
mp1 out a vdd vdd P_18 l=0.18u w=1u
mp2 out b vdd vdd P_18 l=0.18u w=1u
mp3 out c vdd vdd P_18 l=0.18u w=1u
mn1 out a n1 gnd N_18 l=0.18u w=0.5u
mn2 n1 b n2 gnd N_18 l=0.18u w=0.5u
mn3 n2 c out gnd N_18 l=0.18u w=0.5u
.ends

* NAND4 subcircuit
.subckt nand4 a b c d out
mp1 out a vdd vdd P_18 l=0.18u w=1u
mp2 out b vdd vdd P_18 l=0.18u w=1u
mp3 out c vdd vdd P_18 l=0.18u w=1u
mp4 out d vdd vdd P_18 l=0.18u w=1u
mn1 out a n1 gnd N_18 l=0.18u w=0.5u
mn2 n1 b n2 gnd N_18 l=0.18u w=0.5u
mn3 n2 c n3 gnd N_18 l=0.18u w=0.5u
mn4 n3 d gnd gnd N_18 l=0.18u w=0.5u
.ends

* NAND5 subcircuit
.subckt nand5 a b c d e out
mp1 out a vdd vdd P_18 l=0.18u w=1u
mp2 out b vdd vdd P_18 l=0.18u w=1u
mp3 out c vdd vdd P_18 l=0.18u w=1u
mp4 out d vdd vdd P_18 l=0.18u w=1u
mp5 out e vdd vdd P_18 l=0.18u w=1u
mn1 out a n1 gnd N_18 l=0.18u w=0.5u
mn2 n1 b n2 gnd N_18 l=0.18u w=0.5u
mn3 n2 c n3 gnd N_18 l=0.18u w=0.5u
mn4 n3 d n4 gnd N_18 l=0.18u w=0.5u
mn5 n4 e gnd gnd N_18 l=0.18u w=0.5u
.ends

*XOR2 subcircuit
.subckt xor a b out
xinv1 a a_ inv
xinv2 b b_ inv
mp0	net0	a	vdd	vdd	p_18	l=0.18u	w=1u
mp1	out	b_	net0	vdd	p_18	l=0.18u	w=1u
mp2	net1	a_	vdd	vdd	p_18	l=0.18u	w=1u
mp3	out	b	net1	vdd	p_18	l=0.18u	w=1u
mn0	out	a_	net2	0	n_18	l=0.18u	w=0.5u
mn1	net2 b_	0	    0   n_18	l=0.18u	w=0.5u
mn2	out	a	net3	0	n_18	l=0.18u	w=0.5u
mn3	net3	b	0	0	n_18	l=0.18u	w=0.5u
.ends

.subckt  nor2   a  b  out
mp0	net	a	vdd	vdd	p_18	l=0.18u	w=1u
mp1	out	b	net	vdd	p_18	l=0.18u	w=1u
mn0	out	a	0	0	n_18	l=0.18u	w=0.5u
mn1	out b	0	0	n_18	l=0.18u	w=0.5u
.ends

.subckt  nor4   a b c d  out
mp0	net1	a	vdd	    vdd	p_18	l=0.18u	w=1u
mp1	net2	b	net1	vdd	p_18	l=0.18u	w=1u
mp2	net3	c	net2	vdd	p_18	l=0.18u	w=1u
mp3	out 	d	net3	vdd	p_18	l=0.18u	w=1u
mn0	out	a	0	0	n_18	l=0.18u	w=0.5u
mn1	out b	0	0	n_18	l=0.18u	w=0.5u
mn2	out c	0	0	n_18	l=0.18u	w=0.5u
mn3	out d	0	0	n_18	l=0.18u	w=0.5u
.ends

.subckt xnor a b out
xxor1 a b n1 xor
xinv1 n1 out inv
.ends

* .subckt and a b out
* xinv1 b b_ inv
* xnand1 a b_ n1 nand2
* xinv2 n1 out inv
* .ends

* .subckt or a b out
* .ends

.subckt comp1 a b s01 c01
xinv1 b b_ inv
xxnor1 a b c01 xnor
xnand1 b_ a n1 nand2
xinv2 n1 s01 inv
.ends

.subckt comp2 a b c01 s02 c02
xinv1 b b_ inv
xxnor1 a b c02 xnor
xnand1 b_ a c01 n1 nand3
xinv2 n1 s02 inv
.ends

.subckt comp3 a b c01 c02 s03 c03
xinv1 b b_ inv
xxnor1 a b c03 xnor
xnand1 b_ a c01 c02 n1 nand4
xinv2 n1 s03 inv
.ends

.subckt comp4 a b c01 c02 c03 s04 c04
xinv1 b b_ inv
xxnor1 a b c04 xnor
xnand1 b_ a c01 c02 c03 n1 nand5
xinv2 n1 s04 inv
.ends

.subckt pre_final c01 c02 c03 c04 s01 s02 s03 s04 x1 x2
xnor1 s01 s02 s03 s04 n1 nor4
xinv1 n1 x1 inv
xnand1 c01 c02 c03 c04 n2 nand4
xinv2 n2 x2 inv
.ends

* 4-bit comparator
.subckt comp4bit a0 b0 a1 b1 a2 b2 a3 b3 g1 g2 g3
xcomp1 a0 b0 s01 c01 comp1
xcomp2 a1 b1 c01 s02 c02 comp2
xcomp3 a2 b2 c01 c02 s03 c03 comp3
xcomp4 a3 b3 c01 c02 c03 s04 c04 comp4
xpf1 c01 c02 c03 c04 s01 s02 s03 s04 g1 g2 pre_final
xnor1 g1 g2 g3 nor2
* xinv1 n1 g3 inv
.ends

* Main circuit
xcomp4bit a0 b0 a1 b1 a2 b2 a3 b3 g1 g2 g3 comp4bit

* Fixed load capacitance
cload g1 gnd 0.2p
cload1 g2 gnd 0.2p
cload2 g3 gnd 0.2p

* Supply voltage sources
vvdd vdd 0 1.4
vgnd gnd 0 0

* Input signals with parametric frequency scaling
va0 a0 0 0
* va0 a0 0 pulse(1.4 0 0.1n 0.1n 0.1n 4.9n 10n)
vb0 b0 0 pulse(1.4 0 0.1n 0.1n 0.1n 4.9n 10n)
* vb0 b0 0 0
va1 a1 0 pulse(1.4 0 0.1n 0.1n 0.1n 4.9n 10n)
vb1 b1 0 pulse(1.4 0 0.1n 0.1n 0.1n 4.9n 10n)
va2 a2 0 pulse(1.4 0 0.1n 0.1n 0.1n 4.9n 10n)
vb2 b2 0 pulse(1.4 0 0.1n 0.1n 0.1n 4.9n 10n)
va3 a3 0 pulse(1.4 0 0.1n 0.1n 0.1n 4.9n 10n)
vb3 b3 0 pulse(1.4 0 0.1n 0.1n 0.1n 4.9n 10n)

* Measurements
* .meas tran delay_eq trig v(a3) val=0.7 fall=1
* +                    targ v(g2) val=0.7 rise=1
* .meas tran delay_gt trig v(a3) val=0.7 fall=1
* n)

* Measurements
* .meas tran delay_eq trig v(a3) val=0.7 fall=1
* +                    targ v(g2) val=0.7 rise=1
* .meas tran delay_gt trig v(a3) val=0.7 fall=1
* +                    targ v(g1) val=0.7 rise=1
* .meas tran delay_lt trig v(a) val=0.7 fall=1
* +                    targ v(g3) val=0.7 rise=1

.meas tran power avg v(vdd)*i(vvdd)*-1

* .meas tran pdp param='power*(delay_eq+delay_gt+delay_lt)/3'

.tran 0.1n 160n

.end


