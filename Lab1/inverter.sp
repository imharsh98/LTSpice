nverter

* //header
.lib 'cic018.l' tt

* //global nodes
.global vdd gnd
vvdd vdd 0 1.8
vgnd gnd 0 0

* //subcircuit definition
.subckt inverter in out
mp0 out in vdd vdd P_18 l=0.18u w=2u
mn0 out in gnd gnd N_18 l=0.18u w=1u
.ends

* //subcircuit instanciation
xinv in out inverter
cload0 out 0 0.02p

* //input signal patterns
va in 0	pulse(1.2 0	0.1n 0.1n 0.1n 4.9n	10n)
*vb in 0	pulse(1.2 0	0.1n 0.1n 0.1n 9.9n	20n)
*vc in 0	pulse(1.2 0	0.1n 0.1n 0.1n	19.9n 40n)
*vd in 0	pulse(1.2 0	0.1n 0.1n 0.1n	39.9n 80n)

* //measuring the propagation delay
.meas tran delay trig v(in) val=0.6 rise=1 targ v(out) val=0.6 fall=1

* //measuring the average power
.meas tran power avg power

* //Measuring the Product power delay
.meas tran pdp=param('power*delay')

* //Sweeping MOS size
* //.tran 0.1n 50n sweep w1 2u 25u 1u

.end
