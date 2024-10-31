2-input NAND (loading c=0.02p)
.lib 'cic018.l' TT
.global vdd gnd

.subckt  nand  a b  out
*m_name	drain	gate	source	body	model_name	length	width
mp0		out	 	a		vdd		vdd		P_18		l=0.18u	w=1u
mp1		out	 	b		vdd		vdd		P_18		l=0.18u	w=1u
mn0		out		a		net		gnd		N_18		l=0.18u	w=1u
mn1		net		b		gnd		gnd		N_18		l=0.18u	w=1u
.ends

*instantiate first cascaded nand
xnand1 a b out1 nand
*2nd cascaded nand and others
xnand2 c out1 out2 nand
xnand3 d out2 out3 nand
xnand4 e out3 out4 nand

*add capacitors
cload out1 gnd 0.02p
cload2 out2 gnd 0.02p
cload3 out3 gnd 0.02p
cload4 out4 gnd 0.02p

*v_name	+node	-node	value
vvdd	vdd		0		1.8
vgnd	gnd		0		0

*v_name	+node	-node	pulse(max	min	delay	rising	falling	duty	period)
va		a		0		pulse(1.8	0	0.1n		0.1n	0.1n	9.9n	20n)
vb		b		0		1.8
vc 		c		0		1.8
vd		d		0		1.8
ve		e		0		1.8

.tran	0.1n	80n

.meas tran delayN1 TRIG v(a) VAL=0.9 RISE=1 TARG v(out1) VAL=0.9 FALL=1
.meas tran delayN2 TRIG v(a) VAL=0.9 RISE=1 TARG v(out2) VAL=0.9 FALL=1
.meas tran delayN3 TRIG v(a) VAL=0.9 RISE=1 TARG v(out3) VAL=0.9 FALL=1
.meas tran delayN4 TRIG v(a) VAL=0.9 RISE=1 TARG v(out4) VAL=0.9 FALL=1

* multiplied by -1 to indicate that the power is dissipiated power rather than the supplied power
.meas tran pw avg v(vdd)*i(Vvdd)*-1

* Measure Power-Delay-Product (PDP)
.meas tran pdp PARAM='pw*delayN1'
.end
