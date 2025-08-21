`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07/23/2024 10:26:28 AM
// Design Name: 
// Module Name: TB_ProgramMemorywithFSM_BkSel01
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


module TB_ProgramMemorywithFSM_BkSel01(
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
                input reg [7:0] DATA,
            input reg clk,
            input reg BS1, XTAL1, WR, OE, //WR and OE are active low
            input reg [1:0] XA,
            output logic RDY,
            output logic RD_highbyte,
            output logic EN_ChipErase,
            output logic EN_Erase,
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
        #0ns   memory[8'b00000001][7'b0000010] = 8'h34; //RWW row 1, word 1 low byte
        #0ns   memory[8'b00000001][7'b0000011] = 8'h12; //RWW row 1, word 1 high byte

        #0ns   memory[8'b00000010][7'b0000010] = 8'h78; //RWW row 2, word 1 low byte
        #0ns   memory[8'b00000010][7'b0000011] = 8'h56; //RWW row 2, word 1 high byte
        
        #0ns   memory[8'b11100000][7'b0000000] = 8'h99; //NRWW row 0, word 0 low byte
        #0ns   memory[8'b11100000][7'b0000001] = 8'h66; //NRWW row 0, word 0 high byte
        
        #0ns   memory[8'b11100001][7'b0000000] = 8'h89; //NRWW row 1, word 0 low byte
        #0ns   memory[8'b11100001][7'b0000001] = 8'h67; //NRWW row 1, word 0 high byte
        end

        begin
        #49.9ns   DATA[7:0] = 8'b00010000;
        #50ns   DATA[7:0] = 8'b00000000;
        #50ns   DATA[7:0] = 8'b11110000;
        #50ns   DATA[7:0] = 8'b01101001;
        #50ns   DATA[7:0] = 8'b01110000;
        #50ns   DATA[7:0] = 8'b11111111; //300ns
        #6.4001ms DATA[7:0] = 8'h00;
        #50ns   DATA[7:0] = 8'hFF;
        end        
        
        begin
        #49.9ns XA[1:0] = 2'b10;
        #50ns XA[1:0] = 2'b00;
        #50ns XA[1:0] = 2'b01;
        #50ns XA[1:0] = 2'b01;
        #50ns XA[1:0] = 2'b00; //250ns
        #6.40015ms XA[1:0] = 2'b10;
        end
        
        begin
        #199.9ns BS1 = 1'b1;
        end       
        
        begin
        #49.9ns PC_RD = 1;
        #50ns PC_RD = 0;
        #150ns PC_RD = 1;
        #100ns PC_RD = 0; //350ns
        #4ms   PC_RD = 1;
        #100ns  PC_RD = 0; //4.0004ms
        #2.4ms  PC_RD = 1;
        #50ns  PC_RD = 0;
        end
        
        begin
        #299.9ns WR = 0;
        #50ns  WR = 1;  
        end
        
        begin
        #99.9ns PC[13:0] = 14'b00000010000001;
        #200ns PC[13:0] = 14'b11100000000000;
        #50ns  PC[13:0] = 14'b00000001000001;
        #4.00005ms PC[13:0] = 14'b11100001000000;
        #2.40005ms PC[13:0] = 14'b11100000000000;
        end
        
        join
     
    end
 
 always #25ns clk = ~clk;   
endmodule
