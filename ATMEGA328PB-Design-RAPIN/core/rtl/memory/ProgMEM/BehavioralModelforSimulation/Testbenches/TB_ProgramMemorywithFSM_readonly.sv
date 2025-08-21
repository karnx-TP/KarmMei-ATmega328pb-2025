`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/22/2024 10:28:06 PM
// Design Name: 
// Module Name: TB_ProgramMemorywithFSM_readonly
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module TB_ProgramMemorywithFSM_readonly(
            //     input reg [13:0] PC,
            //     //input [7:0] DBI,

            //     output reg PC_RD,
            //     output logic [1:0] BkSel,
            //     output logic EnBuf, EnAdrLat, Adr_0,
            //     output logic DB_WR, DB_RD, Data_RD,
            //     output logic Erase, Prog,
            //     output logic RD,
            //     output logic [255:0][127:0][7:0] memory,

            //     output logic i_RD_RWW, i_ER_RWW, i_WR_RWW,
            //     output logic i_RD_NRWW, i_ER_NRWW, i_WR_NRWW,
            //     output logic EN_RD_A_highbyte, EN_RD_A_lowbyte,
            //     output logic [14:0] RD_A,
            //     output logic [14:0] tmp_RD_access_highbyte, tmp_RD_access_lowbyte,
            //     output logic [127:0][7:0] Out_WRBUF,
            //     output logic [6:0] tmp_wAdrbyteselect,
            //     output logic [14:0] wAdr,
            //     output logic [15:0]Dout,
                
            // input reg clk,
            // input reg BS1, XTAL1, WR, OE, //WR and OE are active low
            // input reg [1:0] XA,
            // input reg [7:0] DATA,
            // output logic RD_highbyte,
            // output logic EN_ChipErase,
            // output logic RDY,
            // output logic EN_Erase,
            // output logic wAdr_sideselect
    );
    
    reg [13:0] PC;
    //input [7:0] DBI,

    reg PC_RD;
    logic [1:0] BkSel;
    logic EnBuf, EnAdrLat, Adr_0;
    logic DB_WR, DB_RD, Data_RD;
    logic Erase, Prog;
    logic RD;
    logic [255:0][127:0][7:0] memory;

    logic i_RD_RWW, i_ER_RWW, i_WR_RWW;
    logic i_RD_NRWW, i_ER_NRWW, i_WR_NRWW;
    logic EN_RD_A_highbyte, EN_RD_A_lowbyte;
    logic [14:0] RD_A;
    logic [14:0] tmp_RD_access_highbyte, tmp_RD_access_lowbyte;
    logic [127:0][7:0] Out_WRBUF;
    logic [6:0] tmp_wAdrbyteselect;
    logic [14:0] wAdr;
    logic [15:0]Dout;
                
    reg clk;
    reg BS1, XTAL1, WR, OE; //WR and OE are active low
    reg [1:0] XA;
    reg [7:0] DATA;
    logic RD_highbyte;
    logic EN_ChipErase;
    logic RDY;
    logic EN_Erase;
    logic wAdr_sideselect;
    
    ProgramMemorywithFSM Memory_Test(.*);
    
    
    initial 
    begin
        clk = 1;
        PC[13:0] = 14'b00000001000001;
        DATA[7:0] = 8'b00000000;
        BS1 = 0;
        PC_RD = 1'b0;
        XTAL1 = 1;
        WR = 1;
        OE = 1;
        XA[1:0] = 2'b10;
       // memory = 262144'b0;
        
        fork
        
        begin
        #0ns   memory[8'b00000001][7'b0000010] = 8'h99; //RWW row 1, word 1 low byte
        #0ns   memory[8'b00000001][7'b0000011] = 8'h66; //RWW row 1, word 1 high byte

        #0ns   memory[8'b11100001][7'b0000010] = 8'h9F; //NRWW row 1, word 1 low byte
        #0ns   memory[8'b11100001][7'b0000011] = 8'hF6; //NRWW row 1, word 1 high byte
        end

        begin
        #0ns   PC[13:0] = 14'b00000001000001;
        #399.9ns PC[13:0] = 14'b11100001000001;
        end

        begin
        #49.9ns   DATA[7:0] = 8'h02;
        #100ns  DATA[7:0] = 8'b01110000;
        #50ns   DATA[7:0] = 8'b10000011;
        #50ns   DATA[7:0] = 8'hFF;
        end        
        
        begin
        #49.9ns XA[1:0] = 2'b10;
        #50ns XA[1:0] = 2'b10;
        #50ns XA[1:0] = 2'b00;
        #50ns XA[1:0] = 2'b00;
        end
        
        begin
        #149.9ns BS1 = 1'b1;
        #50ns BS1 = 1'b0;
        #50ns BS1 = 1'b1;
        end       
        
        begin
        #249.9ns OE = 0;
        #50ns  OE = 1;
        end
        
        begin
        #49.9ns  PC_RD = 1;
        #50ns  PC_RD = 0;
        #250ns PC_RD = 1;
        #100ns PC_RD = 0;
        end
        join
       // #600 PC[13:0] = 14'b11111111111111;
    end
 
 always #25ns clk = ~clk;    
 
endmodule
