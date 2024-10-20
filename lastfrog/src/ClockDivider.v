module ClockDivider #(
    parameter DIV_FACTOR = 23'd2500000
)(
    input wire i_Clk,
    output reg o_Divided_Clk
);
    reg [22:0] counter = 0;
    
    always @(posedge i_Clk) begin
        if (counter == DIV_FACTOR) begin
            counter <= 0;
            o_Divided_Clk <= ~o_Divided_Clk;
        end else begin
            counter <= counter + 1;
        end
    end
endmodule
