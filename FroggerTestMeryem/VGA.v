module vga_controller (
    input i_Clk,               // Clock input (Pin 15)
    output hsync,              // VGA hsync (Pin 26)
    output vsync,              // VGA vsync (Pin 27)
    output [9:0] pixel_x,      // Current pixel X position
    output [9:0] pixel_y,      // Current pixel Y position
    output display_area        // Active display area flag
);

    // VGA resolution parameters (640x480 display)
    parameter H_SYNC_CYCLES = 96;
    parameter H_BACK_PORCH = 48;
    parameter H_DISPLAY_TIME = 640;
    parameter H_FRONT_PORCH = 16;
    parameter H_TOTAL_TIME = H_SYNC_CYCLES + H_BACK_PORCH + H_DISPLAY_TIME + H_FRONT_PORCH;
    
    parameter V_SYNC_CYCLES = 2;
    parameter V_BACK_PORCH = 33;
    parameter V_DISPLAY_TIME = 480;
    parameter V_FRONT_PORCH = 10;
    parameter V_TOTAL_TIME = V_SYNC_CYCLES + V_BACK_PORCH + V_DISPLAY_TIME + V_FRONT_PORCH;

    reg [9:0] h_count = 0;  // Horizontal counter
    reg [9:0] v_count = 0;  // Vertical counter

    // Generating hsync and vsync signals
    always @(posedge i_Clk) begin
        if (h_count < H_TOTAL_TIME - 1)
            h_count <= h_count + 1;
        else begin
            h_count <= 0;
            if (v_count < V_TOTAL_TIME - 1)
                v_count <= v_count + 1;
            else
                v_count <= 0;
        end
    end

    // Horizontal and vertical sync signals
    assign hsync = (h_count < H_SYNC_CYCLES) ? 0 : 1;
    assign vsync = (v_count < V_SYNC_CYCLES) ? 0 : 1;

    // Pixel position within 640x480 display area
    assign display_area = (h_count >= (H_SYNC_CYCLES + H_BACK_PORCH)) && (h_count < (H_SYNC_CYCLES + H_BACK_PORCH + H_DISPLAY_TIME)) &&
                          (v_count >= (V_SYNC_CYCLES + V_BACK_PORCH)) && (v_count < (V_SYNC_CYCLES + V_BACK_PORCH + V_DISPLAY_TIME));
    
    assign pixel_x = h_count - (H_SYNC_CYCLES + H_BACK_PORCH);
    assign pixel_y = v_count - (V_SYNC_CYCLES + V_BACK_PORCH);

endmodule
