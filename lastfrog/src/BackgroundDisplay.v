module Background (
    input wire clk,               // Clock signal
    input wire [9:0] h_count,     // Horizontal counter for VGA
    input wire [8:0] v_count,     // Vertical counter for VGA
    output reg [2:0] bg_r,        // Background Red signal
    output reg [2:0] bg_g,        // Background Green signal
    output reg [2:0] bg_b         // Background Blue signal
);

    // Constants
    localparam TILE_WIDTH = 32;
    localparam TILE_HEIGHT = 32;

    // Calculate the adjusted coordinates for active region
    wire [9:0] active_h = h_count - (96 + 48); // Adjust for horizontal sync and back porch
    wire [9:0] active_v = v_count - (2 + 33);  // Adjust for vertical sync and back porch

    // Ensure we are in the active display region
    wire display_active = (active_h < 640 && active_v < 480);

    // Grid coordinates (which 32x32 tile are we on?)
    wire [4:0] grid_col = active_h / TILE_WIDTH;  // Column in the grid
    wire [3:0] grid_row = active_v / TILE_HEIGHT; // Row in the grid

    // Local coordinates within the 32x32 block
    wire [4:0] block_x = active_h % TILE_WIDTH;  // X within the block
    wire [4:0] block_y = active_v % TILE_HEIGHT; // Y within the block

    // Pixel data from each of the background blocks
    wire [5:0] double_sidewalk_pixel_data;
    wire [5:0] one_way_sidewalk_pixel_data;
    wire [5:0] one_way_sidewalk_reversed_pixel_data;
    wire [5:0] road_pixel_data;
    wire [5:0] sidewalk_pixel_data;

    // Load each block (use the correct BRAM module for each block sprite)
    double_sidewalk_sprite_bram double_sidewalk_bram (
        .clk(clk),
        .sprite_x(block_x),
        .sprite_y(block_y),
        .pixel_data(double_sidewalk_pixel_data)
    );

    one_way_sidewalk_sprite_bram one_way_sidewalk_bram (
        .clk(clk),
        .sprite_x(block_x),
        .sprite_y(block_y),
        .pixel_data(one_way_sidewalk_pixel_data)
    );
    
    sidewalk_monochromatic_bram sidewalk_monochromatic_bram (
        .clk(clk),
        .sprite_x(block_x),
        .sprite_y(block_y),
        .pixel_data(sidewalk_pixel_data)
    );

    one_way_sidewalk_reversed_sprite_bram one_way_sidewalk_reversed_bram (
        .clk(clk),
        .sprite_x(block_x),
        .sprite_y(block_y),
        .pixel_data(one_way_sidewalk_reversed_pixel_data)
    );

    road_sprite_bram road_bram (
        .clk(clk),
        .sprite_x(block_x),
        .sprite_y(block_y),
        .pixel_data(road_pixel_data)
    );

    always @(*) begin
        // Default background to black if not in active region
        bg_r = 3'b000;
        bg_g = 3'b000;
        bg_b = 3'b000;

        if (display_active) begin
            // Adjust rows based on the correct patterns, ensuring unique row identifiers
            case (grid_row)
                6,9: begin
                    // Top and bottom rows: Double sidewalk
                    if (double_sidewalk_pixel_data != 6'b000000) begin
                        bg_r = {double_sidewalk_pixel_data[5:4], 1'b0};  // Red
                        bg_g = {double_sidewalk_pixel_data[3:2], 1'b0};  // Green
                        bg_b = {double_sidewalk_pixel_data[1:0], 1'b0};  // Blue
                    end
                end
                14: begin
                    // Sidewalk rows: One-way sidewalk
                    if (one_way_sidewalk_pixel_data != 6'b000000) begin
                        bg_r = {one_way_sidewalk_pixel_data[5:4], 1'b0};  // Red
                        bg_g = {one_way_sidewalk_pixel_data[3:2], 1'b0};  // Green
                        bg_b = {one_way_sidewalk_pixel_data[1:0], 1'b0};  // Blue
                    end
                end
                2,3,4,5,7,8,10,11,12,13: begin
                    // Road rows
                    if (road_pixel_data != 6'b000000) begin
                        bg_r = {road_pixel_data[5:4], 1'b0};  // Red
                        bg_g = {road_pixel_data[3:2], 1'b0};  // Green
                        bg_b = {road_pixel_data[1:0], 1'b0};  // Blue
                    end
                end
                1: begin
                    // Reversed sidewalk rows
                    if (one_way_sidewalk_reversed_pixel_data != 6'b000000) begin
                        bg_r = {one_way_sidewalk_reversed_pixel_data[5:4], 1'b0};  // Red
                        bg_g = {one_way_sidewalk_reversed_pixel_data[3:2], 1'b0};  // Green
                        bg_b = {one_way_sidewalk_reversed_pixel_data[1:0], 1'b0};  // Blue
                    end
                end
                0: begin
                    // Monochromatic sidewalk
                    if (sidewalk_pixel_data != 6'b000000) begin
                        bg_r = {sidewalk_pixel_data[5:4], 1'b0};  // Red
                        bg_g = {sidewalk_pixel_data[3:2], 1'b0};  // Green
                        bg_b = {sidewalk_pixel_data[1:0], 1'b0};  // Blue
                    end
                end
                default: begin
                    // Default to black background
                    bg_r = 3'b000;
                    bg_g = 3'b000;
                    bg_b = 3'b000;
                end
            endcase
        end
    end
endmodule
