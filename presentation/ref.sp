* SCL gate with Source Follower Buffer implementation
.lib 'cic018.l' tt
.global vdd gnd

* Inverter subcircuit for reference
.subckt inv in out
mp   out  in   vdd  vdd  P_18  l=0.18u  w=1u
mn   out  in   gnd  gnd  N_18  l=0.18u  w=0.5u
.ends

* SCL with Source Follower Buffer subcircuit
.subckt scl_sfb in_p in_n out bias_scl bias_sf
* SCL Core
* Differential pair
mn1  out_p  in_p  tail  gnd  N_18  l=0.18u  w=1u
mn2  out_n  in_n  tail  gnd  N_18  l=0.18u  w=1u
* Tail current source
mn_tail tail bias_scl gnd gnd N_18 l=0.18u w=2u

* Active loads with bulk connected to drain
mp1  out_p  bias_ld  out_p  vdd  P_18  l=0.18u  w=1u
mp2  out_n  bias_ld  out_n  vdd  P_18  l=0.18u  w=1u

* Source Follower Buffer
* NMOS source followers
mn_sf1  out    out_p  sf_tail1  gnd  N_18  l=0.18u  w=1u
mn_sf2  out_b  out_n  sf_tail2  gnd  N_18  l=0.18u  w=1u

* Source follower tail current sources
mn_sft1  sf_tail1  bias_sf  gnd  gnd  N_18  l=0.18u  w=2u
mn_sft2  sf_tail2  bias_sf  gnd  gnd  N_18  l=0.18u  w=2u

* Replica bias circuit for load devices
mp_rb   rb_out  bias_ld  vdd  vdd  P_18  l=0.18u  w=1u
mn_rb   rb_out  vdd tail_rb gnd  N_18  l=0.18u  w=1u
mn_rbt  tail_rb bias_scl gnd     gnd  N_18  l=0.18u  w=2u
.ends

* Main circuit
xscl a_p a_n out bias_scl bias_sf scl_sfb

* Load capacitance
cload out gnd {cval}
* cload out gnd 60f

* Bias voltage sources
vbias_scl bias_scl 0 0.4
vbias_sf  bias_sf  0 0.4
vbias_ld  bias_ld  0 0.8

* Supply voltage
vdd vdd 0 0.5
vgnd gnd 0 0

* Input signals with parametric frequency scaling
* Differential inputs
* va_p a_p 0 pulse(0.6 0 0.1n 0.1n 0.1n 'duty/freq_mult' '80n/freq_mult')
* va_n a_n 0 pulse(0 0.6 0.1n 0.1n 0.1n 'duty/freq_mult' '80n/freq_mult')
va_p a_p 0 pulse(0.6 0 0.1n 0.1n 0.1n 40n 80n)
va_n a_n 0 pulse(0 0.6 0.1n 0.1n 0.1n 40n 80n)

* Base duty cycle
.param duty = 39.9n

* Measurements
.meas tran delay trig v(a_p) val=0.3 fall=1 targ v(out) val=0.0001 rise=1

.meas tran power avg v(vdd)*i(vdd)*-1

.meas tran pdp param='power*delay'

* Transient analysis
* .tran 0.1n '160n/freq_mult'
.tran 0.1n 160n

* Parameter sweep for frequency multiplication
* .step param freq_mult list 1 2 4 8 16

.step param cval 20f 90f 10f

.end
