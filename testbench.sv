`timescale 1ns / 1ps

module tb_traffic_light_controller;

    // Testbench signals
    reg clk;                // Clock signal
    reg reset;              // Reset signal
    wire [1:0] ns_light;   // North-South light output
    wire [1:0] ew_light;   // East-West light output

    // Instantiate the traffic light controller
    traffic_light_controller uut (
        .clk(clk),
        .reset(reset),
        .ns_light(ns_light),
        .ew_light(ew_light)
    );

    // Clock generation
    initial begin
        clk = 0; // Initialize clock
        forever #5 clk = ~clk; // Toggle clock every 5 time units
    end

    // Test sequence
    initial begin
        // Initialize reset
        reset = 1; // Assert reset
        #10;       // Wait for 10 time units
        reset = 0; // Deassert reset

        // Wait for some time to observe the traffic light behavior
        #100; // Wait for 100 time units

        // You can add more test cases here if needed

        // Finish simulation
        $finish;
    end

    // Monitor outputs
    initial begin
        $monitor("Time: %0t | NS Light: %b | EW Light: %b", $time, ns_light, ew_light);
    end

endmodule
