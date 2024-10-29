* 3-input Static CMOS XOR (loading c=0.05p to 0.5p sweep)
.lib 'cic018.l' tt
.global vdd gnd

.subckt inv in out
mp   out  in   vdd  vdd  P_18  l=0.18u  w=1u
mn   out  in   gnd  gnd  N_18  l=0.18u  w=0.5u
.ends

.subckt xor3 a b c out
xinv1 a a_ inv
xinv2 b b_ inv
xinv3 c c_ inv

* PMOS network (pull-up)
mp1  net1   a    vdd   vdd  p_18  l=0.18u  w=2u
mp2  net2   b    net1  vdd  p_18  l=0.18u  w=2u
mp3  out    c    net2  vdd  p_18  l=0.18u  w=2u
mp4  net3   a_   vdd   vdd  p_18  l=0.18u  w=2u
mp5  net4   b    net3  vdd  p_18  l=0.18u  w=2u
mp6  out    c_   net4  vdd  p_18  l=0.18u  w=2u
mp7  net5   a    vdd   vdd  p_18  l=0.18u  w=2u
mp8  net6   b_   net5  vdd  p_18  l=0.18u  w=2u
mp9  out    c    net6  vdd  p_18  l=0.18u  w=2u
mp10 net7   a_   vdd   vdd  p_18  l=0.18u  w=2u
mp11 net8   b_   net7  vdd  p_18  l=0.18u  w=2u
mp12 out    c_   net8  vdd  p_18  l=0.18u  w=2u

* NMOS network (pull-down)
mn1  out    a    net9   gnd  n_18  l=0.18u  w=1u
mn2  net9   b    net10  gnd  n_18  l=0.18u  w=1u
mn3  net10  c    gnd    gnd  n_18  l=0.18u  w=1u
mn4  out    a    net11  gnd  n_18  l=0.18u  w=1u
mn5  net11  b    net12  gnd  n_18  l=0.18u  w=1u
mn6  net12  c_   gnd    gnd  n_18  l=0.18u  w=1u
mn7  out    a_   net13  gnd  n_18  l=0.18u  w=1u
mn8  net13  b_   net14  gnd  n_18  l=0.18u  w=1u
mn9  net14  c    gnd    gnd  n_18  l=0.18u  w=1u
mn10 out    a_   net15  gnd  n_18  l=0.18u  w=1u
mn11 net15  b_   net16  gnd  n_18  l=0.18u  w=1u
mn12 net16  c_   gnd    gnd  n_18  l=0.18u  w=1u
.ends

* Main circuit
xxor3 a b c out xor3

* Load capacitance (will be swept)
cload out gnd {cval}

* Supply voltage sources
vvdd vdd 0 1.8
vgnd gnd 0 0

* Input signals
va a 0 pulse(1.8 0 0.1n 0.1n 0.1n 39.9n 80n)
vb b 0 pulse(1.8 0 0.1n 0.1n 0.1n 79.9n 160n)
vc c 0 pulse(1.8 0 0.1n 0.1n 0.1n 159.9n 320n)

* Measurements
.meas tran delay trig v(a) val=0.9 fall=1
+                   targ v(out) val=0.9 rise=1

.meas tran power avg v(vdd)*i(vvdd)*-1

.meas tran pdp param='power*delay'

* Transient analysis
.tran 0.1n 640n

* Parameter sweep for load capacitance
.step param cval 0.05p 0.5p 0.05p

.end