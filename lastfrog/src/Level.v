module level_counter (
    input wire debounced_sw1,            // Debounced switch 1
    input wire debounced_sw2,            // Debounced switch 2
    input wire debounced_sw3,            // Debounced switch 3
    input wire debounced_sw4,            // Debounced switch 4
    input wire clk,                      // Clock signal
    input wire reset_level,              // Signal to reset the level
    input wire frog_at_top,              // Signal from frog_display to indicate frog reached the top
    input wire [1:0] lives,              // Number of lives remaining
    output reg [3:0] level,              // Level value (to be displayed on 7-segment)
    output reg reset_frog,               // Signal to reset frog to the bottom center
    output reg reset_lives,              // Signal to reset lives to 3
    output wire [6:0] o_Segment1,        // 7-segment display for level (units place)
    output wire [6:0] o_Segment2         // 7-segment display for level (tens place)
);

    // Internal signal to store current level
    reg [3:0] level_counter;             // 5 bits to store the level, up to 99
    reg level_incremented;               // Flag to ensure level is only incremented once per frog reaching top

    // Wires to hold the units and tens digits
    wire [3:0] units_digit;
    wire [3:0] tens_digit;

    // Initialize level to 1 and set the flag to 0
    initial begin
        level_counter = 5'd1;            // Start at level 1
        level_incremented = 0;           // Flag is initially cleared
    end

    // Update the level based on frog reaching the top or reset condition
    always @(posedge clk) begin
        // New condition: Reset to level 1 if all switches are pressed at the same time
        if (debounced_sw1 && debounced_sw2 && debounced_sw3 && debounced_sw4) begin
            level_counter <= 5'd1;       // Reset to level 1 when all switches are pressed
            level_incremented <= 0;      // Clear the flag
            reset_frog <= 1;             // Also reset the frog to initial position
            reset_lives <= 1;            // Reset lives to 3
        end
        // Reset level only if all lives are gone
        else if (reset_level && lives == 0) begin  
            level_counter <= 5'd1;       // Reset to level 1
            level_incremented <= 0;      // Clear the flag
            reset_lives <= 1;            // Reset lives to 3 when all lives are gone
        end 
        // If frog reaches the top and the level has not been incremented yet
        else if (frog_at_top && !level_incremented) begin
            if (level_counter < 15) begin
                level_counter <= level_counter + 5'd1;  // Increment level
                level_incremented <= 1;  // Set the flag to prevent multiple increments
            end
        end 
        // Clear the flag when frog leaves the top
        else if (!frog_at_top) begin
            level_incremented <= 0;  
        end

        // Reset frog when frog reaches the top, all lives are gone, or all switches are pressed
        if (frog_at_top || (reset_level && lives == 0) || (debounced_sw1 && debounced_sw2 && debounced_sw3 && debounced_sw4)) begin
            reset_frog <= 1;  // Reset frog when necessary
        end else begin
            reset_frog <= 0;  // Keep frog where it is otherwise
            reset_lives <= 0; // Reset the reset_lives signal after resetting the lives
        end
    end

    // Assign level_counter to the output level
    always @(posedge clk) begin
        level <= level_counter;
    end

    // Calculate the units and tens digits
    assign units_digit = level_counter / 10;   // Units digit
    assign tens_digit = level_counter % 10;    // Tens digit

    // Connect the digits to the 7-segment display
    segment_display seg1 (
        .digit(units_digit),  // Units digit
        .o_Segment(o_Segment1)
    );

    segment_display seg2 (
        .digit(tens_digit),   // Tens digit
        .o_Segment(o_Segment2)
    );
endmodule
