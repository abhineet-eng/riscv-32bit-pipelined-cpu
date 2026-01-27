module cpu_tb;

    reg clk;
    reg reset;

    // Instantiate DUT
    cpu_top dut (
        .clk(clk),
        .reset(reset)
    );

    // Clock generation: 10 time-unit period
    always #5 clk = ~clk;

    initial begin
        // Initialize
        clk   = 0;
        reset = 1;

        // Hold reset for a few cycles
        #20;
        reset = 0;

        // Run simulation long enough to see pipeline fill & writeback
        #300;

        $finish;
    end

endmodule

