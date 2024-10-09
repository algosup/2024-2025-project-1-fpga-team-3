module screen_divider(
    input wire [9:0] x,          // current pixel x-coordinate (0-639)
    input wire [8:0] y,          // current pixel y-coordinate (0-479)
    output reg [4:0] col,        // column index (0-19)
    output reg [3:0] row         // row index (0-14)
);

// Parameters for the size of each square
parameter SQUARE_WIDTH = 32;
parameter SQUARE_HEIGHT = 32;

always @(*) begin
    // Calculate the column index based on the x-coordinate
    col = x / SQUARE_WIDTH;

    // Calculate the row index based on the y-coordinate
    row = y / SQUARE_HEIGHT;
end

endmodule