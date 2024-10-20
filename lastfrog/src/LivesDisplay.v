module LiveDisplay (
    input wire clk,                  // Clock signal
    input wire [1:0] lives,          // Number of remaining lives (0 to 3)
    input wire [9:0] h_count,        // Horizontal counter (column)
    input wire [8:0] v_count,        // Vertical counter (row)
    output reg [2:0] vga_r,          // VGA Red output signal
    output reg [2:0] vga_g,          // VGA Green output signal
    output reg [2:0] vga_b           // VGA Blue output signal
);

    // Constants for heart size and spacing
    localparam HEART_WIDTH  = 16;
    localparam HEART_HEIGHT = 16;
    localparam HEART_Y_POS  = 490;   // Vertical position of hearts
    localparam HEART_X_START = 160;  // Horizontal start position of first heart

    // Dynamic spacing variable (calculated to avoid overflow)
    reg [9:0] HEART_SPACING;  // Dynamically calculated spacing

    // Adjust spacing dynamically based on max possible heart position to avoid overflow
    always @(*) begin
        if (HEART_X_START + 2 * (HEART_WIDTH + 8) <= 1023) begin
            HEART_SPACING = 8;  // Default spacing value (safe for small hearts)
        end else begin
            // Adjust the spacing dynamically to avoid overflow
            HEART_SPACING = (1023 - (HEART_X_START + 2 * HEART_WIDTH)) / 2;
        end
    end

    // Precompute X start positions for second and third hearts
    wire [9:0] heart2_x_start = HEART_X_START + HEART_WIDTH + HEART_SPACING;
    wire [9:0] heart3_x_start = heart2_x_start + HEART_WIDTH + HEART_SPACING;

    // Check if h_count falls within the range of each heart
    wire first_heart_active  = (h_count >= HEART_X_START && h_count < HEART_X_START + HEART_WIDTH);
    wire second_heart_active = (h_count >= heart2_x_start && h_count < heart2_x_start + HEART_WIDTH);
    wire third_heart_active  = (h_count >= heart3_x_start && h_count < heart3_x_start + HEART_WIDTH);

    // Sprite X and Y coordinates for each heart
    wire [3:0] heart_sprite_x;
    wire [3:0] heart_sprite_y = v_count - HEART_Y_POS;

    // Select the active heart's X-coordinate
    assign heart_sprite_x = first_heart_active ? (h_count - HEART_X_START) :
                            second_heart_active ? (h_count - heart2_x_start) :
                            third_heart_active ? (h_count - heart3_x_start) : 4'b0;

    // Wires for pixel data from heart sprite
    wire [5:0] heart_pixel_data;

    // Instantiate heart sprite BRAM
    heart_sprite_bram heart_bram (
        .clk(clk),
        .sprite_x(heart_sprite_x),
        .sprite_y(heart_sprite_y),
        .pixel_data(heart_pixel_data)
    );

    // Display the hearts based on the number of lives
    always @(*) begin
        // Default VGA to black
        vga_r = 3'b000;
        vga_g = 3'b000;
        vga_b = 3'b000;

        // Check if we are within the valid Y range for hearts
        if (v_count >= HEART_Y_POS && v_count < HEART_Y_POS + HEART_HEIGHT) begin
            // First heart display if lives >= 1
            if (lives >= 1 && first_heart_active) begin
                vga_r = {heart_pixel_data[5:4], 1'b0};  // Red
                vga_g = {heart_pixel_data[3:2], 1'b0};  // Green
                vga_b = {heart_pixel_data[1:0], 1'b0};  // Blue
            end
            // Second heart display if lives >= 2
            else if (lives >= 2 && second_heart_active) begin
                vga_r = {heart_pixel_data[5:4], 1'b0};  // Red
                vga_g = {heart_pixel_data[3:2], 1'b0};  // Green
                vga_b = {heart_pixel_data[1:0], 1'b0};  // Blue
            end
            // Third heart display if lives >= 3
            else if (lives >= 3 && third_heart_active) begin
                vga_r = {heart_pixel_data[5:4], 1'b0};  // Red
                vga_g = {heart_pixel_data[3:2], 1'b0};  // Green
                vga_b = {heart_pixel_data[1:0], 1'b0};  // Blue
            end
        end
    end
endmodule
