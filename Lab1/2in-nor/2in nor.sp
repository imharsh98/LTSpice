2-input nor (loading c=0.01p)
.lib 'cic018.l' tt
.global vdd gnd

.subckt  nor   a  b  out
*m_name	drain	gate	source	body	model_name	length	width
mp0	net	a	vdd	vdd	p_18	l=0.18u	w='4*k'
mp1	out	b	net	vdd	p_18	l=0.18u	w='4*k'

mn0	out	a	0	0	n_18	l=0.18u	w=k
mn1	out b	0	0	n_18	l=0.18u	w=k

.ends

xnor0 a b out nor

cload out gnd 0.02p

*v_name	+node	-node	value
vvdd	vdd		0		1.8
vgnd	gnd		0		0

*v_name	+node	-node	pulse(max	min	delay	rising	falling	duty	period)
va		a		0		pulse(0	1.8	5n		0.01n	0.01n	4.99n	10n)
vb		b		0		pulse(0	1.8	5n		0.01n	0.01n	9.99n	20n)

.meas	tran	delayN	trig	v(a)	val=0.9	rise=1
+						targ	v(out)	val=0.9	fall=1

.meas tran power param='v(vdd)*i(vvdd)'
.meas tran pdp param='power*delayN'

.tran	0.01n	50n
.step param k 0.25u 2.5u 0.05u
.end
