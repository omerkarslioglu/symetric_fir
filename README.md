# Symetric FIR Filter Verilog HDL Design

The Symetric FIR Filter Verilog HDL Design is a type of FIR filter that is synthesized with SkyWater130 PDK on Cadence Genus.

The symmetric FIR (Finite Impulse Response) filter is used to filter out the unwanted signals for a digital signal processing application and the filter schematic is given below. Coefficient bit length is 8-bit and input data bit length is 12-bit. 

Example coefficients set are given in the figure [2, 14, 7, -28, 15,32]. Depending on the coefficients the filter respone becomes changed.

Input data x[n] is in the streaming format, and it is available at the rising edge of every clock signal. The output data y[n] is also available at the rising edge of every clock cycle in the streaming format.

<p align="center">
  <img title="" alt="Scheme of Symetric FIR Design" src="/docs/images/scheme_fir.png"width="600" height="auto">
</p>

The filter implements a three-stage pipelined architecture:

* Symmetric Pair Addition - Adds symmetric tap pairs to reduce multiplications
* Coefficient Multiplication - Multiplies summed pairs with filter coefficients
* Result Accumulation - Combines multiplication results for final output

---

### Test:

Prepared a simple tb generates noisy signals, and I saw smooth signals:

<p align="center">
  <img title="" alt="Scheme of Symetric FIR Design" src="/docs/images/signal_waves.png"width="400" height="auto">
</p>

---

### File Tree:

```
│   LICENSE
│   README.md
│
├───constraints
│       symmetricFIR.sdc
│
├───docs
│   └───images
|         ...
│
├───genus_flow
│       fir.tcl
│       mmmc.tcl
│
├───rpt
│       final.rpt
│       final_area.rpt
│       final_gates.rpt
|       ...
└───rtl
    │   symmetricFIR.v
    │
    └───tb
            tb_symmetricFIR.v

```

---

Thanks for reviewing the design. If you have any questions you can contact me on ``omerkarsliogluu@gmail.com``