* LAB 6-2-a: Full Adder Voltage Analysis
.lib 'cic018.l' tt
.global vdd gnd

* [Previous subcircuits: inv, nand2, xor, fa remain the same]
* [Include all subcircuits from the 1-bit full adder code above]

* Main circuit - 1-bit Full Adder for voltage analysis
xfa1 a b ci s co fa

* Load capacitances
cload_s s gnd 0.1p
cload_co co gnd 0.1p

* Supply voltage parameter
.param SUPPLY=1.8

* Power supply (parameterized)
vvdd vdd 0 {SUPPLY}
vgnd gnd 0 0

* Input patterns with parameterized timing
.param base_period=40n
.param scale_factor=1

* Scaled input patterns
VA A 0 pulse({SUPPLY} 0 1n 0.1n 0.1n '19.9n*scale_factor' '40n*scale_factor')
VB B 0 pulse({SUPPLY} 0 1n 0.1n 0.1n '39.9n*scale_factor' '80n*scale_factor')
VC CI 0 pulse({SUPPLY} 0 1n 0.1n 0.1n '79.9n*scale_factor' '160n*scale_factor')

* Analysis and measurements
.tran 0.05n '200n*scale_factor'

.meas tran delay_s trig v(a) val='SUPPLY/2' rise=1 
+                  targ v(s) val='SUPPLY/2' rise=1
.meas tran delay_co trig v(a) val='SUPPLY/2' rise=1 
+                   targ v(co) val='SUPPLY/2' rise=1
.meas tran power avg p(vvdd)
.meas tran pdp param='power*max(delay_s,delay_co)'

* Voltage sweeps with corresponding timing adjustments
.alter
.param SUPPLY=1.6
.param scale_factor=1

.alter
.param SUPPLY=1.4
.param scale_factor=10

.alter
.param SUPPLY=1.2
.param scale_factor=10

.alter
.param SUPPLY=1.0
.param scale_factor=100

.alter
.param SUPPLY=0.8
.param scale_factor=100

.alter
.param SUPPLY=0.6
.param scale_factor=1000

.end