module ser2par_tb ();

    //Parameter
    parameter CLK_PERIOD = 10;
    parameter bitlen = 8;
    parameter data8bit = 8'h2b;

    //Signal Declaration
    reg  RstB;
    reg  Clk;
    reg  SerDataIn;
    reg  SerDataEn;
    reg[7:0] ParDataOut;

    integer TT;

    //Module Declaration
    ser2par #(
        .bitlen(bitlen)
    )
    ser2par
    (
        .RstB(RstB),
        .Clk(Clk),

        .SerDataIn(SerDataIn),
        .SerDataEn(SerDataEn),

        .ParDataOut(ParDataOut)
    );

    //Task
    always 
    begin : clock
      #(CLK_PERIOD / 2) 
      Clk = 0;
      #(CLK_PERIOD / 2) 
      Clk = 1;
    end

    task init;
    begin
        TT <= 0;
        RstB = 0;
        SerDataIn <= 0;
        SerDataEn <= 0;
        #(2 * CLK_PERIOD);
        RstB = 1;
        #(2 * CLK_PERIOD);
    end
    endtask

    task senddata;
    begin
        TT <= 1;$display("TT = 1");
        SerDataIn <= 1;
        SerDataEn <= 1;
        #(CLK_PERIOD);
        @(posedge Clk);

        SerDataIn <= 0;
        #(CLK_PERIOD);
        @(posedge Clk);

        SerDataIn <= 1;
        #(CLK_PERIOD);
        @(posedge Clk);

        SerDataIn <= 1;
        #(CLK_PERIOD);
        @(posedge Clk);

        SerDataEn <= 0;

    end
    endtask

    task sendByte(input[7:0]  data);
    begin
        TT <= 2;$display("TT = 2");
		for (int i = 0; i < bitlen; i++) begin
			SerDataIn <= data[i];
            SerDataEn <= 1;
            #(CLK_PERIOD);
            @(posedge Clk);
        end
        SerDataEn <= 0;
        #(CLK_PERIOD);
    end
    endtask

    // Main
    initial
    begin : main
      init();
      senddata();
      sendByte(data8bit);

      $display("-- Testbench for ser2par done. --");
      $stop;
    end

endmodule