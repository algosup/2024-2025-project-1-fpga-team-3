module Frogger (
    input wire i_Clk,
    input wire i_Switch_1,   // Move frog left
    input wire i_Switch_2,   // Move frog backward
    input wire i_Switch_3,   // Move frog forward
    input wire i_Switch_4,   // Move frog right
    output reg [2:0] red,
    output reg [2:0] green,
    output reg [2:0] blue,
    output wire hsync,
    output wire vsync,
    output wire o_Segment1_A,   // Segment display outputs
    output wire o_Segment1_B,
    output wire o_Segment1_C,
    output wire o_Segment1_D,
    output wire o_Segment1_E,
    output wire o_Segment1_F,
    output wire o_Segment1_G
);

    // VGA parameters for 640x480 resolution
    localparam H_DISPLAY = 640;
    localparam H_FRONT_PORCH = 16;
    localparam H_SYNC_PULSE = 96;
    localparam H_BACK_PORCH = 48;
    localparam H_TOTAL = H_DISPLAY + H_FRONT_PORCH + H_SYNC_PULSE + H_BACK_PORCH;

    localparam V_DISPLAY = 480;
    localparam V_FRONT_PORCH = 10;
    localparam V_SYNC_PULSE = 2;
    localparam V_BACK_PORCH = 33;
    localparam V_TOTAL = V_DISPLAY + V_FRONT_PORCH + V_SYNC_PULSE + V_BACK_PORCH;

    // Set grid size for the squares
    localparam GRID_WIDTH = 32;  // Width of each grid cell
    localparam GRID_HEIGHT = 32; // Height of each grid cell

    reg [9:0] h_counter = 0;
    reg [9:0] v_counter = 0;

    // Wires to hold frog position and level from the frog_movement module
    wire [9:0] frog_x;
    wire [9:0] frog_y;
    wire [3:0] level; // Level wire from the frog_movement module

    // Instantiate the frog_movement module
    frog_movement frog_move_inst (
        .i_Clk(i_Clk),
        .i_Switch_1(i_Switch_1),
        .i_Switch_2(i_Switch_2),
        .i_Switch_3(i_Switch_3),
        .i_Switch_4(i_Switch_4),
        .h_display(H_DISPLAY),
        .v_display(V_DISPLAY),
        .grid_size(GRID_WIDTH),
        .frog_x(frog_x),    // Output: frog's x position
        .frog_y(frog_y),    // Output: frog's y position
        .level(level)       // Output: current level
    );

    // Instantiate the segment display module and pass the level
    wire [6:0] segment_data;
    segment_display seg_display_inst (
        .i_Level(level),        // Pass the level here
        .o_Segment(segment_data)
    );

    // Car 1 (row 10)
    wire [9:0] car1_x;
    localparam CAR1_ROW = 10;     // Row number for car 1
    localparam CAR1_SPEED = 100000; // Speed for car 1
    localparam CAR1_INITIAL_X = 0; // Initial position for car 1

    car_movement car1_move_inst (
        .i_Clk(i_Clk),
        .h_display(H_DISPLAY),
        .car_x(car1_x),
        .speed_divisor(CAR1_SPEED),
        .initial_position(CAR1_INITIAL_X)
    );

    // Car 2 (row 12)
    wire [9:0] car2_x;
    localparam CAR2_ROW = 12;     // Row number for car 2
    localparam CAR2_SPEED = 80000; // Speed for car 2
    localparam CAR2_INITIAL_X = 100; // Initial position for car 2

    car_movement car2_move_inst (
        .i_Clk(i_Clk),
        .h_display(H_DISPLAY),
        .car_x(car2_x),
        .speed_divisor(CAR2_SPEED),
        .initial_position(CAR2_INITIAL_X)
    );

    // Determine if the current pixel is part of the white grid lines
    wire is_grid_line;
    assign is_grid_line = (h_counter % GRID_WIDTH == 0) || (v_counter % GRID_HEIGHT == 0);

    // RGB output: Frog, grid lines, and cars
    always @(*) begin
        // Default to background color
        red = 3'b000;
        green = 3'b000;
        blue = 3'b000;

        // Draw the frog
        if (h_counter >= frog_x && h_counter < frog_x + GRID_WIDTH &&
            v_counter >= frog_y && v_counter < frog_y + GRID_HEIGHT) begin
            red = 3'b111;   // Frog color (red)
            green = 3'b000;
            blue = 3'b000;
        end

        // Draw car 1
        if (h_counter >= car1_x && h_counter < car1_x + GRID_WIDTH &&
            v_counter >= CAR1_ROW * GRID_HEIGHT && v_counter < (CAR1_ROW * GRID_HEIGHT) + GRID_HEIGHT) begin
            red = 3'b000;  // Car 1 color (green)
            green = 3'b111;
            blue = 3'b000;
        end

        // Draw car 2
        if (h_counter >= car2_x && h_counter < car2_x + GRID_WIDTH &&
            v_counter >= CAR2_ROW * GRID_HEIGHT && v_counter < (CAR2_ROW * GRID_HEIGHT) + GRID_HEIGHT) begin
            red = 3'b000;  // Car 2 color (blue)
            green = 3'b000;
            blue = 3'b111;
        end

        // // Draw the grid lines
        // if (is_grid_line) begin
        //     red = 3'b111;   // White line
        //     green = 3'b111;
        //     blue = 3'b111;
        // end
    end

    // Counters for horizontal and vertical synchronization
    always @(posedge i_Clk) begin
        if (h_counter == H_TOTAL - 1) begin
            h_counter <= 0;
            if (v_counter == V_TOTAL - 1) begin
                v_counter <= 0;
            end else begin
                v_counter <= v_counter + 1;
            end
        end else begin
            h_counter <= h_counter + 1;
        end
    end

    // Horizontal and vertical sync signals
    assign hsync = (h_counter >= (H_DISPLAY + H_FRONT_PORCH) && h_counter < (H_DISPLAY + H_FRONT_PORCH + H_SYNC_PULSE));
    assign vsync = (v_counter >= (V_DISPLAY + V_FRONT_PORCH) && v_counter < (V_DISPLAY + V_FRONT_PORCH + V_SYNC_PULSE));

    // Seven-segment display connections
    assign o_Segment1_A = segment_data[0];
    assign o_Segment1_B = segment_data[1];
    assign o_Segment1_C = segment_data[2];
    assign o_Segment1_D = segment_data[3];
    assign o_Segment1_E = segment_data[4];
    assign o_Segment1_F = segment_data[5];
    assign o_Segment1_G = segment_data[6];

endmodule
