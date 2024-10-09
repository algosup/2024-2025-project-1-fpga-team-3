module frog_movement (
    input wire i_Clk,
    input wire i_Switch_1,      // Move frog left
    input wire i_Switch_2,      // Move frog backward
    input wire i_Switch_3,      // Move frog forward
    input wire i_Switch_4,      // Move frog right
    input wire [9:0] h_display, // Width of the display (VGA)
    input wire [9:0] v_display, // Height of the display (VGA)
    input wire [9:0] grid_size, // Size of the grid
    output reg [9:0] frog_x,    // Output frog's x position
    output reg [9:0] frog_y,    // Output frog's y position
    output reg [3:0] level      // Output the current level
);

    wire switch_1_debounced, switch_2_debounced, switch_3_debounced, switch_4_debounced;

    // Debounce each switch
    debounce debounce_1 (.i_Clk(i_Clk), .i_Switch(i_Switch_1), .o_Switch_state(switch_1_debounced));
    debounce debounce_2 (.i_Clk(i_Clk), .i_Switch(i_Switch_2), .o_Switch_state(switch_2_debounced));
    debounce debounce_3 (.i_Clk(i_Clk), .i_Switch(i_Switch_3), .o_Switch_state(switch_3_debounced));
    debounce debounce_4 (.i_Clk(i_Clk), .i_Switch(i_Switch_4), .o_Switch_state(switch_4_debounced));

    reg switch_state_1 = 0;
    reg switch_state_2 = 0;
    reg switch_state_3 = 0;
    reg switch_state_4 = 0;

    // Pre-calculated initial frog position (middle of the screen for x, bottom for y)
    localparam FROG_START_X = 320;  // This is 640 / 2, since h_display is 640
    localparam FROG_START_Y = 448;  // This is 480 - grid_size (assuming grid_size = 32)

    // Initial state
    initial begin
        frog_x = FROG_START_X;      // Set the frog's initial x position to the middle
        frog_y = FROG_START_Y;      // Set the frog's initial y position to the bottom
        level = 1;                  // Start at level 1
    end

    always @(posedge i_Clk) begin
        // Move left (Switch 1)
        if (switch_1_debounced && !switch_state_1) begin
            if (frog_x > 0) begin
                frog_x <= frog_x - grid_size;
            end
        end
        switch_state_1 <= switch_1_debounced;

        // Move backward (Switch 2)
        if (switch_2_debounced && !switch_state_2) begin
            if (frog_y < v_display - grid_size) begin
                frog_y <= frog_y + grid_size;
            end
        end
        switch_state_2 <= switch_2_debounced;

        // Move forward (Switch 3)
        if (switch_3_debounced && !switch_state_3) begin
            frog_y <= frog_y - grid_size;
            // If frog reaches the top, reset to the bottom and increment level
            if (frog_y <= 0) begin
                frog_y <= FROG_START_Y;
                level <= level + 1;
            end
        end
        switch_state_3 <= switch_3_debounced;

        // Move right (Switch 4)
        if (switch_4_debounced && !switch_state_4) begin
            if (frog_x < h_display - grid_size) begin
                frog_x <= frog_x + grid_size;
            end
        end
        switch_state_4 <= switch_4_debounced;
    end

endmodule
