2-input nor (loading c=0.01p)
.lib 'cic018.l' tt
.global vdd gnd

.subckt  inv  in  out
*m_name	drain	gate	source	body	model_name	length	width
mp		out		in		vdd		vdd		P_18		l=0.18u	w=k
mn		out		in		gnd		gnd		N_18		l=0.18u	w=0.5u
.ends

.subckt  nor   a  b  out
*m_name	drain	gate	source	body	model_name	length	width
mp0	net	a	vdd	vdd	p_18	l=0.18u	w='4*k'
mp1	out	b	net	vdd	p_18	l=0.18u	w='4*k'

mn0	out	a	0	0	n_18	l=0.18u	w=k
mn1	out b	0	0	n_18	l=0.18u	w=k

.ends

.subckt  nor1   a  b  out
*m_name	drain	gate	source	body	model_name	length	width
mp0	net	a	vdd	vdd	p_18	l=0.18u	w=4u
mp1	out	b	net	vdd	p_18	l=0.18u	w=4u

mn0	out	a	0	0	n_18	l=0.18u	w=1u
mn1	out b	0	0	n_18	l=0.18u	w=1u

.ends

xnor0 a b out nor

cload out gnd 0.01p

*v_name	+node	-node	value
vvdd	vdd		0		1.8
vgnd	gnd		0		0

*v_name	+node	-node	pulse(max	min	delay	rising	falling	duty	period)
vin		in		0		pulse(0	1.8	5n		0.01n	0.01n	2.49n	5n)
va		a		0		pulse(0	1.8	5n		0.01n	0.01n	4.99n	10n)
vb		b		0		pulse(0	1.8	5n		0.01n	0.01n	9.99n	20n)
vc		c		0		pulse(0	1.8	5n		0.01n	0.01n	19.9n	40n)
vd		d		0		pulse(0	1.8	5n		0.01n	0.01n	39.9n	80n)

.meas	tran	delayN	trig	v(a)	val=0.9	rise=1
+						targ	v(out)	val=0.9	fall=1

.meas tran pw avg v(vdd)*i(Vvdd)*-1+v(b)*i(vB)*-1+v(a)*i(vA)*-1+v(out)*i(cload)*-1

.meas tran pw1 avg v(vdd)*i(Vvdd)*-1
.meas tran pw2 avg v(b)*i(vB)*-1
.meas tran pw3 avg v(a)*i(vA)*-1
.meas tran pw4 avg v(out)*i(cload)
.meas tran pdp PARAM pw*delayN
*.meas tran maxpower max power
*.meas tran minpower min power
.tran	0.01n	50n
.step param k 0.25u 2.5u 0.05u
*(sweep 	k 	0.25u  2.5u   0.05u)
.end
