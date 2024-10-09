module segment_display (
    input wire [3:0] i_Level,      // Le niveau à afficher
    output reg [6:0] o_Segment     // Les sorties pour l'affichage 7 segments
);

always @(*) begin
    case(i_Level)
        4'd0: o_Segment = 7'b1000000; // 0
        4'd1: o_Segment = 7'b1111001; // 1
        4'd2: o_Segment = 7'b0100100; // 2
        4'd3: o_Segment = 7'b0110000; // 3
        4'd4: o_Segment = 7'b0011001; // 4
        4'd5: o_Segment = 7'b0010010; // 5
        4'd6: o_Segment = 7'b0000010; // 6
        4'd7: o_Segment = 7'b1111000; // 7
        4'd8: o_Segment = 7'b0000000; // 8
        4'd9: o_Segment = 7'b0010000; // 9
        default: o_Segment = 7'b1111111; // Rien d'affiché
    endcase
end

endmodule
