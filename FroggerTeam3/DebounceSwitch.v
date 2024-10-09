
module debounce (
    input wire i_Clk,         // Clock signal
    input wire i_Switch,      // Raw switch input
    output reg o_Switch_state // Debounced switch state
);

    reg [15:0] counter = 0;   // Counter for debouncing
    reg stable_state = 0;     // Stable state for the switch
    reg last_switch = 0;      // Last switch state for edge detection

    always @(posedge i_Clk) begin
        if (i_Switch == stable_state) begin
            // If the switch state is stable, reset the counter
            counter <= 0;
        end else begin
            // Increment the counter while the switch state is changing
            if (counter < 16'hFFFF) begin
                counter <= counter + 1;
            end
            // Once the counter reaches a certain value, change the stable state
            if (counter == 16'hFFFF) begin
                stable_state <= i_Switch;
            end
        end

        // Output the stable state
        o_Switch_state <= stable_state;
    end
endmodule
