* Inverter Circuit with Delay, Power, PDP, and MOS Size Sweep

.subckt inv in out
* PMOS Transistor
mp0 out in vdd vdd pch l=0.1u w='2*w1'
* NMOS Transistor
mn0 out in 0 0 nch l=0.1u w=w1
.ends

* Power supply
Vdd vdd 0 1.2

* Input signal (pulse)
Vin in 0 PULSE(0 1.2 0n 0.1n 0.1n 5n 10n)

* Load capacitor
Cload out 0 0.02p

* Simulation parameters
.tran 0.1n 50n sweep w1 2u 25u 1u

* Measure delay time (between 50% points on input and output)
.meas tran delay_time TRIG v(in) VAL=0.6 RISE=1 TARG v(out) VAL=0.6 FALL=1

* Measure average power consumption
.meas tran power_avg AVG power

* Measure Power-Delay-Product (PDP)
.meas tran pdp PARAM='power_avg*delay_time'

.end
