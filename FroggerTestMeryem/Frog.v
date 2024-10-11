module frog_display (
    input i_Clk,               // Clock input
    input i_Switch_1,          // Move left
    input i_Switch_2,          // Move down
    input i_Switch_3,          // Move up
    input i_Switch_4,          // Move right
    input [9:0] pixel_x,       // Pixel X position from VGA controller
    input [9:0] pixel_y,       // Pixel Y position from VGA controller
    input display_area,        // Active display area flag
    output reg [2:0] red,      // Red VGA signal
    output reg [2:0] green,    // Green VGA signal
    output reg [2:0] blue,     // Blue VGA signal
    output reg [6:0] level     // Current level, displayed as a 4-bit number
);

    // Initial frog position
    reg [4:0] frog_x = 10;  // Frog's X position in grid (0 to 19)
    reg [3:0] frog_y = 14;  // Frog's Y position in grid (0 to 14)

    // Car positions (manual instantiation)
    wire [4:0] car1_x, car2_x, car3_x, car4_x;

    // Registers to store the previous state of switches (for edge detection)
    reg switch_1_last = 0;
    reg switch_2_last = 0;
    reg switch_3_last = 0;
    reg switch_4_last = 0;

    // Level logic
    initial level = 1;  // Start at level 1

    // Instantiating each car manually
    car car1_inst (
        .i_Clk(i_Clk),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .display_area(display_area),
        .car_y(7),            // Car at Y position 7
        .car_direction(0),     // Left to right
        .car_x(car1_x)
    );

    car car2_inst (
        .i_Clk(i_Clk),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .display_area(display_area),
        .car_y(4),            // Car at Y position 4
        .car_direction(1),     // Right to left
        .car_x(car2_x)
    );

    car car3_inst (
        .i_Clk(i_Clk),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .display_area(display_area),
        .car_y(2),            // Car at Y position 2
        .car_direction(0),     // Left to right
        .car_x(car3_x)
    );

    car car4_inst (
        .i_Clk(i_Clk),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .display_area(display_area),
        .car_y(10),            // Car at Y position 10
        .car_direction(1),      // Right to left
        .car_x(car4_x)
    );

    // Movement logic based on switch inputs
    always @(posedge i_Clk) begin
        // Increment level if frog reaches Y = -1
        if (frog_y == 4'b1111) begin
            frog_x <= 10;  // Reset to the middle bottom
            frog_y <= 14;
            if (level < 99) // Ensure level does not exceed 99
                level <= level + 1;  // Increment level
        end
        // Optimized collision detection logic: check if frog hits any car
        else if ((frog_x == car1_x && frog_y == 7) ||
                 (frog_x == car2_x && frog_y == 4) ||
                 (frog_x == car3_x && frog_y == 2) ||
                 (frog_x == car4_x && frog_y == 10)) begin
            frog_x <= 10;  // Reset to the middle bottom
            frog_y <= 14;
            level <= 1;  // Reset level to 1
        end
        else begin
            // Detect rising edges (button press)
            if (i_Switch_1 && !switch_1_last && frog_x > 0) begin
                frog_x <= frog_x - 1;  // Move left
            end
            else if (i_Switch_2 && !switch_2_last && frog_y < 14) begin
                frog_y <= frog_y + 1;  // Move down
            end
            else if (i_Switch_3 && !switch_3_last) begin
                if (frog_y > 0) begin
                    frog_y <= frog_y - 1;  // Move up
                end
                else begin
                    frog_y <= 4'b1111;  // Move to Y = -1 (out of grid)
                end
            end
            else if (i_Switch_4 && !switch_4_last && frog_x < 19) begin
                frog_x <= frog_x + 1;  // Move right
            end
        end

        // Store current switch state for edge detection in the next clock cycle
        switch_1_last <= i_Switch_1;
        switch_2_last <= i_Switch_2;
        switch_3_last <= i_Switch_3;
        switch_4_last <= i_Switch_4;
    end

    // Default color (black)
    reg [2:0] color_red = 3'b000;
    reg [2:0] color_green = 3'b000;
    reg [2:0] color_blue = 3'b000;

    // Draw the frog based on its position in the grid and apply car colors
    always @(posedge i_Clk) begin
        if (display_area) begin
            // Draw the frog as a green square at the current frog_x and frog_y position
            if ((pixel_x >= frog_x * 32) && (pixel_x < (frog_x + 1) * 32) &&
                (pixel_y >= frog_y * 32) && (pixel_y < (frog_y + 1) * 32)) begin
                color_red = 3'b000;   // No red
                color_green = 3'b111; // Full green (green frog)
                color_blue = 3'b000;  // No blue
            end
            else if ((pixel_x % 32 == 0) || (pixel_x % 32 == 31) || 
                     (pixel_y % 32 == 0) || (pixel_y % 32 == 31)) begin
                color_red = 3'b111;  // White border
                color_green = 3'b111;
                color_blue = 3'b111;
            end
            // Else, check for car positions and use the car color
            else if (((pixel_x >= car1_x * 32) && (pixel_x < (car1_x + 1) * 32) &&
                      (pixel_y >= 7 * 32) && (pixel_y < (7 + 1) * 32)) ||
                     ((pixel_x >= car2_x * 32) && (pixel_x < (car2_x + 1) * 32) &&
                      (pixel_y >= 4 * 32) && (pixel_y < (4 + 1) * 32)) ||
                     ((pixel_x >= car3_x * 32) && (pixel_x < (car3_x + 1) * 32) &&
                      (pixel_y >= 2 * 32) && (pixel_y < (2 + 1) * 32)) ||
                     ((pixel_x >= car4_x * 32) && (pixel_x < (car4_x + 1) * 32) &&
                      (pixel_y >= 10 * 32) && (pixel_y < (10 + 1) * 32))) begin
                color_red = 3'b111;   // Full red (same color for all cars)
                color_green = 3'b000; // No green
                color_blue = 3'b000;  // No blue
            end
            else begin
                color_red = 3'b000;
                color_green = 3'b000;
                color_blue = 3'b000;  // Black background
            end
        end else begin
            // Outside the display area
            color_red = 3'b000;
            color_green = 3'b000;
            color_blue = 3'b000;
        end
    end

    // Assign the output colors
    assign red = color_red;
    assign green = color_green;
    assign blue = color_blue;

endmodule
