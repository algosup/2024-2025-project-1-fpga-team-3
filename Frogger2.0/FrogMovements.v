module FrogMovement (
    input i_Clk,
    input reset,
    input i_Switch_3,    // Move up signal (debounced input)
    input i_Switch_2,  // Move down signal
    input i_Switch_1,  // Move left signal
    input i_Switch_4, // Move right signal
    output reg [9:0] frog_x, // Frog X position (in pixels)
    output reg [9:0] frog_y  // Frog Y position (in pixels)
);

    // Define the grid size (20x15 grid)
    parameter GRID_CELL_WIDTH = 32;
    parameter GRID_CELL_HEIGHT = 32;
    parameter GRID_WIDTH = 20;
    parameter GRID_HEIGHT = 15;

    // Initial frog position in the center of the grid
    initial begin
        frog_x = GRID_WIDTH / 2 * GRID_CELL_WIDTH;
        frog_y = GRID_HEIGHT / 2 * GRID_CELL_HEIGHT;
    end

    // Movement logic
    always @(posedge i_Clk or posedge reset) begin
        if (reset) begin
            // Reset frog position to center
            frog_x <= GRID_WIDTH / 2 * GRID_CELL_WIDTH;
            frog_y <= GRID_HEIGHT / 2 * GRID_CELL_HEIGHT;
        end else begin
            // Update frog position based on input, ensure boundary conditions
            if (i_Switch_3 && frog_y > 0)
                frog_y <= frog_y - GRID_CELL_HEIGHT;
            else if (i_Switch_2 && frog_y < (GRID_HEIGHT - 1) * GRID_CELL_HEIGHT)
                frog_y <= frog_y + GRID_CELL_HEIGHT;

            if (i_Switch_1 && frog_x > 0)
                frog_x <= frog_x - GRID_CELL_WIDTH;
            else if (i_Switch_4 && frog_x < (GRID_WIDTH - 1) * GRID_CELL_WIDTH)
                frog_x <= frog_x + GRID_CELL_WIDTH;
        end
    end
endmodule
