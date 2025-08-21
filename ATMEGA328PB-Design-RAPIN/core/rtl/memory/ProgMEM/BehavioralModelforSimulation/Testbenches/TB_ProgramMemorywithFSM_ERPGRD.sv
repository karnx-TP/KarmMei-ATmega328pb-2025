`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/23/2024 05:04:09 AM
// Design Name: 
// Module Name: TB_ProgramMemorywithFSM_ERPGRD
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


module TB_ProgramMemorywithFSM_ERPGRD(
                input reg [13:0] PC,
                //input [7:0] DBI,

                output reg PC_RD,
                output logic [1:0] BkSel,
                output logic EnBuf, EnAdrLat, Adr_0,
                output logic DB_WR, DB_RD, Data_RD,
                output logic Erase, Prog,
                output logic RD,
                output logic [255:0][127:0][7:0] memory,

                output logic i_RD_RWW, i_ER_RWW, i_WR_RWW,
                output logic i_RD_NRWW, i_ER_NRWW, i_WR_NRWW,
                output logic EN_RD_A_highbyte, EN_RD_A_lowbyte,
                output logic [14:0] RD_A,
                output logic [14:0] tmp_RD_access_highbyte, tmp_RD_access_lowbyte,
                output logic [127:0][7:0] Out_WRBUF,
                output logic [6:0] tmp_wAdrbyteselect,
                output logic [14:0] wAdr,
                output logic [15:0]Dout,
                
            input reg clk,
            input reg BS1, XTAL1, WR, OE, //WR and OE are active low
            input reg [1:0] XA,
            input reg [7:0] DATA,
            output logic RD_highbyte,
            output logic EN_ChipErase,
            output logic EN_Erase,
            output logic RDY,
            output logic wAdr_sideselect
    );
    
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
        #0ns   memory[8'b00000001][7'b0000010] = 8'h9F; //RWW row 1, word 1 low byte
        #0ns   memory[8'b00000001][7'b0000011] = 8'hF6; //RWW row 1, word 1 high byte

        #0ns   memory[8'b11100001][7'b0000010] = 8'h99; //NRWW row 1, word 1 low byte
        #0ns   memory[8'b11100001][7'b0000011] = 8'h66; //NRWW row 1, word 1 high byte
        
        #0ns   memory[8'b11100001][7'b0000100] = 8'hCD; //NRWW row 1, word 2 low byte
        #0ns   memory[8'b11100001][7'b0000101] = 8'hAB; //NRWW row 1, word 2 high byte
        end

        begin
        #49.9ns   DATA[7:0] = 8'b00010000;
        #50ns   DATA[7:0] = 8'b10000010;
        #50ns   DATA[7:0] = 8'b01111000;
        #50ns   DATA[7:0] = 8'b10010110;
        #50ns   DATA[7:0] = 8'b10000010;
        #50ns   DATA[7:0] = 8'b10000100; //300ns
        #50ns   DATA[7:0] = 8'b01000010;
        #50ns   DATA[7:0] = 8'b10010111;
        #50ns   DATA[7:0] = 8'b01110000;
        #50ns   DATA[7:0] = 8'hFF;
        #6.4ms  DATA[7:0] = 8'b00000000;
        end        
        
        begin
        #49.9ns XA[1:0] = 2'b10;
        #50ns XA[1:0] = 2'b00;
        #50ns XA[1:0] = 2'b01;
        #50ns XA[1:0] = 2'b01;
        #50ns XA[1:0] = 2'b00;
        #50ns XA[1:0] = 2'b00; //300ns
        #50ns XA[1:0] = 2'b01;
        #50ns XA[1:0] = 2'b01;
        #50ns XA[1:0] = 2'b00; //450ns
        #6.40005ms XA[1:0] = 2'b10;
        end
        
        begin
        #199.9ns BS1 = 1'b1;
        #50ns BS1 = 1'b0;
        #150ns BS1 = 1'b1;
        end       
        
        begin
        #6.400499ms  PC_RD = 1;
        #6.40055ms  PC_RD = 0;
        end
        
        begin
        #499.9ns WR = 0;
        #50ns  WR = 1;  
        end
        
        join
     
    end
 
 always #25ns clk = ~clk;    
 
endmodule
