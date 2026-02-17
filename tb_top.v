`timescale 1ns / 1ps

module tb_top();
    // 1. Signals
    reg clk;
    reg rst; // Added reset for stability
    reg [15:0] current_data;
    reg [15:0] speed_data;
    wire fault;

    // 2. Unit Under Test (UUT)
    motor_fault_logic uut (
        .clk(clk),
        .rst(rst),   // CONNECT RESET
        .current_in(current_data),
        .speed_in(speed_data),
        .fault_detected(fault)
    );

    // 3. Clock Generation (100MHz)
    initial clk = 0;
    always #5 clk = ~clk; 

    integer file_ptr, status;

    // 4. Main Simulation Logic
    initial begin
        // Initialize everything
        current_data = 0;
        speed_data = 0;
        rst = 1;
        #20 rst = 0; // Hold reset for 2 clock cycles

        // --- HEALTHY TEST ---
        // USE FORWARD SLASHES / even on Windows to avoid path errors
        file_ptr = $fopen("healthy.txt", "r");

        if (file_ptr == 0) begin
            $display("ERROR: Could not open healthy.txt. Check the path!");
            $finish;
        end

        $display("Starting Healthy Test...");
        
        while (!$feof(file_ptr)) begin
            @(posedge clk); // WAIT for the clock edge first
            #1;             // DELAY by 1ns so data changes AFTER the clock edge
            status = $fscanf(file_ptr, "%d %d\n", current_data, speed_data);
        end
        $fclose(file_ptr);

        #200; // Large gap to see the transition in the waveform

        // --- FAULTY TEST ---
        file_ptr = $fopen("faulty.txt", "r");

        if (file_ptr == 0) begin
            $display("ERROR: Could not open faulty.txt!");
            $finish;
        end

        $display("Starting Faulty Test...");

        while (!$feof(file_ptr)) begin
            @(posedge clk); 
            #1; 
            status = $fscanf(file_ptr, "%d %d\n", current_data, speed_data);
        end
        
        $fclose(file_ptr);
        $display("Simulation Finished Successfully.");
        #500;
        $finish;
    end
endmodule
