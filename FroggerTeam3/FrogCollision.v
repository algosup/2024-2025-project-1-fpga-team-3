module frog_collision (
    input wire i_Clk,
    input wire [9:0] frog_x,     // Frog's x position
    input wire [9:0] frog_y,     // Frog's y position
    input wire [9:0] car_x,      // Car's x position
    input wire [9:0] car_row,    // Car's row (Y position) in grid units
    input wire [9:0] grid_size,  // Grid size (width and height of the frog/car)
    output reg [9:0] frog_reset_x,  // Frog's reset x position
    output reg [9:0] frog_reset_y,  // Frog's reset y position
    output reg collision,        // Collision detection flag
    output reg explosion_active  // Flag for explosion visual effect
);

    // Parameters for explosion duration
    localparam EXPLOSION_DURATION = 1000000; // Adjust for timing
    reg [19:0] explosion_counter = 0;  // Counter for explosion duration

    // Initial frog position (can be passed as a parameter or hardcoded)
    localparam FROG_INITIAL_X = 320;  // Example initial x position
    localparam FROG_INITIAL_Y = 400;  // Example initial y position

    always @(posedge i_Clk) begin
        // Check if the frog's bounding box overlaps with the car's bounding box
        if (frog_x < car_x + grid_size && frog_x + grid_size > car_x &&
            frog_y < (car_row * grid_size) + grid_size && frog_y + grid_size > (car_row * grid_size)) begin
            collision <= 1;  // Collision detected
        end else begin
            collision <= 0;
        end

        // Handle explosion and reset after collision
        if (collision) begin
            explosion_active <= 1;  // Trigger explosion visual effect
            explosion_counter <= explosion_counter + 1;
            if (explosion_counter >= EXPLOSION_DURATION) begin
                explosion_active <= 0;  // End explosion effect
                explosion_counter <= 0;
                // Reset the frog's position
                frog_reset_x <= FROG_INITIAL_X;
                frog_reset_y <= FROG_INITIAL_Y;
            end
        end
    end
endmodule
