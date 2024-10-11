module debounce (
    input i_Clk,           // Clock input (from the FPGA)
    input i_Switch,        // Switch input
    output reg o_Switch    // Debounced switch output
);

    reg [15:0] counter;    // 16-bit counter for debouncing
    reg switch_state;      // Intermediate stable state

    // Debouncing logic
    always @(posedge i_Clk) begin
        if (i_Switch != switch_state) begin
            counter <= counter + 1;  // Increment counter if switch state changes
            if (counter == 16'hFFFF) begin
                switch_state <= i_Switch;  // Update switch state when counter maxes out
                counter <= 0;              // Reset counter
            end
        end else begin
            counter <= 0;  // Reset counter if no state change
        end
    end

    // Output the stable switch state
    assign o_Switch = switch_state;
endmodule
