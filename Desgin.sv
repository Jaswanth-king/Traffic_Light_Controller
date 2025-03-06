module traffic_light_controller (
    input clk,          // Clock input
    input reset,        // Reset input
    output reg [1:0] ns_light, // North-South light (00: Red, 01: Yellow, 10: Green)
    output reg [1:0] ew_light  // East-West light (00: Red, 01: Yellow, 10: Green)
);

    // State encoding
    parameter NS_GREEN = 2'b00, NS_YELLOW = 2'b01, EW_GREEN = 2'b10, EW_YELLOW = 2'b11;
    
    reg [1:0] state; // Current state of the FSM
    reg [3:0] timer; // Timer to control light duration

    // State transition logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= NS_GREEN; // Start with North-South green light
            timer <= 0;        // Reset timer
        end else begin
            case (state)
                NS_GREEN: begin
                    if (timer == 4'd10) begin // 10 clock cycles for green
                        state <= NS_YELLOW; // Transition to yellow
                        timer <= 0;         // Reset timer
                    end else begin
                        timer <= timer + 1; // Increment timer
                    end
                end
                NS_YELLOW: begin
                    if (timer == 4'd3) begin // 3 clock cycles for yellow
                        state <= EW_GREEN; // Transition to East-West green
                        timer <= 0;       // Reset timer
                    end else begin
                        timer <= timer + 1; // Increment timer
                    end
                end
                EW_GREEN: begin
                    if (timer == 4'd10) begin // 10 clock cycles for green
                        state <= EW_YELLOW; // Transition to yellow
                        timer <= 0;         // Reset timer
                    end else begin
                        timer <= timer + 1; // Increment timer
                    end
                end
                EW_YELLOW: begin
                    if (timer == 4'd3) begin // 3 clock cycles for yellow
                        state <= NS_GREEN; // Transition to North-South green
                        timer <= 0;       // Reset timer
                    end else begin
                        timer <= timer + 1; // Increment timer
                    end
                end
            endcase
        end
    end

    // Output logic
    always @(*) begin
        case (state)
            NS_GREEN: begin
                ns_light = 2'b10; // North-South green
                ew_light = 2'b00; // East-West red
            end
            NS_YELLOW: begin
                ns_light = 2'b01; // North-South yellow
                ew_light = 2'b00; // East-West red
            end
            EW_GREEN: begin
                ns_light = 2'b00; // North-South red
                ew_light = 2'b10; // East-West green
            end
            EW_YELLOW: begin
                ns_light = 2'b00; // North-South red
                ew_light = 2'b01; // East-West yellow
            end
            default: begin
                ns_light = 2'b00; // Default to red
                ew_light = 2'b00; // Default to red
            end
        endcase
    end
endmodule
