3-input XOR (loading c=0.01p)
.lib	'C:\Users\Lenovo\Desktop\LT (WEY)\Lab3\3ipXOR\cic018.l'	tt
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
mp0	net0	a_	vdd		vdd	p_18	l=0.18u	w='2*k'
mp1	net1	b	net0	vdd	p_18	l=0.18u	w='2*k'
mp2	out		c	net1	vdd	p_18	l=0.18u	w='2*k'

mp3	net2	a	vdd		vdd	p_18	l=0.18u	w='2*k'
mp4	net3	b_	net2	vdd	p_18	l=0.18u	w='2*k'
mp5	out		c	net3	vdd	p_18	l=0.18u	w='2*k'

mp6	net4	a	vdd		vdd	p_18	l=0.18u	w='2*k'
mp7	net5	b	net4	vdd	p_18	l=0.18u	w='2*k'
mp8	out		c_	net5	vdd	p_18	l=0.18u	w='2*k'

mp9		net6	a_	vdd		vdd	p_18	l=0.18u	w='2*k'
mp10	net7	b_	net6	vdd	p_18	l=0.18u	w='2*k'
mp11	out		c_	net7	vdd	p_18	l=0.18u	w='2*k'

mn0	out		a_	net8	gnd	n_18	l=0.18u	w=k
mn1	net8	b	net9	gnd	n_18	l=0.18u	w=k
mn2	net9	c	gnd		gnd	n_18	l=0.18u	w=k

mn3	out		a	net10	gnd	n_18	l=0.18u	w=k
mn4	net10	b_	net11	gnd	n_18	l=0.18u	w=k
mn5	net11	c	gnd		gnd	n_18	l=0.18u	w=k

mn6	out		a	net12	gnd	n_18	l=0.18u	w=k
mn7	net12	b	net13	gnd	n_18	l=0.18u	w=k
mn8	net13	c_	gnd		gnd	n_18	l=0.18u	w=k

mn9		out		a_	net14	gnd	n_18	l=0.18u	w=k
mn10	net14	b_	net15	gnd	n_18	l=0.18u	w=k
mn11	net15   c_	gnd		gnd	n_18	l=0.18u	w=k

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
.step param k 0.3u 5u 0.1u
.tran	0.01n	90n
.end
