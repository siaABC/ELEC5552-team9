The adc_dac folder contains the tested assembles design with pin assignment. The DE_Lite10.qpf is the top level project file and the top level vhd file is in the output_files folder as top.vhd. An adcdac.rar file is also provided in case any IP file is lost.  

Code ADC_platform_designer is built in 28/09/21 by Ran Li (22745811). This design has been verified by system console on Quartus Pro version.  

Code ADC_LED_VERIFIED_DE10_Lite, ADC_LED_VERIFIED_DE10_LUT, ADC_LED_VERIFIED_DE10_Lite.SDC are built in 28/09/21 by Ran Li (22745811). This design has been verified by experiment.  

The ADC_DAC2 folder contains the top level entity with no pin assignment and completed ADC,filter,DAC and serial USB design. However some unkown connection issue was found during testing.    

The FPGA/FPGA folder contains some unfinished design element and previous filter attempts. Please refer to the read_me files.  

The FIR folder contained the complete fir filter fir.vhd that was simulated with the testbench fir_tb.vhd with mem.txt input waveforms.  

The uart folder contains codes related to the serial port and also includes testbench code.
