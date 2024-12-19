* Pass-Transistor Circuit for Question 8
.lib 'cic018.l' tt 
.global vdd gnd

.subckt inv in out
mp   out  in   vdd  vdd  P_18  l=0.18u  w=1u
mn   out  in   gnd  gnd  N_18  l=0.18u  w=0.5u
.ends

.subckt q8_circuit a b out
xinv1 a a_ inv
xinv2 b b_ inv

* NMOS pass transistors
mn1  vdd    a     out  gnd  n_18  l=0.18u  w=1u 
mn2  gnd    a_    out  gnd  n_18  l=0.18u  w=1u
mn3  vdd    b     out  gnd  n_18  l=0.18u  w=1u
mn4  gnd    b_    out  gnd  n_18  l=0.18u  w=1u
.ends

* Main circuit
xq8 a b out q8_circuit

* Fixed load capacitance
cload out gnd 2p 

* Supply voltage sources
vvdd vdd 0 1.8
vgnd gnd 0 0

* Input signals
va a 0 pulse(1.8 0 0.1n 0.1n 0.1n 0.3n 0.8n)
vb b 0 pulse(1.8 0 0.1n 0.1n 0.1n 0.3n 1.6n)

* Measurements
.meas tran delay trig v(a) val=0.9 fall=1
+                   targ v(out) val=0.9 rise=1

.meas tran power avg v(vdd)*i(vvdd)*-1

.meas tran pdp param='power*delay'

* Transient analysis
.tran 0.1n 2n

.end