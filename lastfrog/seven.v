module segment_display (
    input wire [3:0] digit,   // 4-bit input for the digit (0-9)
    output reg [6:0] o_Segment
);

    always @(*) begin
        case (digit)
            4'd0: o_Segment = 7'b1000000;
            4'd1: o_Segment = 7'b1111001;
            4'd2: o_Segment = 7'b0100100;
            4'd3: o_Segment = 7'b0110000;
            4'd4: o_Segment = 7'b0011001;
            4'd5: o_Segment = 7'b0010010;
            4'd6: o_Segment = 7'b0000010;
            4'd7: o_Segment = 7'b1111000;
            4'd8: o_Segment = 7'b0000000;
            4'd9: o_Segment = 7'b0010000;
            default: o_Segment = 7'b1111111; // Blank
        endcase
    end
endmodule
