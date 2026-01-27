module imm_gen (
    input  wire [31:0] instr,
    output wire [31:0] imm_out
);
    // I-type immediate (ADDI)
    assign imm_out = {{20{instr[31]}}, instr[31:20]};
endmodule

