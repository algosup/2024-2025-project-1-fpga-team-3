module Shared_Debounce (
    input wire i_Clk,
    input wire [3:0] i_Switches,  // 4 switch inputs packed into a single wire
    output reg [3:0] o_Switches   // 4 debounced outputs
);

    // Debounce limit for 10ms (adjust based on your clock frequency)
    parameter c_DEBOUNCE_LIMIT = 250000;  // 10 ms at 25 MHz

    // Individual counters for each switch
    reg [17:0] r_Count0 = 0;
    reg [17:0] r_Count1 = 0;
    reg [17:0] r_Count2 = 0;
    reg [17:0] r_Count3 = 0;

    // Internal state to track the debounced state for each switch
    reg r_State0 = 1'b0;
    reg r_State1 = 1'b0;
    reg r_State2 = 1'b0;
    reg r_State3 = 1'b0;

    always @(posedge i_Clk) begin
        // Debounce logic for switch 0
        if (i_Switches[0] !== r_State0 && r_Count0 < c_DEBOUNCE_LIMIT) begin
            r_Count0 <= r_Count0 + 1;
        end else if (r_Count0 == c_DEBOUNCE_LIMIT) begin
            r_State0 <= i_Switches[0];
            r_Count0 <= 0;
        end else begin
            r_Count0 <= 0;
        end

        // Debounce logic for switch 1
        if (i_Switches[1] !== r_State1 && r_Count1 < c_DEBOUNCE_LIMIT) begin
            r_Count1 <= r_Count1 + 1;
        end else if (r_Count1 == c_DEBOUNCE_LIMIT) begin
            r_State1 <= i_Switches[1];
            r_Count1 <= 0;
        end else begin
            r_Count1 <= 0;
        end

        // Debounce logic for switch 2
        if (i_Switches[2] !== r_State2 && r_Count2 < c_DEBOUNCE_LIMIT) begin
            r_Count2 <= r_Count2 + 1;
        end else if (r_Count2 == c_DEBOUNCE_LIMIT) begin
            r_State2 <= i_Switches[2];
            r_Count2 <= 0;
        end else begin
            r_Count2 <= 0;
        end

        // Debounce logic for switch 3
        if (i_Switches[3] !== r_State3 && r_Count3 < c_DEBOUNCE_LIMIT) begin
            r_Count3 <= r_Count3 + 1;
        end else if (r_Count3 == c_DEBOUNCE_LIMIT) begin
            r_State3 <= i_Switches[3];
            r_Count3 <= 0;
        end else begin
            r_Count3 <= 0;
        end

        // Update debounced outputs based on stable states
        o_Switches[0] <= r_State0;
        o_Switches[1] <= r_State1;
        o_Switches[2] <= r_State2;
        o_Switches[3] <= r_State3;
    end
endmodule
