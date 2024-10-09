module car (
    input wire i_Clk,
    input wire [9:0] h_position, // Current horizontal position of the car
    input wire [9:0] v_position, // Current vertical position of the car
    output reg [9:0] car_x,      // Output: car's x position
    output reg [2:0] red,        // Car color
    output reg [2:0] green,
    output reg [2:0] blue
);
    localparam CAR_WIDTH = 32;
    localparam CAR_HEIGHT = 32;

    // Initial car color (e.g., green)
    initial begin
        red = 3'b000;
        green = 3'b111;
        blue = 3'b000;
    end

    always @(posedge i_Clk) begin
        // Move the car to the left
        if (h_position == 640) begin
            car_x <= 0; // Reset to the left
        end else begin
            car_x <= h_position + 1; // Move car to the right
        end
    end

    // Determine if the current pixel is part of the car
    always @* begin
        if (car_x <= h_position && h_position < car_x + CAR_WIDTH &&
            v_position <= v_position && v_position < v_position + CAR_HEIGHT) begin
            red = 3'b000;
            green = 3'b111;
            blue = 3'b000; // Car color
        end else begin
            red = 3'b000;
            green = 3'b000;
            blue = 3'b000; // Background color
        end
    end

endmodule
