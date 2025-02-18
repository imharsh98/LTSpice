* 2-input NAND Gate with Delay, Power, PDP, and MOS Size Sweep

.subckt nand a b out
* PMOS Transistors
* format: mpN drain gate source body model length width
mp0 out a vdd vdd pch l=0.1u w=w1
mp1 out b vdd vdd pch l=0.1u w=w1
* NMOS Transistors
mn0 out a net 0 nch l=0.1u w=w1
mn1 net b 0 0 nch l=0.1u w=w1
.ends

* Power supply
Vdd vdd 0 1.2

* Input signals
* Va: Input signal on node a.
* This signal is a pulse that switches between 0V and 1.2V.
* PULSE(0 1.2 0n 0.1n 0.1n 5n 10n):
* Starts at 0V, switches to 1.2V after 0n (no delay), with rise and fall times of 0.1ns.
* The pulse width (time the signal is high) is 5ns, and the period is 10ns.
Va a 0 PULSE(0 1.2 0n 0.1n 0.1n 5n 10n)

* Vb: Input signal on node b.
* Same as Va, but it switches with a delay of 5ns, having a period of 20ns.
Vb b 0 PULSE(0 1.2 0n 0.1n 0.1n 10n 20n)

* Load capacitor
Cload out 0 0.02p

* Simulation parameters
* 0.1n is the timestep and 50n is the total time
.tran 0.1n 50n sweep w1 2u 20u 1u

* Measure delay time
* This measures the delay time between the rising edge of the input (a) and the falling edge of the output (out).
* TRIG v(a) VAL=0.6 RISE=1: The trigger point occurs when the voltage of a rises to 0.6V (first rising edge).
* TARG v(out) VAL=0.6 FALL=1: The target point is when the voltage at out falls to 0.6V (first falling edge).
* The delay time is the time difference between these two events.
.meas tran delay_time TRIG v(a) VAL=0.6 RISE=1 TARG v(out) VAL=0.6 FALL=1

* Measure average power consumption
.meas tran power_avg AVG power

* Measure Power-Delay-Product (PDP)
.meas tran pdp PARAM='power_avg*delay_time'

.end
