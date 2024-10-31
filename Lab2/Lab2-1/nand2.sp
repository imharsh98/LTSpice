2-input NAND (loading c=0.02p)
.lib 'cic018.l' TT
.global vdd gnd

.subckt  nand  a b out
*m_name	drain	gate	source	body	model_name	length	width
mp0		out	 	a		vdd		vdd		P_18		l=0.18u	w=1u
mp1		out	 	b		vdd		vdd		P_18		l=0.18u	w=1u

mn0 	out	    b		net     gnd		N_18		l=0.18u w=1u
mn1		net 	a		gnd 	gnd		N_18		l=0.18u w=1u
.ends

xnand a b out nand

cload out gnd 0.02p

*v_name	+node	-node	value
vvdd	vdd		0		1.8
vgnd	gnd		0		0

*v_name	+node	-node	pulse(max	min	delay	rising	falling	duty	period)
va		a		0		pulse( 1.8  0	 0.1n	 0.1n	0.1n 	9.9n	20n )
vb		b		0		1.8

.tran	0.1n	80n
.meas tran delayN1 trig v(a) val=0.9 rise=3
+                  targ v(out) val=0.9 fall=3
.meas tran pw avg v(vdd)*i(Vvdd)*-1
.meas tran pdp=param('pw*delayN1')

.end
