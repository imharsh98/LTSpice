* SCL gate implementation (without Source Follower Buffer)
.lib 'cic018.l' tt
.global vdd gnd

* Inverter subcircuit for reference
* format: mpN drain gate source body model length width
.subckt inv in out
mp   out  in   vdd  vdd  P_18  l=0.18u  w=1u
mn   out  in   gnd  gnd  N_18  l=0.18u  w=0.5u
.ends

* SCL subcircuit
.subckt scl in_p in_n out bias_scl
* Differential pair
* format: mpN drain gate source body model length width
mn1  out   in_p  tail  gnd  N_18  l=0.18u  w=1u
mn2  out_b in_n  tail  gnd  N_18  l=0.18u  w=1u
* Tail current source
mn_tail tail bias_scl gnd gnd N_18 l=0.18u w=2u

* Active loads with bulk connected to drain
* format: mpN drain gate source body model length widths
mp1  out   bias_ld  vdd   vdd  P_18  l=0.18u  w=1u
mp2  out_b bias_ld  vdd vdd  P_18  l=0.18u  w=1u

* Replica bias circuit for load devices
* format: mpN drain gate source body model length width
mp_rb   rb_out  bias_ld  vdd  vdd  P_18  l=0.18u  w=1u
mn_rb   rb_out  vdd tail_rb gnd  N_18  l=0.18u  w=1u
mn_rbt  tail_rb bias_scl gnd     gnd  N_18  l=0.18u  w=2u
.ends

* Main circuit
xscl a_p a_n out bias_scl scl

* Load capacitance
cload out gnd {cval}

* Bias voltage sources
vbias_scl bias_scl 0 0.4
vbias_ld  bias_ld  0 0.4

* Supply voltage
vdd vdd 0 0.5
vgnd gnd 0 0

* Input signals with parametric frequency scaling
* Differential inputs - adjusted voltage levels for sub-threshold operation
* va_p a_p 0 pulse(0.5 0.1 0.1n 0.1n 0.1n 'duty/freq_mult' '80n/freq_mult')
* va_n a_n 0 pulse(0.1 0.5 0.1n 0.1n 0.1n 'duty/freq_mult' '80n/freq_mult')

* Input signals
* va_p: Input signal on node a_p.
* This signal is a pulse that switches between 0.5V and 0.1V
* PULSE(0.5 0.1 0.1n 0.1n 0.1n 40n 80n):
* Starts at 0.5V, switches to 0.1V after 0.1n, with rise and fall times of 0.1ns.
* The pulse width (time the signal is high) is 40ns, and the period is 80ns.
va_p a_p 0 pulse(0.5 0.1 0.1n 0.1n 0.1n 40n 80n)
va_n a_n 0 pulse(0.1 0.5 0.1n 0.1n 0.1n 40n 80n)

* Base duty cycle
.param duty = 39.9n

* Measurements
* Measure rising edge propagation delay
* .meas tran tpdr trig v(a_p) val=0.3 fall=1
* +                    targ v(out) val=0.25 rise=1
* * Measure falling edge propagation delay
* .meas tran tpdf trig v(a_p) val=0.3 rise=1
* +                    targ v(out) val=0.25 fall=1
* * Average propagation delay
* .meas tran delay param='(tpdr+tpdf)/2'
* .meas tran delay trig v(a_p) val=0.5 fall=1 targ v(out) val=0.6 rise=1
.meas tran delay trig v(a_p) val=0.3 fall=1 targ v(out) val=0.598 rise=1

* Power measurement
.meas tran power avg v(vdd)*i(vdd)*-1

* Power-delay product
.meas tran pdp param='power*delay'

* Transient analysis
* .tran 0.1n '160n/freq_mult'
.tran 0.1n 160n

* Parameter sweep for frequency multiplication
* .step param freq_mult list 1 2 4 8 16

.step param cval 20f 90f 10f

.end
