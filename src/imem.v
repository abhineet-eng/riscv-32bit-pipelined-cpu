module imem (
    input  wire [31:0] addr,
    output reg  [31:0] instr
);
    always @(*) begin
        case (addr[4:2])   // word aligned
            3'd0: instr = 32'h00500093; // ADDI x1, x0, 5
            3'd1: instr = 32'h00308113; // ADDI x2, x1, 3
            3'd2: instr = 32'h002081B3; // ADD  x3, x1, x2
            3'd3: instr = 32'h00000013; // NOP
            default: instr = 32'h00000013;
        endcase
    end
endmodule

