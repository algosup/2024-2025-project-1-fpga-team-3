module FroggerTop (
    input i_Clk,           // 25 MHz clock for VGA
    // input reset,         // Reset button
    input i_Switch_3,       // Button for moving up
    input i_Switch_2,     // Button for moving down
    input i_Switch_1,     // Button for moving left
    input i_Switch_4,    // Button for moving right
    output hsync,        // VGA horizontal sync
    output vsync,        // VGA vertical sync
    output [2:0] red,    // VGA red color channel
    output [2:0] green,  // VGA green color channel
    output [2:0] blue    // VGA blue color channel
);

    // Declare signals for frog position
    wire [9:0] frog_x;
    wire [9:0] frog_y;

    // Instantiate the frog movement module
    FrogMovement frog_movement_inst (
        .i_Clk(clk),
        // .reset(reset),
        .i_Switch_3(move_up),
        .i_Switch_2(move_down),
        .i_Switch_1(move_left),
        .i_Switch_4(move_right),
        .frog_x(frog_x),
        .frog_y(frog_y)
    );

    // Instantiate the VGA controller module
    VGA_Controller vga_controller_inst (
        .i_Clk(clk),
        .hsync(hsync),
        .vsync(vsync),
        .red(red),
        .green(green),
        .blue(blue),
        .frog_x(frog_x),   // Pass the frog's X position to the VGA controller
        .frog_y(frog_y)    // Pass the frog's Y position to the VGA controller
    );

endmodule
