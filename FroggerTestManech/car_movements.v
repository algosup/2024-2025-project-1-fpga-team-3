module car_movement (
    input wire clk,           // Clock input
    input wire reset,         // Reset signal
    input wire [9:0] car_y,   // Car Y position (constant for each car)
    output reg [9:0] car_x    // Car X position (dynamic, moves from right to left)
);

    parameter SCREEN_WIDTH = 640; // Screen width in pixels
    parameter CAR_WIDTH = 32;     // Car width in pixels
    parameter CAR_SPEED = 1;      // Speed of car movement

    // Initialize car position
    initial begin
        car_x = SCREEN_WIDTH;  // Start from the right edge
    end

    // Update car position on every clock cycle
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset the car position to the right side of the screen
            car_x <= SCREEN_WIDTH;
        end else begin
            // Move the car to the left
            if (car_x > CAR_WIDTH)
                car_x <= car_x - CAR_SPEED;  // Move car left by CAR_SPEED pixels
            else
                car_x <= SCREEN_WIDTH;       // Reset to the right side when it moves off screen
        end
    end
endmodule
