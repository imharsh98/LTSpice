3-input XOR (loading c=0.01p)
.lib	'C:\Users\Lenovo\Desktop\LT (WEY)\Lab3\Pseudo NMOS\cic018.l'	tt
.global vdd gnd

.subckt  inv  in  out
*m_name	drain	gate	source	body	model_name	length	width
mp	out	in	vdd	vdd	P_18	l=0.18u	w=1u
mn	out	in	gnd	gnd	N_18	l=0.18u	w=0.5u
.ends

.subckt  xor   a  b c  out
xinv1 a a_ inv
xinv2 b b_ inv
xinv3 c c_ inv

*m_name	drain	gate	source	body	model_name	length	width
mp0	out		gnd	vdd		vdd	p_18	l=0.18u	w=0.5u

mn0	out		a_	net0	gnd	n_18	l=0.18u	w=3u
mn1	net0	b	net1	gnd	n_18	l=0.18u	w=3u
mn2	net1	c	gnd		gnd	n_18	l=0.18u	w=3u

mn3	out		a_	net2	gnd	n_18	l=0.18u	w=3u
mn4	net2	b_	net4	gnd	n_18	l=0.18u	w=3u
mn5	net3	c	gnd		gnd	n_18	l=0.18u	w=3u

mn6	out		a	net5	gnd	n_18	l=0.18u	w=3u
mn7	net5	b	net6	gnd	n_18	l=0.18u	w=3u
mn8	net6	c_	gnd		gnd	n_18	l=0.18u	w=3u

mn9	 out	a	net7	gnd	n_18	l=0.18u	w=3u
mn10 net7	b_	net8	gnd	n_18	l=0.18u	w=3u
mn11 net8   c	gnd		gnd	n_18	l=0.18u	w=3u

.ends

xor0 a b c  out xor

cload out gnd 0.01p

*v_name	+node	-node	value
vvdd	vdd	0	1.8
vgnd	gnd	0	0

*v_name	+node	-node	pulse(max	min	delay	rising	falling	duty	period)
vin	in	0	pulse(0	1.8	5n		0.01n	0.01n	2.49n	5n)
va	a	0	pulse(0	1.8	5n		0.01n	0.01n	4.99n	10n)
vb	b	0	pulse(0	1.8	10n		0.01n	0.01n	9.99n	20n)
vc	c	0	pulse(0	1.8	20n		0.01n	0.01n	19.9n	40n)

.meas	tran	delayN	trig	v(a)	val=0.9	rise=2
+						targ	v(out)	val=0.9	fall=1
.meas tran pw avg v(vdd)*i(Vvdd)*-1

.meas tran pdp PARAM pw*delayN
*.step param k 0.3u 5u 0.1u
.tran	0.01n	90n
.end
