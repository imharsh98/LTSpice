* Inverter Circuit with Delay, Power, PDP, and MOS Size Sweep
.lib 'cic018.l' tt
.global vdd gnd

.subckt inv in out
* PMOS Transistor
mp0 out in vdd vdd P_18 l=0.18u w='2*w1'
* NMOS Transistor
mn0 out in 0 0 N_18 l=0.18u w=w1
.ends

xinv in out inv
* Power supply
vvdd vdd 0 1.2
vgnd gnd 0 0

* Input signal (pulse)
Vin in 0 PULSE(0 1.2 0n 0.1n 0.1n 5n 10n)

* Load capacitor
Cload out gnd 0.02p

* Simulation parameters
.tran 0.1n 50n 
.step param w1 2u 25u 1u

* Measure delay time (between 50% points on input and output)
.meas tran delay_time TRIG v(in) VAL=0.6 RISE=1 TARG v(out) VAL=0.6 FALL=1

* Measure average power consumption
.meas tran power_avg param='i(vvdd) * v(vdd)'

* Measure Power-Delay-Product (PDP)
.meas tran pdp PARAM='power_avg*delay_time'

.end
