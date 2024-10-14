module car #(
    parameter CAR_START = 0,     // Starting X position (default 0)
    parameter CAR_SPEED = 24'd1000000,  // Speed control (larger number = slower)
    parameter CAR_DIRECTION = 1  // 0 = Left, 1 = Right (default Right)
) (
    input wire i_Clk,             // Clock signal
    output reg [4:0] o_car_x      // Output car X position (5 bits for grid size)
);

    // Internal register for car X position
    reg [4:0] car_x = CAR_START;  // Car's X position

    // Larger speed counter to control car movement spe4
    reg [21:0] speed_counter = 0;  // Wider counter for larger range

    // Car movement logic
    always @(posedge i_Clk) begin
        // Increment the speed counter
        if (speed_counter >= CAR_SPEED) begin
            speed_counter <= 0;

            // Move car based on direction
            if (CAR_DIRECTION == 1) begin
                // Move to the right
                if (car_x < 19)
                    car_x <= car_x + 1;  // Increment car X position (move one grid space)
                else
                    car_x <= 0;          // Wrap around to the left
            end else begin
                // Move to the left
                if (car_x > 0)
                    car_x <= car_x - 1;  // Decrement car X position (move one grid space)
                else
                    car_x <= 19;         // Wrap around to the right
            end
        end else begin
            speed_counter <= speed_counter + 1;  // Increment speed counter
        end

        // Update the output car X position inside the always block
        o_car_x <= car_x;
    end

endmodule
