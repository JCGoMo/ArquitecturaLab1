module mux3_tb;
    reg [63:0] d0, d1, d2;
    reg [1:0] s;
    wire [63:0] y;

    // Instancia del módulo mux3
    mux3 #(64) uut (
        .d0(d0),
        .d1(d1),
        .d2(d2),
        .s(s),
        .y(y)
    );

    // Señales de prueba
    initial begin
        // Prueba 1: s=0 (Seleccionar d0)
        d0 = 64'b1111111111111111;
        d1 = 64'b1010101010101010;
        d2 = 64'b0000000000000000;
        s = 2'b00;
        #10;

        // Prueba 2: s=1 (Seleccionar d1)
        d0 = 64'b1111111111111111;
        d1 = 64'b1010101010101010;
        d2 = 64'b0000000000000000;
        s = 2'b01;
        #10;

        // Prueba 3: s=2 (Seleccionar d2)
        d0 = 64'b1111111111111111;
        d1 = 64'b1010101010101010;
        d2 = 64'b0000000000000000;
        s = 2'b10;
        #10;

         // Prueba 4: s=3 (Seleccionar d1)
        d0 = 64'b1111111111111111;
        d1 = 64'b1010101010101010;
        d2 = 64'b0000000000000000;
        s = 2'b11;
        #10;
    end
endmodule
