module Frogger (
    input wire i_Clk,          // Clock input
    input wire i_Switch_1,     // Reset switch
    input wire i_Switch_2,     // Movement switch
    input wire i_Switch_3,
    input wire i_Switch_4,
    output reg [2:0] red,      // VGA red signal
    output reg [2:0] green,    // VGA green signal
    output reg [2:0] blue,     // VGA blue signal
    output reg hsync,          // VGA horizontal sync
    output reg vsync           // VGA vertical sync
);

    // Declare frog and car position wires
    wire [9:0] frog_x, frog_y; 
    wire [9:0] car1_x, car2_x, car3_x;

    // Instantiate frog movement (assuming frog_movement module is already defined)
    frog_movement frog_move_inst (
        .frog_x(frog_x),
        .frog_y(frog_y),
        .i_Switch_2,
        .i_Switch_3,
        .i_Switch_4,
        .i_Switch_1,
    );

    // Instantiate car movement modules (three cars in different lanes)
    car_movement car1 (
        .clk(i_Clk),
        .reset(i_Switch_1),     // Reset using switch
        .car_x(car1_x),
        .car_y(100)             // Car in lane 1
    );

    car_movement car2 (
        .clk(i_Clk),
        .reset(i_Switch_1),
        .car_x(car2_x),
        .car_y(200)             // Car in lane 2
    );

    car_movement car3 (
        .clk(i_Clk),
        .reset(i_Switch_1),
        .car_x(car3_x),
        .car_y(300)             // Car in lane 3
    );

    // VGA rendering logic
    always @(posedge i_Clk) begin
        // Example VGA rendering logic for cars and frog
        if ((current_x >= frog_x && current_x <= frog_x + 16) && (current_y >= frog_y && current_y <= frog_y + 16)) begin
            red <= 3'b000;       // Frog is green
            green <= 3'b111;
            blue <= 3'b000;
        end
        else if ((current_x >= car1_x && current_x <= car1_x + 32) && (current_y == 100)) begin
            red <= 3'b111;       // Car 1 (Red)
            green <= 3'b000;
            blue <= 3'b000;
        end
        else if ((current_x >= car2_x && current_x <= car2_x + 32) && (current_y == 200)) begin
            red <= 3'b111;       // Car 2 (Red)
            green <= 3'b000;
            blue <= 3'b000;
        end
        else if ((current_x >= car3_x && current_x <= car3_x + 32) && (current_y == 300)) begin
            red <= 3'b111;       // Car 3 (Red)
            green <= 3'b000;
            blue <= 3'b000;
        end
        else begin
            // Render background or other game objects
            red <= 3'b000;
            green <= 3'b000;
            blue <= 3'b000;
        end
    end

    // VGA sync logic (this block controls hsync, vsync, and pixel generation)
    // Assuming your VGA controller needs horizontal sync and vertical sync signals to be generated.
    // 640x480 @ 60Hz timing (25.175 MHz pixel clock):

    reg [9:0] current_x = 0; // Horizontal pixel position (0-639)
    reg [9:0] current_y = 0; // Vertical pixel position (0-479)

    // Horizontal timing constants
    parameter h_visible_area = 640; // Visible pixels
    parameter h_front_porch = 16;
    parameter h_sync_pulse = 96;
    parameter h_back_porch = 48;
    parameter h_total = h_visible_area + h_front_porch + h_sync_pulse + h_back_porch;

    // Vertical timing constants
    parameter v_visible_area = 480; // Visible lines
    parameter v_front_porch = 10;
    parameter v_sync_pulse = 2;
    parameter v_back_porch = 33;
    parameter v_total = v_visible_area + v_front_porch + v_sync_pulse + v_back_porch;

    always @(posedge i_Clk) begin
        // Horizontal Counter
        if (current_x < h_total - 1)
            current_x <= current_x + 1;
        else begin
            current_x <= 0;
            // Vertical Counter
            if (current_y < v_total - 1)
                current_y <= current_y + 1;
            else
                current_y <= 0;
        end

        // Generate hsync and vsync
        hsync <= (current_x >= h_visible_area + h_front_porch) && (current_x < h_visible_area + h_front_porch + h_sync_pulse);
        vsync <= (current_y >= v_visible_area + v_front_porch) && (current_y < v_visible_area + v_front_porch + v_sync_pulse);
    end

endmodule


