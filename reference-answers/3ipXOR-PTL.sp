3_input_pass_transistor_xor
.lib 'C:\Users\Lenovo\Desktop\LT (WEY)\Lab3\Pass transistor\cic018.l' tt
.global vdd gnd

.subckt inv in out
mp out in vdd vdd P_18 l=0.18u w=0.5u
mn out in gnd gnd N_18 l=0.18u w=1u
.ends

* drain gate source body mos_type L
.subckt  xor   a  b c x xx out
xinv1 a a_ inv
xinv2 b b_ inv
xinv3 c c_ inv
xd1 x x_  inv
xd2 x_ xx inv

*m_name	drain	gate	source	body	model_name	length	width
mn0	x		b_	a	gnd N_18 l=0.18u w=1u
mn1	x		b	a_	gnd N_18 l=0.18u w=1u
mn2	out	    x_	c	gnd N_18 l=0.18u w=1u
mn3	out 	xx	c_	gnd	N_18 l=0.18u w=1u

*xd3 out1 out2 vdd gnd inv1
*xd4 out2 out vdd gnd inv1

.ends
xxor a b c x xx out  xor
*cload node+ node- value
cload out gnd 0.01p

*DC source
*v_name	+node	-node	value
vvdd	vdd	0	1.8
vgnd	gnd	0	0

*V node+ node- pulse(V1 V2 T_delay T_rise T_fall pw period)
va a 0 pulse(1.8 0 0.1n 0.1n 0.1n 39.9n 80n)
vb b 0 pulse(1.8 0 0.1n 0.1n 0.1n 79.9n 160n)
vc c 0 pulse(1.8 0 0.1n 0.1n 0.1n 159.9n 320n)
.tran 0.1n 640n
*(sweep k 0.05p 0.3p 0.05p)

*delay analysis val=half of vdd
.meas tran delayN1 trig v(a) val=0.9 rise=4
+ 				   targ v(out) val=0.9 rise=3

*average_power analysis
.meas tran pw avg v(vdd)*i(Vvdd)*-1

*power-Delay-Product(pdp) analysis
.meas tran pdp=param('pw*delayN1')
.end
