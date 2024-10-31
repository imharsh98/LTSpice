4-input NAND (loading c=0.02p)
.lib 'cic018.l' TT
.global vdd gnd

.subckt  nand  a b c d out
*m_name	drain	gate	source	body	model_name	length	width
mp0		out	 	a		vdd		vdd		P_18		l=0.18u	w=1u
mp1		out	 	b		vdd		vdd		P_18		l=0.18u	w=1u
mp2		out	 	c		vdd		vdd		P_18		l=0.18u	w=1u
mp3		out	 	d		vdd		vdd		P_18		l=0.18u	w=1u

mn0		out		d		net1	gnd		N_18		l=0.18u	w=1u
mn1		net1	c		net2	gnd		N_18		l=0.18u	w=1u
mn2 	net2	b		net3	gnd		N_18		l=0.18u w=1u
mn3		net3	a		gnd		gnd		N_18		l=0.18u w=1u
.ends

xnand a b c d out nand

cload out gnd {k}

*v_name	+node	-node	value
vvdd	vdd		0		1.8
vgnd	gnd		0		0

*v_name	+node	-node	pulse(max	min	delay	rising	falling	duty	period)
va		a		0		pulse( 1.8  0	 0.1n	 0.1n	0.1n 	9.9n	20n )
vb		b		0		1.8
vc		c		0		1.8
vd		d		0		1.8
.tran	0.1n	80n
.step param k 0.05p 1p 0.05p
.meas tran delayN1 trig v(a) val=0.9 rise=3
+                  targ v(out) val=0.9 fall=3
.meas tran pw avg v(vdd)*i(Vvdd)*-1
.meas tran pdp=param('pw*delayN1')

.end
