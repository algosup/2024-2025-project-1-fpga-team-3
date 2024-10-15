module car #(
    parameter CAR_START = 0,     // Starting X position (default 0)
    parameter CAR_SPEED = 24'd99,  // Speed control (larger number = slower)
    parameter CAR_DIRECTION = 1  // 0 = Left, 1 = Right (default Right)
) (
    input wire i_Clk,             // Clock signal
    output reg [4:0] o_car_x      // Output car X position (5 bits for grid size)
);

    // Internal register for car X position
    reg [4:0] car_x = CAR_START;  // Car's X position

    // Larger speed counter to control car movement spe4
    reg speed_counter = 1;  // Wider counter for larger range

always @(posedge i_Clk) begin
    if (speed_counter == 0) begin
        // Move the car and reset the speed counter
        speed_counter <= CAR_SPEED - 1;
        
        // Move the car based on direction
        if (CAR_DIRECTION == 1) begin
            if (car_x < 19)
                car_x <= car_x + 1;
            else
                car_x <= 0;
        end else begin
            if (car_x > 0)
                car_x <= car_x - 1;
            else
                car_x <= 19;
        end
    end else begin
        speed_counter <= speed_counter - 1;
    end

    // Update output
    o_car_x <= car_x;
end
endmodule
