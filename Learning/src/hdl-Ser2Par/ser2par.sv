module ser2par #(
    // Parameters
    parameter  bitlen = 8
    ) 

    (
        // Input/Output Port
        input wire  RstB,
        input wire  Clk,

        input wire  SerDataIn,
        input wire  SerDataEn,

        output wire[7:0] ParDataOut
    );

    //Signal Declaration
    reg[7:0]        rParData;
    
    //Output Assignment
    assign ParDataOut[7:0] = rParData;

    //Behavior
    always @(posedge Clk)
    begin : ShiftReg
        if(!RstB) begin
            rParData <= 8'h00;
        end else begin
            if(SerDataEn) begin
                rParData <= {SerDataIn, rParData[7:1]};
            end else begin
                rParData <= rParData;
            end 
        end 
    end
    
endmodule