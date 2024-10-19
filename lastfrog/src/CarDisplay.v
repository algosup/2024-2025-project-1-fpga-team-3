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
    reg [5:0] speed_counter;

    // Define adjusted speed
    reg [23:0] adjusted_speed;

    // Calculate the adjusted speed based on the current level
    always @(*) begin
        case (level)
            1: adjusted_speed = BASE_SPEED;             // Level 1: 100% speed (starting level)
            2: adjusted_speed = BASE_SPEED * 995 / 1000;  // Level 2: 99.5% of BASE_SPEED
            3: adjusted_speed = BASE_SPEED * 990 / 1000;  // Level 3: 99% of BASE_SPEED
            4: adjusted_speed = BASE_SPEED * 985 / 1000;  // Level 4: 98.5% of BASE_SPEED
            5: adjusted_speed = BASE_SPEED * 980 / 1000;  // Level 5: 98% of BASE_SPEED
            6: adjusted_speed = BASE_SPEED * 975 / 1000;  // Level 6: 97.5% of BASE_SPEED
            7: adjusted_speed = BASE_SPEED * 970 / 1000;  // Level 7: 97% of BASE_SPEED
            8: adjusted_speed = BASE_SPEED * 965 / 1000;  // Level 8: 96.5% of BASE_SPEED
            9: adjusted_speed = BASE_SPEED * 960 / 1000;  // Level 9: 96% of BASE_SPEED
            10: adjusted_speed = BASE_SPEED * 955 / 1000; // Level 10: 95.5% of BASE_SPEED
            11: adjusted_speed = BASE_SPEED * 950 / 1000; // Level 11: 95% of BASE_SPEED
            12: adjusted_speed = BASE_SPEED * 945 / 1000; // Level 12: 94.5% of BASE_SPEED
            13: adjusted_speed = BASE_SPEED * 940 / 1000; // Level 13: 94% of BASE_SPEED
            14: adjusted_speed = BASE_SPEED * 938 / 1000; // Level 14: 93.5% of BASE_SPEED
            15: adjusted_speed = BASE_SPEED * 937 / 1000; // Level 15: 93% of BASE_SPEED
            16: adjusted_speed = BASE_SPEED * 936 / 1000; // Level 16: 92.5% of BASE_SPEED
            17: adjusted_speed = BASE_SPEED * 935 / 1000; // Level 17: 92% of BASE_SPEED
            18: adjusted_speed = BASE_SPEED * 934 / 1000; // Level 18: 91.5% of BASE_SPEED
            19: adjusted_speed = BASE_SPEED * 933 / 1000; // Level 19: 91% of BASE_SPEED
            20: adjusted_speed = BASE_SPEED * 932 / 1000; // Level 20: 90.5% of BASE_SPEED
            21: adjusted_speed = BASE_SPEED * 931 / 1000; // Level 21: 90% of BASE_SPEED
            22: adjusted_speed = BASE_SPEED * 930 / 1000; // Level 22: 89.5% of BASE_SPEED
            23: adjusted_speed = BASE_SPEED * 929 / 1000; // Level 23: 89% of BASE_SPEED
            24: adjusted_speed = BASE_SPEED * 928 / 1000; // Level 24: 88.5% of BASE_SPEED
            25: adjusted_speed = BASE_SPEED * 927 / 1000; // Level 25: 88% of BASE_SPEED
            26: adjusted_speed = BASE_SPEED * 926 / 1000; // Level 26: 87.5% of BASE_SPEED
            27: adjusted_speed = BASE_SPEED * 925 / 1000; // Level 27: 87% of BASE_SPEED
            28: adjusted_speed = BASE_SPEED * 924 / 1000; // Level 28: 86.5% of BASE_SPEED
            29: adjusted_speed = BASE_SPEED * 923 / 1000; // Level 29: 86% of BASE_SPEED
            30: adjusted_speed = BASE_SPEED * 922 / 1000; // Level 30: 85.5% of BASE_SPEED
            31: adjusted_speed = BASE_SPEED * 921 / 1000; // Level 31: 85% of BASE_SPEED
            32: adjusted_speed = BASE_SPEED * 920 / 1000; // Level 32: 84.5% of BASE_SPEED
            33: adjusted_speed = BASE_SPEED * 919 / 1000; // Level 33: 84% of BASE_SPEED
            34: adjusted_speed = BASE_SPEED * 918 / 1000; // Level 34: 83.5% of BASE_SPEED
            35: adjusted_speed = BASE_SPEED * 917 / 1000; // Level 35: 83% of BASE_SPEED
            36: adjusted_speed = BASE_SPEED * 916 / 1000; // Level 36: 82.5% of BASE_SPEED
            37: adjusted_speed = BASE_SPEED * 915 / 1000; // Level 37: 82% of BASE_SPEED
            38: adjusted_speed = BASE_SPEED * 914 / 1000; // Level 38: 81.5% of BASE_SPEED
            39: adjusted_speed = BASE_SPEED * 913 / 1000; // Level 39: 81% of BASE_SPEED
            40: adjusted_speed = BASE_SPEED * 912 / 1000; // Level 40: 80.5% of BASE_SPEED
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
