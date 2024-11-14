6-input NAND (loading c=0.02p)
.lib	'C:\Users\Lenovo\Desktop\LT (WEY)\Lab2\NAND 2-8 ip\cic018.l' TT
.global vdd gnd

.subckt  nand  a b c d e f out
*m_name	drain	gate	source	body	model_name	length	width
mp0		out	 	a		vdd		vdd		P_18		l=0.18u	w=1u
mp1		out	 	b		vdd		vdd		P_18		l=0.18u	w=1u
mp2		out	 	c		vdd		vdd		P_18		l=0.18u	w=1u
mp3		out	 	d		vdd		vdd		P_18		l=0.18u	w=1u
mp4		out	 	e		vdd		vdd		P_18		l=0.18u	w=1u
mp5		out	 	f		vdd		vdd		P_18		l=0.18u	w=1u

mn0		out		f		net1	gnd		N_18		l=0.18u	w=1u
mn1		net1	e		net2	gnd		N_18		l=0.18u	w=1u
mn2 	net2	d		net3	gnd		N_18		l=0.18u w=1u
mn3		net3	c		net4	gnd		N_18		l=0.18u w=1u
mn4		net4	b		net5	gnd		N_18		l=0.18u w=1u
mn5		net5	a		gnd		gnd		N_18		l=0.18u w=1u
.ends

xnand a b c d e f out nand

cload out gnd 0.02p

*v_name	+node	-node	value
vvdd	vdd		0		1.8
vgnd	gnd		0		0

*v_name	+node	-node	pulse(max	min	delay	rising	falling	duty	period)
va		a		0		pulse( 1.8  0	 0.1n	 0.1n	0.1n 	9.9n	20n )
vb		b		0		1.8
vc		c		0		1.8
vd		d		0		1.8
ve		e		0		1.8
vf		f		0		1.8

.tran	0.1n	80n
.meas tran delayN1 trig v(a) val=0.9 rise=3
+                  targ v(out) val=0.9 fall=3
.meas tran pw avg v(vdd)*i(Vvdd)*-1
.meas tran pdp=param('pw*delayN1')

.end
