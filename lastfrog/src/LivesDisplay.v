module live_display (
    input wire [1:0] lives,        // Nombre de vies restantes (0 à 3)
    input wire [9:0] h_count,      // Compteur de colonnes (horizontal)
    input wire [8:0] v_count,      // Compteur de lignes (vertical)
    output reg [2:0] vga_r,        // Sortie VGA Red signal
    output reg [2:0] vga_g,        // Sortie VGA Green signal
    output reg [2:0] vga_b         // Sortie VGA Blue signal
);

    // Taille des carrés de vie (16x16 pixels)
    localparam LIFE_WIDTH = 16;
    localparam LIFE_HEIGHT = 16;

    // Espacement entre les vies
    localparam LIFE_SPACING = 24;  // Espacement entre chaque vie, ajusté pour un peu plus de distance

    // Position de départ pour les vies (bas gauche de l'écran)
    localparam LIFE_Y_POS = 490;   // Position verticale (juste avant le bas de l'écran)
    localparam LIFE_X_START = 160;  // Position horizontale de départ (légèrement décalé du bord)

 always @(*) begin
    // Par défaut, sortie VGA noire
    vga_r = 3'b000;
    vga_g = 3'b000;
    vga_b = 3'b000;

    // Activer la logique de calcul uniquement dans la zone des vies
    if (v_count >= LIFE_Y_POS && v_count < LIFE_Y_POS + LIFE_HEIGHT) begin
        // Pour la première vie (seulement si au moins une vie)
        if (lives >= 1 && h_count >= LIFE_X_START && h_count < LIFE_X_START + LIFE_WIDTH) begin
            vga_r = 3'b111;  // Rouge
            vga_g = 3'b111;
            vga_b = 3'b111;
        end
        // Pour la deuxième vie (seulement si au moins deux vies)
        else if (lives >= 2 && h_count >= LIFE_X_START + LIFE_SPACING && h_count < LIFE_X_START + LIFE_SPACING + LIFE_WIDTH) begin
            vga_r = 3'b111;
            vga_g = 3'b111;
            vga_b = 3'b111;
        end
        // Pour la troisième vie (seulement si au moins trois vies)
        else if (lives >= 3 && h_count >= LIFE_X_START + 2*LIFE_SPACING && h_count < LIFE_X_START + 2*LIFE_SPACING + LIFE_WIDTH) begin
            vga_r = 3'b111;
            vga_g = 3'b111;
            vga_b = 3'b111;
        end
    end
end
endmodule