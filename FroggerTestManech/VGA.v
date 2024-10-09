module vga_display(
    input wire i_Clk,            // Clock input (mapped to i_Clk, pin 15)
    output wire hsync,           // Horizontal sync output (mapped to pin 26)
    output wire vsync,           // Vertical sync output (mapped to pin 27)
    output reg [2:0] red,        // Red output (mapped to pins 36, 37, 40)
    output reg [2:0] green,      // Green output (mapped to pins 29, 30, 33)
    output reg [2:0] blue        // Blue output (mapped to pins 28, 41, 42)
);

// VGA timing parameters for 640x480 resolution @ 60Hz
localparam H_DISPLAY = 640;   // Horizontal display area
localparam H_FRONT_PORCH = 16;
localparam H_SYNC_PULSE = 96;
localparam H_BACK_PORCH = 48;
localparam H_TOTAL = 800;

localparam V_DISPLAY = 480;   // Vertical display area
localparam V_FRONT_PORCH = 10;
localparam V_SYNC_PULSE = 2;
localparam V_BACK_PORCH = 33;
localparam V_TOTAL = 525;

// Pixel counters
reg [9:0] h_counter = 0; // Horizontal pixel counter
reg [9:0] v_counter = 0; // Vertical pixel counter

// Generate sync signals
assign hsync = (h_counter < (H_DISPLAY + H_FRONT_PORCH)) || (h_counter >= (H_DISPLAY + H_FRONT_PORCH + H_SYNC_PULSE));
assign vsync = (v_counter < (V_DISPLAY + V_FRONT_PORCH)) || (v_counter >= (V_DISPLAY + V_FRONT_PORCH + V_SYNC_PULSE));

// Increment pixel counters
always @(posedge i_Clk) begin
    if (h_counter == H_TOTAL - 1) begin
        h_counter <= 0;
        if (v_counter == V_TOTAL - 1)
            v_counter <= 0;
        else
            v_counter <= v_counter + 1;
    end else begin
        h_counter <= h_counter + 1;
    end
end

// VGA Cell parameters (32x32 pixels, 15x20 grid)
localparam CELL_SIZE = 32;    // Size of each cell (32x32)
localparam EDGE_SIZE = 1;     // Thickness of the cell borders (in pixels)
localparam GRID_COLS = 20;    // Number of columns
localparam GRID_ROWS = 15;    // Number of rows

// Calculate the current cell position
wire [9:0] h_cell = h_counter % CELL_SIZE;
wire [9:0] v_cell = v_counter % CELL_SIZE;

// Determine if the current pixel is on the edge of a cell
wire on_cell_edge;
assign on_cell_edge = (h_counter < H_DISPLAY) && (v_counter < V_DISPLAY) &&
                      (h_cell < EDGE_SIZE || h_cell >= (CELL_SIZE - EDGE_SIZE) || 
                       v_cell < EDGE_SIZE || v_cell >= (CELL_SIZE - EDGE_SIZE));

// Output white on cell edges, otherwise black
always @(posedge i_Clk) begin
    if (on_cell_edge) begin
        red <= 3'b111;   // White color (full RGB)
        green <= 3'b111;
        blue <= 3'b111;
    end else begin
        red <= 3'b000;   // Black background
        green <= 3'b000;
        blue <= 3'b000;
    end
end

endmodule
