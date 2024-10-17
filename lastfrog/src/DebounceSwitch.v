module Shared_Debounce (
    input wire i_Clk,
    input wire [3:0] i_Switches,  // 4 switch inputs packed into a single wire
    output reg [3:0] o_Switches   // 4 debounced outputs
);

    // Reduce the debounce limit for slightly faster debounce (e.g., 100,000 cycles instead of 250,000)
    parameter c_DEBOUNCE_LIMIT = 100000;
    localparam COUNTER_WIDTH = 17;  // log2(100000) ≈ 17 bits for the counter

    reg [COUNTER_WIDTH-1:0] r_Count[3:0];  // Individual counters for each switch
    reg [3:0] r_State = 4'b0;              // Internal debounced state

    integer i;

    // Debounce logic for all 4 switches
    always @(posedge i_Clk) begin
        for (i = 0; i < 4; i = i + 1) begin
            // Switch input is different than the current internal state
            if (i_Switches[i] !== r_State[i]) begin
                if (r_Count[i] < c_DEBOUNCE_LIMIT) begin
                    // Increment the counter if switch state is different
                    r_Count[i] <= r_Count[i] + 1;
                end else begin
                    // If debounce counter reaches limit, update state
                    r_State[i] <= i_Switches[i];
                    r_Count[i] <= 0; // Reset counter after state change
                end
            end else begin
                // Reset counter if switch input matches internal state
                r_Count[i] <= 0;
            end
        end

        // Update debounced outputs
        o_Switches <= r_State;
    end

endmodule
