module clock_divider (
    input wire i_Clk,              // Input clock signal
    output reg o_Divided_Clk       // Output slower clock signal
);
    parameter DIV_FACTOR = 24'd10;  // Division factor (parameterized)
    reg [23:0] counter = 0;

    always @(posedge i_Clk) begin
        if (counter >= (DIV_FACTOR - 1))
            counter <= 0;
        else
            counter <= counter + 1;

        o_Divided_Clk <= (counter == 0);  // Toggle the divided clock at the end of the count
    end
endmodule
