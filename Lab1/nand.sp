NAND2

* //header
.lib 'cic018.l' tt

* //global nodes
.global vdd gnd
vvdd vdd 0 1.8
vgnd gnd 0 0

* //subcircuit definition
.subckt nand2 a b out
mp0	out	a vdd	vdd	P_18 l=0.18u w=2u
mp1	out	b vdd	vdd	P_18 l=0.18u w=2u
mn0	out	a net	0	N_18 l=0.18u w=2u
mn1	net	b  0	0	N_18 l=0.18u w=2u
.ends

* //subcircuit instanciation
xnand a b out nand2
cload0 out 0 0.02p

* //a_input signal patterns
va a 0	pulse(1.2 0	0.1n 0.1n 0.1n 4.9n	10n)

* //b_input signal patterns
vb b 0	pulse(1.2 0	0.1n 0.1n 0.1n 9.9n	20n)


* //measuring the propagation delay
.meas tran delay_1 trig v(a) val=0.6 rise=2
+                  targ v(out) val=0.6 rise=2
.meas tran delay_2 trig v(b) val=0.6 fall=3 targ v(out) val=0.6 rise=2

* //measuring the average power
.meas tran avg_power=param('i(vvdd) * vvdd')

* //Measuring the power delay product
.meas tran pdp=param('avg_power*delay_1')
.meas tran pdp=param('avg_power*delay_2')

* //Sweeping MOS size
.tran 0.1n 50n
.step param w 2u 20u 1u

.end
