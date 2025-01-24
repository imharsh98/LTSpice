# LTSpice

Repo containing all files related to LT SPICE lab at CGU 1st Sem

Each lab exercise is written using a .sp file which when simulated using the LTSpice tool produces .raw, .op.raw and a .log file. We are generally only interested in the .log file.

A guide to the programs:

* This line represents the gate which needs to be constructed

.subckt nand a b out

* PMOS Transistors
* format: mpN drain gate source body model length width
mp0 out a vdd vdd pch l=0.1u w=w1
mp1 out b vdd vdd pch l=0.1u w=w1
* NMOS Transistors
* the format remains the same as the PMOS
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

===========================================
List of folders in this repo and their purpose:

practice: Just hands-on practice. Nothing new in here.
practice-questions: Solutions to the practice questions problems shared.
reference answers: other students' solutions to certain questions 
presentation: files related to the exam presentation on a research paper
LTspiceResults.xlsx: Excel file containing the graphs for different problems.
exam: folder specific to the LT spice exam held on 20 Dec 2024 at CGU.
