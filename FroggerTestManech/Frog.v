module square_drawer (
    input wire [9:0] h_counter,
    input wire [9:0] v_counter,
    input wire [9:0] frog_x,  // Input to pass the frog's x position
    input wire [9:0] frog_y,  // Input to pass the frog's y position
    output wire in_square
);

    // Define the grid size
    localparam GRID_SIZE = 32;  // Example grid size (both width and height)

    // Check if the current pixel is within the frog's square
    assign in_square = (h_counter >= frog_x && h_counter < frog_x + GRID_SIZE &&
                        v_counter >= frog_y && v_counter < frog_y + GRID_SIZE);

endmodule
