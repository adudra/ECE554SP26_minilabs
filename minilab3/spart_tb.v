module spart_tb();
    lab1_spart dut (
        .CLOCK_50(),
        .KEY(),
        .SW(),
        .LEDR(),
        .GPIO()
    );

    spart spart0 (
        .clk(),
        .rst(),
        .iocs(),
        .iorw(),
        .rda(),
        .tbr(),
        .ioaddr(),
        .databus(),
        .txd(),
        .rxd()
    );

endmodule