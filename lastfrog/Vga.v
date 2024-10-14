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
    localparam H_FRONT_PORCH = 16;
    localparam H_LINE = 800;

    localparam V_SYNC_CYC = 2;
    localparam V_BACK_PORCH = 33;
    localparam V_ACTIVE_VIDEO = 480;
    localparam V_FRONT_PORCH = 10;
    localparam V_LINE = 525;

    // // Grid parameters (32x32 pixel cells)
    localparam GRID_WIDTH = 32;
    localparam GRID_HEIGHT = 32;

    // Horizontal and vertical counters for VGA timing
    reg [9:0] h_count = 0;
    reg [8:0] v_count = 0;

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

        // Generate VGA signals (simplified example)
        if (h_count >= H_SYNC_CYC + H_BACK_PORCH && h_count < H_SYNC_CYC + H_BACK_PORCH + H_ACTIVE_VIDEO &&
            v_count >= V_SYNC_CYC + V_BACK_PORCH && v_count < V_SYNC_CYC + V_BACK_PORCH + V_ACTIVE_VIDEO) begin
            // Example: Display frog as a green square
            if ((h_count - (H_SYNC_CYC + H_BACK_PORCH)) / GRID_WIDTH == frog_col && 
                (v_count - (V_SYNC_CYC + V_BACK_PORCH)) / GRID_HEIGHT == frog_row) begin
                vga_r <= 3'b000;
                vga_g <= 3'b111;
                vga_b <= 3'b000;
            end else begin
                // Check for cars
                if ((h_count - (H_SYNC_CYC + H_BACK_PORCH)) / GRID_WIDTH == car1_x && 
                    (v_count - (V_SYNC_CYC + V_BACK_PORCH)) / GRID_HEIGHT == car1_y ||
                    (h_count - (H_SYNC_CYC + H_BACK_PORCH)) / GRID_WIDTH == car2_x && 
                    (v_count - (V_SYNC_CYC + V_BACK_PORCH)) / GRID_HEIGHT == car2_y ||
                    (h_count - (H_SYNC_CYC + H_BACK_PORCH)) / GRID_WIDTH == car3_x && 
                    (v_count - (V_SYNC_CYC + V_BACK_PORCH)) / GRID_HEIGHT == car3_y ||
                    (h_count - (H_SYNC_CYC + H_BACK_PORCH)) / GRID_WIDTH == car4_x && 
                    (v_count - (V_SYNC_CYC + V_BACK_PORCH)) / GRID_HEIGHT == car4_y ||
                    (h_count - (H_SYNC_CYC + H_BACK_PORCH)) / GRID_WIDTH == car5_x && 
                    (v_count - (V_SYNC_CYC + V_BACK_PORCH)) / GRID_HEIGHT == car5_y ||
                    (h_count - (H_SYNC_CYC + H_BACK_PORCH)) / GRID_WIDTH == car6_x && 
                    (v_count - (V_SYNC_CYC + V_BACK_PORCH)) / GRID_HEIGHT == car6_y ||
                    (h_count - (H_SYNC_CYC + H_BACK_PORCH)) / GRID_WIDTH == car7_x && 
                    (v_count - (V_SYNC_CYC + V_BACK_PORCH)) / GRID_HEIGHT == car7_y ||
                    (h_count - (H_SYNC_CYC + H_BACK_PORCH)) / GRID_WIDTH == car8_x && 
                    (v_count - (V_SYNC_CYC + V_BACK_PORCH)) / GRID_HEIGHT == car8_y ||
                    (h_count - (H_SYNC_CYC + H_BACK_PORCH)) / GRID_WIDTH == car9_x && 
                    (v_count - (V_SYNC_CYC + V_BACK_PORCH)) / GRID_HEIGHT == car9_y ||
                    (h_count - (H_SYNC_CYC + H_BACK_PORCH)) / GRID_WIDTH == car10_x && 
                    (v_count - (V_SYNC_CYC + V_BACK_PORCH)) / GRID_HEIGHT == car10_y) begin
                    vga_r <= 3'b111;
                    vga_g <= 3'b000;
                    vga_b <= 3'b000;
                end else begin
                    vga_r <= 3'b000;
                    vga_g <= 3'b000;
                    vga_b <= 3'b000;
                end
            end
        end else begin
            vga_r <= 3'b000;
            vga_g <= 3'b000;
            vga_b <= 3'b000;
        end
    end
endmodule
