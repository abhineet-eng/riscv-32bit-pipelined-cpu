module cpu_top (
    input wire clk,
    input wire reset
);

    // ======================================================
    // IF STAGE
    // ======================================================
    wire [31:0] pc;
    wire [31:0] pc_next;
    wire [31:0] instr;

    pc PC (
        .clk(clk),
        .reset(reset),
        .pc_next(pc_next),
        .pc(pc)
    );

    imem IMEM (
        .addr(pc),
        .instr(instr)
    );

    // ======================================================
    // IF / ID PIPELINE
    // ======================================================
    reg [31:0] IF_ID_pc;
    reg [31:0] IF_ID_instr;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            IF_ID_pc    <= 0;
            IF_ID_instr <= 0;
        end else begin
            IF_ID_pc    <= pc;
            IF_ID_instr <= instr;
        end
    end

    // ======================================================
    // ID STAGE
    // ======================================================
    wire [6:0] opcode = IF_ID_instr[6:0];
    wire [4:0] rd_id  = IF_ID_instr[11:7];
    wire [2:0] funct3 = IF_ID_instr[14:12];
    wire [4:0] rs1    = IF_ID_instr[19:15];
    wire [4:0] rs2    = IF_ID_instr[24:20];
    wire [6:0] funct7 = IF_ID_instr[31:25];

    wire [31:0] imm_out;

    imm_gen IMM (
        .instr(IF_ID_instr),
        .imm_out(imm_out)
    );

    // ---------------- Control ----------------
    reg        reg_write_r;
    reg        branch_r;
    reg        alu_src_r;
    reg [3:0]  alu_ctrl_r;

    wire reg_write_id = reg_write_r;
    wire branch_id    = branch_r;
    wire alu_src_id   = alu_src_r;
    wire [3:0] alu_ctrl_id = alu_ctrl_r;

    always @(*) begin
        reg_write_r = 0;
        branch_r    = 0;
        alu_src_r   = 0;
        alu_ctrl_r  = 4'b0000;

        case (opcode)

            // R-type (ADD)
            7'b0110011: begin
                reg_write_r = 1;
                alu_src_r   = 0;      // use rs2
                alu_ctrl_r  = 4'b0000;
            end

            // ADDI
            7'b0010011: begin
                reg_write_r = 1;
                alu_src_r   = 1;      // use immediate
                alu_ctrl_r  = 4'b0000;
            end

            // BEQ
            7'b1100011: begin
                branch_r    = 1;
                alu_src_r   = 0;
                alu_ctrl_r  = 4'b0001; // SUB
            end
        endcase
    end

    // ---------------- Register File ----------------
    wire [31:0] rd1;
    wire [31:0] rd2;

    regfile RF (
        .clk(clk),
        .we(MEM_WB_reg_write),
        .rs1(rs1),
        .rs2(rs2),
        .rd(MEM_WB_rd),
        .wd(MEM_WB_alu_out),
        .rd1(rd1),
        .rd2(rd2)
    );

    // ======================================================
    // ID / EX PIPELINE
    // ======================================================
    reg [31:0] ID_EX_rd1;
    reg [31:0] ID_EX_rd2;
    reg [31:0] ID_EX_imm;
    reg [4:0]  ID_EX_rd;
    reg        ID_EX_reg_write;
    reg        ID_EX_branch;
    reg        ID_EX_alu_src;
    reg [3:0]  ID_EX_alu_ctrl;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ID_EX_rd1       <= 0;
            ID_EX_rd2       <= 0;
            ID_EX_imm       <= 0;
            ID_EX_rd        <= 0;
            ID_EX_reg_write <= 0;
            ID_EX_branch    <= 0;
            ID_EX_alu_src   <= 0;
            ID_EX_alu_ctrl  <= 0;
        end else begin
            ID_EX_rd1       <= rd1;
            ID_EX_rd2       <= rd2;
            ID_EX_imm       <= imm_out;
            ID_EX_rd        <= rd_id;
            ID_EX_reg_write <= reg_write_id;
            ID_EX_branch    <= branch_id;
            ID_EX_alu_src   <= alu_src_id;
            ID_EX_alu_ctrl  <= alu_ctrl_id;
        end
    end

    // ======================================================
    // EX STAGE
    // ======================================================
    wire [31:0] alu_b =
        (ID_EX_alu_src) ? ID_EX_imm : ID_EX_rd2;

    wire [31:0] alu_out;

    alu ALU (
        .a(ID_EX_rd1),
        .b(alu_b),
        .alu_ctrl(ID_EX_alu_ctrl),
        .result(alu_out)
    );

    wire zero = (alu_out == 0);

    // ======================================================
    // EX / MEM PIPELINE
    // ======================================================
    reg [31:0] EX_MEM_alu_out;
    reg [4:0]  EX_MEM_rd;
    reg        EX_MEM_reg_write;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            EX_MEM_alu_out   <= 0;
            EX_MEM_rd        <= 0;
            EX_MEM_reg_write <= 0;
        end else begin
            EX_MEM_alu_out   <= alu_out;
            EX_MEM_rd        <= ID_EX_rd;
            EX_MEM_reg_write <= ID_EX_reg_write;
        end
    end

    // ======================================================
    // MEM / WB PIPELINE
    // ======================================================
    reg [31:0] MEM_WB_alu_out;
    reg [4:0]  MEM_WB_rd;
    reg        MEM_WB_reg_write;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            MEM_WB_alu_out   <= 0;
            MEM_WB_rd        <= 0;
            MEM_WB_reg_write <= 0;
        end else begin
            MEM_WB_alu_out   <= EX_MEM_alu_out;
            MEM_WB_rd        <= EX_MEM_rd;
            MEM_WB_reg_write <= EX_MEM_reg_write;
        end
    end

    // ======================================================
    // NEXT PC LOGIC
    // ======================================================
    wire [31:0] pc_branch = IF_ID_pc + ID_EX_imm;
    assign pc_next = (ID_EX_branch && zero) ? pc_branch : pc + 4;

endmodule
