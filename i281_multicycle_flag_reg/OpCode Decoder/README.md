# OpCode Decoder

This combinational block takes the higher byte from the specified CMEM address (specified using read select) and decodes it into a 27-wide output. The lower 23 bits are the one-hot encoded opcodes and the top 4 bits are the RX and RY wires.

## Structure

<img width="1000" height="700" alt="image" src="i281_main/OpCode Decoder/images/decoder_netlist.png" />

## Testbench: Sample Output Waveform

<img width="1000" height="700" alt="image" src="i281_main/OpCode Decoder/images/decoder_waveform.png" />
