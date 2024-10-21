module car #(
    parameter CAR_START = 0,          // Starting X position (default 0)
    parameter BASE_SPEED = 24'd1000,  // Base speed control (initial speed)
    parameter CAR_DIRECTION = 1       // 0 = Left, 1 = Right (default Right)
) (
    input wire i_Clk,                 // Slower clock signal from clock divider
    input wire [3:0] level,           // Current level (speed factor)
    output reg [4:0] o_car_x          // Output car X position (5 bits for grid size)
);

    // Internal register for car X position
    reg [4:0] car_x = CAR_START;      // Car's X position

    // Speed counter with 9 bits to control the speed more efficiently
    reg [2:0] speed_counter;

    // Define adjusted speed
    reg [19:0] adjusted_speed;

    // Calculate the adjusted speed based on the current level
    always @(*) begin
        case (level)
            1: adjusted_speed = BASE_SPEED;             // Level 1: 100% speed (starting level)
            2: adjusted_speed = BASE_SPEED - 1;  // Level 2: 99.5% of BASE_SPEED
            3: adjusted_speed = BASE_SPEED - 2;  // Level 3: 99% of BASE_SPEED
            4: adjusted_speed = BASE_SPEED - 3;  // Level 4: 98.5% of BASE_SPEED
            5: adjusted_speed = BASE_SPEED - 4;  // Level 5: 98% of BASE_SPEED
            6: adjusted_speed = BASE_SPEED - 5;  // Level 6: 97.5% of BASE_SPEED
            7: adjusted_speed = BASE_SPEED - 6;  // Level 7: 97% of BASE_SPEED
            8: adjusted_speed = BASE_SPEED - 7;  // Level 8: 96.5% of BASE_SPEED
            9: adjusted_speed = BASE_SPEED - 8;  // Level 9: 96% of BASE_SPEED
            10: adjusted_speed = BASE_SPEED - 9; // Level 10: 95.5% of BASE_SPEED
            11: adjusted_speed = BASE_SPEED - 10; // Level 11: 95% of BASE_SPEED
            12: adjusted_speed = BASE_SPEED - 11; // Level 12: 94.5% of BASE_SPEED
            13: adjusted_speed = BASE_SPEED - 12; // Level 13: 94% of BASE_SPEED
            14: adjusted_speed = BASE_SPEED - 13; // Level 14: 93.5% of BASE_SPEED
            15: adjusted_speed = BASE_SPEED - 15; // Level 15: 93% of BASE_SPEED
            default: adjusted_speed = BASE_SPEED;       // Default case if level is out of range
        endcase
    end

    always @(posedge i_Clk) begin
        if (speed_counter == 0) begin
            // Move the car and reset the speed counter
            speed_counter <= adjusted_speed[6:2];  // Use the top 5 bits of adjusted_speed to reset the counter

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
