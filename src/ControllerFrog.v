module FrogController (
    input wire clk,             // Clock signal
    input wire debounced_sw1,   // Debounced Button for moving left
    input wire debounced_sw2,   // Debounced Button for moving down
    input wire debounced_sw3,   // Debounced Button for moving up
    input wire debounced_sw4,   // Debounced Button for moving right
    input wire reset_frog,      // Signal to reset frog to initial position
    input wire reset_lives,     // Signal to reset lives to 3 (triggered by switches or game over)
    input wire [4:0] car1_x, car2_x, car3_x, car4_x, car5_x,
    input wire [4:0] car6_x, car7_x, car8_x, car9_x, car10_x,
    input wire [4:0] car11_x, car12_x, car13_x, car14_x, car15_x, car16_x,
    input wire [3:0] car1_y, car2_y, car3_y, car4_y, car5_y,
    input wire [3:0] car6_y, car7_y, car8_y, car9_y, car10_y,
    input wire [3:0] car11_y, car12_y, car13_y, car14_y, car15_y, car16_y,
    output reg [4:0] frog_col,      // Frog X position (in columns, 5 bits)
    output reg [3:0] frog_row,      // Frog Y position (in rows, 4 bits)
    output wire frog_at_top,        // Signal to notify if frog reached the top row
    output reg collision_detected,  // Signal for detecting collisions
    output reg [1:0] lives,         // Number of lives left (2 bits, for 3 lives)
    output reg [1:0] frog_direction // Frog's direction (00 = up, 01 = down, 10 = left, 11 = right)
);

    // Grid parameters
    parameter GRID_COLS = 20;   // Number of columns in the grid (5 bits)
    parameter GRID_ROWS = 15;   // Number of rows in the grid (4 bits)

    // Movement blocking state
    reg move_block;

    // Initialize frog position, move block state, collision detection, lives, and direction
    initial begin
        frog_col = GRID_COLS / 2;   // Start at the center column (column 10)
        frog_row = GRID_ROWS - 1;   // Start at the bottom row (row 14)
        move_block = 0;             // No movement is blocked initially
        collision_detected = 0;     // No collision initially
        lives = 3;                  // Start with 3 lives
        frog_direction = 2'b00;     // Start with frog facing up
    end

    // Move frog based on debounced button presses
    always @(posedge clk) begin
        // Reset lives to 3 if reset_lives signal is active (switch reset or game over)
        if (reset_lives) begin
            lives <= 3;
        end

        // Reset the frog to initial position if needed (level up or reset)
        if (reset_frog) begin
            frog_col <= GRID_COLS / 2;  // Reset to the center column (column 10)
            frog_row <= GRID_ROWS - 1;  // Reset to the bottom row (row 14)
            collision_detected <= 0;    // Clear the collision flag
            frog_direction <= 2'b00;    // Reset direction to up
        end
        // Reset the move_block when no button is pressed
        else if (!debounced_sw1 && !debounced_sw2 && !debounced_sw3 && !debounced_sw4) begin
            move_block <= 0;
        end

        // Move frog based on debounced button presses, only once per press
        if (!move_block) begin
            if (debounced_sw1 && frog_col > 0) begin
                frog_col <= frog_col - 1;
                frog_direction <= 2'b10;  // Left
                move_block <= 1;  // Block further movement
            end
            else if (debounced_sw2 && frog_row < GRID_ROWS - 1) begin
                frog_row <= frog_row + 1;
                frog_direction <= 2'b01;  // Down
                move_block <= 1;  // Block further movement
            end
            else if (debounced_sw3 && frog_row > 0) begin
                frog_row <= frog_row - 1;
                frog_direction <= 2'b00;  // Up
                move_block <= 1;  // Block further movement
            end
            else if (debounced_sw4 && frog_col < GRID_COLS - 1) begin
                frog_col <= frog_col + 1;
                frog_direction <= 2'b11;  // Right
                move_block <= 1;  // Block further movement
            end
        end

        // Check for collision with all 16 cars
        if ((frog_col == car1_x && frog_row == car1_y) ||
            (frog_col == car2_x && frog_row == car2_y) ||
            (frog_col == car3_x && frog_row == car3_y) ||
            (frog_col == car4_x && frog_row == car4_y) ||
            (frog_col == car5_x && frog_row == car5_y) ||
            (frog_col == car6_x && frog_row == car6_y) ||
            (frog_col == car7_x && frog_row == car7_y) ||
            (frog_col == car8_x && frog_row == car8_y) ||
            (frog_col == car9_x && frog_row == car9_y) ||
            (frog_col == car10_x && frog_row == car10_y) ||
            (frog_col == car11_x && frog_row == car11_y) ||
            (frog_col == car12_x && frog_row == car12_y) ||
            (frog_col == car13_x && frog_row == car13_y) ||
            (frog_col == car14_x && frog_row == car14_y) ||
            (frog_col == car15_x && frog_row == car15_y) ||
            (frog_col == car16_x && frog_row == car16_y)) begin
            if (lives > 0) begin
                lives <= lives - 1;  // Decrement lives
                frog_col <= GRID_COLS / 2;  // Reset frog position
                frog_row <= GRID_ROWS - 1;
                collision_detected <= 1;    // Flag the collision
                frog_direction <= 2'b00;    // Reset direction to up
            end
        end else begin
            collision_detected <= 0;   // Clear the collision flag if no collision
        end
    end

    // Signal if frog has reached the top row (row 0), but lives remain unchanged
    assign frog_at_top = (frog_row == 0);

endmodule
