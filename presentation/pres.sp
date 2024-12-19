* Voltage Level Shifter Using Regulated Cross Coupled Pull Up Networks
* Using standard LTspice MOSFET models

.param VDDH=1.8
.param VDDL=0.4

* Power supplies
Vddh vddh 0 {VDDH}
Vddl vddl 0 {VDDL}
Vin in 0 PULSE(0 {VDDL} 0 0.1n 0.1n 5n 10n)

* Level Shifter Circuit
* PMOS devices
MP1 out1 n1 vddh vddh PMOS l=180n w=360n
MP2 n1 in vddh vddh PMOS l=180n w=360n
MP5 n3 out1 vddh vddh PMOS l=180n w=360n
MP7 out2 n3 vddh vddh PMOS l=180n w=360n

* NMOS devices
MN3 n2 in 0 0 NMOS l=180n w=180n
MN4 out1 n2 0 0 NMOS l=180n w=180n
MN6 n3 out1 0 0 NMOS l=180n w=180n
MN8 out2 n3 0 0 NMOS l=180n w=180n

* Analysis commands
.tran 0 20n 0 0.1n

* MOSFET Models
.model NMOS NMOS (Level=1 Vto=0.4 Kp=120u)
.model PMOS PMOS (Level=1 Vto=-0.4 Kp=40u)

* Measurements
.measure tran trise TRIG v(out1) VAL={VDDH/2} RISE=1 TARG v(out1) VAL={0.9*VDDH} RISE=1
.measure tran tfall TRIG v(out1) VAL={0.9*VDDH} FALL=1 TARG v(out1) VAL={VDDH/2} FALL=1
.measure tran delay TRIG v(in) VAL={VDDL/2} RISE=1 TARG v(out1) VAL={VDDH/2} RISE=1
.measure tran avg_power AVG -v(vddh)*i(Vddh) FROM 0ns TO 20ns

* Control commands
.option temp=27
.option nomarch
.option plotwinsize=0

.end
