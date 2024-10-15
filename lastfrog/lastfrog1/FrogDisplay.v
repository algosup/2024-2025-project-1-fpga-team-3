module frog_display (
    input wire clk,             // Clock signal
    input wire debounced_sw1,   // Debounced Button for moving left
    input wire debounced_sw2,   // Debounced Button for moving down
    input wire debounced_sw3,   // Debounced Button for moving up
    input wire debounced_sw4,   // Debounced Button for moving right
    input wire reset_frog,      // Signal to reset frog to initial position
    input wire [4:0] car1_x,    // Car 1 X position
    input wire [3:0] car1_y,    // Car 1 Y position
    input wire [4:0] car2_x,    // Car 2 X position
    input wire [3:0] car2_y,    // Car 2 Y position
    input wire [4:0] car3_x,    // Car 3 X position
    input wire [3:0] car3_y,    // Car 3 Y position
    input wire [4:0] car4_x,    // Car 4 X position
    input wire [3:0] car4_y,    // Car 4 Y position
    input wire [4:0] car5_x,    // Car 5 X position
    input wire [3:0] car5_y,    // Car 5 Y position
    input wire [4:0] car6_x,    // Car 6 X position
    input wire [3:0] car6_y,    // Car 6 Y position
    input wire [4:0] car7_x,    // Car 7 X position
    input wire [3:0] car7_y,    // Car 7 Y position
    input wire [4:0] car8_x,    // Car 8 X position
    input wire [3:0] car8_y,    // Car 8 Y position
    input wire [4:0] car9_x,    // Car 9 X position
    input wire [3:0] car9_y,    // Car 9 Y position
    input wire [4:0] car10_x,   // Car 10 X position
    input wire [3:0] car10_y,   // Car 10 Y position
    input wire [4:0] car11_x,   // Car 11 X position
    input wire [3:0] car11_y,   // Car 11 Y position
    output reg [4:0] frog_col,  // Frog X position (in columns, 5 bits)
    output reg [3:0] frog_row,  // Frog Y position (in rows, 4 bits)
    output wire frog_at_top,    // Signal to notify if frog reached the top row
    output reg collision_detected // Signal for detecting collisions
);

    // Grid parameters
    parameter GRID_COLS = 20;   // Number of columns in the grid (5 bits)
    parameter GRID_ROWS = 15;   // Number of rows in the grid (4 bits)

    // Movement blocking state
    reg move_block;

    // Initial frog position (center bottom) and block state
    initial begin
        frog_col = GRID_COLS / 2;  // Start at the center column (column 10)
        frog_row = GRID_ROWS - 1;  // Start at the bottom row (row 14)
        move_block = 0;            // No movement is blocked initially
        collision_detected = 0;    // No collision initially
    end

    // Move frog based on debounced button presses
    always @(posedge clk) begin
        // Reset the frog to initial position if reset_frog signal is active or if all buttons are pressed
        if (reset_frog || (debounced_sw1 && debounced_sw2 && debounced_sw3 && debounced_sw4)) begin
            frog_col <= GRID_COLS / 2;  // Reset to the center column (column 10)
            frog_row <= GRID_ROWS - 1;  // Reset to the bottom row (row 14)
            collision_detected <= 0;    // Clear the collision flag
        end
        // Reset the move_block when no button is pressed
        else if (!debounced_sw1 && !debounced_sw2 && !debounced_sw3 && !debounced_sw4) begin
            move_block <= 0;
        end

        // Move frog based on debounced button presses, only once per press
        if (!move_block) begin
            if (debounced_sw1 && frog_col > 0) begin
                frog_col <= frog_col - 1;
                move_block <= 1;  // Block further movement
            end
            else if (debounced_sw2 && frog_row < GRID_ROWS - 1) begin
                frog_row <= frog_row + 1;
                move_block <= 1;  // Block further movement
            end
            else if (debounced_sw3 && frog_row > 0) begin
                frog_row <= frog_row - 1;
                move_block <= 1;  // Block further movement
            end
            else if (debounced_sw4 && frog_col < GRID_COLS - 1) begin
                frog_col <= frog_col + 1;
                move_block <= 1;  // Block further movement
            end
        end

        // Check for collision with all 11 cars
        if ((frog_col == car1_x && frog_row == car1_y) ||
            (frog_col == car2_x && frog_row == car2_y) ||
            (frog_col == car3_x && frog_row == car3_y) ||
            (frog_col == car4_x && frog_row == car4_y) ||
            (frog_col == car5_x && frog_row == car5_y) ||
            (frog_col == car6_x && frog_row == car6_y) ||
            (frog_col == car7_x && frog_row == car7_y) ||
            (frog_col == car8_x && frog_row == car8_y) ||
            (frog_col == car9_x && frog_row == car9_y) ||
            (frog_col == car10_x&& frog_row == car10_y) ||
            (frog_col == car11_x&& frog_row == car11_y)) begin
            collision_detected <= 1;   // Set collision flag if frog hits any car
            frog_col <= GRID_COLS / 2; // Reset frog position to the initial state
            frog_row <= GRID_ROWS - 1;
        end else begin
            collision_detected <= 0;   // Clear the collision flag if no collision
        end
    end

    // Signal if frog has reached the top row (row 0)
    assign frog_at_top = (frog_row == 0);

endmodule
