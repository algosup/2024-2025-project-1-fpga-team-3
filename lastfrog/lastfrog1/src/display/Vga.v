module vga_display (
    input wire clk,             // Clock signal
    input wire [4:0] frog_col,  // Frog X position (in grid columns, 5 bits)
    input wire [3:0] frog_row,  // Frog Y position (in grid rows, 4 bits)
    input wire [4:0] car1_x,    // Car 1 X position (in grid columns)
    input wire [3:0] car1_y,    // Car 1 Y position (in grid rows)
    input wire [4:0] car2_x,    // Car 2 X position (in grid columns)
    input wire [3:0] car2_y,    // Car 2 Y position (in grid rows)
    input wire [4:0] car3_x,    // Car 3 X position (in grid columns)
    input wire [3:0] car3_y,    // Car 3 Y position (in grid rows)
    input wire [4:0] car4_x,    // Car 4 X position (in grid columns)
    input wire [3:0] car4_y,    // Car 4 Y position (in grid rows)
    input wire [4:0] car5_x,    // Car 5 X position (in grid columns)
    input wire [3:0] car5_y,    // Car 5 Y position (in grid rows)
    input wire [4:0] car6_x,    // Car 6 X position (in grid columns)
    input wire [3:0] car6_y,    // Car 6 Y position (in grid rows)
    input wire [4:0] car7_x,    // Car 7 X position (in grid columns)
    input wire [3:0] car7_y,    // Car 7 Y position (in grid rows)
    input wire [4:0] car8_x,    // Car 8 X position (in grid columns)
    input wire [3:0] car8_y,    // Car 8 Y position (in grid rows)
    input wire [4:0] car9_x,    // Car 9 X position (in grid columns)
    input wire [3:0] car9_y,    // Car 9 Y position (in grid rows)
    input wire [4:0] car10_x,   // Car 10 X position (in grid columns)
    input wire [3:0] car10_y,   // Car 10 Y position (in grid rows)
    input wire [4:0] car11_x,   // Car 11 X position (in grid columns)
    input wire [3:0] car11_y,   // Car 11 Y position (in grid rows)
    input wire [4:0] car12_x,   // Car 12 X position (in grid columns)
    input wire [3:0] car12_y,   // Car 12 Y position (in grid rows)
    input wire [4:0] car13_x,   // Car 13 X position (in grid columns)
    input wire [3:0] car13_y,   // Car 13 Y position (in grid rows)
    input wire [4:0] car14_x,   // Car 14 X position (in grid columns)
    input wire [3:0] car14_y,   // Car 14 Y position (in grid rows)
    input wire [4:0] car15_x,   // Car 15 X position (in grid columns)
    input wire [3:0] car15_y,   // Car 15 Y position (in grid rows)
    input wire [4:0] car16_x,   // Car 16 X position (in grid columns)
    input wire [3:0] car16_y,   // Car 16 Y position (in grid rows)
    input wire [4:0] car17_x,   // Car 17 X position (in grid columns)
    input wire [3:0] car17_y,   // Car 17 Y position (in grid rows)
    input wire [4:0] car18_x,   // Car 18 X position (in grid columns)
    input wire [3:0] car18_y,   // Car 18 Y position (in grid rows)
    input wire [4:0] car19_x,   // Car 19 X position (in grid columns)
    input wire [3:0] car19_y,   // Car 19 Y position (in grid rows)
    input wire [4:0] car20_x,   // Car 20 X position (in grid columns)
    input wire [3:0] car20_y,   // Car 20 Y position (in grid rows)
    input wire [4:0] car21_x,   // Car 21 X position (in grid columns)
    input wire [3:0] car21_y,   // Car 21 Y position (in grid rows)
    input wire [4:0] car22_x,   // Car 22 X position (in grid columns)
    input wire [3:0] car22_y,   // Car 22 Y position (in grid rows)
    input wire [4:0] car23_x,   // Car 23 X position (in grid columns)
    input wire [3:0] car23_y,   // Car 23 Y position (in grid rows)
    input wire [4:0] car24_x,   // Car 24 X position (in grid columns)
    input wire [3:0] car24_y,   // Car 24 Y position (in grid rows)
    output reg [2:0] vga_r,     // VGA Red signal
    output reg [2:0] vga_g,     // VGA Green signal
    output reg [2:0] vga_b,     // VGA Blue signal
    output reg vga_hs,          // VGA Horizontal sync
    output reg vga_vs           // VGA Vertical sync
);

    // VGA timing parameters for 640x480 resolution
    localparam H_SYNC_CYC = 96;
    localparam H_BACK_PORCH = 48;
    localparam H_ACTIVE_VIDEO = 640;
    localparam H_FRONT_PORCH = 15;
    localparam H_LINE = 800;

    localparam V_SYNC_CYC = 2;
    localparam V_BACK_PORCH = 33;
    localparam V_ACTIVE_VIDEO = 480;
    localparam V_FRONT_PORCH = 10;
    localparam V_LINE = 525;

    // Grid parameters (32x32 pixel cells)
    localparam GRID_WIDTH = 32;
    localparam GRID_HEIGHT = 32;

    // Horizontal and vertical counters for VGA timing
    reg [9:0] h_count = 0;
    reg [8:0] v_count = 0;

    // Background color signals
    wire [2:0] bg_r, bg_g, bg_b;

    // Instantiate the background module
    background bg_inst (
        .h_count(h_count),
        .v_count(v_count),
        .bg_r(bg_r),
        .bg_g(bg_g),
        .bg_b(bg_b)
    );

    wire [4:0] sprite_x;
    wire [4:0] sprite_y;

    // Assign calculated sprite_x and sprite_y positions based on h_count and v_count
    assign sprite_x = (h_count - (H_SYNC_CYC + H_BACK_PORCH)) % GRID_WIDTH;
    assign sprite_y = (v_count - (V_SYNC_CYC + V_BACK_PORCH)) % GRID_HEIGHT;

    // Instantiate the sprite ROM for the frog
    wire sprite_pixel;
    sprite_frog frog_sprite (
        .x(sprite_x),    // Pass the calculated x position
        .y(sprite_y),    // Pass the calculated y position
        .pixel(sprite_pixel)  // Pixel output from sprite
    );

    always @(posedge clk) begin
        // Horizontal counter
        if (h_count == H_LINE - 1) begin
            h_count <= 0;
            // Vertical counter
            if (v_count == V_LINE - 1) begin
                v_count <= 0;
            end else begin
                v_count <= v_count + 1;
            end
        end else begin
            h_count <= h_count + 1;
        end

        // Generate horizontal sync pulse
        vga_hs <= (h_count < H_SYNC_CYC) ? 0 : 1;

        // Generate vertical sync pulse
        vga_vs <= (v_count < V_SYNC_CYC) ? 0 : 1;

        // Set default to background color
        vga_r <= bg_r;
        vga_g <= bg_g;
        vga_b <= bg_b;

        // Check if in the active video area
        if (h_count >= H_SYNC_CYC + H_BACK_PORCH && h_count < H_SYNC_CYC + H_BACK_PORCH + H_ACTIVE_VIDEO &&
            v_count >= V_SYNC_CYC + V_BACK_PORCH && v_count < V_SYNC_CYC + V_BACK_PORCH + V_ACTIVE_VIDEO) begin
            
            // Draw the frog
            if ((h_count - (H_SYNC_CYC + H_BACK_PORCH)) / GRID_WIDTH == frog_col &&
                (v_count - (V_SYNC_CYC + V_BACK_PORCH)) / GRID_HEIGHT == frog_row) begin

                // Check if the pixel is part of the frog sprite
                if (sprite_pixel) begin
                    vga_r <= 3'b111;  // Frog color (green)
                    vga_g <= 3'b111;
                    vga_b <= 3'b111;
                end
            end else begin
                // Draw cars on top of the background
                if (((h_count - (H_SYNC_CYC + H_BACK_PORCH)) / GRID_WIDTH == car1_x && 
                     (v_count - (V_SYNC_CYC + V_BACK_PORCH)) / GRID_HEIGHT == car1_y) ||
                    ((h_count - (H_SYNC_CYC + H_BACK_PORCH)) / GRID_WIDTH == car2_x && 
                     (v_count - (V_SYNC_CYC + V_BACK_PORCH)) / GRID_HEIGHT == car2_y) ||
                    ((h_count - (H_SYNC_CYC + H_BACK_PORCH)) / GRID_WIDTH == car3_x && 
                     (v_count - (V_SYNC_CYC + V_BACK_PORCH)) / GRID_HEIGHT == car3_y) ||
                    ((h_count - (H_SYNC_CYC + H_BACK_PORCH)) / GRID_WIDTH == car4_x && 
                     (v_count - (V_SYNC_CYC + V_BACK_PORCH)) / GRID_HEIGHT == car4_y) ||
                    ((h_count - (H_SYNC_CYC + H_BACK_PORCH)) / GRID_WIDTH == car5_x && 
                     (v_count - (V_SYNC_CYC + V_BACK_PORCH)) / GRID_HEIGHT == car5_y) ||
                    ((h_count - (H_SYNC_CYC + H_BACK_PORCH)) / GRID_WIDTH == car6_x && 
                     (v_count - (V_SYNC_CYC + V_BACK_PORCH)) / GRID_HEIGHT == car6_y) ||
                    ((h_count - (H_SYNC_CYC + H_BACK_PORCH)) / GRID_WIDTH == car7_x && 
                     (v_count - (V_SYNC_CYC + V_BACK_PORCH)) / GRID_HEIGHT == car7_y) ||
                    ((h_count - (H_SYNC_CYC + H_BACK_PORCH)) / GRID_WIDTH == car8_x && 
                     (v_count - (V_SYNC_CYC + V_BACK_PORCH)) / GRID_HEIGHT == car8_y) ||
                    ((h_count - (H_SYNC_CYC + H_BACK_PORCH)) / GRID_WIDTH == car9_x && 
                     (v_count - (V_SYNC_CYC + V_BACK_PORCH)) / GRID_HEIGHT == car9_y) ||
                    ((h_count - (H_SYNC_CYC + H_BACK_PORCH)) / GRID_WIDTH == car10_x && 
                     (v_count - (V_SYNC_CYC + V_BACK_PORCH)) / GRID_HEIGHT == car10_y) ||
                    ((h_count - (H_SYNC_CYC + H_BACK_PORCH)) / GRID_WIDTH == car11_x && 
                     (v_count - (V_SYNC_CYC + V_BACK_PORCH)) / GRID_HEIGHT == car11_y) ||
                    ((h_count - (H_SYNC_CYC + H_BACK_PORCH)) / GRID_WIDTH == car12_x && 
                     (v_count - (V_SYNC_CYC + V_BACK_PORCH)) / GRID_HEIGHT == car12_y) ||
                    ((h_count - (H_SYNC_CYC + H_BACK_PORCH)) / GRID_WIDTH == car13_x && 
                     (v_count - (V_SYNC_CYC + V_BACK_PORCH)) / GRID_HEIGHT == car13_y) ||
                    ((h_count - (H_SYNC_CYC + H_BACK_PORCH)) / GRID_WIDTH == car14_x && 
                     (v_count - (V_SYNC_CYC + V_BACK_PORCH)) / GRID_HEIGHT == car14_y) ||
                    ((h_count - (H_SYNC_CYC + H_BACK_PORCH)) / GRID_WIDTH == car15_x && 
                     (v_count - (V_SYNC_CYC + V_BACK_PORCH)) / GRID_HEIGHT == car15_y) ||
                    ((h_count - (H_SYNC_CYC + H_BACK_PORCH)) / GRID_WIDTH == car16_x && 
                     (v_count - (V_SYNC_CYC + V_BACK_PORCH)) / GRID_HEIGHT == car16_y) ||
                    ((h_count - (H_SYNC_CYC + H_BACK_PORCH)) / GRID_WIDTH == car17_x && 
                     (v_count - (V_SYNC_CYC + V_BACK_PORCH)) / GRID_HEIGHT == car17_y) ||
                    ((h_count - (H_SYNC_CYC + H_BACK_PORCH)) / GRID_WIDTH == car18_x && 
                     (v_count - (V_SYNC_CYC + V_BACK_PORCH)) / GRID_HEIGHT == car18_y) ||
                    ((h_count - (H_SYNC_CYC + H_BACK_PORCH)) / GRID_WIDTH == car19_x && 
                     (v_count - (V_SYNC_CYC + V_BACK_PORCH)) / GRID_HEIGHT == car19_y) ||
                    ((h_count - (H_SYNC_CYC + H_BACK_PORCH)) / GRID_WIDTH == car20_x && 
                     (v_count - (V_SYNC_CYC + V_BACK_PORCH)) / GRID_HEIGHT == car20_y) ||
                    ((h_count - (H_SYNC_CYC + H_BACK_PORCH)) / GRID_WIDTH == car21_x && 
                     (v_count - (V_SYNC_CYC + V_BACK_PORCH)) / GRID_HEIGHT == car21_y) ||
                    ((h_count - (H_SYNC_CYC + H_BACK_PORCH)) / GRID_WIDTH == car22_x && 
                     (v_count - (V_SYNC_CYC + V_BACK_PORCH)) / GRID_HEIGHT == car22_y) ||
                    ((h_count - (H_SYNC_CYC + H_BACK_PORCH)) / GRID_WIDTH == car23_x && 
                     (v_count - (V_SYNC_CYC + V_BACK_PORCH)) / GRID_HEIGHT == car23_y) ||
                    ((h_count - (H_SYNC_CYC + H_BACK_PORCH)) / GRID_WIDTH == car24_x && 
                     (v_count - (V_SYNC_CYC + V_BACK_PORCH)) / GRID_HEIGHT == car24_y)) begin
                    vga_r <= 3'b111;
                    vga_g <= 3'b000;
                    vga_b <= 3'b000;  // Car color (red)
                end
            end
        end
    end
endmodule
