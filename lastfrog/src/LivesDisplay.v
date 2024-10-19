module live_display (
    input wire clk,                 // Clock signal
    input wire [1:0] lives,         // Number of remaining lives (0 to 3)
    input wire [9:0] h_count,       // Horizontal counter (column)
    input wire [8:0] v_count,       // Vertical counter (row)
    output reg [2:0] vga_r,         // VGA Red output signal
    output reg [2:0] vga_g,         // VGA Green output signal
    output reg [2:0] vga_b          // VGA Blue output signal
);

    // Heart sprite size (16x16 pixels)
    localparam HEART_WIDTH = 16;
    localparam HEART_HEIGHT = 16;

    // Spacing between hearts (adjusted to be close)
    localparam HEART_SPACING = 16;  // Close spacing between each heart, while reducing LUT

    // Starting position for hearts (bottom left of the screen)
    localparam HEART_Y_POS = 490;   // Vertical position (just before the bottom of the screen)
    localparam HEART_X_START = 160; // Horizontal starting position (slightly offset from the edge)

    // Increase the wire size to handle overflow issues (widened to 10 bits)
    wire [8:0] heart1_x_start = HEART_X_START;
    wire [8:0] heart2_x_start = HEART_X_START + HEART_WIDTH + HEART_SPACING;
    wire [8:0] heart3_x_start = HEART_X_START + 2 * (HEART_WIDTH + HEART_SPACING);

    // Determine which heart is being displayed
    wire first_heart = (h_count >= heart1_x_start && h_count < heart1_x_start + HEART_WIDTH);
    wire second_heart = (h_count >= heart2_x_start && h_count < heart2_x_start + HEART_WIDTH);
    wire third_heart = (h_count >= heart3_x_start && h_count < heart3_x_start + HEART_WIDTH);

    // Sprite coordinates for the current heart
    wire [3:0] heart_sprite_x = first_heart ? (h_count - heart1_x_start) :
                                second_heart ? (h_count - heart2_x_start) :
                                third_heart ? (h_count - heart3_x_start) : 0;
    wire [3:0] heart_sprite_y = v_count - HEART_Y_POS;

    // Wires to store pixel data from heart sprites
    wire [5:0] heart_pixel_data;

    // Instantiate heart sprite BRAM
    heart_sprite_bram heart_bram (
        .clk(clk),
        .sprite_x(heart_sprite_x),
        .sprite_y(heart_sprite_y),
        .pixel_data(heart_pixel_data)
    );

    always @(*) begin
        // Default VGA output to black
        vga_r = 3'b000;
        vga_g = 3'b000;
        vga_b = 3'b000;

        // Display hearts based on lives count and if in the correct range
        if (v_count >= HEART_Y_POS && v_count < HEART_Y_POS + HEART_HEIGHT) begin
            // First heart display
            if (lives >= 1 && first_heart) begin
                vga_r = {heart_pixel_data[5:4], 1'b0};  // Red
                vga_g = {heart_pixel_data[3:2], 1'b0};  // Green
                vga_b = {heart_pixel_data[1:0], 1'b0};  // Blue
            end
            // Second heart display
            else if (lives >= 2 && second_heart) begin
                vga_r = {heart_pixel_data[5:4], 1'b0};  // Red
                vga_g = {heart_pixel_data[3:2], 1'b0};  // Green
                vga_b = {heart_pixel_data[1:0], 1'b0};  // Blue
            end
            // Third heart display
            else if (lives >= 3 && third_heart) begin
                vga_r = {heart_pixel_data[5:4], 1'b0};  // Red
                vga_g = {heart_pixel_data[3:2], 1'b0};  // Green
                vga_b = {heart_pixel_data[1:0], 1'b0};  // Blue
            end
        end
    end
endmodule
