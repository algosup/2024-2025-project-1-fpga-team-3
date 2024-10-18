module background (
    input wire [9:0] h_count,   // Horizontal counter for VGA
    input wire [8:0] v_count,   // Vertical counter for VGA
    output reg [2:0] bg_r,      // Background Red signal
    output reg [2:0] bg_g,      // Background Green signal
    output reg [2:0] bg_b       // Background Blue signal
);

    // Grid parameters
    localparam TILE_WIDTH = 32;
    localparam TILE_HEIGHT = 32;

    // Define the horizontal and vertical sync offsets (as needed by your VGA setup)
    localparam H_SYNC_OFFSET = 144;  // Horizontal porch offset
    localparam V_SYNC_OFFSET = 35;   // Vertical porch offset

    // Calculate the current grid position based on horizontal and vertical counters
    wire [4:0] grid_col = (h_count - H_SYNC_OFFSET) / TILE_WIDTH;  // Grid column (0-19)
    wire [3:0] grid_row = (v_count - V_SYNC_OFFSET) / TILE_HEIGHT; // Grid row (0-14)

    always @(*) begin
        // Default background to black
        bg_r = 3'b000;
        bg_g = 3'b000;
        bg_b = 3'b000;

        // Only color within the active display area
        if (h_count >= H_SYNC_OFFSET && h_count < (H_SYNC_OFFSET + (TILE_WIDTH * 20)) &&
            v_count >= V_SYNC_OFFSET && v_count < (V_SYNC_OFFSET + (TILE_HEIGHT * 15))) begin
            // Set background color based on the row
            case (grid_row)
                4'd14: begin
                    // Top row: Grass (green)
                    bg_r = 3'b010;
                    bg_g = 3'b100;
                    bg_b = 3'b000;
                end
                4'd8, 4'd9, 4'd10, 4'd11, 4'd12, 4'd13: begin
                    // Rows 8-13: Road (black)
                    bg_r = 3'b000;
                    bg_g = 3'b000;
                    bg_b = 3'b000;
                end
                4'd7: begin
                    // Row 7: Grass (green)
                    bg_r = 3'b010;
                    bg_g = 3'b100;
                    bg_b = 3'b000;
                end
                4'd1, 4'd2, 4'd3, 4'd4, 4'd5, 4'd6: begin
                    // Rows 1-6: Road (black)
                    bg_r = 3'b000;
                    bg_g = 3'b000;
                    bg_b = 3'b000;
                end
                4'd0: begin
                    // Bottom row: Grass (green)
                    bg_r = 3'b010;
                    bg_g = 3'b100;
                    bg_b = 3'b000;
                end
                default: begin
                    // Default to black (if out of bounds)
                    bg_r = 3'b000;
                    bg_g = 3'b000;
                    bg_b = 3'b000;
                end
            endcase
        end
    end

endmodule
