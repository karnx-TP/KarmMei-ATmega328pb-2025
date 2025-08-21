`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineers:
// 
// Create Date: 07/22/2024 09:44:47 PM
// Design Name: 
// Module Name: ProgramMemorywithFSM
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

//top level of Memory of FSM block and Program Memory block
module ProgramMemorywithFSM(
                input [13:0] PC,
                input PC_RD,
                output logic [1:0] BkSel,
                output logic EnBuf, EnAdrLat, Adr_0,
                output logic DB_WR, DB_RD, Data_RD,
                output logic Erase, Prog,
                output reg RD,
                output reg [255:0][127:0][7:0] memory,

                output reg i_RD_RWW, i_ER_RWW, i_WR_RWW,
                output reg i_RD_NRWW, i_ER_NRWW, i_WR_NRWW,
                output reg EN_RD_A_highbyte, EN_RD_A_lowbyte,
                output reg [14:0] RD_A,
                output reg [14:0] tmp_RD_access_highbyte, tmp_RD_access_lowbyte,
                output reg [127:0][7:0] Out_WRBUF,
                output reg [6:0] tmp_wAdrbyteselect,
                output reg [14:0] wAdr,
                output logic [15:0]Dout,
                
            input clk,
            input BS1, XTAL1, WR, OE, //WR and OE are active low
            input [1:0] XA,
            input [7:0] DATA,
            output logic RD_highbyte,
            output logic EN_ChipErase,
            output logic EN_Erase,
            output logic [2:0] wAdr_sideselect,
            output logic RDY
    );
    logic [7:0] DBI;
    assign DBI[7:0] = DATA[7:0];
    assign Adr_0 = BS1;
    Memory_FSM FSMofMemory(.*);
    EEPROM_32kbytes_memory ProgramMem(.*);

    
    
    
endmodule
