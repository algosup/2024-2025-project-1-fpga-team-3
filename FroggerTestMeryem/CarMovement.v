module car_movement (
    input wire i_Clk,
    input wire [9:0] h_display,      // Horizontal display size
    output reg [9:0] car_x,          // Car's x position
    input wire [23:0] speed_divisor, // Speed divisor for this car
    input wire [9:0] initial_position // Initial position for the car
);

    reg [23:0] speed_counter = 0;  // Counter for speed control
    reg initialized = 0;  // Flag to indicate if initial position is set

    // Control car movement
    always @(posedge i_Clk) begin
        // Set initial position once
        if (!initialized) begin
            car_x <= initial_position; // Set the initial position
            initialized <= 1;          // Mark as initialized
        end
        
        // Handle car movement
        speed_counter <= speed_counter + 1;
        if (speed_counter >= speed_divisor) begin
            speed_counter <= 0; // Reset counter
            // Move the car to the right
            if (car_x >= h_display) begin
                car_x <= 0; // Reset to the left
            end else begin
                car_x <= car_x + 1; // Move car to the right
            end
        end
    end
endmodule
