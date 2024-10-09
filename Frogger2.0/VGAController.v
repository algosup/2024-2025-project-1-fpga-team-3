module VGA_Controller (
    input i_Clk,         // 25 MHz clock for VGA
    output reg hsync,  // Horizontal sync
    output reg vsync,  // Vertical sync
    output reg [2:0] red,   // Red color channel
    output reg [2:0] green, // Green color channel
    output reg [2:0] blue,  // Blue color channel
    input [9:0] frog_x,     // Frog X position
    input [9:0] frog_y      // Frog Y position
    );

    // VGA 640x480 timing constants
    parameter H_SYNC_CYCLES = 96;
    parameter H_BACK_PORCH = 48;
    parameter H_DISPLAY = 640;
    parameter H_FRONT_PORCH = 16;
    parameter H_TOTAL = 800;  // Total horizontal time

    parameter V_SYNC_CYCLES = 2;
    parameter V_BACK_PORCH = 33;
    parameter V_DISPLAY = 480;
    parameter V_FRONT_PORCH = 10;
    parameter V_TOTAL = 525;  // Total vertical time

    reg [9:0] h_counter = 0;
    reg [9:0] v_counter = 0;

    // Horizontal sync
    always @(posedge i_Clk) begin
        if (h_counter < H_TOTAL - 1)
            h_counter <= h_counter + 1;
        else begin
            h_counter <= 0;
            if (v_counter < V_TOTAL - 1)
                v_counter <= v_counter + 1;
            else
                v_counter <= 0;
        end
    end

    // Generate hsync and vsync signals
    assign hsync = (h_counter < H_SYNC_CYCLES) ? 0 : 1;
    assign vsync = (v_counter < V_SYNC_CYCLES) ? 0 : 1;
    
    // Parameters for grid layout (20x15 grid)
    parameter GRID_WIDTH = 32;
    parameter GRID_HEIGHT = 32;

    // Calculate grid boundaries
    wire is_grid_boundary = 
        (h_counter == 0 || h_counter == H_DISPLAY - 1 ||    // Left and right edges
         v_counter == 0 || v_counter == V_DISPLAY - 1);     // Top and bottom edges



// Display logic: rendering the frog and the grid with edges
    always @(posedge i_Clk) begin
        if (h_counter < H_DISPLAY && v_counter < V_DISPLAY) begin
            // Draw grid boundary (edges)
            if (is_grid_boundary) begin
                red <= 3'b111;   // White grid edges
                green <= 3'b111;
                blue <= 3'b111;
            end
            // Draw grid lines (inside the grid)
            else if (h_counter % GRID_WIDTH == 0 || v_counter % GRID_HEIGHT == 0) begin
                red <= 3'b111;   // White grid lines
                green <= 3'b111;
                blue <= 3'b111;
            end
            // Draw the frog
            else if (h_counter >= frog_x && h_counter < frog_x + GRID_WIDTH &&
                     v_counter >= frog_y && v_counter < frog_y + GRID_HEIGHT) begin
                red <= 3'b000;
                green <= 3'b111;  // Green frog
                blue <= 3'b000;
            end else begin
                // Background (black)
                red <= 3'b000;
                green <= 3'b000;
                blue <= 3'b000;
            end
        end else begin
            // During sync periods, turn off RGB signals
            red <= 3'b000;
            green <= 3'b000;
            blue <= 3'b000;
        end
    end
endmodule