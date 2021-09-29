Top level eneity is implemented with previous top level design for the FPGA section.

The clock divider is modified outside the FIR filter, can be switched. The current two clock is only 1 and 2 HZ, but can be easily changed.

7seg is set to go and can be put onto the board instantly.

FIR filter can be changed to whichever working one once they pass the simulation. The current one is till the thesis one just to pass the compilation. 

Just a reminder that the filter has its own frequency devider, I didn't buypass my clk devider. The correct clock input should be 50Mhz straight out of the board's clock pin.

