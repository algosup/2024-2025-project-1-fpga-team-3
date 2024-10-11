module seven_segment_display (
    input [6:0] level,    // Level input (0 to 99)
    output reg [6:0] o_Segment1,  // Tens digit (1st display)
    output reg [6:0] o_Segment2   // Units digit (2nd display)
);

    always @(*) begin
        // Decode the tens place
        case (level / 10) // Get tens digit
            4'd0: o_Segment1 = 7'b1000000; // Display 0
            4'd1: o_Segment1 = 7'b1111001; // Display 1
            4'd2: o_Segment1 = 7'b0100100; // Display 2
            4'd3: o_Segment1 = 7'b0110000; // Display 3
            4'd4: o_Segment1 = 7'b0011001; // Display 4
            4'd5: o_Segment1 = 7'b0010010; // Display 5
            4'd6: o_Segment1 = 7'b0000010; // Display 6
            4'd7: o_Segment1 = 7'b1111000; // Display 7
            4'd8: o_Segment1 = 7'b0000000; // Display 8
            4'd9: o_Segment1 = 7'b0010000; // Display 9
            default: o_Segment1 = 7'b1111111; // Turn off for numbers >= 100
        endcase
    end
    
    always @(*) begin
        // Decode the units place
        case (level % 10) // Get units digit
            4'd0: o_Segment2 = 7'b1000000; // Display 0
            4'd1: o_Segment2 = 7'b1111001; // Display 1
            4'd2: o_Segment2 = 7'b0100100; // Display 2
            4'd3: o_Segment2 = 7'b0110000; // Display 3
            4'd4: o_Segment2 = 7'b0011001; // Display 4
            4'd5: o_Segment2 = 7'b0010010; // Display 5
            4'd6: o_Segment2 = 7'b0000010; // Display 6
            4'd7: o_Segment2 = 7'b1111000; // Display 7
            4'd8: o_Segment2 = 7'b0000000; // Display 8
            4'd9: o_Segment2 = 7'b0010000; // Display 9
            default: o_Segment2 = 7'b1111111; // Turn off all segments
        endcase
    end

endmodule
