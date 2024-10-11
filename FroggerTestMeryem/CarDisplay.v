module car (
    input i_Clk,               // Clock input
    input [9:0] pixel_x,       // Pixel X position from VGA controller
    input [9:0] pixel_y,       // Pixel Y position from VGA controller
    input display_area,        // Active display area flag
    input [4:0] car_y,         // Car's Y position (0 to 14)
    input car_direction,       // 0 = left to right, 1 = right to left
    output reg [4:0] car_x,    // Car's X position (0 to 19)
    output reg [2:0] red,      // Red VGA signal (for the car)
    output reg [2:0] green,    // Green VGA signal (for the car)
    output reg [2:0] blue      // Blue VGA signal (for the car)
);

    reg [23:0] car_counter = 0;  // Counter to control car speed
    parameter CAR_SPEED = 24'd5000000;  // Speed of the car

    // Car movement logic
    always @(posedge i_Clk) begin
        car_counter <= car_counter + 1;
        if (car_counter >= CAR_SPEED) begin
            car_counter <= 0;
            if (car_direction == 0) begin
                // Move left to right
                if (car_x < 19) begin
                    car_x <= car_x + 1;
                end else begin
                    car_x <= 0;  // Wrap car to the left side of the grid
                end
            end else begin
                // Move right to left
                if (car_x > 0) begin
                    car_x <= car_x - 1;
                end else begin
                    car_x <= 19;  // Wrap car to the right side of the grid
                end
            end
        end
    end

    // Draw the car at its current position
    always @(posedge i_Clk) begin
        if (display_area) begin
            // Draw the car in red at its current position
            if ((pixel_x >= car_x * 32) && (pixel_x < (car_x + 1) * 32) &&
                (pixel_y >= car_y * 32) && (pixel_y < (car_y + 1) * 32)) begin
                red <= 3'b111;   // Full red (red car)
                green <= 3'b000; // No green
                blue <= 3'b000;  // No blue
            end else begin
                red <= 3'b000;  // No car, black background
                green <= 3'b000;
                blue <= 3'b000;
            end
        end else begin
            red <= 3'b000;
            green <= 3'b000;
            blue <= 3'b000;
        end
    end

endmodule
