module level_counter (
    input wire clk,                  // Clock signal
    input wire reset_level,          // Signal to reset the level
    input wire frog_at_top,          // Signal from frog_display to indicate frog reached the top
    input wire [1:0] lives,          // Number of lives remaining
    output reg [4:0] level,          // Level value (to be displayed on 7-segment)
    output reg reset_frog,           // Signal to reset frog to the bottom center
    output wire [6:0] o_Segment1,    // 7-segment display for level (units place)
    output wire [6:0] o_Segment2     // 7-segment display for level (tens place)
);

    // Internal signal to store current level
    reg [4:0] level_counter;  // 5 bits to store the level, up to 99
    reg level_incremented;    // Flag to ensure level is only incremented once per frog reaching top

    // Wires to hold the units and tens digits
    wire [3:0] units_digit;
    wire [3:0] tens_digit;

    // Initialize level to 1 and set the flag to 0
    initial begin
        level_counter = 5'd1;        // Start at level 1
        level_incremented = 0;       // Flag is initially cleared
    end

    // Update the level based on frog reaching the top or reset condition
    always @(posedge clk) begin
        if (reset_level && lives == 0) begin  // Reset level only if lives are 0
            level_counter <= 5'd1;  // Reset to level 1
            level_incremented <= 0; // Clear the flag
        end else if (frog_at_top && !level_incremented) begin
            if (level_counter < 99) begin
                level_counter <= level_counter + 5'd1;  // Increment level
                level_incremented <= 1;  // Set the flag to prevent multiple increments
            end
        end else if (!frog_at_top) begin
            level_incremented <= 0;  // Clear the flag when frog leaves the top
        end
        
        reset_frog <= frog_at_top || (reset_level && lives == 0); // Reset frog either at level reset or top
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
