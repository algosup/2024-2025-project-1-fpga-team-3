module VgaDisplay (
    input wire clk,
    input wire [4:0] frog_col,  // Frog X position (in grid columns)
    input wire [3:0] frog_row,  // Frog Y position (in grid rows)
    input wire [1:0] lives,     // Number of lives remaining
    input wire [4:0] car1_x, car2_x, car3_x, car4_x, car5_x,
    input wire [4:0] car6_x, car7_x, car8_x, car9_x, car10_x,
    input wire [4:0] car11_x, car12_x, car13_x, car14_x, car15_x, car16_x,
    input wire [3:0] car1_y, car2_y, car3_y, car4_y, car5_y,
    input wire [3:0] car6_y, car7_y, car8_y, car9_y, car10_y,
    input wire [3:0] car11_y, car12_y, car13_y, car14_y, car15_y, car16_y,
    output reg [2:0] vga_r, vga_g, vga_b,  // VGA RGB color signals
    output reg vga_hs, vga_vs              // VGA sync signals
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

    // Sync logic for horizontal and vertical signals
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

        // Generate sync signals
        vga_hs <= (h_count < H_SYNC_CYC) ? 0 : 1;
        vga_vs <= (v_count < V_SYNC_CYC) ? 0 : 1;
    end

    // Calculate the adjusted coordinates
    wire [9:0] active_h = h_count - (H_SYNC_CYC + H_BACK_PORCH); // Adjust for active region
    wire [9:0] active_v = v_count - (V_SYNC_CYC + V_BACK_PORCH); // Adjust for active region

    // Calculate sprite coordinates for the frog
    wire [4:0] sprite_x = (active_h - (frog_col * GRID_WIDTH)) % GRID_WIDTH;
    wire [4:0] sprite_y = (active_v - (frog_row * GRID_HEIGHT)) % GRID_HEIGHT;


    // Instantiate the blue car left sprite BRAM module
    wire [5:0] blue_car_left_pixel_data;
    BlueCarLeftSpriteBram blue_car_left_bram (
        .clk(clk),
        .sprite_x(active_h[4:0]),    // Truncate active_h to 5 bits
        .sprite_y(active_v[4:0]),    // Truncate active_v to 5 bits
        .pixel_data(blue_car_left_pixel_data)  // Car's pixel data
    );
    // Instantiate the blue car right sprite BRAM module
    wire [5:0] blue_car_right_pixel_data;
    BlueCarRightSpriteBram blue_car_right_bram (
        .clk(clk),
        .sprite_x(active_h[4:0]),    // Truncate active_h to 5 bits
        .sprite_y(active_v[4:0]),    // Truncate active_v to 5 bits
        .pixel_data(blue_car_right_pixel_data)  // Car's pixel data
    );

    // Instantiate the red car left sprite BRAM module
    wire [5:0] red_car_left_pixel_data;
    RedCarLeftSpriteBram red_car_left_bram (
        .clk(clk),
        .sprite_x(active_h[4:0]),    // Truncate active_h to 5 bits
        .sprite_y(active_v[4:0]),    // Truncate active_v to 5 bits
        .pixel_data(red_car_left_pixel_data)  // Car's pixel data
    );
        // Instantiate the red car right sprite BRAM module
    wire [5:0] red_car_right_pixel_data;
    RedCarRightSpriteBram red_car_right_bram (
        .clk(clk),
        .sprite_x(active_h[4:0]),    // Truncate active_h to 5 bits
        .sprite_y(active_v[4:0]),    // Truncate active_v to 5 bits
        .pixel_data(red_car_right_pixel_data)  // Car's pixel data
    );

    // Instantiate the frog sprite BRAM module
    wire [5:0] frog_pixel_data;
    FrogSpriteBram frog_bram_inst (
        .clk(clk),
        .sprite_x(sprite_x),
        .sprite_y(sprite_y),
        .pixel_data(frog_pixel_data)
    );

    // Instantiate the lives display module (using heart sprites for lives)
    wire [2:0] lives_r, lives_g, lives_b;
    LiveDisplay lives_inst (
        .clk(clk),
        .lives(lives),
        .h_count(h_count),
        .v_count(v_count),
        .vga_r(lives_r),
        .vga_g(lives_g),
        .vga_b(lives_b)
    );

    // Instantiate the background module
    wire [2:0] bg_r, bg_g, bg_b;
    Background bg_inst (
        .clk(clk),
        .h_count(h_count),
        .v_count(v_count),
        .bg_r(bg_r),
        .bg_g(bg_g),
        .bg_b(bg_b)
    );

    // VGA output logic for frog, lives, cars, and background
    always @(posedge clk) begin
        // Default background color from the background module
        vga_r <= bg_r;
        vga_g <= bg_g;
        vga_b <= bg_b;

        // Display frog sprite 
        if ((active_h >= frog_col * GRID_WIDTH) && (active_h < (frog_col + 1) * GRID_WIDTH) &&
            (active_v >= frog_row * GRID_HEIGHT) && (active_v < (frog_row + 1) * GRID_HEIGHT) && 
            frog_pixel_data != 6'b000000) begin
            vga_r <= {frog_pixel_data[5:4], 1'b0};  // Red
            vga_g <= {frog_pixel_data[3:2], 1'b0};  // Green
            vga_b <= {frog_pixel_data[1:0], 1'b0};  // Blue
        end
        // Display lives if not default background
        else if (lives_r != 3'b000 || lives_g != 3'b000 || lives_b != 3'b000) begin
            vga_r <= lives_r;
            vga_g <= lives_g;
            vga_b <= lives_b;
        end
        // Display blue car sprite 
        else if (((active_h / GRID_WIDTH == car3_x && active_v / GRID_HEIGHT == car3_y) ||
                  (active_h / GRID_WIDTH == car6_x && active_v / GRID_HEIGHT == car6_y) ||
                  (active_h / GRID_WIDTH == car7_x && active_v / GRID_HEIGHT == car7_y) ||
                  (active_h / GRID_WIDTH == car8_x && active_v / GRID_HEIGHT == car8_y)) &&
                 blue_car_left_pixel_data != 6'b000000) begin
            // Set the VGA output using the car's pixel data
            vga_r <= {blue_car_left_pixel_data[5:4], 1'b0};  // Red
            vga_g <= {blue_car_left_pixel_data[3:2], 1'b0};  // Green
            vga_b <= {blue_car_left_pixel_data[1:0], 1'b0};  // Blue
        end
        else if (((active_h / GRID_WIDTH == car1_x && active_v / GRID_HEIGHT == car1_y) ||
                  (active_h / GRID_WIDTH == car2_x && active_v / GRID_HEIGHT == car2_y) ||
                  (active_h / GRID_WIDTH == car4_x && active_v / GRID_HEIGHT == car4_y) ||
                  (active_h / GRID_WIDTH == car5_x && active_v / GRID_HEIGHT == car5_y) ||
                  (active_h / GRID_WIDTH == car9_x && active_v / GRID_HEIGHT == car9_y)) &&
                 blue_car_right_pixel_data != 6'b000000) begin
            // Set the VGA output using the car's pixel data
            vga_r <= {blue_car_right_pixel_data[5:4], 1'b0};  // Red
            vga_g <= {blue_car_right_pixel_data[3:2], 1'b0};  // Green
            vga_b <= {blue_car_right_pixel_data[1:0], 1'b0};  // Blue
        end
        // Display red car sprite
        else if (((active_h / GRID_WIDTH == car10_x && active_v / GRID_HEIGHT == car10_y) ||
                  (active_h / GRID_WIDTH == car11_x && active_v / GRID_HEIGHT == car11_y) ||
                  (active_h / GRID_WIDTH == car12_x && active_v / GRID_HEIGHT == car12_y) ||
                  (active_h / GRID_WIDTH == car16_x && active_v / GRID_HEIGHT == car16_y)) && 
                 red_car_left_pixel_data != 6'b000000) begin
            // Set the VGA output using the car's pixel data
            vga_r <= {red_car_left_pixel_data[5:4], 1'b0};  // Red
            vga_g <= {red_car_left_pixel_data[3:2], 1'b0};  // Green
            vga_b <= {red_car_left_pixel_data[1:0], 1'b0};  // Blue
        end
        else if (((active_h / GRID_WIDTH == car13_x && active_v / GRID_HEIGHT == car13_y) ||
                  (active_h / GRID_WIDTH == car14_x && active_v / GRID_HEIGHT == car14_y) ||
                  (active_h / GRID_WIDTH == car15_x && active_v / GRID_HEIGHT == car15_y)) && 
                 red_car_right_pixel_data != 6'b000000) begin
            // Set the VGA output using the car's pixel data
            vga_r <= {red_car_right_pixel_data[5:4], 1'b0};  // Red
            vga_g <= {red_car_right_pixel_data[3:2], 1'b0};  // Green
            vga_b <= {red_car_right_pixel_data[1:0], 1'b0};  // Blue
        end
    end
endmodule
