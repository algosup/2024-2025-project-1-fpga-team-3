module top (
    input wire i_Clk,           // Clock signal
    input wire i_Switch_1,      // Button for moving left
    input wire i_Switch_2,      // Button for moving down
    input wire i_Switch_3,      // Button for moving up
    input wire i_Switch_4,      // Button for moving right
    output wire o_LED_1,        // LED output for switch 1
    output wire o_LED_2,        // LED output for switch 2
    output wire o_LED_3,        // LED output for switch 3
    output wire o_LED_4,        // LED output for switch 4
    output wire [2:0] o_VGA_Red,  // VGA Red signal
    output wire [2:0] o_VGA_Grn,  // VGA Green signal
    output wire [2:0] o_VGA_Blu,  // VGA Blue signal
    output wire o_VGA_HSync,      // VGA Horizontal sync
    output wire o_VGA_VSync,      // VGA Vertical sync
    output wire [6:0] o_Segment1, // 7-segment display for units place
    output wire [6:0] o_Segment2  // 7-segment display for tens place
);

    // Pack switches into a single bus
    wire [3:0] i_Switches = {i_Switch_4, i_Switch_3, i_Switch_2, i_Switch_1};

    // Debounced output signals
    wire [3:0] debounced_Switches;

    // Instantiate the shared debounce module
    Shared_Debounce debounce_inst (
        .i_Clk(i_Clk),
        .i_Switches(i_Switches),
        .o_Switches(debounced_Switches)
    );

    // Assign debounced signals to individual wires
    wire debounced_sw1 = debounced_Switches[0];
    wire debounced_sw2 = debounced_Switches[1];
    wire debounced_sw3 = debounced_Switches[2];
    wire debounced_sw4 = debounced_Switches[3];

    wire slow_clk;

    // Slow down the clock for the car movement
    clock_divider #(.DIV_FACTOR(24'd1000000)) clk_div_inst (
    .i_Clk(i_Clk),
    .o_Divided_Clk(slow_clk)
);

    // Car instantiations
    wire [4:0] car1_x, car2_x, car3_x, car4_x, car5_x;
    wire [4:0] car6_x, car7_x, car8_x, car9_x, car10_x, car11_x;
    wire [4:0] car12_x, car13_x, car14_x, car15_x, car16_x, car17_x;
    wire [4:0] car18_x, car19_x, car20_x, car21_x, car22_x, car23_x;
    wire [4:0] car24_x;
    wire [3:0] car1_y = 4'd2, car2_y = 4'd2, car3_y = 4'd3;
    wire [3:0] car4_y = 4'd4, car5_y = 4'd4, car6_y = 4'd5;
    wire [3:0] car7_y = 4'd6, car8_y = 4'd6, car9_y = 4'd8;
    wire [3:0] car10_y = 4'd9, car11_y = 4'd9, car12_y = 4'd10;
    wire [3:0] car13_y = 4'd11, car14_y = 4'd11, car15_y = 4'd12;
    wire [3:0] car16_y = 4'd13, car17_y = 4'd13, car18_y = 4'd13;
    wire [3:0] car19_y = 4'd4, car20_y = 4'd4, car21_y = 4'd5;
    wire [3:0] car22_y = 4'd6, car23_y = 4'd8, car24_y = 4'd9;

car #(.CAR_START(1), .CAR_SPEED(24'd2500), .CAR_DIRECTION(1)) car1_inst (
    .i_Clk(slow_clk),
    .o_car_x(car1_x)
);

car #(.CAR_START(2), .CAR_SPEED(24'd2500), .CAR_DIRECTION(1)) car2_inst (
    .i_Clk(slow_clk),
    .o_car_x(car2_x)
);

car #(.CAR_START(3), .CAR_SPEED(24'd2500), .CAR_DIRECTION(1)) car3_inst (
    .i_Clk(slow_clk),
    .o_car_x(car3_x)
);

car #(.CAR_START(4), .CAR_SPEED(24'd2500), .CAR_DIRECTION(1)) car4_inst (
    .i_Clk(slow_clk),
    .o_car_x(car4_x)
);

car #(.CAR_START(5), .CAR_SPEED(24'd2500), .CAR_DIRECTION(1)) car5_inst (
    .i_Clk(slow_clk),
    .o_car_x(car5_x)
);

car #(.CAR_START(6), .CAR_SPEED(24'd2500), .CAR_DIRECTION(0)) car6_inst (
    .i_Clk(slow_clk),
    .o_car_x(car6_x)
);

car #(.CAR_START(7), .CAR_SPEED(24'd2500), .CAR_DIRECTION(0)) car7_inst (
    .i_Clk(slow_clk),
    .o_car_x(car7_x)
);

car #(.CAR_START(8), .CAR_SPEED(24'd2500), .CAR_DIRECTION(0)) car8_inst (
    .i_Clk(slow_clk),
    .o_car_x(car8_x)
);

car #(.CAR_START(9), .CAR_SPEED(24'd2500), .CAR_DIRECTION(1)) car9_inst (
    .i_Clk(slow_clk),
    .o_car_x(car9_x)
);

car #(.CAR_START(10), .CAR_SPEED(24'd2500), .CAR_DIRECTION(1)) car10_inst (
    .i_Clk(slow_clk),
    .o_car_x(car10_x)
);

car #(.CAR_START(11), .CAR_SPEED(24'd2500), .CAR_DIRECTION(0)) car11_inst (
    .i_Clk(slow_clk),
    .o_car_x(car11_x)
);

car #(.CAR_START(12), .CAR_SPEED(24'd2500), .CAR_DIRECTION(0)) car12_inst (
    .i_Clk(slow_clk),
    .o_car_x(car12_x)
);

car #(.CAR_START(13), .CAR_SPEED(24'd2500), .CAR_DIRECTION(1)) car13_inst (
    .i_Clk(slow_clk),
    .o_car_x(car13_x)
);

car #(.CAR_START(14), .CAR_SPEED(24'd2500), .CAR_DIRECTION(1)) car14_inst (
    .i_Clk(slow_clk),
    .o_car_x(car14_x)
);

car #(.CAR_START(15), .CAR_SPEED(24'd2500), .CAR_DIRECTION(1)) car15_inst (
    .i_Clk(slow_clk),
    .o_car_x(car15_x)
);

car #(.CAR_START(16), .CAR_SPEED(24'd2500), .CAR_DIRECTION(0)) car16_inst (
    .i_Clk(slow_clk),
    .o_car_x(car16_x)
);

car #(.CAR_START(17), .CAR_SPEED(24'd2500), .CAR_DIRECTION(0)) car17_inst (
    .i_Clk(slow_clk),
    .o_car_x(car17_x)
);

car #(.CAR_START(18), .CAR_SPEED(24'd2500), .CAR_DIRECTION(0)) car18_inst (
    .i_Clk(slow_clk),
    .o_car_x(car18_x)
);

car #(.CAR_START(19), .CAR_SPEED(24'd2500), .CAR_DIRECTION(1)) car19_inst (
    .i_Clk(slow_clk),
    .o_car_x(car19_x)
);

car #(.CAR_START(20), .CAR_SPEED(24'd2500), .CAR_DIRECTION(1)) car20_inst (
    .i_Clk(slow_clk),
    .o_car_x(car20_x)
);

car #(.CAR_START(21), .CAR_SPEED(24'd2500), .CAR_DIRECTION(0)) car21_inst (
    .i_Clk(slow_clk),
    .o_car_x(car21_x)
);

car #(.CAR_START(22), .CAR_SPEED(24'd2500), .CAR_DIRECTION(0)) car22_inst (
    .i_Clk(slow_clk),
    .o_car_x(car22_x)
);

car #(.CAR_START(23), .CAR_SPEED(24'd2500), .CAR_DIRECTION(1)) car23_inst (
    .i_Clk(slow_clk),
    .o_car_x(car23_x)
);

car #(.CAR_START(24), .CAR_SPEED(24'd2500), .CAR_DIRECTION(1)) car24_inst (
    .i_Clk(slow_clk),
    .o_car_x(car24_x)
);


    // Frog position in terms of grid coordinates
    wire [4:0] frog_col;
    wire [3:0] frog_row;
    wire frog_at_top;  // Signal when the frog reaches the top of the grid
    wire reset_frog;   // Signal to reset frog to its initial position
    wire collision_detected;  // Collision signal

    // Instantiate the frog_display module
    frog_display frog_inst (
        .clk(i_Clk),
        .debounced_sw1(debounced_sw1),
        .debounced_sw2(debounced_sw2),
        .debounced_sw3(debounced_sw3),
        .debounced_sw4(debounced_sw4),
        .reset_frog(reset_frog),
        .car1_x(car1_x), .car1_y(car1_y),
        .car2_x(car2_x), .car2_y(car2_y),
        .car3_x(car3_x), .car3_y(car3_y),
        .car4_x(car4_x), .car4_y(car4_y),
        .car5_x(car5_x), .car5_y(car5_y),
        .car6_x(car6_x), .car6_y(car6_y),
        .car7_x(car7_x), .car7_y(car7_y),
        .car8_x(car8_x), .car8_y(car8_y),
        .car9_x(car9_x), .car9_y(car9_y),
        .car10_x(car10_x), .car10_y(car10_y),
        .car11_x(car11_x), .car11_y(car11_y),
        .car12_x(car12_x), .car12_y(car12_y),
        .car13_x(car13_x), .car13_y(car13_y),
        .car14_x(car14_x), .car14_y(car14_y),
        .car15_x(car15_x), .car15_y(car15_y),
        .car16_x(car16_x), .car16_y(car16_y),
        .car17_x(car17_x), .car17_y(car17_y),
        .car18_x(car18_x), .car18_y(car18_y),
        .car19_x(car19_x), .car19_y(car19_y),
        .car20_x(car20_x), .car20_y(car20_y),
        .car21_x(car21_x), .car21_y(car21_y),
        .car22_x(car22_x), .car22_y(car22_y),
        .car23_x(car23_x), .car23_y(car23_y),
        .car24_x(car24_x), .car24_y(car24_y),
        .frog_col(frog_col),
        .frog_row(frog_row),
        .frog_at_top(frog_at_top),
        .collision_detected(collision_detected)  // Collision output
    );

    // Use collision_detected signal to reset both frog and level
    wire [3:0] current_level;

    // Define the reset_level signal
    wire reset_level = collision_detected || (debounced_sw1 && debounced_sw2 && debounced_sw3 && debounced_sw4);

    // Level counter to track and display the current level
    level_counter level_inst (
        .clk(i_Clk),
        .reset_level(reset_level),  // Reset level on collision or manual reset
        .frog_at_top(frog_at_top),
        .level(current_level),
        .reset_frog(reset_frog),    // Output signal to reset frog
        .o_Segment1(o_Segment1),    // 7-segment display (units)
        .o_Segment2(o_Segment2)     // 7-segment display (tens)
    );

    // Instantiate the VGA display logic to render the frog and cars
    vga_display vga_inst (
        .clk(i_Clk),
        .frog_col(frog_col),
        .frog_row(frog_row),
        .car1_x(car1_x),
        .car1_y(car1_y),
        .car2_x(car2_x),
        .car2_y(car2_y),
        .car3_x(car3_x),
        .car3_y(car3_y),
        .car4_x(car4_x),
        .car4_y(car4_y),
        .car5_x(car5_x),
        .car5_y(car5_y),
        .car6_x(car6_x),
        .car6_y(car6_y),
        .car7_x(car7_x),
        .car7_y(car7_y),
        .car8_x(car8_x),
        .car8_y(car8_y),
        .car9_x(car9_x),
        .car9_y(car9_y),
        .car10_x(car10_x),
        .car10_y(car10_y),
        .car11_x(car11_x),
        .car11_y(car11_y),
        .car12_x(car12_x),
        .car12_y(car12_y),
        .car13_x(car13_x),
        .car13_y(car13_y),
        .car14_x(car14_x),
        .car14_y(car14_y),
        .car15_x(car15_x),
        .car15_y(car15_y),
        .car16_x(car16_x),
        .car16_y(car16_y),
        .car17_x(car17_x),
        .car17_y(car17_y),
        .car18_x(car18_x),
        .car18_y(car18_y),
        .car19_x(car19_x),
        .car19_y(car19_y),
        .car20_x(car20_x),
        .car20_y(car20_y),
        .car21_x(car21_x),
        .car21_y(car21_y),
        .car22_x(car22_x),
        .car22_y(car22_y),
        .car23_x(car23_x),
        .car23_y(car23_y),
        .car24_x(car24_x),
        .car24_y(car24_y),
        .vga_r(o_VGA_Red),
        .vga_g(o_VGA_Grn),
        .vga_b(o_VGA_Blu),
        .vga_hs(o_VGA_HSync),
        .vga_vs(o_VGA_VSync)
    );

assign o_LED_1 = debounced_sw1;
assign o_LED_2 = debounced_sw2;
assign o_LED_3 = debounced_sw3;
assign o_LED_4 = debounced_sw4;
endmodule
