module vga_display (
    input wire clk,             // Clock signal
    input wire [4:0] frog_col,  // Frog X position (in grid columns, 5 bits)
    input wire [3:0] frog_row,  // Frog Y position (in grid rows, 4 bits)
    input wire [1:0] lives,     // Number of lives remaining
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
    reg [9:0] h_count = 640;
    reg [8:0] v_count = 480;

    // Background color signals
    wire [2:0] bg_r, bg_g, bg_b;

    // Signals from live_display for lives
    wire [2:0] lives_r, lives_g, lives_b;

    // Sprite position within the grid cell
    wire [4:0] sprite_x;
    wire [4:0] sprite_y;
    wire sprite_pixel;

    // Instantiate the background module
    background bg_inst (
        .h_count(h_count),
        .v_count(v_count),
        .bg_r(bg_r),
        .bg_g(bg_g),
        .bg_b(bg_b)
    );

    // Assign calculated sprite_x and sprite_y positions based on h_count and v_count
    assign sprite_x = (h_count - (H_SYNC_CYC + H_BACK_PORCH)) % GRID_WIDTH;
    assign sprite_y = (v_count - (V_SYNC_CYC + V_BACK_PORCH)) % GRID_HEIGHT;

    // Instantiate the sprite ROM for the frog
    sprite_frog frog_sprite (
        .x(sprite_x),    // Pass the calculated x position
        .y(sprite_y),    // Pass the calculated y position
        .pixel(sprite_pixel)  // Pixel output from sprite
    );

    // Horizontal sync and vertical sync logic
    always @(posedge clk) begin
        if (h_count == H_LINE - 1) begin
            h_count <= 0;
            if (v_count == V_LINE - 1) begin
                v_count <= 0;
            end else begin
                v_count <= v_count + 1;
            end
        end else begin
            h_count <= h_count + 1;
        end

        vga_hs <= (h_count < H_SYNC_CYC) ? 0 : 1;
        vga_vs <= (v_count < V_SYNC_CYC) ? 0 : 1;
    end

    // Instancier le module live_display pour afficher les vies
    live_display lives_inst (
        .lives(lives),
        .h_count(h_count),
        .v_count(v_count),
        .vga_r(lives_r),
        .vga_g(lives_g),
        .vga_b(lives_b)
    );

    // Logique unifiée pour gérer l'affichage
    always @(posedge clk) begin
        // Par défaut, couleur de fond
        vga_r <= bg_r;
        vga_g <= bg_g;
        vga_b <= bg_b;

        // Priorité : affichage des vies
        if (lives_r != 3'b000 || lives_g != 3'b000 || lives_b != 3'b000) begin
            vga_r <= lives_r;
            vga_g <= lives_g;
            vga_b <= lives_b;
        end
        // Ensuite, afficher la grenouille si elle est dans la zone active
        else if ((h_count - (H_SYNC_CYC + H_BACK_PORCH)) / GRID_WIDTH == frog_col &&
                 (v_count - (V_SYNC_CYC + V_BACK_PORCH)) / GRID_HEIGHT == frog_row && sprite_pixel) begin
            vga_r <= 3'b000;  // Grenouille verte
            vga_g <= 3'b111;
            vga_b <= 3'b000;
        end
            // Affichage des voitures si pas de grenouille
            else if (((h_count - (H_SYNC_CYC + H_BACK_PORCH)) / GRID_WIDTH == car1_x && 
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
                      (v_count - (V_SYNC_CYC + V_BACK_PORCH)) / GRID_HEIGHT == car16_y)) begin
                vga_r <= 3'b111;  // Car color (red)
                vga_g <= 3'b000;
                vga_b <= 3'b000;
            end
        end
endmodule