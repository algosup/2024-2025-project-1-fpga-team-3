module level_counter (
    input wire clk,                  // Clock signal
    input wire reset_level,          // Signal to reset the level
    input wire frog_at_top,          // Signal from frog_display to indicate frog reached the top
    output reg [4:0] level,          // Level value (to be displayed on 7-segment)
    output wire reset_frog,          // Signal to reset frog to the bottom center
    output wire [6:0] o_Segment1,    // 7-segment display for level (units place)
    output wire [6:0] o_Segment2     // 7-segment display for level (tens place)
);

    // Internal signal to store current level
    reg [4:0] level_counter;  // Extend to 7 bits to handle higher levels (up to 99)

    // Wires to hold the units and tens digits, explicitly 4-bit wide
    wire [3:0] units_digit;
    wire [3:0] tens_digit;
    // Initial level setup
    initial begin
        level_counter = 7'd1;   // Start at level 1
    end

    // Increment level or reset it based on signals
    always @(posedge clk) begin
        if (reset_level) begin
            level_counter <= 7'd1;  // Reset level to 1
        end
        else if (frog_at_top) begin
            if (level_counter < 99) begin
            level_counter <= level_counter + 7'd1;  // Increment level, limit to 99
            end
        end
    end

    // Assign the level_counter value to the level output
    always @(posedge clk) begin
        level <= level_counter;
    end


    // Generate reset_frog signal when frog reaches the top
    assign reset_frog = frog_at_top;

    // Explicitly calculate and assign the units and tens digits as 4-bit values
    assign units_digit = (level_counter / 10) & 7'b1111;          // The lower 4 bits
    assign tens_digit = level_counter % 10;  // The lower 4 bits of the division result

    // Connect the digits to the 7-segment display modules
    segment_display seg1 (
        .digit(units_digit),  // Pass the 4-bit units digit
        .o_Segment(o_Segment1)
    );

    segment_display seg2 (
        .digit(tens_digit),   // Pass the 4-bit tens digit
        .o_Segment(o_Segment2)
    );
endmodule
