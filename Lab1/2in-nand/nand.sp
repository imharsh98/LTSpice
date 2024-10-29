* 2-input NAND (loading c=0.01p)
.lib 'cic018.l' tt
.global vdd gnd

.subckt  nand  a b  out
*m_name	drain	gate	source	body	model_name	length	width
mp0		out	 	a		vdd		vdd		P_18		l=0.18u	w=w1
mp1		out	 	b		vdd		vdd		P_18		l=0.18u	w=w1
mn0		out		a		net		gnd		N_18		l=0.18u	w=w1
mn1		net		b		gnd		gnd		N_18		l=0.18u	w=w1
.ends

xnand a b out nand

cload out gnd 0.02p

*v_name	+node	-node	value
vvdd	vdd		0		1.8
vgnd	gnd		0		0

*v_name	+node	-node	pulse(max	min	delay	rising	falling	duty	period)
va		a		0		pulse(0	1.8	5n		0.01n	0.01n	4.99n	10n)
vb		b		0		pulse(0	1.8	5n		0.01n	0.01n	9.99n	20n)
.tran 0.1n 50n
.step param w1 2u 20u 1u
.meas tran delay_time TRIG v(a) VAL=0.6 RISE=1 TARG v(out) VAL=0.6 FALL=1

* Measure average power consumption
.meas tran power_avg param='i(vvdd) * v(vdd)'

* Measure Power-Delay-Product (PDP)
.meas tran pdp PARAM='power_avg*delay_time'
.end
