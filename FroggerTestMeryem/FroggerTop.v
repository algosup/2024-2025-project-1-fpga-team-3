module frogger_game (
    input i_Clk,               // Clock input
    input i_Switch_1,          // Move left
    input i_Switch_2,          // Move down
    input i_Switch_3,          // Move up
    input i_Switch_4,          // Move right
    output hsync,              // VGA hsync
    output vsync,              // VGA vsync
    output [2:0] red,          // Red VGA signal
    output [2:0] green,        // Green VGA signal
    output [2:0] blue,         // Blue VGA signal
    output [6:0] o_Segment1,   // First 7-segment display (pins 3, 4, 93, 91, 90, 1, 2)
    output [6:0] o_Segment2    // Second 7-segment display (pins 100, 99, 97, 95, 94, 8, 96)
);

    wire [9:0] pixel_x;        // Pixel X position from VGA controller
    wire [9:0] pixel_y;        // Pixel Y position from VGA controller
    wire display_area;         // Active display area flag
    wire [6:0] level;          // Current level (0-9)

    // Debounced signals for each switch
    wire debounced_switch_1;
    wire debounced_switch_2;
    wire debounced_switch_3;
    wire debounced_switch_4;

    // Instantiate debouncers for each switch
    debounce debounce_switch_1 (
        .i_Clk(i_Clk),
        .i_Switch(i_Switch_1),
        .o_Switch(debounced_switch_1)
    );

    debounce debounce_switch_2 (
        .i_Clk(i_Clk),
        .i_Switch(i_Switch_2),
        .o_Switch(debounced_switch_2)
    );

    debounce debounce_switch_3 (
        .i_Clk(i_Clk),
        .i_Switch(i_Switch_3),
        .o_Switch(debounced_switch_3)
    );

    debounce debounce_switch_4 (
        .i_Clk(i_Clk),
        .i_Switch(i_Switch_4),
        .o_Switch(debounced_switch_4)
    );

    // Instantiate the VGA controller
    vga_controller vga_inst (
        .i_Clk(i_Clk),
        .hsync(hsync),
        .vsync(vsync),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .display_area(display_area)
    );

    // Instantiate the frog display logic with movement and debounced inputs
    frog_display frog_inst (
        .i_Clk(i_Clk),
        .i_Switch_1(debounced_switch_1),  // Pass the debounced signals
        .i_Switch_2(debounced_switch_2),
        .i_Switch_3(debounced_switch_3),
        .i_Switch_4(debounced_switch_4),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .display_area(display_area),
        .red(red),
        .green(green),
        .blue(blue),
        .level(level)
    );

    // Instantiate the 7-segment display logic
    seven_segment_display segment_inst (
        .level(level),
        .o_Segment1(o_Segment1),
        .o_Segment2(o_Segment2)
    );

    
    

endmodule
