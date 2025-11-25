iverilog ALU/alu.v ALU/aluoutreg.v Assembler/BIOS_Hardcoded_High.v Assembler/BIOS_Hardcoded_Low.v Assembler/User_Code_High.v Assembler/User_Code_Low.v Assembler/User_Data.v "Code Memory/codemem.v" "Code Memory/imemregister.v" "Control FSM/controlfsm.v" "Data Memory/datamem.v" "Data Memory/dmemregister.v" Flags/flags.v "OpCode Decoder/opcodedec.v" PC/pc.v Registers/registers.v Registers/leftinputreg.v Registers/rightinputreg.v i281_toplevel.v i281_toplevel_tb.v
vvp a.out
gtkwave dump.vcd
