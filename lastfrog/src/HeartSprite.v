module heart_sprite_bram (
    input wire clk,                 // Clock signal
    input wire [4:0] sprite_x,      // X coordinate within the car sprite (0-19)
    input wire [4:0] sprite_y,      // Y coordinate within the car sprite (0-19)
    output reg [5:0] pixel_data    // 6-bit pixel data
);

    // Declare a 400x6 bit Block RAM (BRAM) for storing the 20x20 car sprite (6-bit color)
    reg [5:0] heart_bram [0:399];

    // Initialize the car sprite data in BRAM
    initial begin
        heart_bram[0] = 6'b000000;
heart_bram[1] = 6'b000000;
heart_bram[2] = 6'b000000;
heart_bram[3] = 6'b000000;
heart_bram[4] = 6'b000000;
heart_bram[5] = 6'b000000;
heart_bram[6] = 6'b000000;
heart_bram[7] = 6'b000000;
heart_bram[8] = 6'b000000;
heart_bram[9] = 6'b000000;
heart_bram[10] = 6'b000000;
heart_bram[11] = 6'b100000;
heart_bram[12] = 6'b100000;
heart_bram[13] = 6'b010000;
heart_bram[14] = 6'b010000;
heart_bram[15] = 6'b100000;
heart_bram[16] = 6'b100000;
heart_bram[17] = 6'b000000;
heart_bram[18] = 6'b000000;
heart_bram[19] = 6'b000000;
heart_bram[20] = 6'b000000;
heart_bram[21] = 6'b000000;
heart_bram[22] = 6'b100000;
heart_bram[23] = 6'b100000;
heart_bram[24] = 6'b010000;
heart_bram[25] = 6'b100000;
heart_bram[26] = 6'b100000;
heart_bram[27] = 6'b000000;
heart_bram[28] = 6'b000000;
heart_bram[29] = 6'b010000;
heart_bram[30] = 6'b010000;
heart_bram[31] = 6'b110000;
heart_bram[32] = 6'b110000;
heart_bram[33] = 6'b110101;
heart_bram[34] = 6'b110101;
heart_bram[35] = 6'b110000;
heart_bram[36] = 6'b100000;
heart_bram[37] = 6'b010000;
heart_bram[38] = 6'b000000;
heart_bram[39] = 6'b000000;
heart_bram[40] = 6'b000000;
heart_bram[41] = 6'b010000;
heart_bram[42] = 6'b100000;
heart_bram[43] = 6'b100000;
heart_bram[44] = 6'b100000;
heart_bram[45] = 6'b110000;
heart_bram[46] = 6'b110101;
heart_bram[47] = 6'b111001;
heart_bram[48] = 6'b010000;
heart_bram[49] = 6'b100000;
heart_bram[50] = 6'b100000;
heart_bram[51] = 6'b110000;
heart_bram[52] = 6'b110101;
heart_bram[53] = 6'b111001;
heart_bram[54] = 6'b111001;
heart_bram[55] = 6'b110101;
heart_bram[56] = 6'b100000;
heart_bram[57] = 6'b100000;
heart_bram[58] = 6'b010000;
heart_bram[59] = 6'b000000;
heart_bram[60] = 6'b100000;
heart_bram[61] = 6'b010000;
heart_bram[62] = 6'b100000;
heart_bram[63] = 6'b110101;
heart_bram[64] = 6'b111010;
heart_bram[65] = 6'b111010;
heart_bram[66] = 6'b111010;
heart_bram[67] = 6'b111001;
heart_bram[68] = 6'b010000;
heart_bram[69] = 6'b100000;
heart_bram[70] = 6'b110000;
heart_bram[71] = 6'b110101;
heart_bram[72] = 6'b111010;
heart_bram[73] = 6'b111010;
heart_bram[74] = 6'b111010;
heart_bram[75] = 6'b111001;
heart_bram[76] = 6'b110100;
heart_bram[77] = 6'b100000;
heart_bram[78] = 6'b010000;
heart_bram[79] = 6'b100000;
heart_bram[80] = 6'b100000;
heart_bram[81] = 6'b110000;
heart_bram[82] = 6'b110101;
heart_bram[83] = 6'b111001;
heart_bram[84] = 6'b111010;
heart_bram[85] = 6'b111111;
heart_bram[86] = 6'b111111;
heart_bram[87] = 6'b100101;
heart_bram[88] = 6'b100000;
heart_bram[89] = 6'b110101;
heart_bram[90] = 6'b111001;
heart_bram[91] = 6'b111001;
heart_bram[92] = 6'b111110;
heart_bram[93] = 6'b111111;
heart_bram[94] = 6'b111111;
heart_bram[95] = 6'b111010;
heart_bram[96] = 6'b110101;
heart_bram[97] = 6'b110000;
heart_bram[98] = 6'b110000;
heart_bram[99] = 6'b100000;
heart_bram[100] = 6'b100000;
heart_bram[101] = 6'b110000;
heart_bram[102] = 6'b110101;
heart_bram[103] = 6'b111010;
heart_bram[104] = 6'b111111;
heart_bram[105] = 6'b111010;
heart_bram[106] = 6'b111010;
heart_bram[107] = 6'b110101;
heart_bram[108] = 6'b110100;
heart_bram[109] = 6'b111001;
heart_bram[110] = 6'b111001;
heart_bram[111] = 6'b111111;
heart_bram[112] = 6'b111111;
heart_bram[113] = 6'b111010;
heart_bram[114] = 6'b111010;
heart_bram[115] = 6'b110101;
heart_bram[116] = 6'b111001;
heart_bram[117] = 6'b110101;
heart_bram[118] = 6'b110000;
heart_bram[119] = 6'b100000;
heart_bram[120] = 6'b100000;
heart_bram[121] = 6'b110000;
heart_bram[122] = 6'b110101;
heart_bram[123] = 6'b111010;
heart_bram[124] = 6'b111111;
heart_bram[125] = 6'b111001;
heart_bram[126] = 6'b111001;
heart_bram[127] = 6'b111001;
heart_bram[128] = 6'b111001;
heart_bram[129] = 6'b111001;
heart_bram[130] = 6'b111001;
heart_bram[131] = 6'b111111;
heart_bram[132] = 6'b111010;
heart_bram[133] = 6'b111001;
heart_bram[134] = 6'b111001;
heart_bram[135] = 6'b110101;
heart_bram[136] = 6'b111001;
heart_bram[137] = 6'b111001;
heart_bram[138] = 6'b110100;
heart_bram[139] = 6'b010000;
heart_bram[140] = 6'b100000;
heart_bram[141] = 6'b110000;
heart_bram[142] = 6'b110000;
heart_bram[143] = 6'b110101;
heart_bram[144] = 6'b111001;
heart_bram[145] = 6'b111001;
heart_bram[146] = 6'b111001;
heart_bram[147] = 6'b111001;
heart_bram[148] = 6'b111001;
heart_bram[149] = 6'b111001;
heart_bram[150] = 6'b111001;
heart_bram[151] = 6'b111001;
heart_bram[152] = 6'b111001;
heart_bram[153] = 6'b111001;
heart_bram[154] = 6'b110101;
heart_bram[155] = 6'b111001;
heart_bram[156] = 6'b110101;
heart_bram[157] = 6'b110101;
heart_bram[158] = 6'b110100;
heart_bram[159] = 6'b010000;
heart_bram[160] = 6'b100000;
heart_bram[161] = 6'b010000;
heart_bram[162] = 6'b100000;
heart_bram[163] = 6'b110000;
heart_bram[164] = 6'b110101;
heart_bram[165] = 6'b111001;
heart_bram[166] = 6'b110101;
heart_bram[167] = 6'b111001;
heart_bram[168] = 6'b111001;
heart_bram[169] = 6'b111001;
heart_bram[170] = 6'b110101;
heart_bram[171] = 6'b111001;
heart_bram[172] = 6'b111001;
heart_bram[173] = 6'b110101;
heart_bram[174] = 6'b111001;
heart_bram[175] = 6'b110101;
heart_bram[176] = 6'b110101;
heart_bram[177] = 6'b100000;
heart_bram[178] = 6'b100000;
heart_bram[179] = 6'b100000;
heart_bram[180] = 6'b000000;
heart_bram[181] = 6'b010000;
heart_bram[182] = 6'b100000;
heart_bram[183] = 6'b100000;
heart_bram[184] = 6'b110101;
heart_bram[185] = 6'b111001;
heart_bram[186] = 6'b111001;
heart_bram[187] = 6'b111001;
heart_bram[188] = 6'b110101;
heart_bram[189] = 6'b110101;
heart_bram[190] = 6'b111001;
heart_bram[191] = 6'b110101;
heart_bram[192] = 6'b111001;
heart_bram[193] = 6'b111001;
heart_bram[194] = 6'b110101;
heart_bram[195] = 6'b110101;
heart_bram[196] = 6'b110100;
heart_bram[197] = 6'b110000;
heart_bram[198] = 6'b100000;
heart_bram[199] = 6'b100000;
heart_bram[200] = 6'b000000;
heart_bram[201] = 6'b000000;
heart_bram[202] = 6'b010000;
heart_bram[203] = 6'b100000;
heart_bram[204] = 6'b110100;
heart_bram[205] = 6'b111001;
heart_bram[206] = 6'b111001;
heart_bram[207] = 6'b111001;
heart_bram[208] = 6'b110101;
heart_bram[209] = 6'b110101;
heart_bram[210] = 6'b111001;
heart_bram[211] = 6'b110101;
heart_bram[212] = 6'b111001;
heart_bram[213] = 6'b111001;
heart_bram[214] = 6'b110101;
heart_bram[215] = 6'b110101;
heart_bram[216] = 6'b110000;
heart_bram[217] = 6'b100000;
heart_bram[218] = 6'b100000;
heart_bram[219] = 6'b000000;
heart_bram[220] = 6'b000000;
heart_bram[221] = 6'b000000;
heart_bram[222] = 6'b000000;
heart_bram[223] = 6'b100000;
heart_bram[224] = 6'b100000;
heart_bram[225] = 6'b110101;
heart_bram[226] = 6'b111001;
heart_bram[227] = 6'b111001;
heart_bram[228] = 6'b110101;
heart_bram[229] = 6'b111001;
heart_bram[230] = 6'b110101;
heart_bram[231] = 6'b111001;
heart_bram[232] = 6'b110101;
heart_bram[233] = 6'b110101;
heart_bram[234] = 6'b110101;
heart_bram[235] = 6'b110000;
heart_bram[236] = 6'b100000;
heart_bram[237] = 6'b010000;
heart_bram[238] = 6'b000000;
heart_bram[239] = 6'b000000;
heart_bram[240] = 6'b000000;
heart_bram[241] = 6'b000000;
heart_bram[242] = 6'b000000;
heart_bram[243] = 6'b100000;
heart_bram[244] = 6'b100000;
heart_bram[245] = 6'b010000;
heart_bram[246] = 6'b110100;
heart_bram[247] = 6'b111001;
heart_bram[248] = 6'b111001;
heart_bram[249] = 6'b110101;
heart_bram[250] = 6'b111001;
heart_bram[251] = 6'b110101;
heart_bram[252] = 6'b110100;
heart_bram[253] = 6'b110000;
heart_bram[254] = 6'b100000;
heart_bram[255] = 6'b100000;
heart_bram[256] = 6'b100000;
heart_bram[257] = 6'b010000;
heart_bram[258] = 6'b000000;
heart_bram[259] = 6'b000000;
heart_bram[260] = 6'b000000;
heart_bram[261] = 6'b000000;
heart_bram[262] = 6'b000000;
heart_bram[263] = 6'b000000;
heart_bram[264] = 6'b000000;
heart_bram[265] = 6'b010000;
heart_bram[266] = 6'b100000;
heart_bram[267] = 6'b110100;
heart_bram[268] = 6'b110101;
heart_bram[269] = 6'b110101;
heart_bram[270] = 6'b110101;
heart_bram[271] = 6'b110100;
heart_bram[272] = 6'b110000;
heart_bram[273] = 6'b100000;
heart_bram[274] = 6'b100000;
heart_bram[275] = 6'b010000;
heart_bram[276] = 6'b010000;
heart_bram[277] = 6'b000000;
heart_bram[278] = 6'b000000;
heart_bram[279] = 6'b000000;
heart_bram[280] = 6'b000000;
heart_bram[281] = 6'b000000;
heart_bram[282] = 6'b000000;
heart_bram[283] = 6'b000000;
heart_bram[284] = 6'b000000;
heart_bram[285] = 6'b000000;
heart_bram[286] = 6'b010000;
heart_bram[287] = 6'b100000;
heart_bram[288] = 6'b110101;
heart_bram[289] = 6'b110101;
heart_bram[290] = 6'b110101;
heart_bram[291] = 6'b110000;
heart_bram[292] = 6'b100000;
heart_bram[293] = 6'b100000;
heart_bram[294] = 6'b000000;
heart_bram[295] = 6'b000000;
heart_bram[296] = 6'b000000;
heart_bram[297] = 6'b000000;
heart_bram[298] = 6'b000000;
heart_bram[299] = 6'b000000;
heart_bram[300] = 6'b000000;
heart_bram[301] = 6'b000000;
heart_bram[302] = 6'b000000;
heart_bram[303] = 6'b000000;
heart_bram[304] = 6'b000000;
heart_bram[305] = 6'b000000;
heart_bram[306] = 6'b010000;
heart_bram[307] = 6'b100000;
heart_bram[308] = 6'b110101;
heart_bram[309] = 6'b110101;
heart_bram[310] = 6'b110000;
heart_bram[311] = 6'b100000;
heart_bram[312] = 6'b010000;
heart_bram[313] = 6'b000000;
heart_bram[314] = 6'b000000;
heart_bram[315] = 6'b000000;
heart_bram[316] = 6'b000000;
heart_bram[317] = 6'b000000;
heart_bram[318] = 6'b000000;
heart_bram[319] = 6'b000000;
heart_bram[320] = 6'b000000;
heart_bram[321] = 6'b000000;
heart_bram[322] = 6'b000000;
heart_bram[323] = 6'b000000;
heart_bram[324] = 6'b000000;
heart_bram[325] = 6'b000000;
heart_bram[326] = 6'b100000;
heart_bram[327] = 6'b110100;
heart_bram[328] = 6'b110101;
heart_bram[329] = 6'b110000;
heart_bram[330] = 6'b100000;
heart_bram[331] = 6'b010000;
heart_bram[332] = 6'b010000;
heart_bram[333] = 6'b000000;
heart_bram[334] = 6'b000000;
heart_bram[335] = 6'b000000;
heart_bram[336] = 6'b000000;
heart_bram[337] = 6'b000000;
heart_bram[338] = 6'b000000;
heart_bram[339] = 6'b000000;
heart_bram[340] = 6'b000000;
heart_bram[341] = 6'b000000;
heart_bram[342] = 6'b000000;
heart_bram[343] = 6'b000000;
heart_bram[344] = 6'b000000;
heart_bram[345] = 6'b000000;
heart_bram[346] = 6'b100000;
heart_bram[347] = 6'b110000;
heart_bram[348] = 6'b110000;
heart_bram[349] = 6'b100000;
heart_bram[350] = 6'b100000;
heart_bram[351] = 6'b010000;
heart_bram[352] = 6'b000000;
heart_bram[353] = 6'b000000;
heart_bram[354] = 6'b000000;
heart_bram[355] = 6'b000000;
heart_bram[356] = 6'b000000;
heart_bram[357] = 6'b000000;
heart_bram[358] = 6'b000000;
heart_bram[359] = 6'b000000;
heart_bram[360] = 6'b000000;
heart_bram[361] = 6'b000000;
heart_bram[362] = 6'b000000;
heart_bram[363] = 6'b000000;
heart_bram[364] = 6'b000000;
heart_bram[365] = 6'b000000;
heart_bram[366] = 6'b000000;
heart_bram[367] = 6'b110000;
heart_bram[368] = 6'b110000;
heart_bram[369] = 6'b100000;
heart_bram[370] = 6'b110101;
heart_bram[371] = 6'b000000;
heart_bram[372] = 6'b000000;
heart_bram[373] = 6'b000000;
heart_bram[374] = 6'b000000;
heart_bram[375] = 6'b000000;
heart_bram[376] = 6'b000000;
heart_bram[377] = 6'b000000;
heart_bram[378] = 6'b000000;
heart_bram[379] = 6'b000000;
heart_bram[380] = 6'b000000;
heart_bram[381] = 6'b000000;
heart_bram[382] = 6'b000000;
heart_bram[383] = 6'b000000;
heart_bram[384] = 6'b000000;
heart_bram[385] = 6'b000000;
heart_bram[386] = 6'b000000;
heart_bram[387] = 6'b010000;
heart_bram[388] = 6'b010000;
heart_bram[389] = 6'b000000;
heart_bram[390] = 6'b000000;
heart_bram[391] = 6'b000000;
heart_bram[392] = 6'b000000;
heart_bram[393] = 6'b000000;
heart_bram[394] = 6'b000000;
heart_bram[395] = 6'b000000;
heart_bram[396] = 6'b000000;
heart_bram[397] = 6'b000000;
heart_bram[398] = 6'b000000;
heart_bram[399] = 6'b000000;
    end

    // Calculate the BRAM address based on (sprite_x, sprite_y) coordinates
    wire [8:0] bram_address = (sprite_y * 20) + sprite_x; // 9-bit address for 400 entries

    // Output the pixel data from the BRAM based on the address
    always @(posedge clk) begin
        pixel_data <= heart_pixel[bram_address];
    end

endmodule