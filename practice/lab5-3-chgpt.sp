* Complete 8-bit Manchester Carry-Generation Chain
.lib 'cic018.l' tt
.global vdd gnd

* Inverter for signal inversion
.subckt inv in out
mp   out  in   vdd  vdd  P_18  l=0.18u  w=1u
mn   out  in   gnd  gnd  N_18  l=0.18u  w=0.5u
.ends

* AND Gate (G = A AND B)
.subckt and2 a b out
mp1  out  a   vdd  vdd  P_18  l=0.18u  w=1u
mn1  out  a   n1   gnd  N_18  l=0.18u  w=1u
mp2  n1   b   vdd  vdd  P_18  l=0.18u  w=1u
mn2  n1   b   gnd  gnd  N_18  l=0.18u  w=1u
.ends

* XOR Gate (P = A XOR B)
.subckt xor2 a b out
mp3  out a a_ vdd P_18 l=0.18u w=1u
mn3  out b b_ gnd N_18 l=0.18u w=1u
mp4  out n1   vdd vdd  P_18  l=0.18u  w=1u
mn4  out n2   gnd gnd  N_18  l=0.18u  w=1u
.ends

* 8-bit Manchester Carry Chain 
* Cascade G0, P1, P2, ..., P7
* Pattern frequency = 125 MHz (half of 250 MHz CLK)

* Carry Generation Chain
xand0 A0 B0 G0 and2
xxor1 A1 B1 P1 xor2
xxor2 A2 B2 P2 xor2
xxor3 A3 B3 P3 xor2
xxor4 A4 B4 P4 xor2
xxor5 A5 B5 P5 xor2
xxor6 A6 B6 P6 xor2
xxor7 A7 B7 P7 xor2

* Clocks and Signals for all A and B inputs (125 MHz pattern, 250 MHz clock)
* A signals
va0 A0 0 pulse(1.8 0 0.1n 0.1n 0.1n 7.9n 16n)
va1 A1 0 pulse(1.8 0 0.1n 0.1n 0.1n 7.9n 16n)
va2 A2 0 pulse(1.8 0 0.1n 0.1n 0.1n 7.9n 16n)
va3 A3 0 pulse(1.8 0 0.1n 0.1n 0.1n 7.9n 16n)
va4 A4 0 pulse(1.8 0 0.1n 0.1n 0.1n 7.9n 16n)
va5 A5 0 pulse(1.8 0 0.1n 0.1n 0.1n 7.9n 16n)
va6 A6 0 pulse(1.8 0 0.1n 0.1n 0.1n 7.9n 16n)
va7 A7 0 pulse(1.8 0 0.1n 0.1n 0.1n 7.9n 16n)

* B signals
vb0 B0 0 pulse(1.8 0 0.1n 0.1n 0.1n 15.9n 32n)
vb1 B1 0 pulse(1.8 0 0.1n 0.1n 0.1n 15.9n 32n)
vb2 B2 0 pulse(1.8 0 0.1n 0.1n 0.1n 15.9n 32n)
vb3 B3 0 pulse(1.8 0 0.1n 0.1n 0.1n 15.9n 32n)
vb4 B4 0 pulse(1.8 0 0.1n 0.1n 0.1n 15.9n 32n)
vb5 B5 0 pulse(1.8 0 0.1n 0.1n 0.1n 15.9n 32n)
vb6 B6 0 pulse(1.8 0 0.1n 0.1n 0.1n 15.9n 32n)
vb7 B7 0 pulse(1.8 0 0.1n 0.1n 0.1n 15.9n 32n)

* Clock
vck CK 0 pulse(0 1.8 2.1n 0.1n 0.1n 1.9n 4n)

* Measurement commands
.meas tran avg_power avg v(vdd)*i(vvdd)*-1
.meas tran critical_delay trig v(A0) val=0.9 fall=1 targ v(P7) val=0.9 rise=1

* Transient analysis - total time based on frequency
.tran 0.1n 40n
.ends
